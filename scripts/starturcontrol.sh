#!/bin/bash
SCRIPT_DIR=$(dirname $(readlink -f $0))
CONFIG_DIR=$HOME
mkdir -p $CONFIG_DIR/.urcontrol
HOME=$CONFIG_DIR $SCRIPT_DIR/URControl -r &>$CONFIG_DIR/URControl.log &
