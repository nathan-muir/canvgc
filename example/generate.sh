#!/usr/bin/env bash

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
PROJECT_ROOT=$( cd "$( dirname "$SCIRPT_DIR" )" && pwd )

node "$PROJECT_ROOT/bin/canvgc" "$PROJECT_ROOT/example/simple.svg" "$PROJECT_ROOT/example/simple.js" --prepend 'if(typeof window.canvgc=="undefined")window.canvgc={};window.canvgc.simple =' --append ';'
node "$PROJECT_ROOT/bin/canvgc" "$PROJECT_ROOT/example/complex.svg" "$PROJECT_ROOT/example/complex.js" --prepend 'if(typeof window.canvgc=="undefined")window.canvgc={};window.canvgc.complex =' --append ';'
