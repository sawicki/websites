# Launchpad Sites

Static websites deployed to the Hostinger VPS.

## Live Sites

- `https://fjs.cx/` -> `www/landing/`
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

## Manual Deploy

Stage files on the server under `/home/felix/landing-deploy`, then run:

```bash
sudo deploy-launchpad
```

## One-Time Passwordless Deploy Setup

Install the root-owned deploy script and the narrow sudoers rule:

```bash
sudo install -m 0755 -o root -g root ~/landing-deploy/scripts/deploy-launchpad.sh /usr/local/sbin/deploy-launchpad
sudo install -m 0440 -o root -g root ~/landing-deploy/scripts/sudoers-deploy-launchpad /etc/sudoers.d/deploy-launchpad
sudo visudo -cf /etc/sudoers.d/deploy-launchpad
```
