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

### 1. VPS (Hostinger KVM4)

SSH into the VPS and run:

```bash
curl -fsSL https://raw.githubusercontent.com/MOsaidJutt/Nuvforge/main/deploy/deploy.sh | bash
```

or clone the repo and run `bash deploy/deploy.sh`. It clones/pulls this repo to
`/var/www/nuvforge`, installs the nginx config and reloads nginx.

> If the existing site on this VPS runs on **Apache or a control panel**
> (CyberPanel, CloudPanel, hPanel VPS templates), do NOT install nginx alongside it.
> Tell Claude what is running and the config will be adapted.

### 2. Cloudflare DNS (nuvforge.com)

| Type | Name | Content | Proxy |
|---|---|---|---|
| A | `@` | VPS IP | Proxied |
| A | `tax` | VPS IP | Proxied |
| CNAME | `www` | `nuvforge.com` | Proxied |

### 3. SSL

Recommended (no renewals, works behind Cloudflare proxy):

1. Cloudflare dashboard -> SSL/TLS -> **Origin Server** -> Create Certificate
   (hosts: `nuvforge.com`, `*.nuvforge.com`, 15 years).
2. Save as `/etc/ssl/cloudflare/nuvforge.pem` and `/etc/ssl/cloudflare/nuvforge.key` on the VPS.
3. Uncomment the SSL lines in `deploy/nginx-nuvforge.conf`, reload nginx.
4. Cloudflare SSL/TLS mode -> **Full (strict)**.
5. SSL/TLS -> Edge Certificates -> enable **Always Use HTTPS**.

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
