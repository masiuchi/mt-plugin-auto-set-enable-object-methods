package MT::Plugin::AutoSetEnableObjectMethods::Callback;
use strict;
use warnings;

use MT::AutoSetEnableObjectMethods;

sub init_app {
    MT::AutoSetEnableObjectMethods->set;
}

1;

