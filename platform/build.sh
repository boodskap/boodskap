#!/bin/bash
PVERSION="4.4.9"
PPATCH="02"
MODE="single"

echo "Building..."
docker build --build-arg PVERSION=${PVERSION} --build-arg PPATCH=${PPATCH} --build-arg MODE=${MODE} -t boodskapiot/platform:${PVERSION}-${PPATCH} -t boodskapiot/platform:latest .
