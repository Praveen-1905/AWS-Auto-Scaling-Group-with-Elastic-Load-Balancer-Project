#!/bin/bash
# Simple load testing script
echo "Starting load test..."
ab -n 1000 -c 50 http://your-alb-dns-name/
