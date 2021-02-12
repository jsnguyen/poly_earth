#!/bin/bash

# Usage ./get_hgt.sh USERNAME INTEGER_LATLON

# For example, Mt. Fuji is at 35.362729, 138.730627 so to download the data file you need you woulde execute:
# ./get_hgt.sh username n35e138

# If you need an area that overlaps multiple tiles, download all the necessary tiles that your desired geography overlaps in

# !!! To access the data you need to create an account at this website:
# https://e4ftl01.cr.usgs.gov/ASTT/

# !!! See the following for more details on the files:
# https://lpdaac.usgs.gov/products/nasadem_hgtv001/


wget --user=${1} --ask-password https://e4ftl01.cr.usgs.gov/MEASURES/NASADEM_HGT.001/2000.02.11/NASADEM_HGT_${1}.zip
unzip NASADEM_HGT_${2}.zip
