"""Clean illegal chars"""
from argparse import ArgumentParser


def clean(inpath: str, outpath: str):
    """Clean"""
    with open(inpath, 'rb') as file:
        content = file.read()
    cleaned_content = content.replace(b'\x03', b'')
    with open(outpath, 'wb') as file:
        file.write(cleaned_content)


def cli():
    """Command line interface."""
    parser = ArgumentParser('Cleans illegal characters in file.')
    parser.add_argument('-i', '--inpath', required=True, help='Input path')
    parser.add_argument( '-o', '--outpath', required=True, help='Output path')
    clean(**vars(parser.parse_args()))


if __name__ == '__main__':
    cli()
