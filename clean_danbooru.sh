#!/bin/bash
#script to clean up danbooru downloads because its always riddled with 404s.

for file in $HOME/hitagi/*
do
    if diff $file ex.jpg > /dev/null
    then
        rm $file
    fi
done
