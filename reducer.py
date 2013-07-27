#!/usr/bin/env python

import sys

(last_key, last_count) = (None, 0) 
for line in sys.stdin:
	(key, count) = line.strip().split("\t")
	if last_key and last_key != key:
		print "%s\t%d" % (last_key, last_count)
		(last_key, last_count) = (key, int(count)) 
	else:
		last_key = key 
		last_count += int(count)

# for debugging
#	if last_key:
#		print "%s\t%d" % (last_key, last_count)