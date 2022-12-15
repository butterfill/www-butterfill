#! /bin/bash


node_modules/docpad/bin/docpad clean
node_modules/docpad/bin/docpad generate --env static
#nb do not --delete-removed because talks under subdirectories!
s3cmd sync  out/ s3://www.butterfill.com --add-header "Cache-Control: max-age=86400"

