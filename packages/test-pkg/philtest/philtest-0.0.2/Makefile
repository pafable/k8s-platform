BUILD_HOME ?= ~/rpmbuild
NAME ?= philtest
SPEC_FILE ?= philtest.spec
VERSION ?= 0.0.1
PKG_NAME ?= $(NAME)-$(VERSION)
SPEC_PATH ?= $(BUILD_HOME)/SPECS/$(SPEC_FILE)

build:
	rpmbuild -v -bb $(SPEC_PATH)

ci:
	rpmlint -i $(SPEC_PATH)

clean:
	rm -rfv $(BUILD_HOME)/BUILD/$(PKG_NAME) $(BUILD_HOME)/RPMS/noarch $(BUILD_HOME)/SOURCES/*.tar.gz

install:
	rpm -ivh $(BUILD_HOME)/RPMS/noarch/$(PKG_NAME)-1.el9.noarch.rpm --replacefiles

setup:
	rpmdev-setuptree

specfile: setup ci
	rpmdev-newspec -o $(SPEC_PATH)

tar:
	tar -czvf $(BUILD_HOME)/SOURCES/$(PKG_NAME).tar.gz -C $(BUILD_HOME)/SOURCES $(PKG_NAME)