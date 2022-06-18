#!/bin/bash

my_dir=$(dirname $0)

while read p; do
    code --install-extension $p
done < $my_dir/extensions
