#!/bin/bash

cd cassandra
rm -rf cassandra01/*
rm -rf cassandra02/*

cd ../elastic
rm -rf elastic01/*
rm -rf elastic02/*

cd ../ignite
rm -rf ignite01/*
rm -rf ignite02/*

cd ../platform
rm -rf platform01/data/*
rm -rf platform02/data/*
