#!/bin/python3

import sys

def convert(hex_path, bin_path):
    memory = {}
    
    with open(hex_path, 'r') as f:
        for line in f:
            line = line.strip()
            if not line.startswith(':'): 
                continue
                
            length = int(line[1:3], 16)
            addr = int(line[3:7], 16)
            record_type = int(line[7:9], 16)
            
            if record_type == 0:
                for i in range(length):
                    byte_val = int(line[9 + i*2 : 11 + i*2], 16)
                    memory[addr + i] = byte_val

    if not memory:
        print(f"Error: No data found in {hex_path}")
        sys.exit(1)

    min_addr = min(memory.keys())
    max_addr = max(memory.keys())
    
    # print(f"Converting: {hex_path} -> {bin_path}")
    # print(f"Base Address: {hex(min_addr)} | Size: {max_addr - min_addr + 1} bytes")

    with open(bin_path, 'wb') as f:
        for addr in range(min_addr, max_addr + 1):
            f.write(bytes([memory.get(addr, 0xFF)]))

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("Usage: python hex2bin.py <input.hex> <output.bin>")
        sys.exit(1)
    convert(sys.argv[1], sys.argv[2])
