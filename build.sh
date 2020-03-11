#!/usr/bin/env bash

openscad -D 'print=true' -D 'part="top"' -o top.stl enclosure.scad
openscad -D 'print=true' -D 'part="bottom"' -o bottom.stl enclosure.scad
