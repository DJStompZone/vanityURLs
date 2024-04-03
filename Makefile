CCRED=\033[0;31m
CCEND=\033[0m

localConfig       := ./vanityURLs.conf
include           $(localConfig)

.PHONY: help

help: ## Show this help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

debug:
	echo $(MY_DOMAIN)
	[ -f $(localConfig) ] && source $(localConfig)

config: ## Modify the .vanityURLS.conf before running setup
	@nano $(localConfig)

setup: ## Setup the environment
	cp $(REPO_DIR)/vanityURLS.conf ~/.vanityURLS.conf

	mkdir -p $(SCRIPT_DIR)
	cp scripts/* $(SCRIPT_DIR)
	chmod +x $(SCRIPT_DIR)/lnk
	chmod +x $(SCRIPT_DIR)/validateURL

	mkdir -p build
	rm build/_headers 2> /dev/null || true
	echo "https://"$(MY_PAGE)"/*" > build/_headers
	echo "  X-Robots-Tag: noindex" >> build/_headers
	echo "  X-Content-Type-Options: nosniff" >> build/_headers
	echo "  " >> build/_headers
	echo "https://"$(MY_DOMAIN)"/*" >> build/_headers
	echo "  X-Robots-Tag: noindex" >> build/_headers
	echo "  X-Content-Type-Options: nosniff" >> build/_headers

	rm dynamic.lnk 2> /dev/null
	echo "/github/* https://github.com/DJStompZone/:splat" > dynamic.lnk

	rm static.lnk 2> /dev/null
	
	echo "/github https://github.com/DJStompZone/" >> static.lnk
	echo "  " >> static.lnk
