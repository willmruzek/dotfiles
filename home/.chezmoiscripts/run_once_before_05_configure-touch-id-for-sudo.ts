#!/usr/bin/env zx

// Configure Touch ID for sudo
const sudoLocalPath = "/etc/pam.d/sudo_local"

try {
  await fs.access(sudoLocalPath)
  
  // File exists, check if pam_tid.so is already configured
  const content = await fs.readFile(sudoLocalPath, 'utf8')
  if (!content.includes("pam_tid.so")) {
    $.echo("🔐 Adding Touch ID authentication to existing sudo_local...")
    await $`echo "auth sufficient pam_tid.so" | sudo tee -a ${sudoLocalPath}`
    $.echo("✅ Touch ID for sudo configured")
  } else {
    $.echo("✅ Touch ID for sudo already configured")
  }
} catch (error) {
  // File doesn't exist
  $.echo("🔐 Setting up Touch ID for sudo...")
  await $`sudo cp /etc/pam.d/sudo_local.template ${sudoLocalPath}`
  await $`echo "auth sufficient pam_tid.so" | sudo tee -a ${sudoLocalPath}`
  $.echo("✅ Touch ID for sudo configured")
}
