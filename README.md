# Oxygen Not Included Mod Cache Cleanup Scripts

## Purpose of These Scripts

These scripts are designed to remove all cached information about the mods in the Oxygen Not Included game. By forcing the game to reinstall the mods and update them, these scripts can help resolve issues when the app crashes on launch after installation or version upgrade.

- The script will clean up the mods folder
- The script will clean up `Steam/steamapps/workshop/appworkshop_457140.acf` file that holds all the references of the mods installed from workshop
- The script will clean up `mods.json` that stored saved configuration of active mods

## How to Run on macOS

1. **Install jq**: Ensure `jq` is installed. You can install it using Homebrew with the following command:

   ```bash
   brew install jq
   ```

1. **Make the Script Executable**: Make the script executable with the following command:

   ```bash
   chmod +x cleanup-oni-mods.sh
   ```

1. **Run the Script**: Execute the script with the following command:

   ```bash
   ./cleanup-oni-mods.sh
   ```

## How to Run on Windows

1. **Run PowerShell as Administrator**: Open PowerShell with administrative privileges.
1. **Set Execution Policy**: If not already set, allow PowerShell scripts to run by setting the execution policy:

   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

1. **Run the Script**: Navigate to the directory where the script is saved and execute it:

   ```powershell
   .\cleanup-oni-mods.ps1
   ```

By following these steps, you can clean up the mod cache for the Oxygen Not Included game on both macOS and Windows, ensuring that mods are reinstalled and updated to prevent crashes.
