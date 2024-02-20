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

tmp/input/source.gz: | tmp/input/
	wget ${SOURCE_URL} -O $@

# Requires GitHub CLI: https://cli.github.com/
release: | tmp/output/release/
	@test $(VERSION)
	gh release create $(VERSION) --notes "New release." --title "$(VERSION)" tmp/output/release/*

# HELP -----------------------------------------------------------------------------------------------------------------
help:
	@echo "-----------------------------------"
	@echo "	Command reference: GARD OWL Ingest"
	@echo "-----------------------------------"
	@echo "all"
	@echo "Runs ingest and creates all release artefacts.\n"
	@echo "release"
	@echo "Uploads release to GitHub.\n"
