#!/bin/bash

nmcli connection show | grep "VPN-" | awk '{print $1}'
