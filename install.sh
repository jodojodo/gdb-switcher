# submodule
echo -e "\n[+] Update submodule : gef, gepda, pwndbg"
git submodule init
git submodule update

# gef
echo -e "\n[x] Update Gef Submodule and install gef-extras"
cd gef
git checkout dev
git pull
rm gef-extras && mkdir gef-extras
bash scripts/gef-extras.sh -b dev -p $PWD
cd ../

# peda
cd peda
git checkout master
git pull

# pwndbg
echo -e "\n[x] Update pwndbg Submodule"
cd pwndbg
git checkout dev
git pull
echo -e "\n[+] Install pwndbg"
(cd pwndbg && ./setup.sh)

# radare2 
echo -e "\n[x] Update Radare2 Submodule"
cd radare2
git checkout master
git pull
echo -e "\n[+] Install radare2"
./sys/install.sh

echo -e "\n[+] Installation DONE."
