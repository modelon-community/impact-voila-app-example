# Variables
CURDIR := $(shell pwd)
CONSTRAINTS_FILE := $(CURDIR)/constraints.txt
DOWNLOADS_DIR := $(CURDIR)/downloads
REQUIREMENTS_FILE := $(CURDIR)/requirements.txt
INSTALLS_DIR := $(CURDIR)/installs

# Make targets
install:
	pip freeze > $(CONSTRAINTS_FILE)
	pip download -d $(DOWNLOADS_DIR) -r $(REQUIREMENTS_FILE) -c $(CONSTRAINTS_FILE) --no-deps
	pip install -r $(REQUIREMENTS_FILE) -c $(CONSTRAINTS_FILE) --no-deps --no-index --find-links $(DOWNLOADS_DIR) --target $(INSTALLS_DIR)
