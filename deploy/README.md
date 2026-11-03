# Publishing with a Cloudflare Tunnel

Web Bluetooth needs a secure page. A [Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/) gives the app a public `https://` address without opening any ports.

## 1. Create the tunnel (once)

```sh
brew install cloudflared
cloudflared tunnel login                                       # pick your domain
cloudflared tunnel create niimbot-print                        # prints the tunnel ID
cloudflared tunnel route dns niimbot-print print.example.com   # your hostname
```

## 2. Run it with Docker

Copy the tunnel's credentials file and a config into the git-ignored `.secrets/cloudflared/` folder:

```sh
mkdir -p .secrets/cloudflared
cp ~/.cloudflared/<TUNNEL_ID>.json .secrets/cloudflared/
cp deploy/cloudflared.example.yml .secrets/cloudflared/niimbot-print.yml   # then fill in the ID and hostname
```

Start the app and the tunnel together:

```sh
docker compose --profile tunnel up -d --build
```

The tunnel is a separate profile, so a plain `docker compose up -d` serves the app on `localhost` only. Both containers restart automatically (`restart: unless-stopped`) as long as Docker is running.

## Without Docker

```sh
./start.command &                                                       # serves http://localhost:8765
cloudflared tunnel run --url http://localhost:8765 niimbot-print
```

## Updating

After you change `index.html`, rebuild: `docker compose up -d --build web`.

## Keep out of git

`.secrets/` holds the tunnel credentials. It is already in `.gitignore`. Anyone with that file can run your tunnel, so never commit it.
