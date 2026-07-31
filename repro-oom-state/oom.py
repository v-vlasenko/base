#!/usr/bin/env python3
import json, sys

# Allocate ~600 MB of memory to trigger OOM on constrained workspace
data = []
chunk = "x" * (1024 * 1024)  # 1 MB string
for i in range(600):
    data.append(chunk)

# Output required JSON for external data source
print(json.dumps({"result": "allocated"}))
