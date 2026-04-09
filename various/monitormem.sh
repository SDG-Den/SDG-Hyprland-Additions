#!/bin/bash

free | grep Mem | awk "{print 100 / \$2 * \$3}" | sed 's/\./ /' | awk "{print \$1}"