#!/bin/sh

SCRIPT=$(readlink -f "$0")
BASEDIR=$(dirname "$SCRIPT")

# .gdbinit backup
echo "[+] Backup ~/.gdbinit"
NOW=$(date +"%Y-%M-%d")
cp ~/.gdbinit ~/.gdbinit".backup@"$NOW

# .gdbinit my configuration
if [ ! -f ~/.gdbinit-my ]; then
    echo "[+] copy .gdbinit-my to ~"
    cp "$BASEDIR"/.gdbinit-my ~
fi

# Legacy gdb
echo -e "\n[+] 1. legacy gdb"
echo "source ~/.gdbinit-my" > ~/.gdbinit-gdb

# gef
echo -e "[+] 2. gef"
cp "$BASEDIR"/gef/gef.py ~/.gdbinit-gef.py
gefInit="~/.gdbinit-gef.py"
echo "source "$gefInit > ~/.gdbinit-gef
echo "source ~/.gdbinit-my" >> ~/.gdbinit-gef
# Setup gef as standard
cp ~/.gdbinit-gef ~/.gdbinit
# Install gef-extras
rm -rf "$BASEDIR"/gef/gef-extras && mkdir "$BASEDIR"/gef/gef-extras
bash "$BASEDIR"/gef/scripts/gef-extras.sh -b main -p "$BASEDIR/gef"

echo -e "[+] 3. peda"
pedaInit="$BASEDIR/peda/peda.py"
rm "$BASEDIR/peda/lib/six.py" # as this is served via apt

# Work around for syntax error
rm "$BASEDIR/peda/peda.py"
wget https://raw.githubusercontent.com/longld/peda/444921e53c954468390af33e3d139d553a05df28/peda.py -O "$BASEDIR/peda/peda.py"

echo "source "$pedaInit > ~/.gdbinit-peda
echo "source ~/.gdbinit-my" >> ~/.gdbinit-peda

echo -e "[+] 4. pwndbg"
pwndbgInit="$BASEDIR/pwndbg/gdbinit.py"
echo "source "$pwndbgInit > ~/.gdbinit-pwndbg
echo "source ~/.gdbinit-my" >> ~/.gdbinit-pwndbg

echo -e "[+] gdb-switcher configuration ~/.zshrc"
cat <<'EOF' >> ~/.zshrc

# gdbs : gdb-switcher
function gdbs() {
      echo -e "\n[*] Which debugger ?"
      echo -e "\n1 : Legacy GDB"
      echo "2 : peda"
      echo "3 : gef"
      echo "4 : pwndbg"
      echo "5 : radare2"

      radare="no"

      read choice
      case $choice in
          1) echo "[+] gdb-switch => gdb"
             cp ~/.gdbinit-gdb ~/.gdbinit
             ;;
          2) echo "[+] gdb-switch => peda"
                 cp ~/.gdbinit-peda ~/.gdbinit
             ;;
          3) echo "[+] gdb-switch => gef"
                 cp ~/.gdbinit-gef ~/.gdbinit
             ;;
          4) echo "[+] gdb-switch => pwndbg"
                 cp ~/.gdbinit-pwndbg ~/.gdbinit
             ;;
          5) echo "[+] gdb-switch => radare2"
                  radare="run"
             ;;
      esac

      if [ "$#" -eq 1 ]; then
         if [ "$radare" = "run" ]; then
            echo "[+] debugger execution : radare2"
            r2 $1
         else
            echo "[+] debugger execution"
            gdb -q $1
         fi
      fi
}
EOF

echo -e "\n[+] Source .zshrc again for using new gdbs configuration."
source ~/.zshrc

echo -e "\n[+] DONE."
