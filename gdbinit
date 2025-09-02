# ensures GDB resolves paths relative to the root of the file system
set sysroot /

# the hookpost-file function automatically executes after a file command is issued to load an executable
define hookpost-file
# ensures GDB resolves paths relative to the root of the file system every time a new executable is loaded
set sysroot /
end

define init-peda
source ~/.gdb_plugins/peda/peda.py
end
document init-peda
Initializes the PEDA (Python Exploit Development Assistant for GDB) framework
end

define init-peda-arm
source ~/.gdb_plugins/peda-arm/peda-arm.py
end
document init-peda-arm
Initializes the PEDA (Python Exploit Development Assistant for GDB) framework for ARM.
end

define init-peda-intel
source ~/.gdb_plugins/peda-arm/peda-intel.py
end
document init-peda-intel
Initializes the PEDA (Python Exploit Development Assistant for GDB) framework for INTEL.
end

# creates a custom command called `init-pwndbg`` that can be called from gdb
define init-pwndbg
# loads pwndbg (a powerful GDB plugin for exploit development)
source ~/.gdb_plugins/pwndbg/gdbinit.py
# configures GDB to follow the parent process after a fork
set follow-fork-mode parent
end
# provides documentation for the custom `init-pwndbg` command
document init-pwndbg
Initializes PwnDBG
end

define init-gef
source ~/.gdb_plugins/gef/gef.py
end
document init-gef
Initializes GEF (GDB Enhanced Features)
end

# unsets extra GDB env vars to ensure debugging matches system environment
set exec-wrapper env -u LINES -u COLUMNS -u _
# sets disassembly syntax to Intel syntax (over default AT&T syntax) for easier parsing
set disassembly-flavor intel