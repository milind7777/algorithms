#!/bin/bash 
ESESC_BIN=${1:-../main/esesc}

# Global config for all runs
export ESESC_TASS_nInstMax=7e9
export ESESC_TASS_nInstSkip=1e8

# variable name encodings to use in map
reportFile="ESESC_ReportFile"
benchName="ESESC_BenchName"

# default values of all above variables to reset after each run
declare -A def
def[$reportFile]="def_never_be_exe"
def[$benchName]="./bins/spec06_bzip2.riscv64  ./data/spec06/401.bzip2/input.combined"

# general function to run
run () {
  local -n config="$1"

  # export variables in r1
  for key in "${!config[@]}"; do
    declare "$key=${config[$key]}"
    export "$key"
  done

  # make call to esesc
  if [ -f $ESESC_BIN ]; then
    $ESESC_BIN 
  else
    $ESESC_BenchName 
  fi

  # rest exported variables to default values
  for key in "${!config[@]}"; do
    declare "$key=${def[$key]}"
    export "$key"
  done
}

############################################################################
############################################################################
# experiment 1
# 
# boom2 config


declare -A r1

r1[$reportFile]="AVLTree"
r1[$benchName]="RISCV64/AVL.rv"

riscv64-linux-gnu-g++ -O3 -static -Iinclude/ src/avl_demo.cpp -o RISCV64/AVL.rv
# riscv64-linux-gnu-gcc -O3 -static 10.Graphs/TopologicalSorting.c -o RISCV64/TopologicalSorting.rv

run r1