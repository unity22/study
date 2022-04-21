#!/bin/python3

import math
import os
import random
import re
import sys

def oddNumbers(l, r):
    array = []
    for i in range(l, r+1):
        if i % 2 != 0:
            array.append(i)
    return array

if __name__ == '__main__':
    fptr = sys.stdout # open(os.environ['OUTPUT_PATH'], 'w')
    l = int(input().strip())
    r = int(input().strip())
    result = oddNumbers(l, r)
    fptr.write('\n'.join(map(str, result)))
    fptr.write('\n')
    fptr.close()
