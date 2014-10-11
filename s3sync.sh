#! /bin/bash

s3cmd sync --delete-removed ~out/ s3://www.butterfill.com --add-header "Cache-Control: max-age=86400"

