.DEFAULT_GOAL := all
.PHONY: all release clean
TODAY ?=$(shell date +%Y-%m-%d)
VERSION=v$(TODAY)
SOURCE_URL=https://icd11files.blob.core.windows.net/tmp/whofic-2023-04-08.owl.gz


# MAIN COMMANDS / GOALS ------------------------------------------------------------------------------------------------
all: tmp/output/release/icd11foundation.owl

clean:
	rm -rf tmp/

tmp/output/release/icd11foundation.owl: tmp/output/intermediate1-unicode-cleaned.owl
	robot remove --axioms equivalent -i $< -o $@

# Cleans all unicode characters
tmp/output/intermediate1-unicode-cleaned.owl: tmp/input/source.owl | tmp/output/release/
	tr -cd '\11\12\15\40-\176' < $< > $@

tmp/output/release/:
	mkdir -p $@

tmp/input/:
	mkdir -p $@

tmp/input/source.owl: tmp/input/source.gz
	gunzip -c $< > $@
	rm $<

tmp/input/source.gz: | tmp/input/
	wget ${SOURCE_URL} -O $@

# Requires GitHub CLI: https://cli.github.com/
release: | tmp/output/release/
	@test $(VERSION)
	gh release create $(VERSION) --notes "New release." --title "$(VERSION)" tmp/output/release/*

xxx: tmp/input/Orphanet_Nomenclature_Pack_EN/ORPHA_ICD11_mapping_en_newversion_2023.xml

# Mappings
# todo: Stable URI/filename issue: https://github.com/monarch-initiative/icd11/pull/12#discussion_r1542187711
tmp/input/Orphanet_Nomenclature_Pack_EN/ORPHA_ICD11_mapping_en_newversion_2023.xml: | tmp/input/
	wget https://www.orphadata.com/data/nomenclature/packs/Orphanet_Nomenclature_Pack_EN.zip -O tmp/input/Orphanet_Nomenclature_Pack_EN.zip
	unzip tmp/input/Orphanet_Nomenclature_Pack_EN.zip -d tmp/input/Orphanet_Nomenclature_Pack_EN

tmp/input/ordo.owl: | tmp/input/
	wget http://www.orphadata.org/data/ORDO/ordo_orphanet.owl -O $@

tmp/output/release/ordo-icd11.sssom.tsv: tmp/input/Orphanet_Nomenclature_Pack_EN/ORPHA_ICD11_mapping_en_newversion_2023.xml tmp/input/ordo.owl | tmp/output/release/
	python3 src/mappings.py $< > $@

# HELP -----------------------------------------------------------------------------------------------------------------
help:
	@echo "-----------------------------------"
	@echo "	Command reference: GARD OWL Ingest"
	@echo "-----------------------------------"
	@echo "all"
	@echo "Runs ingest and creates all release artefacts.\n"
	@echo "release"
	@echo "Uploads release to GitHub.\n"
