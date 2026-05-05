# Facsimile Images

This directory is reserved for the facsimile files of the Library of Congress
copy of the 1534 *Breviarium Romanum*:

https://www.loc.gov/item/79218337/

TIFF downloads go in `tiff/`.

The direct TIFF URLs are listed in `../metadata/tiff_urls.txt`, extracted from
the Library of Congress JSON endpoint:

```sh
curl -L 'https://www.loc.gov/item/79218337/?fo=json' -o metadata/loc_79218337.json
jq -r '.resources[0].files[] | map(select(.mimetype=="image/tiff"))[0].url' \
  metadata/loc_79218337.json > metadata/tiff_urls.txt
```

There are 983 TIFF files. Their published LoC sizes sum to about 36.5 GB.

Run this from the repository root to download or resume the full set:

```sh
scripts/download_loc_tiffs.sh
```

To pause the download after the current file finishes, create:

```sh
touch facsimiles/tiff/.pause
```

To continue, remove the pause file:

```sh
rm facsimiles/tiff/.pause
```

PNG derivatives go in `png/`. Convert all downloaded TIFF files with:

```sh
scripts/convert_tiffs_to_png.sh
```

The conversion script skips PNG files that are newer than their matching TIFF.
To pause conversion after the current file finishes, create:

```sh
touch facsimiles/png/.pause
```

To continue, remove the pause file:

```sh
rm facsimiles/png/.pause
```

JPG derivatives for upload workflows go in `jpg/`. Convert all downloaded
TIFF files with:

```sh
scripts/convert_tiffs_to_jpg.sh
```

The default JPEG quality is 88. Override it like this:

```sh
JPEG_QUALITY=92 scripts/convert_tiffs_to_jpg.sh
```

For a small test run, limit the number of converted files:

```sh
MAX_FILES=5 JPEG_QUALITY=88 scripts/convert_tiffs_to_jpg.sh
```

The script skips JPG files that are newer than their matching TIFF. To pause
conversion after the current file finishes, create:

```sh
touch facsimiles/jpg/.pause
```

To continue, remove the pause file:

```sh
rm facsimiles/jpg/.pause
```
