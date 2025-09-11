# Steinberg Deployment and Licensing Scripts

This repository contains scripts for automating the deployment and licensing of Steinberg software products across different platforms, as described on the [Steinberg Multiuser Administration Guide](https://steinberg.help/multiuser-guide/deployment-automated/).

## Overview

This collection provides tools for IT administrators to streamline the installation and licensing of Steinberg audio software in enterprise environments. The scripts support both Windows and macOS platforms and handle the complete workflow from license request generation to installation.

## Repository Structure

```
├── LICENSE.txt                    # BSD 3-Clause License
├── docs/                          # Documentation (placeholder)
├── examples/
│   └── jamf/
│       └── Dorico6andContentInstaller.sh  # Complete Dorico 6 deployment script
└── licensing/
    ├── mac/                       # macOS licensing scripts
    │   ├── 1_generate_license_request_for_this_computer.command
    │   ├── 2_process_license_requests_in_this_folder.command
    │   ├── 3_install_license_for_this_computer.command
    │   └── enable_current_licenses_for_all_users.command
    └── win/                       # Windows licensing scripts
        ├── batch/                 # Batch file versions
        │   ├── 1_generate_license_request_for_this_computer.bat
        │   ├── 2_process_license_requests_in_this_folder.bat
        │   └── 3_install_license_for_this_computer.bat
        └── powershell/            # PowerShell versions
            ├── 1_generate_license_file_for_this_computer.ps1
            ├── 2_process_license_requests_in_this_folder.ps1
            └── 3_install_license_file_for_this_computer.ps1
```


## Examples

### JAMF Pro Integration
The `Dorico6andContentInstaller.sh` script demonstrates a complete deployment workflow including:
- Downloading and installing Steinberg software components
- Installing content libraries and VST instruments
- Comprehensive logging and error handling

## Support

For technical support with Steinberg software licensing, contact Steinberg support through their official channels.