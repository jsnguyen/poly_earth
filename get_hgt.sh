#!/bin/bash

wget --user=jsnguyen --ask-password https://e4ftl01.cr.usgs.gov/MEASURES/NASADEM_HGT.001/2000.02.11/NASADEM_HGT_${1}.zip
unzip NASADEM_HGT_${1}.zip
