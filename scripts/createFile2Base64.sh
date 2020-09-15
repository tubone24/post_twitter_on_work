#!/usr/bin/env bash

filename=$1

cat $filename | base64 -d