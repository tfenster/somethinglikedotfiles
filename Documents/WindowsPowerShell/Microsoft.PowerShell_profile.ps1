function t {   
    # Windows Theme
    $themePath = "Registry::HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    $AppsUseLightTheme = Get-ItemProperty -Path $themePath -Name AppsUseLightTheme
    $SystemUsesLightTheme = Get-ItemProperty -Path $themePath -Name SystemUsesLightTheme
    Set-ItemProperty -Path $themePath -Name AppsUseLightTheme -Value (($AppsUseLightTheme.AppsUseLightTheme / 1 + 1) % 2) -Type DWord
    Set-ItemProperty -Path $themePath -Name SystemUsesLightTheme -Value (($SystemUsesLightTheme.SystemUsesLightTheme / 1 + 1) % 2) -Type DWord

    # Terminal
    $settingsPath = "$env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    $terminalLightTheme = "One Half Light"
    $terminalDarkTheme = "One Half Dark"
    if (Select-String -Path $settingsPath -Pattern $terminalDarkTheme) {
        ((Get-Content $settingsPath) -replace $terminalDarkTheme, $terminalLightTheme) | Set-Content $settingsPath
    } else {
        ((Get-Content $settingsPath)  -replace $terminalLightTheme, $terminalDarkTheme) | Set-Content $settingsPath
    }
}
