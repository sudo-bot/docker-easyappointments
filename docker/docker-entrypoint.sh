#!/bin/sh -l
##
# @license http://unlicense.org/UNLICENSE The UNLICENSE
# @author William Desportes <williamdes@wdes.fr>
##

set -eu

echo 'Starting...'
horust --unsuccessful-exit-finished-failed
echo 'Stopped.'
