# SSL Certificate Management for SigNoz

This guide covers SSL certificate setup, renewal, and management for SigNoz with Nginx reverse proxy.

## Current Setup

- **Nginx reverse proxy** with SSL termination
- **Port 443** for HTTPS access
- **Port 80** redirects to HTTPS

## Certificate Types

### 1. Self-Signed Certificate (Development/Internal)

**Location:** `nginx/certs/`
- `signoz.crt` - Certificate file
- `signoz.key` - Private key

**Expiration:** 365 days from creation

#### Check Expiration Date

```bash
docker run --rm -v "%cd%\nginx\certs:/certs" alpine/openssl x509 -in /certs/signoz.crt -noout -enddate
```

#### Renew Self-Signed Certificate

```bash
# Generate new certificate
docker run --rm -v "%cd%\nginx\certs:/certs" alpine/openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /certs/signoz.key -out /certs/signoz.crt -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"

# Restart Nginx
docker-compose restart nginx
```

#### Set Reminder

Add to calendar: Renew certificate **30 days before expiration**

---

### 2. Let's Encrypt Certificate (Production)

**Requirements:**
- Public domain name
- Domain pointing to your server IP
- Ports 80 and 443 accessible

#### Initial Setup

1. **Update configuration files:**

Edit `nginx/nginx-prod.conf`:
```nginx
server_name your-domain.com;  # Replace with your domain
```

Edit `setup-letsencrypt.bat`:
```bash
# Replace these values:
# - your-domain.com
# - your-email@example.com
```

2. **Obtain certificate:**

```bash
setup-letsencrypt.bat
```

3. **Start services:**

```bash
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

#### Auto-Renewal

The Certbot container automatically checks for renewal every 12 hours. Certificates renew when they have 30 days or less remaining.

**Verify auto-renewal is running:**

```bash
docker logs signoz-certbot
```

#### Manual Renewal

```bash
docker-compose -f docker-compose.yml -f docker-compose.prod.yml run --rm certbot renew
docker-compose -f docker-compose.yml -f docker-compose.prod.yml restart nginx
```

---

## Accessing SigNoz

**Development (Self-Signed):**
```
https://localhost
```
Note: Browser will show security warning - click "Advanced" → "Proceed"

**Production (Let's Encrypt):**
```
https://your-domain.com
```

---

## Troubleshooting

### Certificate Expired

**Symptoms:** Browser shows "Your connection is not private" or "Certificate expired"

**Solution:**
```bash
# Check expiration
docker run --rm -v "%cd%\nginx\certs:/certs" alpine/openssl x509 -in /certs/signoz.crt -noout -dates

# Renew certificate (see renewal section above)
```

### Nginx Won't Start

**Check logs:**
```bash
docker logs signoz-nginx
```

**Common issues:**
- Certificate files missing or incorrect permissions
- Port 443 already in use
- Invalid nginx.conf syntax

**Verify certificate files exist:**
```bash
dir nginx\certs
```

### Let's Encrypt Rate Limits

Let's Encrypt has rate limits:
- 50 certificates per domain per week
- 5 duplicate certificates per week

**Solution:** Use staging environment for testing:
```bash
docker-compose run --rm certbot certonly --webroot --webroot-path=/var/www/certbot --staging -d your-domain.com
```

---

## Monitoring Certificate Expiration

### Check Certificate Validity

```bash
# Self-signed certificate
docker run --rm -v "%cd%\nginx\certs:/certs" alpine/openssl x509 -in /certs/signoz.crt -noout -text | findstr "Not After"

# Let's Encrypt certificate
docker-compose -f docker-compose.yml -f docker-compose.prod.yml run --rm certbot certificates
```

### Set Up Monitoring

Add certificate expiration monitoring to your observability stack or set calendar reminders:

- **Self-signed:** Check 30 days before expiration
- **Let's Encrypt:** Auto-renews, but verify logs monthly

---

## Security Best Practices

1. **Never commit private keys** to version control
2. **Use strong SSL protocols** (TLSv1.2, TLSv1.3 only)
3. **Rotate certificates** before expiration
4. **Monitor certificate expiration** dates
5. **Use Let's Encrypt** for production environments
6. **Backup certificates** regularly

---

## File Structure

```
deploy/docker/
├── docker-compose.yml              # Main compose file
├── docker-compose.prod.yml         # Production override with Certbot
├── setup-letsencrypt.bat          # Script to obtain Let's Encrypt cert
├── generate-certs.bat             # Script to generate self-signed cert
└── nginx/
    ├── nginx.conf                 # Development config (self-signed)
    ├── nginx-prod.conf            # Production config (Let's Encrypt)
    └── certs/
        ├── signoz.crt            # SSL certificate
        └── signoz.key            # Private key
```

---

## Quick Reference

| Task | Command |
|------|---------|
| Check expiration | `docker run --rm -v "%cd%\nginx\certs:/certs" alpine/openssl x509 -in /certs/signoz.crt -noout -enddate` |
| Renew self-signed | `generate-certs.bat` then `docker-compose restart nginx` |
| Setup Let's Encrypt | `setup-letsencrypt.bat` |
| Manual renewal (LE) | `docker-compose -f docker-compose.yml -f docker-compose.prod.yml run --rm certbot renew` |
| View Certbot logs | `docker logs signoz-certbot` |
| Restart Nginx | `docker-compose restart nginx` |

---

## Support

For issues or questions:
- SigNoz Documentation: https://signoz.io/docs/
- Let's Encrypt Documentation: https://letsencrypt.org/docs/
