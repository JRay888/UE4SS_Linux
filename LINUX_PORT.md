# UE4SS Linux Port

This is an **experimental** Linux port of UE4SS, primarily intended for use with Linux dedicated servers like Palworld.

## ⚠️ Important Warnings

1. **This is experimental and untested** - The Linux port requires significant additional work and testing
2. **Server-only** - The GUI features are disabled on Linux (DX11/Windows GUI removed)
3. **May not work with all games** - Different server implementations may have different UE object systems
4. **Active development needed** - This port provides the foundation but needs game-specific testing

## Changes from Windows Version

### Core Changes
- Replaced `DllMain` with `__attribute__((constructor))` for .so loading
- Replaced Windows threading (CreateThread) with pthreads
- Removed Windows crash dumper (MiniDumpWriteDump) - using signal handlers and backtrace instead
- Removed DirectX 11 and Win32 GUI components
- Replaced Windows-specific libraries (dbghelp, psapi) with Linux equivalents (pthread, dl)

### Files Added
- `src/main_ue4ss_linux.cpp` - Linux entry point using .so constructor
- `src/CrashDumper_linux.cpp` - Linux crash handler using signals
- `build_linux.sh` - Linux build script

### Build System Changes
- Made ASM_MASM optional (Windows-only)
- Added Linux platform definitions to CMake
- Conditional compilation for platform-specific code
- Linux-specific linker flags and libraries

## Prerequisites

### On Your Development Machine (for building)
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y build-essential cmake git g++ \
    libgl1-mesa-dev libx11-dev libxrandr-dev libxinerama-dev \
    libxcursor-dev libxi-dev

# Install Rust (required for patternsleuth)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
```

### On Your Linux Server (for running)
```bash
# Install runtime dependencies
sudo apt-get install -y libgl1 libx11-6
```

## Building

### Step 1: Clone and Initialize Submodules
```bash
git clone <your-repo-url>
cd RE-UE4SS-3.0.1
git submodule update --init --recursive
```

**Important**: You need your GitHub account linked to an Epic Games account to access the Unreal Engine submodules.

### Step 2: Build
```bash
chmod +x build_linux.sh
./build_linux.sh Shipping
```

Build modes: `Debug`, `Shipping`, `Test`

The output will be in: `build_linux/Output/Game__Shipping__Linux/UE4SS/bin/libUE4SS.so`

## Installation on Linux Server

### Step 1: Copy Files
```bash
# Copy the .so file to your Palworld server directory
cp build_linux/Output/Game__Shipping__Linux/UE4SS/bin/libUE4SS.so /path/to/palworld/server/
```

### Step 2: Set Up UE4SS Configuration
```bash
# Copy or create UE4SS configuration files in the server directory
# You'll need:
# - UE4SS-settings.ini
# - Mods/ directory with your Lua mods
```

### Step 3: Load UE4SS

#### Option A: Using LD_PRELOAD (Recommended)
```bash
cd /path/to/palworld/server
LD_PRELOAD=./libUE4SS.so ./PalServer-Linux-Shipping
```

#### Option B: Using patchelf (Persistent)
```bash
# Install patchelf
sudo apt-get install patchelf

# Patch the server binary
patchelf --add-needed ./libUE4SS.so ./PalServer-Linux-Shipping

# Now run normally
./PalServer-Linux-Shipping
```

## Known Issues and Limitations

### Currently Disabled
- **GUI**: All DirectX 11 and Win32 GUI features are disabled
  - Live View
  - Console Window
  - Visual debugger
- **Crash Dumps**: Using basic signal handlers instead of Windows minidumps

### Potential Issues
1. **Memory Layout Differences**: Windows and Linux binaries may have different memory layouts
2. **Calling Conventions**: Some function hooking may behave differently on Linux
3. **Symbol Resolution**: Linux .so loading is different from Windows DLL injection
4. **Game-Specific Issues**: Each game's Linux server may be built differently

## Debugging

### Enable Verbose Logging
Edit `UE4SS-settings.ini`:
```ini
[Debug]
ConsoleEnabled = true
GuiConsoleEnabled = false
GuiConsoleVisible = false

[Logging]
LogLevel = 2  ; 0=Error, 1=Warning, 2=Info, 3=Verbose
```

### Check if UE4SS Loaded
```bash
# Check if the .so is loaded
cat /proc/<PID>/maps | grep UE4SS

# Check for crash logs
ls -la crash_*.log
```

### Common Problems

#### "Symbol not found" errors
- The game's Linux server may not export the same symbols as the Windows version
- You may need to update AOBs (Array of Bytes) signatures for Linux

#### Segmentation faults on startup
- Check that all dependencies are installed
- Verify that your Lua mods are compatible
- Try with no mods first to isolate the issue

#### UE4SS doesn't seem to load
- Verify LD_PRELOAD is working: `ldd ./PalServer-Linux-Shipping`
- Check file permissions: `chmod +x libUE4SS.so`
- Look for error messages in console output

## Development Notes

### Additional Work Needed

This port provides the foundation, but several components need work:

1. **Platform Abstraction Layer**: Many files still have Windows-specific code that needs to be abstracted
2. **Testing**: Extensive testing with actual Linux game servers
3. **GUI Alternative**: Consider adding a web-based UI for server administration
4. **Signal Handling**: Improve the Linux crash handler
5. **Injection Method**: May need alternative loading methods depending on the game

### Areas with Windows Dependencies Still Present

Many first-party dependencies in `deps/first/` may have Windows-specific code:
- File I/O operations
- Memory scanning
- Process enumeration
- Function hooking

You may encounter build errors in these areas that need to be addressed case-by-case.

## Contributing

If you get this working with Palworld or other games:
1. Document your findings
2. Share any game-specific configuration
3. Report issues with specific error messages
4. Submit patches for improvements

## Support

This is an experimental port. For best results:
1. Start with the simplest Lua mods first
2. Test without GUI features
3. Monitor server logs carefully
4. Be prepared to modify signatures/AOBs for Linux

Good luck! This is cutting-edge territory for UE4SS.
