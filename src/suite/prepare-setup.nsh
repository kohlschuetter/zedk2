# zedk
# Copyright 2026 Christian Kohlschuetter
# https://github.com/kohlschuetter/zedk

# Script to enter BIOS from UEFIshell
# inspired by UniversalAMDFormBrowser

# currently, UUIDs are hardcoded
UnloadUUID.efi
# aka gEfiFormBrowser2ProtocolGuid / HIIFormBrowser2
#UnloadUUID.efi B9D4C360-BCFB-4F9B-9298-53C136982258
# aka gEdkiiFormBrowserExProtocolGuid
#UnloadUUID.efi 1F73B18D-4630-43C1-A1DE-6F80855D7DA4
# aka gEfiHiiPopupProtocolGuid / HiiPopup
#UnloadUUID.efi 4311EDC0-6054-46D4-9E40-893EA952FCCC
# aka gEdkiiFormDisplayEngineProtocolGuid
#UnloadUUID.efi 9BBE29E9-FDA1-41EC-AD52-452213742D2E
load DisplayEngine.efi
load SetupBrowser.efi

# Unlock hidden BIOS settings
# Works on: Lenovo Tiny m920q/x, p330, m625q
# Does not work on: Lenovo Tiny m910q/x
setup_var.efi AmiSetupFormSetVar:0x00=1

# launching directly may hang?
# UiApp.efi
echo -off
echo To launch BIOS setup, please enter: UiApp.efi
