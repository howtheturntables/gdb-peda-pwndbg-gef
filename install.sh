#!/bin/sh

installer_path=$(cd "$(dirname "$0")" && pwd)

mkdir -p ~/.gdb_plugins

echo "[+] Checking for required dependencies..."
if command -v git >/dev/null 2>&1 ; then
    echo "[-] Git found!"
else
    echo "[-] Git not found! Aborting..."
    echo "[-] Please install git and try again."
    exit 1
fi

if [ -f ~/.gdbinit ] || [ -h ~/.gdbinit ]; then
    echo "[+] backing up gdbinit file"
    cp ~/.gdbinit ~/.gdbinit.back_up
fi

# download peda and decide whether to overwrite if exists
if [ -d ~/.gdb_plugins/peda ] || [ -h ~/.peda ]; then
    echo "[-] PEDA found"
    read -p "skip download to continue? (enter 'y' or 'n') " skip_peda

    if [ $skip_peda = 'n' ]; then
        rm -rf ~/.gdb_plugins/peda
        git clone https://github.com/longld/peda.git ~/.gdb_plugins/peda
    else
        echo "PEDA skipped"
    fi
else
    echo "[+] Downloading PEDA..."
    git clone https://github.com/longld/peda.git ~/.gdb_plugins/peda
fi

# download peda arm and decide whether to overwrite if exists
if [ -d ~/.gdb_plugins/peda-arm ] || [ -h ~/.peda ]; then
    echo "[-] PEDA ARM found"
    read -p "skip download to continue? (enter 'y' or 'n') " skip_peda_arm

    if [ $skip_peda_arm = 'n' ]; then
        rm -rf ~/.gdb_plugins/peda-arm
	git clone https://github.com/alset0326/peda-arm.git ~/.gdb_plugins/peda-arm
    else
	echo "PEDA ARM skipped"
    fi
else	    
    echo "[+] Downloading PEDA ARM..."
    git clone https://github.com/alset0326/peda-arm.git ~/.gdb_plugins/peda-arm
fi

# download pwndbg and decide whether to overwrite if exists
if [ -d ~/.gdb_plugins/pwndbg ] || [ -h ~/.pwndbg ]; then
    echo "[-] Pwndbg found"
    read -p "skip download to continue? (enter 'y' or 'n') " skip_pwndbg

    if [ $skip_pwndbg = 'n' ]; then
        rm -rf ~/.gdb_plugins/pwndbg
        git clone https://github.com/pwndbg/pwndbg.git ~/.gdb_plugins/pwndbg

        cd ~/.gdb_plugins/pwndbg
        ./setup.sh
    else
        echo "Pwndbg skipped"
    fi
else
    echo "[+] Downloading Pwndbg..."
    git clone https://github.com/pwndbg/pwndbg.git ~/.gdb_plugins/pwndbg

    cd ~/.gdb_plugins/pwndbg
    ./setup.sh
fi

# download gef and decide whether to overwrite if exists
if [ -d ~/.gdb_plugins/gef ] || [ -h ~/.gef ]; then
    echo "[-] GEF found"
    read -p "skip download to continue? (enter 'y' or 'n') " skip_gef

    if [ $skip_gef = 'n' ]; then
        rm -rf ~/.gdb_plugins/gef
        git clone https://github.com/hugsy/gef.git ~/.gdb_plugins/gef

        cd ~/.gdb_plugins/gef/scripts
        ./gef.sh
    else
        echo "GEF skipped"
    fi
else
    echo "[+] Downloading GEF..."
    git clone https://github.com/hugsy/gef.git ~/.gdb_plugins/gef

    cd ~/.gdb_plugins/gef/scripts
    ./gef.sh
fi

cd $installer_path

echo "[+] Setting .gdbinit..."
cp gdbinit ~/.gdbinit

install_wrapper() {
    src_gdb_file=$1
    dst=$2

    if [ -f "$installer_path/$src_gdb_file" ]; then
        echo "[+] Installing $src_gdb_file at $dst"
        if sudo cp "$installer_path/$src_gdb_file" "$dst" && sudo chmod +x "$dst"; then
            echo "[+] $src_gdb_file installed successfully"
        else
            echo "[-] Permission denied (need sudo to install $file). Exiting..."
            exit 1
        fi
    else
        echo "[-] $src_gdb_file not found, skipping"
    fi
}

echo "[+] Creating GDB wrapper scripts..."

if [ -d ~/.gdb_plugins/peda ]; then
    install_wrapper gdb-peda /usr/bin/gdb-peda
fi

if [ -d ~/.gdb_plugins/peda-arm ]; then
    install_wrapper gdb-peda-arm /usr/bin/gdb-peda-arm
fi

if [ -d ~/.gdb_plugins/pwndbg ]; then
    install_wrapper gdb-pwndbg /usr/bin/gdb-pwndbg
fi

if [ -d ~/.gdb_plugins/gef ]; then
    install_wrapper gdb-gef /usr/bin/gdb-gef
fi

echo "[+] Done"
