# Niimbot Print

A label designer that runs in your browser and prints over Bluetooth to a **NIIMBOT D110_M**. There is nothing to install and no account to make. It is one HTML file.

Source: https://github.com/gabrielkirsten/niimbot-d100-print

## Features

- **Canvas editor.** Add text, lines, boxes and symbols, then drag them around the label. Handles resize, guides snap to the center and edges, and arrow keys nudge.
- **Fonts and styling.** 10 fonts, bold, italic, alignment, 90° rotation steps, dashed or dotted lines, rounded boxes and a white-on-black mode.
- **Templates and saved designs.** Start from a template, save your own, and reprint recent labels in one click.
- **Exact preview.** The preview is already reduced to the printer's black and white dots, so it matches the print.
- **Printer status.** Battery, paper, and how many labels are left on the roll, when the printer reports them.
- **Undo and redo**, layers, and keyboard shortcuts (click the `?` in the app for the list).

## Use it

You need **Chrome or Edge** (Safari and Firefox don't support Web Bluetooth) on a computer with Bluetooth.

1. Turn on the D110_M and close the NIIMBOT phone app so it isn't holding the connection.
2. Open the app (see below) and click **Connect**. Pick the printer in the browser's Bluetooth window.
3. Design a label. Print one copy first and check it. If it comes out upside down, set **Print direction** to *Flipped 180°*.

You can design and save labels without a printer connected.

## Run it

Web Bluetooth only works on a secure page, and `http://localhost` counts as one.

```sh
./start.command          # serves the folder on http://localhost:8765 and opens a browser
# or, by hand:
python3 -m http.server 8765
```

On macOS you can also double-click `start.command`.

### With Docker

```sh
docker compose up -d --build        # serves the app on http://localhost:8765
```

The container is a small non-root nginx with a strict security policy, and it restarts by itself. Stop it with `docker compose down`.

### Publish it with a Cloudflare Tunnel

To use the app from any device at a public `https://` address, point a [Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/) at it. The tunnel supplies the HTTPS that Bluetooth requires, so you don't need to open any ports. The printer still pairs with whichever computer the *browser* is on. Setup and the Docker route are in [deploy/README.md](deploy/README.md).

Because the app is a single static page, you can also host it on any static host (GitHub Pages, Cloudflare Pages, Netlify) with no tunnel.

## Make it yours

Everything configurable sits in the `CONFIG` object at the top of the script in `index.html`: the GitHub link, the printer profile, and the label roll sizes. To add a roll, add an entry under `sizes` (`len` is the label length in dots at 203 dpi, `paper` the roll width in dots) and a matching option in the *Roll size* control.

## How it works and what to expect

- The page loads the open-source [niimbot-web-bluetooth](https://github.com/iscarelli/niimbot-web-bluetooth) driver (MIT) from unpkg and fonts from Google Fonts, so it needs an internet connection. Designs are saved only in your browser's local storage.
- **Early support.** The driver identifies the D110_M (model 2320), but its maintainers flag printing on this exact model as unverified. The app checks the model ID before enabling print and defaults to one copy. Common label geometry (96 dots printable width at 203 dpi) comes from the driver's registry; paper registration is not verified on every roll.
- **Roll sizes.** When you connect, the app reads the roll's RFID tag and sets the label size automatically if it has seen that roll before. The tag identifies the roll but doesn't report its dimensions, so for a new roll you choose the size once and it is remembered in this browser from then on.
- **If the end of your text is cut off,** the label you loaded is probably shorter than the size you chose. Pick **Custom** and set the real length, or apply the **Ruler** template, print it, and read the last number that appears. The editor also warns when content is within 1 mm of the label's ends, where printers tend to clip.
- Some rolls have no readable tag. Choose the size manually.

## License

The driver is MIT licensed. Add a `LICENSE` file for this project before publishing.
