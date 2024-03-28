"""Extract mappings"""
import json
from argparse import ArgumentParser
from pathlib import Path
from typing import Dict, List

SRC_DIR = Path(__file__).parent
PROJECT_DIR = SRC_DIR.parent
CONFIG_DIR = PROJECT_DIR / "config"
INPUT_DIR = PROJECT_DIR / "tmp" / "input"
OUTPUT_DIR = PROJECT_DIR / "output" / "release"
INPUT_MAPPINGS = str(INPUT_DIR / "mappings.json")
INPUT_CONFIG = str(CONFIG_DIR / "icd11.sssom-metadata.yml")
OUTPUT_FILE = str(PROJECT_DIR / "ordo-icd11.sssom.tsv")


def run(input_mappings: str = INPUT_MAPPINGS, input_sssom_config: str = INPUT_CONFIG, outpath: str = OUTPUT_FILE):
    """Run"""
    with open(input_mappings, 'r') as f:
        d = json.load(f)
    source_mappings: List[Dict] = d['JDBOR'][0]['DisorderList'][0]['Disorder']
    with open(input_mappings.replace('.json', '-indent.json'), 'w') as f:
        json.dump(source_mappings, f, indent=2)
    print()


def cli():
    """Command line interface."""
    parser = ArgumentParser(
        prog='Create SSSOM outputs',
        description='Create SSSOM outputs from MedGen source')
    parser.add_argument(
        '-m', '--input-mappings', default=INPUT_MAPPINGS, help='Path to mapping file sourced from Orphanet.')
    parser.add_argument(
        '-c', '--input-sssom-config', default=INPUT_CONFIG, help='Path to SSSOM config yml.')
    parser.add_argument(
        '-o', '--outpath', default=OUTPUT_FILE, help='Path to save SSSOM TSV.')
    run(**vars(parser.parse_args()))


if __name__ == '__main__':
    cli()
