# UE4SS Linux Port - Complete Package

This directory contains an **experimental Linux port** of UE4SS with **automated CI/CD builds**.

## 🎯 What You Have

✅ **Modified source code** for Linux compatibility  
✅ **Automated build pipelines** (GitLab CI + GitHub Actions)  
✅ **Comprehensive documentation**  
✅ **Build scripts** for manual compilation  

## 🚀 Quick Start (The Easy Way)

### Step 1: Choose Your CI Platform

Pick ONE of these options:

| Platform | Best For | Setup Time |
|----------|----------|------------|
| **GitLab CI** | Private repos, simpler | 5 minutes |
| **GitHub Actions** | Public repos, popular | 10 minutes |

### Step 2: Follow the Setup Guide

**Read:** `CI_SETUP.md` - This has complete instructions for:
- Creating a GitLab/GitHub account
- Pushing your code
- Triggering automated builds
- Downloading the compiled binary

### Step 3: Get Your Binary

The CI system will automatically:
- Build UE4SS for Linux
- Create a `.tar.gz` package
- Make it available for download

**You don't need a Linux machine to build!**

## 📚 Documentation Guide

Depending on what you need, read these files:

### For Getting Started:
1. **`CI_SETUP.md`** ⭐ START HERE
   - How to use automated builds
   - No Linux machine needed!

2. **`QUICK_START_LINUX.md`**
   - Manual build instructions
   - If you want to build on your server directly

### For Understanding the Port:
3. **`LINUX_PORT.md`**
   - Technical details of the port
   - Debugging guide
   - Known limitations

4. **`LINUX_PORT_SUMMARY.txt`**
   - What was changed
   - What still needs work
   - Realistic expectations

### For Installation:
5. **After you have the binary:**
   - Extract: `tar -xzf UE4SS-Linux-*.tar.gz`
   - Copy `libUE4SS.so` to your Palworld server
   - Run: `LD_PRELOAD=./libUE4SS.so ./PalServer-Linux-Shipping`

## 🔧 What's Been Modified

### Core Changes:
- ✅ CMake build system (supports Linux platform)
- ✅ Entry point (`.so` constructor instead of DllMain)
- ✅ Crash dumper (signal handlers instead of Windows APIs)
- ✅ Removed GUI components (DX11, Win32)
- ✅ Platform-specific library linking

### New Files:
```
.gitlab-ci.yml                    # GitLab CI pipeline
.github/workflows/build-linux.yml # GitHub Actions workflow
UE4SS/src/main_ue4ss_linux.cpp   # Linux entry point
UE4SS/src/CrashDumper_linux.cpp  # Linux crash handler
build_linux.sh                    # Manual build script
```

### Modified Files:
```
CMakeLists.txt              # Added Linux platform support
UE4SS/CMakeLists.txt        # Platform-specific compilation
```

## ⚠️ Important Warnings

### This Will Likely Not Work Immediately

Here's the reality:

1. **The build WILL fail initially**
   - Many dependencies have Windows-specific code
   - You'll need to fix compilation errors iteratively
   - Use the CI system to test fixes automatically

2. **Even if it compiles, it may not work with Palworld**
   - Linux server may have different UE object system
   - Memory layouts differ between Windows/Linux
   - Function hooking needs testing

3. **This is a foundation, not a finished product**
   - Expect 1-2 months of work to stabilize
   - Need to fix Windows APIs throughout dependencies
   - Requires debugging with actual game server

### Realistic Timeline

- **Week 1**: Get it to compile (fix build errors)
- **Week 2-3**: Get it to load without crashing
- **Week 4-8**: Get basic functionality working
- **Month 3+**: Stabilize and add features

## 🎬 Recommended Workflow

### The Iterative Approach:

```bash
# 1. Push to GitLab/GitHub
git push origin main

# 2. CI automatically builds
# (Watch the build logs)

# 3. Build fails with error
# (Read the first error in logs)

# 4. Fix the error locally
# Example: Replace Windows.h with Linux equivalent

# 5. Push the fix
git commit -am "Fix: Replace GetModuleFileName with dladdr"
git push origin main

# 6. CI rebuilds automatically
# (Repeat until success)
```

**You don't need to SSH into Linux or set up a build environment!** Use CI to iterate.

## 📦 File Structure

```
RE-UE4SS-3.0.1/
├── .gitlab-ci.yml              # GitLab pipeline
├── .github/workflows/
│   └── build-linux.yml         # GitHub Actions
├── CI_SETUP.md                 # ⭐ START HERE
├── LINUX_PORT.md               # Technical docs
├── QUICK_START_LINUX.md        # Manual build guide
├── LINUX_PORT_SUMMARY.txt      # Changes summary
├── README_LINUX_PORT.md        # This file
├── build_linux.sh              # Build script
├── CMakeLists.txt              # Modified for Linux
└── UE4SS/
    ├── CMakeLists.txt          # Modified for Linux
    └── src/
        ├── main_ue4ss_linux.cpp      # New
        └── CrashDumper_linux.cpp     # New
```

## 🆘 When Things Go Wrong

### Build Fails:
1. Check `CI_SETUP.md` - Expected Build Errors section
2. Look at the **first** error in build logs
3. Find the Windows API that's failing
4. Replace with Linux equivalent (see LINUX_PORT_SUMMARY.txt)
5. Push and let CI rebuild

### Can't Access Submodules:
- Link your GitHub account to Epic Games
- For GitLab: May need SSH keys or personal access token

### Build Succeeds But Crashes:
1. Check that libUE4SS.so loaded: `cat /proc/<PID>/maps | grep UE4SS`
2. Look for crash logs in server directory
3. Enable verbose logging in UE4SS-settings.ini
4. Check Palworld server logs

### Completely Stuck:
- Share your build logs on UE4SS Discord
- Create a GitHub issue with error details
- Check if others have attempted Palworld Linux modding

## 💡 Pro Tips

1. **Use CI, not local builds**
   - Faster iteration
   - No need to set up Linux build environment
   - Free compute time!

2. **Fix errors one at a time**
   - Don't try to fix everything at once
   - First error is usually the root cause
   - Subsequent errors often cascade from first

3. **Test incrementally**
   - Get dependencies building first
   - Then add UE4SS components
   - Test with minimal mods initially

4. **Document your fixes**
   - You're pioneering this
   - Others will benefit from your notes
   - Share on UE4SS Discord

## 🎯 Success Criteria

### Milestone 1: Compilation
- [ ] Build completes without errors
- [ ] libUE4SS.so is generated
- [ ] All dependencies linked properly

### Milestone 2: Loading
- [ ] libUE4SS.so loads via LD_PRELOAD
- [ ] No immediate segfaults
- [ ] UE4SS initialization runs

### Milestone 3: Basic Functionality
- [ ] Lua engine initializes
- [ ] UE object system accessible
- [ ] Simple mods can load

### Milestone 4: Full Functionality
- [ ] All Lua mods work
- [ ] Stable under load
- [ ] No memory leaks

## 🤝 Contributing Back

If you get this working:

1. **Document everything**
   - What errors you encountered
   - How you fixed them
   - Palworld-specific quirks

2. **Share your work**
   - Create a public repo with your fixes
   - Post on UE4SS Discord
   - Help others attempting this

3. **Consider upstreaming**
   - Submit PRs to official UE4SS repo
   - Help make Linux a first-class platform

## 🌟 The Bottom Line

**What I've Given You:**
- ✅ Foundation for Linux port
- ✅ Automated build infrastructure
- ✅ Comprehensive documentation
- ✅ Path forward with clear steps

**What You Need to Do:**
- 🔧 Iteratively fix compilation errors
- 🔧 Test with Palworld Linux server
- 🔧 Debug and stabilize
- 🔧 Be patient - this is hard!

**The build system will do the heavy lifting. You just need to feed it fixes!**

---

## Next Steps

1. **Read `CI_SETUP.md`** - Set up automated builds
2. **Push to GitLab or GitHub** - Trigger first build
3. **Watch it fail** - Read the error logs
4. **Start fixing** - One error at a time
5. **Iterate** - Push fixes, rebuild, repeat

Good luck! You're attempting something that hasn't been done before with UE4SS. It's challenging, but with the automated CI, you've got the best chance of success. 🚀
