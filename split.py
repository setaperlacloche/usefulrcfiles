#!/usr/bin/env python3
# Split full UEFI Flash file into one file per region

import sys
import uefi_firmware

fn = sys.argv[1]

with open(fn, 'rb') as fh:
    file_content = fh.read()
parser = uefi_firmware.AutoParser(file_content)
del file_content
if parser.type() == 'unknown':
    print( "type unknown" )
    sys.exit( 1 )

fd = parser.parse()
print( f"Type : {fd.info()['type']}, Size : {fd.size}" )
for rgn in fd.regions:
    print( f"Label : {rgn.label}, Size : {len(rgn.data)}, #Sections : {len(rgn.objects)}" )
    with open( rgn.label + '/' + fn, "wb" ) as fw:
        fw.write( rgn.data )
