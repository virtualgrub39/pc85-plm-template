#!/usr/bin/env python3
import sys

def convert(hex_path, bin_path):
    memory = {}
    with open(hex_path, 'r') as f:
        for line in f:
            line = line.strip()
            if not line.startswith(':'): continue
            length = int(line[1:3], 16)
            addr = int(line[3:7], 16)
            record_type = int(line[7:9], 16)
            if record_type == 0:
                for i in range(length):
                    memory[addr + i] = int(line[9 + i*2 : 11 + i*2], 16)

    if not memory:
        print("Error: No data found")
        sys.exit(1)

    addresses = sorted(memory.keys())
    chunks = []
    current_chunk = [addresses[0]]
    for addr in addresses[1:]:
        if addr == current_chunk[-1] + 1:
            current_chunk.append(addr)
        else:
            chunks.append(current_chunk)
            current_chunk = [addr]
    chunks.append(current_chunk)

    with open(bin_path, 'wb') as f:
        for chunk in chunks:
            addr = chunk[0]
            length = len(chunk)
            
            # Address
            f.write(addr.to_bytes(2, byteorder='little'))
            # Length
            f.write(length.to_bytes(2, byteorder='little'))
            # Data
            for a in chunk:
                f.write(bytes([memory[a]]))
                
        # EOF Marker 
        f.write((0).to_bytes(2, byteorder='little'))
        f.write((0).to_bytes(2, byteorder='little'))

if __name__ == '__main__':
    if len(sys.argv) != 3: sys.exit(1)
    convert(sys.argv[1], sys.argv[2])
