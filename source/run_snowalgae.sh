#!/bin/sh
# Yukihiko Onuma, 2022 IIS, the University of Tokyo
#
# Basic Shell-script to run Snow Algae Model.
#
#                                             Last Modified : 24 Jan 2022  
#
###########################################################################

./snowalgae.bin

mv ./*.csv ../output
#mv ./*.bin ../output
mv ./log.txt ../output
cp ./*.nml ../output
