function t {   
    # Windows Theme and define mode to be consistent 
    $themePath = "Registry::HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    $AppsUseLightTheme = Get-ItemProperty -Path $themePath -Name AppsUseLightTheme
    $goDark = ($AppsUseLightTheme.AppsUseLightTheme / 1) -eq 1
    
    Set-ItemProperty -Path $themePath -Name AppsUseLightTheme -Value ($(if ($goDark) { 0 } else { 1 })) -Type DWord
    Set-ItemProperty -Path $themePath -Name SystemUsesLightTheme -Value ($(if ($goDark) { 0 } else { 1 })) -Type DWord

    # Terminal
    if ($goDark) {
        $terminalTheme = "One Half Dark"
    } else {
        $terminalTheme = "One Half Light"
    }
    $settingsPath = "$env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    $jsonObj = (Get-Content $settingsPath | Out-String) | ConvertFrom-Json
    foreach ($profile in $jsonObj.profiles.list) {
        if ($null -eq $profile.colorScheme ) {
            $profile | Add-Member -type NoteProperty -name "colorScheme" -value "$terminalTheme"
        } else {
            $profile.colorScheme = "$terminalTheme"
        }
    }
    ConvertTo-Json $jsonObj -Depth 5 | Set-Content $settingsPath 
}