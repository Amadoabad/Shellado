#!/bin/bash

# Get CPU Usage (percentage of idle, so 100 - idle)
top -bn1 | grep 'Cpu(s)' | sed 's/.*, *\([0-9.]*\)%* id.*/\1/' | awk '{print 100 - $1}'

# Get Memory Usage (used in MB, total in MB)
free -m | awk 'NR==2{print $3, $2}'

# Get CPU Temperature (from sensors, removing + and °C)
sensors | grep 'Package id 0:' | awk '{print $4}' | sed 's/+\|°C//g'
