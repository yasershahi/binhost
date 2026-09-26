# gentoo-binhost — personal binary package host

Builds Gentoo binpkgs with **this laptop's exact config** on GitHub Actions
and publishes them via GitHub Pages, so the laptop downloads instead of
compiling. Unsigned + HTTPS (personal use).

## First-time setup (do once)

1. Create an empty **public** repo on GitHub (e.g. `yasershahi/gentoo-binhost`)
   and push this folder to it:
   ```sh
   cd ~/Projects/binhost
   git init -b main
   git add -A
   git commit -m "personal binhost"
   git remote add origin git@github.com:<you>/<repo>.git
   git push -u origin main
   ```
2. In repo Settings → Pages → deploy from the `gh-pages` branch
   (it appears after the first workflow run).
3. Actions tab → `build-binpkgs` → Run workflow. First run builds only
   `fastfetch` + `htop` (fast validation).
4. Point the laptop at it (personal first, official as fallback):
   ```sh
   # in /etc/portage/make.conf
   PORTAGE_BINHOST="https://<you>.github.io/<repo>/ https://distfiles.gentoo.org/releases/amd64/binpackages/23.0/x86-64"
   ```
5. Test: `emerge -p <pkg>` should show `[binary]` instead of `[ebuild]`.

## Adding the monsters

Uncomment lines in `packages.txt` (`gcc`, `llvm`, `clang`, `mesa`…),
push, re-run the workflow. Keep `portage/` in sync with the laptop
after any make.conf / package.use change (just copy the files over).

## Notes

- CI builds from source on purpose (`--usepkg=n`); your config files
  in `portage/` guarantee USE-flag match with the laptop.
- `gh-pages` is force-pushed orphan on each run (binpkgs are big,
  history would explode).
- Unsigned binhost: fine over HTTPS for personal use; portage may
  warn but installs. GPG signing can be added later if desired.
- If a package still shows `[ebuild]`, its USE/flags drifted from
  `portage/` — re-sync the configs and rebuild.
