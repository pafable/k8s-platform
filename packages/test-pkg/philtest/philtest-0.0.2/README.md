# Example Creation of RPM Package 

1. Install packages
```shell
dnf install -y \
  rpm-build \
  rpm-devel \
  rpmdevtools \
  rpmlint
```

2. Setup rpmbuild dir and create spec file
```shell
make specfile
```

4. Put your package files in SOURCES dir
It should follow this structure
```shell
├── BUILD
├── BUILDROOT
├── Makefile
├── RPMS
├── SOURCES
│   └── philtest-0.0.2
│       ├── etc
│       │   └── rsyslog.conf
│       └── hello.txt
├── SPECS
│   └── philtest.spec
└── SRPMS
```

5. Create a tar file
```shell
make tar
```

6. Create rpm package
```shell
make build
``` 