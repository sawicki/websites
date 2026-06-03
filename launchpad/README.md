# Launchpad Sites

Static websites deployed to the Hostinger VPS.

## Live Sites

- `https://fjs.cx/` -> `www/landing/`
- `https://fjs.cx/mhpcc/` -> `www/landing/mhpcc/`
- `https://eberly.xyz/` -> `www/eberly.xyz/`

## Server Paths

- Caddy config: `/etc/caddy/Caddyfile`
- Launch pad root: `/var/www/landing`
- Eberly root: `/var/www/eberly.xyz`

## Manual Deploy

Stage files on the server, then install them with `sudo`:

```bash
sudo install -m 0644 Caddyfile /etc/caddy/Caddyfile
sudo install -d -m 0755 -o www-data -g www-data /var/www/landing /var/www/eberly.xyz
sudo cp -a www/landing/. /var/www/landing/
sudo cp -a www/eberly.xyz/. /var/www/eberly.xyz/
sudo chown -R www-data:www-data /var/www/landing /var/www/eberly.xyz
sudo systemctl reload caddy
```
