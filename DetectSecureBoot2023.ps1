# Intune Custom Compliance Detection Script
try {
    # Check if the "Windows UEFI CA 2023" certificate exists in the 'db' variable
    $dbCerts = [System.Text.Encoding]::ASCII.GetString((Get-SecureBootUEFI db).bytes)
    
    if ($dbCerts -match 'Windows UEFI CA 2023') {
        $IsRenewed = $true
    } else {
        $IsRenewed = $false
    }
}
catch {
    # If the command fails (e.g., Secure Boot not supported or enabled)
    $IsRenewed = $false
}

# Create the output hash table
$hash = @{ 
    SecureBoot2023Cert = $IsRenewed 
}

# Return as a compressed JSON string (Required for Intune)
return $hash | ConvertTo-Json -Compress
