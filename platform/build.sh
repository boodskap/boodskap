#!/bin/bash
PVERSION="4.0.0"
PPATCH="0002"
echo "Building with"
echo "docker build --build-arg PVERSION=${PVERSION} --build-arg PPATCH=${PPATCH} -t boodskapiot/platform:${PVERSION}-${PPATCH} -t boodskapiot/platform:latest ."
docker build --build-arg PVERSION=${PVERSION} --build-arg PPATCH=${PPATCH} -t boodskapiot/platform:${PVERSION}-${PPATCH} -t boodskapiot/platform:latest .
