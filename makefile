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

# Mappings
tmp/input/mappings.json: | tmp/input/
	wget -qO tmp/input/en_product1.json.tar.gz https://www.orphadata.com/data/json/en_product1.json.tar.gz
	tar -xvf tmp/input/en_product1.json.tar.gz -C tmp/input/
	mv tmp/input/en_product1.json $@
	rm tmp/input/en_product1.json.tar.gz

tmp/output/release/ordo-icd11.sssom.tsv: tmp/input/mappings.json | tmp/output/release/
	python3 src/make_sssom.py $< > $@

# HELP -----------------------------------------------------------------------------------------------------------------
help:
	@echo "-----------------------------------"
	@echo "	Command reference: GARD OWL Ingest"
	@echo "-----------------------------------"
	@echo "all"
	@echo "Runs ingest and creates all release artefacts.\n"
	@echo "release"
	@echo "Uploads release to GitHub.\n"
