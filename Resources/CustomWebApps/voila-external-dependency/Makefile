# Variables
CURDIR := $(shell pwd)
CONSTRAINTS_FILE := $(CURDIR)/constraints.txt
REQUIREMENTS_FILE := $(CURDIR)/requirements.txt
INSTALLS_DIR := $(CURDIR)/installs

# Make targets
install:
	pip freeze > $(CONSTRAINTS_FILE)
	pip install -r $(REQUIREMENTS_FILE) -c $(CONSTRAINTS_FILE) --no-deps --target $(INSTALLS_DIR)
