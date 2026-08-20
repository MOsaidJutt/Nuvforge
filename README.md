# Nuvforge

White-Label Software, Forged for Your Brand.

| Folder | Serves | Domain |
|---|---|---|
| `site/` | Nuvforge landing page | https://nuvforge.com |
| `tax/` | NuvTax landing page | https://tax.nuvforge.com |
| `deploy/` | nginx config + deploy script | (VPS) |
| `logos/` | Extracted brand logo assets | - |

Both pages are fully static (self-hosted fonts, inline CSS/JS, no build step).

## Go-live runbook

### 1. VPS (already deployed)

The VPS at `2.25.211.34` runs **Caddy in Docker** (compose at `/root/Eliseenterprise.com/`),
already serving `plainview.works`. Nuvforge is served by that same Caddy instance:

- Files live at `/var/www/nuvforge` (this repo, cloned)
- Caddy mounts it read-only at `/srv/nuvforge`
- Site blocks are in `/root/Eliseenterprise.com/Caddyfile` (see `deploy/Caddyfile.snippet`)

To publish updates after pushing to GitHub:

```bash
ssh root@2.25.211.34 'git -C /var/www/nuvforge pull'
```

No restart needed. Caddy serves the files straight from disk.

### 2. Cloudflare DNS (the remaining blocker)

Add these three records in Cloudflare for `nuvforge.com`:

| Type | Name | Content | Proxy |
|---|---|---|---|
| A | `@` | `2.25.211.34` | **DNS only (grey cloud)** |
| A | `tax` | `2.25.211.34` | **DNS only (grey cloud)** |
| CNAME | `www` | `nuvforge.com` | **DNS only (grey cloud)** |

Set them to **DNS only** first. Caddy then issues real Let's Encrypt certificates
automatically within about a minute of the records propagating, and both sites go live on HTTPS.

### 3. Optional: turn on the Cloudflare proxy

Once HTTPS works end to end, you can switch the records to **Proxied (orange cloud)** for
CDN and DDoS protection. If you do, set Cloudflare SSL/TLS mode to **Full (strict)**, never
Flexible. Leaving them on DNS only is perfectly fine too.

### 4. Google indexing (do this the day the site is live)

1. https://search.google.com/search-console -> Add property -> **Domain** `nuvforge.com`
   (verifies via a DNS TXT record in Cloudflare; covers the tax subdomain too).
2. Submit both sitemaps: `https://nuvforge.com/sitemap.xml` and `https://tax.nuvforge.com/sitemap.xml`.
3. URL Inspection -> paste each homepage -> **Request Indexing**.
4. Create a **Google Business Profile** for NuvTax (category: Tax Preparation Service) and
   link tax.nuvforge.com. This is the fastest way to appear for local "tax filer" searches.
5. Set up Google Analytics 4 and paste the tag into both pages (placeholder comments exist).

### Updating the sites

Edit files, commit, push, then on the VPS: `bash /var/www/nuvforge/deploy/deploy.sh`.

## Contact wiring

- WhatsApp: +92 312 3560670 (all CTAs use `wa.me/923123560670` with prefilled messages)
- Email: Nuvforge@gmail.com
