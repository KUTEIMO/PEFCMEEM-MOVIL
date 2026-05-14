# Config Git for work — new laptop

Use this checklist on any PC where you will work on **PEFCMEEM-MOVIL**. Copy the blocks into **PowerShell** or **Git Bash** as noted.

---

## 1. Install Git

- Download: [https://git-scm.com/download/win](https://git-scm.com/download/win) (Windows) or use your OS package manager on Linux/macOS.
- During setup, choose **“Git from the command line and also from 3rd-party software”** so `git` works in the terminal.

---

## 2. Identity (required once per machine)

Replace the name and email with your work identity (same as on GitHub if you use that email there).

```bash
git config --global user.name "YOUR NAME"
git config --global user.email "your.work@email.com"
```

Optional: default branch name `main`:

```bash
git config --global init.defaultBranch main
```

Check:

```bash
git config --global --list
```

---

## 3. Get the project (clone)

Pick a folder where you keep code (example: `Documents\dev`). Then:

```bash
cd %USERPROFILE%\Documents\dev
git clone https://github.com/KUTEIMO/PEFCMEEM-MOVIL.git
cd PEFCMEEM-MOVIL
```

Repository URL: `https://github.com/KUTEIMO/PEFCMEEM-MOVIL.git`

---

## 4. Sign in to GitHub when pushing (HTTPS)

The first `git push` may open a browser or ask for credentials.

- Prefer **GitHub login** or a **Personal Access Token (PAT)** as the password (not your GitHub account password).
- Create a PAT: GitHub → **Settings** → **Developer settings** → **Personal access tokens** → generate with scope **`repo`**.

If you use **SSH** instead, add an SSH key in GitHub and clone with:

```bash
git clone git@github.com:KUTEIMO/PEFCMEEM-MOVIL.git
```

---

## 5. Flutter on the new laptop (to run the app)

1. Install Flutter: [https://docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install)
2. In the project folder:

```bash
cd PEFCMEEM-MOVIL
flutter pub get
flutter doctor
```

Open the folder in Cursor/VS Code and run the app from there if you prefer.

---

## 6. Daily Git commands (inside the project folder)

```bash
git pull
git status
git add -A
git commit -m "Short description of what you changed"
git push
```

If `git pull` reports conflicts, fix the files it lists, then:

```bash
git add -A
git commit -m "Resolve merge conflicts"
git push
```

---

## 7. If the folder was copied instead of cloned (avoid this)

Copying the project **without** the hidden `.git` folder means you lose history and remote. Always use **`git clone`** on the new laptop.

If you only have a ZIP without `.git`, clone fresh into a new folder and copy over any local-only files you still need (never overwrite `.git`).

---

## Quick reference

| Task              | Command                                      |
| ----------------- | -------------------------------------------- |
| Clone repo        | `git clone https://github.com/KUTEIMO/PEFCMEEM-MOVIL.git` |
| Update from GitHub | `git pull`                                  |
| Send changes      | `git add -A` → `git commit -m "..."` → `git push` |

---

*Last repo: [PEFCMEEM-MOVIL](https://github.com/KUTEIMO/PEFCMEEM-MOVIL) — branch `main`.*
