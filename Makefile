TF ?= terraform
PKR ?= packer

.PHONY: tf-check
tf-check:
	$(TF) --version

.PHONY: pkr-check
pkr-check:
	$(PKR) --version