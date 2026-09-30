# yaser-overlay — personal Gentoo overlay + compile offload

This repo is a Gentoo overlay (lives at the repo root: `metadata/`,
`profiles/`, category dirs) **plus** a tiny personal compile-offload
kitchen. Nothing here targets other people: no signing, personal USE
flags, `-march=sandybridge`.

## Packages

| package | type | why here |
|---|---|---|
| `app-editors/vscode-bin` | upstream tarball, no compile | Microsoft doesn't ship Gentoo ebuilds |
| `www-client/vivaldi-bin` | upstream `.deb`, no compile | same, conflicts with `www-client/vivaldi` |
| `gui-apps/gearlever` | source build, `~amd64` | heavy dep tree (libadwaita/GTK4) on old laptop |
| `media-video/footage`, `media-video/flowblade`, `x11-misc/clockenstein`, `www-client/brave-origin-bin` | legacy | kept as-is |

## How the laptop avoids compiling

1. `-bin` ebuilds never compile anywhere.
2. `gui-apps/gearlever` is compiled on GitHub Actions (see
   `.github/workflows/build.yml`, scope = `packages.txt`) and published
   as a binpkg via GitHub Pages. The laptop lists that Pages URL first
   in `PORTAGE_BINHOST`, official Gentoo binhost second.
3. Hard guarantee per install: `emerge -G gui-apps/gearlever`
   (`--usepkgonly` fails instead of compiling if the binpkg is missing
   or drifted).

## Laptop setup

```sh
# 1. overlay (until it is registered upstream, add by URL)
sudo eselect repository add yaser git https://github.com/<you>/yaser-overlay.git
sudo emaint sync -r yaser

# 2. personal binhost first, official fallback second (in /etc/portage/make.conf)
PORTAGE_BINHOST="https://<you>.github.io/<repo>/ https://distfiles.gentoo.org/releases/amd64/binpackages/23.0/x86-64"
```

## Adding a package later

1. Drop the ebuild + `metadata.xml` under the right category, run
   `ebuild <file> manifest`.
2. If it needs compiling on the laptop: add its atom to `packages.txt`
   (keep the list tiny — each entry costs CI minutes), push, run the
   workflow.
3. Keep `portage/` in sync with the laptop after any make.conf /
   package.use / python-target change, or binpkgs silently stop
   matching and portage falls back to source builds.

## Notes

- `portage/make.conf` pins `-march=sandybridge` and
  `PYTHON_TARGETS=python3_14`: CI must match the laptop exactly.
- `gh-pages` is force-pushed orphan on each run (binpkgs are big,
  history would explode).
- Unsigned binhost over HTTPS is fine for personal use.
