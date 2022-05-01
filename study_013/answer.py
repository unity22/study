#!/bin/python3

import math
import os
import random
import re
import sys

# Complete the solve function below.
def solve(s):
    first_name = s[0]
    first_name_upper = first_name.upper()
    space = s.find(" ")
    first_surname = s[space + 1]
    index_fs = s.index(first_surname)
    first_surname_upper = first_surname.upper()
    return first_name_upper + s[1:space] +" " + first_surname_upper + s[index_fs+1:]


if __name__ == '__main__':
    s = input()
    result = solve(s)
    print(result)
