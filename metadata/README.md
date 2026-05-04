# Library of Congress Metadata

`loc_79218337.json` is the JSON representation of:

https://www.loc.gov/item/79218337/

It was downloaded with:

```sh
curl -L 'https://www.loc.gov/item/79218337/?fo=json' -o metadata/loc_79218337.json
```

`tiff_urls.txt` contains the direct master TIFF URLs for the full facsimile.
They come from `resources[0].files`, where each page/scan has an
`image/tiff` entry such as:

```text
https://tile.loc.gov/storage-services/master/rbc/rbc0001/2019/2019rosen0827/0001.tif
```

The file list contains 983 TIFF URLs, ending with `0983.tif`.
