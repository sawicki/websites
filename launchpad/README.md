# Launchpad Sites

Static websites deployed to the Hostinger VPS.

## Live Sites

- `https://fjs.cx/` -> `www/landing/`
- `https://fjs.cx/elemental-text/` -> `www/landing/elemental-text/`
- `https://fjs.cx/mhpcc/` -> `www/landing/mhpcc/`
- `https://fjs.cx/mhpcc/networking.html` -> `www/landing/mhpcc/networking.html`
- `https://eberly.xyz/` -> `www/eberly.xyz/`
- `https://ty.fjs.cx/` -> `www/ty.fjs.cx/`
- `https://maggie.eberly.xyz/` -> `/var/www/maggie.fjs.cx`
- `https://ty.eberly.xyz/` -> `www/ty.fjs.cx/`

## Server Paths

- Caddy config: `/etc/caddy/Caddyfile`
- Launch pad root: `/var/www/landing`
- Eberly root: `/var/www/eberly.xyz`
- Ty root: `/var/www/ty.fjs.cx`

## Page Notes

- `elemental-text` was created in Claude Design with the prompt: "Create a very large editable text box, pre-filled with sample text. For certain words like \"Fire\", \"Smoke\", \"metal\", \"wind\", render visual + particle effects that match the word."

## Manual Deploy

Stage files on the server under `/home/felix/landing-deploy`, then run:

```bash
sudo deploy-launchpad
```

From this workstation, the usual update path is:

```powershell
scp .\launchpad\Caddyfile felix@148.230.88.124:/home/felix/landing-deploy/Caddyfile.hostinger
scp -r .\launchpad\www felix@148.230.88.124:/home/felix/landing-deploy/
ssh felix@148.230.88.124 'sudo -n deploy-launchpad'
```

`deploy-launchpad` runs as root because it writes to `/etc/caddy/Caddyfile`, writes selected files under `/var/www`, sets ownership to `www-data`, validates the Caddyfile, and reloads Caddy. The sudoers rule should stay narrow: `felix` may run only `/usr/local/sbin/deploy-launchpad` without a password, not arbitrary sudo commands.

## One-Time Passwordless Deploy Setup

Install the root-owned deploy script and the narrow sudoers rule:

```bash
sudo install -m 0755 -o root -g root ~/landing-deploy/scripts/deploy-launchpad.sh /usr/local/sbin/deploy-launchpad
sudo install -m 0440 -o root -g root ~/landing-deploy/scripts/sudoers-deploy-launchpad /etc/sudoers.d/deploy-launchpad
sudo visudo -cf /etc/sudoers.d/deploy-launchpad
```
