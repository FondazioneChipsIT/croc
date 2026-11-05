#!/bin/bash
# Copyright (c) 2026 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Authors:
# - Thomas Benz     <tbenz@iis.ee.ethz.ch>

set -e  # Exit on error
set -u  # Error on undefined vars


################
# Setup
################
# Source environment
# source "../env.sh"


################
# Helpers
################

show_help() {
    cat << EOF
Verilator Coordinator

Usage:
    ./run_verilator.sh [OPTIONS]

Options:
    --help, -h          Show this help message
    --dry-run, -n       Only print commands instead of executing
    --verbose, -v       Print commands while executing
    --build-rtl         Build RTL Verilator binary
    --build-postpnr     Build post-PNR Verilator binary
    --run-rtl           Run RTL simulation
    --run-postpnr       Run post-PNR simulation

Example:
    # Build and run RTL simulation with given binary
    ./run_verilator.sh --build-rtl --run-rtl ../sw/bin/helloworld.hex

EOF
    exit 0
}


run_cmd() {
    if [ "$DRYRUN" = 1 ]; then
        echo $1
    else
        eval $1
    fi
}


init_pdk() {
    run_cmd "echo [INFO] Download and patch PDK for Verilator"
    run_cmd "git submodule update --init"
    run_cmd "cd ../ihp13/pdk && git apply ../verilator_stdcell.patch"
}


build_verilator_rtl() {
    run_cmd "echo [INFO][Verilator] Build Verilator"
    run_cmd "verilator \
        -Wno-fatal \
        -Wno-style \
        -Wno-BLKANDNBLK \
        -Wno-WIDTHEXPAND \
        -Wno-WIDTHTRUNC \
        -Wno-WIDTHCONCAT \
        -Wno-ASCRANGE \
        --binary \
        -j 2 \
        --timing \
        --autoflush \
        --trace-fst \
        --trace-threads 2 \
        --trace-structs \
        --unroll-count 1 \
        --unroll-stmts 1 \
        --x-assign fast \
        --x-initial fast \
        -O3 \
        --top tb_croc_soc \
        --Mdir obj_dir_rtl \
        -f croc_rtl.f 2>&1 | \
        tee core_wrap_build.log"
}


build_verilator_postpnr() {
    run_cmd "echo [INFO][Verilator] Build Verilator"
    run_cmd "verilator \
        -Wno-fatal \
        -Wno-style \
        -Wno-BLKANDNBLK \
        -Wno-WIDTHEXPAND \
        -Wno-WIDTHTRUNC \
        -Wno-WIDTHCONCAT \
        -Wno-ASCRANGE \
        --binary \
        -j 2 \
        --timing \
        --autoflush \
        --trace-threads 2 \
        --trace-structs \
        --trace-underscore \
        --no-trace-params \
        --unroll-count 1 \
        --unroll-stmts 1 \
        --x-assign fast \
        --x-initial fast \
        -O3 \
        --top tb_croc_soc \
        --Mdir obj_dir_postpnr \
        -f croc_postpnr.f 2>&1 | \
        tee core_wrap_build.log"
}


run_binary_rtl() {
    run_cmd "echo [INFO][Verilator] Running $1"
    run_cmd "obj_dir_rtl/Vtb_croc_soc +binary="$1" | tee core_wrap.log"
}


run_binary_postpnr() {
    run_cmd "echo [INFO][Verilator] Running $1"
    run_cmd "obj_dir_postpnr/Vtb_croc_soc +binary="$1" | tee core_wrap.log"
}


####################
# Parse Arguments
####################

DRYRUN=0

# default action if no argument is given
if [ $# -eq 0 ]; then
    show_help
    return 0
fi

# check for global arguments
for arg in "$@"; do
    [[ "$arg" == -v || "$arg" == --verbose ]] && set -x
    [[ "$arg" == -n || "$arg" == --dry-run ]] && DRYRUN=1
done

# parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --help|-h)
            show_help
            ;;
        --verbose|-v)
            shift
            ;;
        --dry-run|-n)
            shift
            ;;
        # script-specific commands
        --init-pdk)
            init_pdk
            shift
            ;;
        --build-rtl)
            build_verilator_rtl
            shift
            ;;
        --build-postpnr)
            build_verilator_postpnr
            shift
            ;;
        --run-rtl)
            run_binary_rtl $2
            shift 2
            ;;
        --run-postpnr)
            run_binary_postpnr $2
            shift 2
            ;;
        # Error handling
        *)
            echo "[ERROR] Unknown option: $1 (use --help for usage)" >&2
            exit 1
            ;;
    esac
done
