# SecureBoot2023
# Windows Secure Boot 2023 CA Compliance Check

## Overview
This repository provides the necessary scripts and configuration files to monitor the deployment of the **Windows UEFI CA 2023** certificate across your Windows fleet via **Microsoft Intune**. 

As outlined in the [Microsoft Secure Boot Playbook](https://techcommunity.microsoft.com/blog/windows-itpro-blog/secure-boot-playbook-for-certificates-expiring-in-2026/4469235), the 2011 Secure Boot CA certificates will expire in **June 2026**. Devices that have not transitioned to the 2023 CAs by this date may face boot issues or security vulnerabilities.

## Repository Contents
| File | Description |
| :--- | :--- |
| `DetectSecureBoot2023.ps1` | PowerShell discovery script for Intune. |
| `SecureBoot2023.json` | Compliance rule definition for Intune. |

## Prerequisites
* **Windows 10/11** (Secure Boot must be supported/enabled).
* **Microsoft Intune** (Plan 1 or higher).
* Devices must be capable of running the `Get-SecureBootUEFI` cmdlet (typically requires 64-bit PowerShell host).

## Setup Instructions

### Step 1: Upload the Discovery Script
1. Navigate to the **Microsoft Intune admin center**.
2. Go to **Endpoint security** > **Device compliance** > **Scripts** > **Add**.
3. Select **Windows 10 and later**.
4. Upload `DetectSecureBoot2023.ps1`.
5. **Settings:**
   - Run this script using the logged on credentials: **No**
   - Enforce script signature check: **No**
   - Run script in 64 bit PowerShell Host: **Yes** (Required for UEFI access).

### Step 2: Create the Custom Compliance Policy
1. Go to **Devices** > **Compliance policies** > **Create Policy**.
2. Platform: **Windows 10 and later**.
3. Under **Compliance settings**, expand **Custom Compliance**.
4. Select the discovery script you uploaded in Step 1.
5. Upload the `SecureBoot2023.json` file.
6. Complete the wizard and assign the policy to your target groups.

## How it Works
The PowerShell script queries the UEFI `db` variable using:
```powershell
[System.Text.Encoding]::ASCII.GetString((Get-SecureBootUEFI db).bytes) -match 'Windows UEFI CA 2023'
If the certificate is present, the script returns a boolean true to Intune. The JSON rule then validates this result. Devices without the certificate will appear as "Not Compliant", allowing you to track your 2026 readiness.

Troubleshooting
If a device shows an error:

Ensure the device BIOS/UEFI is up to date (OEM firmware must support the 2023 CA).

Ensure Secure Boot is actually enabled on the hardware.

Check the UEFICA2023Status registry key for deployment progress.

License
This project is licensed under the MIT License.


---

### Next Step
Since you are using this to track your own fleet's progress, **would you like me to help you draft the `DetectSecureBoot2023.ps1` and `SecureBoot2023.json` files as separate blocks so you can easily copy and save them?**
