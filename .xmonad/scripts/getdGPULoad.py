#!/usr/bin/python3

from pynvml import *

nvmlInit()
handle = nvmlDeviceGetHandleByIndex(0)
print(str(nvmlDeviceGetUtilizationRates(handle).gpu))
