#!/bin/bash
amixer get Master |grep % |awk '{print $5, $6}' | head -1

