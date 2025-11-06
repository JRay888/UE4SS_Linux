# Automated CI/CD Build Setup

I've created automated build pipelines so you don't have to manually compile on Linux. The build will happen automatically in the cloud!

## Option 1: GitLab CI/CD (Recommended for Private Repos)

### Setup Steps:

1. **Create a GitLab account** (if you don't have one)
   - Go to gitlab.com
   - Sign up for free

2. **Push your code to GitLab**
   ```bash
   cd C:\Users\MayorJRay\RE-UE4SS-3.0.1
   git init
   git add .
   git commit -m "Initial Linux port"
   git remote add origin https://gitlab.com/YOUR_USERNAME/RE-UE4SS-linux.git
   git push -u origin main
   ```

3. **GitLab will automatically detect `.gitlab-ci.yml`** and start building

4. **Monitor the build**
   - Go to your project on GitLab
   - Click "CI/CD" → "Pipelines"
   - Watch the build progress

5. **Download the built files**
   - Once the build completes, go to the pipeline
   - Click on the "package:release" job
   - Download the artifact: `UE4SS-Linux-{commit}.tar.gz`

### What the GitLab Pipeline Does:
- ✅ Installs all dependencies (GCC, CMake, Rust, etc.)
- ✅ Checks out code with all submodules
- ✅ Builds for Shipping configuration
- ✅ Builds for Debug configuration (on develop branch)
- ✅ Packages everything into a tarball
- ✅ Keeps artifacts for 30 days

---

## Option 2: GitHub Actions (Recommended for Public Repos)

### Setup Steps:

1. **Create a GitHub account** (if you don't have one)
   - Go to github.com
   - Sign up for free

2. **Link GitHub to Epic Games** (REQUIRED for submodules)
   - Go to your Epic Games account settings
   - Link your GitHub account
   - This allows access to Unreal Engine submodules

3. **Push your code to GitHub**
   ```bash
   cd C:\Users\MayorJRay\RE-UE4SS-3.0.1
   git init
   git add .
   git commit -m "Initial Linux port"
   git remote add origin https://github.com/YOUR_USERNAME/RE-UE4SS-linux.git
   git push -u origin main
   ```

4. **GitHub will automatically detect the workflow** in `.github/workflows/build-linux.yml`

5. **Monitor the build**
   - Go to your repo on GitHub
   - Click "Actions" tab
   - Watch the workflow run

6. **Download the built files**
   - Click on the completed workflow run
   - Scroll down to "Artifacts"
   - Download `UE4SS-Linux-{sha}.tar.gz`

### What the GitHub Actions Workflow Does:
- ✅ Runs on Ubuntu 22.04
- ✅ Installs dependencies automatically
- ✅ Uses Rust action for toolchain setup
- ✅ Builds with parallel compilation
- ✅ Uploads artifacts for 30 days
- ✅ Creates release packages on main branch

---

## Option 3: Manual Build (If CI Fails)

If the automated builds fail due to compilation errors:

1. **SSH into your Linux server**
   ```bash
   ssh user@your-server
   ```

2. **Upload the code**
   ```bash
   scp -r C:\Users\MayorJRay\RE-UE4SS-3.0.1 user@your-server:/home/user/
   ```

3. **Follow the Quick Start guide**
   - See `QUICK_START_LINUX.md`
   - You'll need to manually fix compilation errors

---

## Expected Build Errors

The automated build **WILL LIKELY FAIL** initially. Here's why and what to do:

### Common Issues:

1. **Submodule Access**
   - **Error**: "Permission denied" when cloning submodules
   - **Fix**: Make sure your GitHub account is linked to Epic Games
   - **GitLab**: May need to add SSH keys or personal access tokens

2. **Windows-Specific Code**
   - **Error**: "Windows.h not found" or similar
   - **Fix**: This needs manual code changes (see below)
   - **Where**: Likely in `deps/first/` directories

3. **Missing Symbols**
   - **Error**: "undefined reference to `GetModuleFileName`" etc.
   - **Fix**: Need to create Linux equivalents for these functions
   - **Status**: Will require iterative fixes

### Iterative Fix Process:

When a build fails:

1. **Download the build log** from GitLab/GitHub
2. **Identify the first error** (ignore subsequent errors)
3. **Find the problematic file** in the error message
4. **Fix the Windows-specific code**:
   ```cpp
   // Windows code
   #ifdef _WIN32
   HANDLE h = CreateFile(...);
   #else
   // Linux equivalent
   int fd = open(...);
   #endif
   ```
5. **Commit and push** the fix
6. **CI will automatically rebuild**
7. **Repeat** until it compiles

---

## Monitoring Build Progress

### GitLab:
```
Your Project → CI/CD → Pipelines → Click on latest pipeline
```

### GitHub:
```
Your Repo → Actions → Click on latest workflow run
```

### What to Look For:
- ✅ **Green checkmarks** = Success
- ⏸️ **Yellow circles** = In progress  
- ❌ **Red X** = Failed (click to see logs)

---

## Getting the Built Binary

### Once Build Succeeds:

**GitLab:**
1. Go to pipeline
2. Click "package:release" job
3. Download artifact on right sidebar

**GitHub:**
1. Go to Actions
2. Click successful workflow
3. Scroll to "Artifacts" section
4. Download the tarball

### Extract and Use:
```bash
tar -xzf UE4SS-Linux-*.tar.gz
cd bin/
# You'll find libUE4SS.so here
```

---

## Pro Tips

1. **Use the CI system to iterate**
   - Don't waste time setting up a local Linux build environment
   - Push fixes, let CI build, check results
   - Much faster than building locally

2. **Enable email notifications**
   - GitLab/GitHub can email you when builds complete
   - No need to constantly check

3. **Use branches**
   - Create a `develop` branch for experimental fixes
   - Only merge to `main` when builds succeed

4. **Read the logs carefully**
   - The first error is usually the real problem
   - Subsequent errors are often cascading failures

---

## Need Help?

If automated builds keep failing:

1. **Share the build logs** 
   - Copy the error output from GitLab/GitHub
   - Ask on UE4SS Discord or create an issue

2. **Check LINUX_PORT_SUMMARY.txt**
   - Lists known areas needing work
   - Has Windows→Linux API translations

3. **Start small**
   - Try building just the dependencies first
   - Add UE4SS components incrementally

---

## Summary

✅ **Easiest**: Use GitLab CI (works great with private repos, no Epic Games linking required initially)

✅ **Most Popular**: Use GitHub Actions (free for public repos, great integration)

🔧 **Last Resort**: Manual build on your Linux server

**The CI will fail at first** - that's expected! Use it to iteratively fix compilation errors without needing your own Linux build machine.
