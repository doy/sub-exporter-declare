package Sub::Exporter::Declare;
use strict;
use warnings;

my %EXPORT_DATA;

use Sub::Exporter 'build_exporter', -setup => {
    exports => [qw(export export_default), import => \&import_generator],
    groups => {
        default => [qw(export export_default import)],
    },
};

sub export {
    my @exports = @_;
    my $caller = caller;
    $EXPORT_DATA{$caller} ||= {};
    push @{ $EXPORT_DATA{$caller}->{exports} ||= [] }, @exports;
}

sub export_default {
    my @exports = @_;
    my $caller = caller;
    $EXPORT_DATA{$caller} ||= {};
    push @{ $EXPORT_DATA{$caller}->{exports} ||= [] }, @exports;
    push @{ $EXPORT_DATA{$caller}->{groups}{default} ||= [] }, @exports;
}

sub import_generator {
    my ($class, $name, $arg, $col) = @_;
    return sub {
        my ($package) = @_;
        my $import = build_exporter($EXPORT_DATA{$package});
        goto $import;
    };
}

1;
