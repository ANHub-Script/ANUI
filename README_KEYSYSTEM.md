# WindUI Key System Installation Guide

Follow these simple steps to set up your Key System with automatic registration.

## 1. Upload to GitHub
You need to upload the specific folder structure to your GitHub repository.

**Files to Upload:**
*   `.github/workflows/key-system.yml` (Crucial for auto-registration)
*   `docs/index.html` (The website)
*   `docs/script.js` (The logic)
*   `docs/style.css` (The look)
*   `docs/keys.txt` (The database)

**Folder Structure should look like this:**
```text
RepoName/
├── .github/
│   └── workflows/
│       └── key-system.yml
└── docs/
    ├── index.html
    ├── script.js
    ├── style.css
    └── keys.txt
```

## 2. Configuration (Done!)
I have automatically updated `docs/script.js` with your repo name:
`const REPO_NAME = "ANHub-Script/key-sytem";`

## 3. Enable GitHub Pages
1.  Go to your Repository Settings on GitHub.
2.  Click **Pages** on the left sidebar.
3.  Under **Build and deployment** -> **Branch**, select `main` (or master) and the `/docs` folder.
4.  Click **Save**.
5.  Your website link will be: `https://ANHub-Script.github.io/key-sytem/`

## 4. Enable Permissions (For Auto-Database)
1.  Go to Repository Settings.
2.  Click **Actions** -> **General**.
3.  Scroll down to **Workflow permissions**.
4.  Select **Read and write permissions**.
5.  Click **Save**.

## 5. Update Your Lua Script
Use the example in `docs/Lua_Integration_Example.lua` to connect your script to this system.
*   Replace `WEBSITE_URL` with your new GitHub Pages link.
*   Replace `raw.githubusercontent...` link with your own raw link to `keys.txt`.

## 6. How the Auto-Registration Works
1.  User clicks "Get Key" -> Website generates a key.
2.  User clicks "Register" -> Website opens a GitHub Issue.
3.  User clicks "Submit New Issue" -> **GitHub Action Bot** wakes up.
4.  Bot validates HWID, adds it to `keys.txt`, and saves it.
5.  Website automatically detects the change and activates the user.

---
**Done!** Your key system is now fully serverless and automated.
