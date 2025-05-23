package OpenSSL::safe::installdata;

use strict;
use warnings;
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw($PREFIX
                  $BINDIR $BINDIR_REL
                  $LIBDIR $LIBDIR_REL
                  $INCLUDEDIR $INCLUDEDIR_REL
                  $APPLINKDIR $APPLINKDIR_REL
                  $ENGINESDIR $ENGINESDIR_REL
                  $MODULESDIR $MODULESDIR_REL
                  $PKGCONFIGDIR $PKGCONFIGDIR_REL
                  $CMAKECONFIGDIR $CMAKECONFIGDIR_REL
                  $VERSION @LDLIBS);

our $PREFIX             = '/home/phaedrus/Forge/GH/openssl-3.3.1';
our $BINDIR             = '/home/phaedrus/Forge/GH/openssl-3.3.1/apps';
our $BINDIR_REL         = 'apps';
our $LIBDIR             = '/home/phaedrus/Forge/GH/openssl-3.3.1';
our $LIBDIR_REL         = '.';
our $INCLUDEDIR         = '/home/phaedrus/Forge/GH/openssl-3.3.1/include';
our $INCLUDEDIR_REL     = 'include';
our $APPLINKDIR         = '/home/phaedrus/Forge/GH/openssl-3.3.1/ms';
our $APPLINKDIR_REL     = 'ms';
our $ENGINESDIR         = '/home/phaedrus/Forge/GH/openssl-3.3.1/engines';
our $ENGINESDIR_REL     = 'engines';
our $MODULESDIR         = '/home/phaedrus/Forge/GH/openssl-3.3.1/providers';
our $MODULESDIR_REL     = 'providers';
our $PKGCONFIGDIR       = '';
our $PKGCONFIGDIR_REL   = '';
our $CMAKECONFIGDIR     = '';
our $CMAKECONFIGDIR_REL = '';
our $VERSION            = '3.3.1';
our @LDLIBS             =
    # Unix and Windows use space separation, VMS uses comma separation
    split(/ +| *, */, '-ldl -pthread -lm');

1;
