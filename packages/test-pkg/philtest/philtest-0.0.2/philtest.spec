Name:           philtest
Version:        0.0.2
Release:        1%{?dist}
Summary:        this is phil's test rpm

License:        MIT
URL:            https://pafable.com
Source0:        philtest-%{version}.tar.gz

BuildArch:      noarch
BuildRoot:      %{_tmppath}/%{name}-buildroot

%description
This is phil's test rpm and contains a file that says hello

%prep
%autosetup

%pre
mv /etc/rsyslog.conf /etc/rsyslog.conf.backup

%install
mkdir -p "$RPM_BUILD_ROOT"
cp -R * "$RPM_BUILD_ROOT"

%files
/etc/rsyslog.conf
/hello.txt

%changelog
* Sun Mar 02 2025 phil <pafable@pafable.com>
- Second!

* Sat Mar 01 2025 phil <pafable@pafable.com>
- First!