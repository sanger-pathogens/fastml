.PHONY: all

# Copying autoconf style
PACKAGE_NAME=fastml2
PACKAGE_VERSION=2.2

all: libs programs

debug: libs.debug

%: libs.% programs.%
	echo $@

libs: libs.all

programs: programs.all

programs.all: libs
programs.debug: libs.debug

semphy: programs.semphy

install: programs.install

programs.install programs.all semphy: libs

clean: libs.clean programs.clean

libs.%:
	+cd libs/phylogeny;make

programs.%:
	+cd programs/fastml;make

tags: libs/*/*.cpp libs/*/*.h programs/*/*.h programs/*/*.cpp
	etags --members --language=c++ $^ 

dist:
	rm -rf ${PACKAGE_NAME}-${PACKAGE_VERSION}
	mkdir ${PACKAGE_NAME}-${PACKAGE_VERSION}
	rm -rf libs/phylogeny/*.o libs/phylogeny/*.a programs/fastml/*.o programs/fastml/*.a
	cp -R debian libs programs Makefile Readme.md ${PACKAGE_NAME}-${PACKAGE_VERSION}
	tar czvf ${PACKAGE_NAME}-${PACKAGE_VERSION}.tar.gz ${PACKAGE_NAME}-${PACKAGE_VERSION}
	rm -rf ${PACKAGE_NAME}-${PACKAGE_VERSION}

release: dist
	vagrant up
	vagrant ssh -c "sudo apt-get update"
	vagrant provision
	vagrant ssh -c "tar xzvf /vagrant/${PACKAGE_NAME}-${PACKAGE_VERSION}.tar.gz"
	vagrant ssh -c "cd ${PACKAGE_NAME}-${PACKAGE_VERSION} && dpkg-buildpackage -uc -us -rfakeroot"
	vagrant ssh -c "cp ${PACKAGE_NAME}_${PACKAGE_VERSION}_amd64.deb /vagrant"
	vagrant ssh -c "cp ${PACKAGE_NAME}_${PACKAGE_VERSION}_amd64.changes /vagrant"
	vagrant ssh -c "cp ${PACKAGE_NAME}_${PACKAGE_VERSION}.tar.gz /vagrant"
	vagrant halt
