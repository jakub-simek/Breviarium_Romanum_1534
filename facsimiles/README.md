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
