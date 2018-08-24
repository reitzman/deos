#!/usr/bin/env python3
# Distributed under the MIT software license
import binascii, struct, sys, io, argparse
from PIL import Image

def png_to_block(blockdata):
    '''
    Extract embedded data in PNG image.
    Pass in raw PNG image, return raw block data.
    '''
    inf = io.BytesIO(blockdata)
    img = Image.open(inf)
    if img.format != 'PNG' or img.mode != 'RGBA':
        raise ValueError('Image has invalid format-mode {}-{}'.format(img.format, img.mode))
    imgdata = img.tobytes()

    metaheader = imgdata[0:8]
    (blocksize,crc) = struct.unpack('>II', metaheader)
    print('size {:d}×{:d}'.format(img.width, img.height))
    print('metaheader:')
    print('  size  : {:d}'.format(blocksize))
    print('  CRC32 : {:x}'.format(crc))

    if 8+blocksize > len(imgdata):
        raise ValueError('Block size does not fit in image, image was cropped or header corrupted')
    blockdata = imgdata[8:8+blocksize]

    if binascii.crc32(blockdata) != crc:
        raise ValueError('Block CRC mismatch')

    return blockdata

def parse_arguments():
    parser = argparse.ArgumentParser(description='Convert PNG image back to bitcoin block data')
    parser.add_argument('infilename', metavar='INFILE.png', type=str, nargs='?',
            help='PNG image name. If not specified, read from standard input.')
    parser.add_argument('outfilename', metavar='OUTFILE.txt', type=str, nargs='?',
            help='Block data (hex output like RPC "getblock <hash> false"). If not specified, write to standard output.')
    return parser.parse_args()

def main():
    args = parse_arguments()

    if args.infilename is not None:
        with open(args.infilename, 'rb') as f:
            imgdata = f.read()
    else:
        imgdata = sys.stdin.buffer.read()

    blockdata = png_to_block(imgdata)

    if args.outfilename is not None:
        with open(args.outfilename, 'w') as f:
            f.write(binascii.b2a_hex(blockdata).decode() + '\n')
    else:
        sys.stdout.write(binascii.b2a_hex(blockdata).decode() + '\n')

if __name__ == '__main__':
    main()
