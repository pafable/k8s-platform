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

5. Create a tar file
```shell
make tar
```

6. Create rpm package
```shell
make build
``` 