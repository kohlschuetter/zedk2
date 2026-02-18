#!/bin/bash
#
# Initializes the project and its dependencies
# Copyright 2026 Christian Kohlschuetter
#

set -e
verbose=0
clean=1

while [[ 1 ]]; do
case $1 in
  -v)
    verbose=1
    shift
    ;;
  -C)
    clean=0
    shift
    ;;
  *)
    break
esac
done

ref="$1"
refName=$ref
refName=${refName:=<current>}
cd $(dirname $0)

echo Cleaning target folder...
mkdir -p target
rm -rfv target/*

echo "Resetting edk2 repo... ref=${refName}"
git submodule update --init
cd edk2
git checkout --quiet $ref
if [[ $clean -eq 1 ]]; then
  echo "Cleaning..."
  git clean --quiet -xdf
fi
git submodule update --init

echo "Building BaseTools..."

if [[ $verbose -eq 0 ]]; then
  set +e
  make -C BaseTools >/dev/null 2>&1
  rc=$?
  set -e
  if [[ $rc -ne 0 ]]; then
    echo "Building BaseTools failed; run \"./init.sh -v\" for details" >&2
    exit 1
  fi
else
  make -C BaseTools 
fi

echo "done"
