#!/bin/bash


path=$1


fileicon -q set "$path" "${path}cover.jpg" || echo "failed"
