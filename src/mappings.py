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
INPUT_NOMENCLATURE_XML = str(INPUT_DIR / "Orphanet_Nomenclature_Pack_EN" / "ORPHA_ICD11_mapping_en_newversion_2023.xml")
INPUT_OWL = str(INPUT_DIR / "ordo.owl")
INPUT_CONFIG = str(CONFIG_DIR / "icd11.sssom-metadata.yml")
OUTPUT_FILE = str(PROJECT_DIR / "ordo-icd11.sssom.tsv")


def run(
    input_nomenclature_xml: str = INPUT_NOMENCLATURE_XML, input_owl: str = INPUT_OWL,
    input_sssom_config: str = INPUT_CONFIG, outpath: str = OUTPUT_FILE
):
    """Run"""
    # TODO: ordo.owl
    #  - Extract all of the mappings with -E. This probably involves running similar SPARQL to what's in mondo ingest
    #    - idk if there's a way to easily do this in OAK. --axioms or something
    #  - Filter ICD11 (MMS)

    # TODO: nomenclature XML
    #  - Lookup ICD11 foundation term from MMS term
    print()


def cli():
    """Command line interface."""
    parser = ArgumentParser(
        prog='Create SSSOM outputs',
        description='Create SSSOM outputs from Orphanet source')
    parser.add_argument(
        '-n', '--input-nomenclature-xml', default=INPUT_NOMENCLATURE_XML,
        help='Path to ICD11 mapping XML file from the Orphanet nomenclature pack.')
    parser.add_argument(
        '-w', '--input-owl', default=INPUT_OWL, help='Path to Orphanet release OWL.')
    parser.add_argument(
        '-c', '--input-sssom-config', default=INPUT_CONFIG, help='Path to SSSOM config yml.')
    parser.add_argument(
        '-o', '--outpath', default=OUTPUT_FILE, help='Path to save SSSOM TSV.')
    run(**vars(parser.parse_args()))


if __name__ == '__main__':
    cli()
