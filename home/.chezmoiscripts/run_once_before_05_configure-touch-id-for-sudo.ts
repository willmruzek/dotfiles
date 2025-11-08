#!/usr/bin/env zx

import { ResultAsync, err, ok } from 'neverthrow'

// Configure Touch ID for sudo
const sudoLocalPath = "/etc/pam.d/sudo_local"

// Helper to check if file exists
const fileExists = (path: string): ResultAsync<boolean, Error> =>
  ResultAsync.fromPromise(
    fs.access(path).then(() => true),
    () => new Error(`File does not exist: ${path}`)
  ).orElse(() => ok(false))

// Helper to read file content
const readFile = (path: string): ResultAsync<string, Error> =>
  ResultAsync.fromPromise(
    fs.readFile(path, 'utf8'),
    (e) => new Error(`Failed to read file: ${e}`)
  )

// Helper to execute shell command
const runCommand = (command: ProcessPromise): ResultAsync<void, Error> =>
  ResultAsync.fromPromise(
    command.then(() => undefined),
    (e) => new Error(`Command failed: ${e}`)
  )

// Main logic
const configureTouchID = async () => {
  const exists = await fileExists(sudoLocalPath)
  
  if (exists.isErr()) {
    return exists
  }

  if (exists.value) {
    // File exists, check if pam_tid.so is already configured
    const contentResult = await readFile(sudoLocalPath)
    
    if (contentResult.isErr()) {
      return contentResult
    }

    if (!contentResult.value.includes("pam_tid.so")) {
      echo`🔐 Adding Touch ID authentication to existing sudo_local...`
      const result = await runCommand($`echo "auth sufficient pam_tid.so" | sudo tee -a ${sudoLocalPath}`)
      if (result.isErr()) {
        return result
      }
      echo`✅ Touch ID for sudo configured`
    } else {
      echo`✅ Touch ID for sudo already configured`
    }
  } else {
    // File doesn't exist
    echo`🔐 Setting up Touch ID for sudo...`
    const copyResult = await runCommand($`sudo cp /etc/pam.d/sudo_local.template ${sudoLocalPath}`)
    if (copyResult.isErr()) {
      return copyResult
    }
    
    const appendResult = await runCommand($`echo "auth sufficient pam_tid.so" | sudo tee -a ${sudoLocalPath}`)
    if (appendResult.isErr()) {
      return appendResult
    }
    
    echo`✅ Touch ID for sudo configured`
  }

  return ok(undefined)
}

// Execute and handle result
const result = await configureTouchID()

if (result.isErr()) {
  echo`❌ Error: ${result.error.message}`
  process.exit(1)
}
