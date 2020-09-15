#!/usr/bin/env bash

decoded=$1
filename=$2

echo $decoded | base64 -d > $filename