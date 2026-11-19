# colab-lfs-demo

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/YOUR_GITHUB_USER/colab-lfs-demo/blob/main/notebooks/lfs_demo.ipynb)

Small test repo: a Jupyter notebook that opens in Google Colab and loads a ~6 MB data file stored with **Git LFS**.

```
.
├── .gitattributes            # *.npy, *.nc, *.parquet … → Git LFS
├── data/
│   └── wind_speed_field.npy  # synthetic (24 h × 256 × 256) wind field, stored in LFS
├── notebooks/
│   └── lfs_demo.ipynb        # clones the repo, pulls LFS files, plots the data
└── publish.sh                # creates the GitHub repo and pushes
```

## Publish

Needs `git`, `git-lfs` and the GitHub CLI (`gh auth login` once).

```bash
./publish.sh <your-github-user>                         # public repo "colab-lfs-demo"
./publish.sh <your-github-user> my-repo-name --private  # private, custom name
```

The script fills in your username in this README and in the notebook, commits, and pushes.

### Manual alternative (no `gh`)

1. Create an empty repo on github.com.
2. Replace `YOUR_GITHUB_USER` (and the repo name, if different) in `README.md` and `notebooks/lfs_demo.ipynb`.
3. Run:
   ```bash
   git init -b main
   git lfs install --local
   git add .gitattributes && git add .
   git commit -m "Colab + Git LFS demo"
   git remote add origin https://github.com/<user>/<repo>.git
   git push -u origin main
   ```

## Test

1. On GitHub, `data/wind_speed_field.npy` should show **"Stored with Git LFS"**.
2. Click **Open in Colab** and choose **Runtime → Run all**.
3. The notebook checks that it got the real file (not an LFS pointer) and plots it.

## How it works / gotchas

- **The Colab button only loads the `.ipynb`**, not the repo. That's why the notebook clones the repo and runs `git lfs pull` itself.
- **Private repos:** Colab will ask to authorize GitHub when you open the notebook. Cloning *inside* the notebook needs a token: add a fine-grained token with read access as a Colab secret named `GH_TOKEN`.
- **Bandwidth:** every new Colab session downloads the LFS files again, which counts against your GitHub LFS bandwidth quota.
