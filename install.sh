#!/bin/sh

SCRIPT=$(readlink -f "$0")
BASEDIR=$(dirname "$SCRIPT")

# submodule
echo -e "\n[+] Update submodule : gef, gepda, pwndbg"
git submodule init
git submodule update

# gef
echo -e "\n[x] Update Gef Submodule"
cd "$BASEDIR"/gef
git checkout main
git pull

# peda
cd "$BASEDIR"/peda
git checkout master
git pull

# pwndbg
echo -e "\n[x] Update pwndbg Submodule"
cd "$BASEDIR"/pwndbg
echo $(pwd)
git checkout dev
git pull
echo -e "\n[+] Install pwndbg"
./setup.sh

# radare2
echo -e "\n[x] Update Radare2 Submodule"
cd "$BASEDIR"/radare2
git checkout master
git pull
echo -e "\n[+] Install radare2"
./sys/install.sh

echo -e "\n[+] Installation DONE."
