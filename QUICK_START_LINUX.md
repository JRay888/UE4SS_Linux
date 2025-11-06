# Quick Start: UE4SS on Linux Palworld Server

## Transfer Files to Linux Server

From your Windows machine, transfer these files to your Linux server:
```bash
# Upload the entire RE-UE4SS-3.0.1 directory to your Linux server
scp -r C:\Users\MayorJRay\RE-UE4SS-3.0.1 user@your-server:/home/user/
```

## On Your Linux Server

### 1. Install Dependencies
```bash
sudo apt-get update
sudo apt-get install -y build-essential cmake git g++ \
    libgl1-mesa-dev libx11-dev libxrandr-dev libxinerama-dev \
    libxcursor-dev libxi-dev

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
```

### 2. Initialize Submodules
```bash
cd /home/user/RE-UE4SS-3.0.1
git submodule update --init --recursive
```

**Note**: Your GitHub account must be linked to Epic Games for UE submodule access.

### 3. Build UE4SS
```bash
chmod +x build_linux.sh
./build_linux.sh Shipping
```

This will create: `build_linux/Output/Game__Shipping__Linux/UE4SS/bin/libUE4SS.so`

### 4. Install to Palworld Server
```bash
# Assuming your Palworld server is at /opt/palworld/
sudo cp build_linux/Output/Game__Shipping__Linux/UE4SS/bin/libUE4SS.so /opt/palworld/
sudo cp -r <your_mods_folder> /opt/palworld/Mods/
sudo cp UE4SS-settings.ini /opt/palworld/
```

### 5. Launch Palworld with UE4SS
```bash
cd /opt/palworld
LD_PRELOAD=./libUE4SS.so ./PalServer-Linux-Shipping
```

## Quick Test

To verify UE4SS loaded:
```bash
# In another terminal, while server is running
ps aux | grep PalServer
# Note the PID

cat /proc/<PID>/maps | grep UE4SS
# Should show libUE4SS.so is loaded

# Check for UE4SS logs in the server directory
ls -la /opt/palworld/*.log
```

## Troubleshooting

### Build Fails
- Make sure all dependencies are installed
- Check CMake version: `cmake --version` (need 3.18+)
- Check GCC version: `g++ --version` (need C++23 support, GCC 11+)

### Server Won't Start
```bash
# Check dependencies
ldd libUE4SS.so

# Run with verbose output
LD_DEBUG=all LD_PRELOAD=./libUE4SS.so ./PalServer-Linux-Shipping 2>&1 | grep UE4SS
```

### Mods Don't Load
1. Check `UE4SS-settings.ini` exists in server directory
2. Check `Mods/` directory structure matches Windows UE4SS format
3. Look for crash logs: `ls crash_*.log`

## What's Different from Windows?

- **No GUI**: All visual debugging tools are disabled
- **LD_PRELOAD**: Uses Linux shared library injection instead of DLL injection
- **Console only**: All output goes to stdout/logs (no popup windows)

## Next Steps

Read `LINUX_PORT.md` for:
- Detailed troubleshooting
- Development notes
- Known limitations
- How to contribute improvements
