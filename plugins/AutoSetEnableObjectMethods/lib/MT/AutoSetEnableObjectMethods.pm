package MT::AutoSetEnableObjectMethods;
use strict;
use warnings;

use MT;

sub set {
    my $class = shift;
    for my $type ( $class->_plugin_object_types ) {
        $class->_set_enable_object_methods($type);
    }
}

sub _set_enable_object_methods {
    my $class = shift;
    my ($type) = @_;
    return if $class->_enable_object_methods($type);
    my $disable_object_methods
        = $class->_disable_object_methods($type) || +{};
    $class->_enable_object_methods(
        $type,
        +{  delete => !$disable_object_methods->{delete},
            edit   => !$disable_object_methods->{edit},
            save   => !$disable_object_methods->{save},
        }
    );
}

sub _disable_object_methods {
    my $class = shift;
    my $type  = shift;
    MT->registry( 'applications', 'cms', 'disable_object_methods', $type );
}

sub _enable_object_methods {
    my $class = shift;
    my $type  = shift;
    my @keys  = ( 'applications', 'cms', 'enable_object_methods', $type );
    if (@_) {
        MT->registry( @keys, @_ );
    }
    else {
        MT->registry(@keys);
    }
}

sub _plugin_object_types {
    my $class = shift;
    my %types;
    for my $key ( keys %MT::Plugins ) {
        my $plugin = $MT::Plugins{$key}{object};
        for my $type ( keys %{ $plugin->registry('object_types') || +{} } ) {
            my $object = $plugin->registry( 'object_types', $type );
            next if $type =~ /\./ || ref $object eq 'HASH';
            $types{$type} = 1;
        }
    }
    keys %types;
}

1;

