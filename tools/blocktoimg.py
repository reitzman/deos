#!/usr/bin/env python3
# Distributed under the MIT software license
import binascii, struct, sys, io, argparse
from PIL import Image

IMG_WIDTH = 512 # could be made adaptive...
MIN_HEIGHT = 4 # minimum height of image; twitter won't let us upload anything smaller
BYTES_PER_PIXEL = 4 # RGBA, 8 bit

def div_roundup(x,y):
    return (x+y-1)//y

def block_to_png(blockdata):
    '''
    Embed data in PNG image.
    Pass in raw block data, returns raw PNG image.
    '''
    metaheader = struct.pack('>II', len(blockdata), binascii.crc32(blockdata))

    data = metaheader + blockdata

    # determine size;
    # add an extra pixel to make sure that there's always padding, twitter will
    # convert to JPG in the unlikely case that the entire alpha channel is 255
    pixels = div_roundup(len(data), BYTES_PER_PIXEL) + 1
    width = IMG_WIDTH
    height = max(div_roundup(pixels, width), MIN_HEIGHT)

    # add zero-padding
    padding_len = width*height*BYTES_PER_PIXEL - len(data)
    data += b'\x00' * padding_len

    # compress as PNG
    img = Image.frombytes("RGBA", (width, height), data)
    outf = io.BytesIO()
    img.save(outf, "PNG", optimize=True) # optimize sets compress_level to 9(max) as well
    return outf.getvalue()

def parse_arguments():
    parser = argparse.ArgumentParser(description='Convert bitcoin block data to PNG image')
    parser.add_argument('infilename', metavar='INFILE.hex', type=str, nargs='?',
            help='Block data (hex output from RPC "getblock <hash> false"). If not specified, read from standard input.')
    parser.add_argument('outfilename', metavar='OUTFILE.png', type=str, nargs='?',
            help='PNG image name. If not specified, write to standard output.')
    return parser.parse_args()

def main():
    args = parse_arguments()

    if args.infilename is not None:
        with open(args.infilename, 'r') as f:
            blockdata = binascii.a2b_hex(f.read().strip())
    else:
        blockdata = binascii.a2b_hex(sys.stdin.read().strip())

    imgdata = block_to_png(blockdata)

    if args.outfilename is not None:
        with open(args.outfilename, 'wb') as f:
            f.write(imgdata)
    else:
        sys.stdout.buffer.write(imgdata)

if __name__ == '__main__':
    main()
