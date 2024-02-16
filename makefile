.DEFAULT_GOAL := all
.PHONY: all download-inputs update-inputs deploy-release
TODAY ?=$(shell date +%Y-%m-%d)
VERSION=v$(TODAY)
SOURCE_URL=https://icd11files.blob.core.windows.net/tmp/whofic-2023-04-08.owl.gz


# MAIN COMMANDS / GOALS ------------------------------------------------------------------------------------------------
all: tmp/output/release/icd11foundation.owl

tmp/output/release/icd11foundation.owl: tmp/input/source.owl | tmp/output/release/
	 python3 icd11_foundation_ingest/clean_illegal_chars.py -i $< -o $@

tmp/output/release/:
	mkdir -p $@

tmp/input/:
	mkdir -p $@

tmp/input/source.owl: | tmp/input/
	wget ${SOURCE_URL} -O $@

# Requires GitHub CLI: https://cli.github.com/
deploy-release: | tmp/output/release/
	@test $(VERSION)
	gh release create $(VERSION) --notes "New release." --title "$(VERSION)" tmp/output/release/*

# HELP -----------------------------------------------------------------------------------------------------------------
help:
	@echo "-----------------------------------"
	@echo "	Command reference: GARD OWL Ingest"
	@echo "-----------------------------------"
	@echo "all"
	@echo "Runs ingest and creates all release artefacts.\n"
	@echo "deploy-release"
	@echo "Uploads release to GitHub.\n"
