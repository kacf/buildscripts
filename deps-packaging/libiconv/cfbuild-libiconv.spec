Summary: CFEngine Build Automation -- libiconv
Name: cfbuild-libiconv
Version: %{version}
Release: 1
Source0: libiconv-1.14.tar.gz
License: MIT
Group: Other
Url: http://www.gnu.org/software/libiconv/
BuildRoot: %{_topdir}/BUILD/%{name}-%{version}-%{release}-buildroot

Patch0: remove-misguided-aix-fixing-attempt.patch

AutoReqProv: no

%define prefix %{buildprefix}

%prep
mkdir -p %{_builddir}
%setup -q -n libiconv-1.14
%patch0 -p1

./configure --prefix=%{prefix} --enable-shared --disable-static


%build

make   
 
%install

rm -rf ${RPM_BUILD_ROOT}

make install DESTDIR=${RPM_BUILD_ROOT}

rm -f ${RPM_BUILD_ROOT}%{prefix}/lib/libcharset.la
rm -f ${RPM_BUILD_ROOT}%{prefix}/lib/libiconv.la


%clean
rm -rf $RPM_BUILD_ROOT

%package devel
Summary: CFEngine Build Automation -- libiconv -- development files
Group: Other
AutoReqProv: no

%description
CFEngine Build Automation -- libiconv

%description devel
CFEngine Build Automation -- libiconv -- development files

%files
%defattr(-,root,root)

%dir %prefix/lib
%prefix/lib/*.so*
%prefix/lib/charset.alias

%files devel
%defattr(-,root,root)

%prefix/include

%changelog
