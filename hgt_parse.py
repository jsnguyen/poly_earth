import os
import math
import numpy as np

fn = 'n37w122.hgt'

siz = os.path.getsize(fn)
dim = int(math.sqrt(siz/2))

assert dim*dim*2 == siz, 'Invalid file size'

data = np.fromfile(fn, np.dtype('>i2'), dim*dim).reshape((dim, dim))
for row in data:
    for el in row:
        print(el)
