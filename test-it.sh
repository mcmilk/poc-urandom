#!/bin/bash

MODS="cs128p cs256pp blake3"

for m in $MODS; do
  #echo sudo insmod ./poc_${m}.ko
  sudo insmod ./poc_${m}.ko
done
sudo ln -f -s /dev/urandom /dev/urandom-linux

BS=32
SZ=1
for bs in 1 2 3 4 5; do
  for m in $MODS "linux"; do
    N=`printf "%8s %5s" $m $BS`
    pv -N "$N" -B $BS -S -s ${SZ}M /dev/urandom-$m > /dev/null
  done
  BS=$((BS*4))
  SZ=$((SZ*8))
done

for m in $MODS; do
  #echo sudo rmmod poc_${m}
  sudo rmmod poc_${m}
done
sudo rm -f /dev/urandom-linux
