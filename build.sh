#!/bin/bash
#
# Builds some edk2 code
# Copyright 2026 Christian Kohlschuetter
#

cd $(dirname $0)

curDir=$(pwd)
targetDir="${curDir}/target"
printf "Writing files to: $targetDir\n"

cd edk2

export WORKSPACE=
export EDK_TOOLS_PATH=
export CONF_PATH=

if [[ $# -eq 0 ]]; then
  targets=(
    # Serial port console drivers
    MdeModulePkg/Bus/Pci/PciSioSerialDxe
    MdeModulePkg/Universal/Console/TerminalDxe

    # Setup  related components
    MdeModulePkg/Universal/DisplayEngineDxe
    MdeModulePkg/Universal/SetupBrowserDxe
    MdeModulePkg/Application/UiApp
  
    # uefishell
    ShellPkg/Application/Shell
  )
else
  targets=$@
fi

shift $#
. ./edksetup.sh

echo Targets: ${targets[@]}

set -e
for target in ${targets[@]}; do
  printf "\n"
  printf "====================================================================================\n"

  pkg=${target%%/*}
  name=${target##*/}

  pkgDsc="${pkg}/${pkg}.dsc"
  modDsc="${target}/${name}.inf"

  baseName=$(grep -m 1 BASE_NAME "$modDsc" | tr '\r' '\n')
  baseName=( ${baseName##*= } )
  [[ -z "$baseName" ]] && baseName=${name}

  printf "*** Building $target\n"
  build -p ${pkgDsc} -m ${modDsc} -a X64 -t GCC5 -b RELEASE

  buildName=${pkg%%Pkg}

  case "$baseName" in
    Shell)
      efiName="Shell_EA4BB293-2D7F-4456-A681-1F22F42CD0BC"
      targetName="Shell"
      ;;
    *)
      efiName=${baseName}
      targetName=${efiName}
      ;;
  esac  

  cp -av "${curDir}/edk2/Build/${buildName}/RELEASE_GCC5/X64/${efiName}.efi" "${targetDir}/${targetName}.efi"
done
