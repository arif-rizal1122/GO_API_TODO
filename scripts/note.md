Migration Script Conversion Plan
The user is attempting to run a PowerShell script on Linux, leading to syntax errors. This plan outlines the conversion of 
migrate.ps1
 to a native Bash script migrate.sh.

Proposed Changes
Scripts
[NEW] 
migrate.sh
A new Bash script that replaces the functionality of 
migrate.ps1
.

Loads environment variables from 
.env
.
Supports up, down, create, and status commands.
Includes a confirmation prompt for rollbacks (down).
[DELETE] 
migrate.ps1
Once the Bash script is verified, the PowerShell script should be removed to avoid confusion.

Verification Plan
Manual Verification
Run ./scripts/migrate.sh status to verify it connects to the database and loads 
.env
 correctly.
Run ./scripts/migrate.sh create testmigration to verify file creation.
Run ./scripts/migrate.sh up to apply migrations.
Run ./scripts/migrate.sh down and verify the confirmation prompt works.

Comment
Ctrl+Alt+M
