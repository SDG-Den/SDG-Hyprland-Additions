#!/bin/bash

vmstat 1 2 | tail -1 | awk "{print 100 - \$15 \"%\"}"