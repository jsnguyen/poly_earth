# Poly Earth

This package is for creating 3d models of any geographical feature on the Earth, using global NASA elevation data. So you can get models of Mt. Everest, the Grand Canyon, etc. The models can be scaled down into 3d printable objects. Currently only supports rectangular areas. Uses Julia and saves models into a .stl binary format. Non-binary stl format is also supported!

Here's an example of Mt. Fuji (also included in the examples folder):
<img src=mt_fuji_model.png alt="mt. fuji model" width=400/>

Essentially, all this package does is take the mesh data of the elevation and draws triangles between adjacent points, creating a rough surface. Triangles are then added on the sides and the bottom to make a closed solid that can be 3d printed.

All of the Julia source code is in the `src` folder. Please peruse in there to understand the example Mt. Fuji script in the `examples` folder.

A simple download script is included at `get_hgt.sh`, please read the comments inside to see what it does.

To access the data you need to create an account at this website: https://e4ftl01.cr.usgs.gov/ASTT/

The elevation files are in a raw `.hgt` format of 3601*3601 16 bit signed integers. See this discussion for reference:
https://stackoverflow.com/questions/357415/how-to-read-nasa-hgt-binary-files

# Notes

The notebooks have some experiments on drawing 2d topographical lines for making maps in both Julia and Python, but I didn't get very far with this.
