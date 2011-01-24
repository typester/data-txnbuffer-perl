package Data::TxnBuffer;
use strict;
use warnings;
use XSLoader;

use Try::Tiny;

our $VERSION = '0.01';

XSLoader::load __PACKAGE__, $VERSION;

sub txn_read {
    my ($self, $code) = @_;

    my ($ret, $err);
    try {
        $code->($self);
        $ret = $self->spin;
    } catch {
        $err = $_;
        $self->reset;
    };

    if ($err) {
        # rethrow
        die $err;
    }

    $ret;
}

1;

__END__

=head1 NAME

Data::TxnBuffer - Module abstract (<= 44 characters) goes here

=head1 SYNOPSIS

use Data::TxnBuffer;

# create buffer
my $buf = Data::TxnBuffer->new;
# or create buffer from some data
my $buf = Data::TxnBuffer->new( data => $data );

# read some data
use Try::Tiny;
try {
    my $u32   = $buf->read_u32; # read unsigned int
    my $bytes = $buf->read(10); # read 10 bytes

    $buf->spin; # all data received. clear these data from buffer.
} catch {
    $buf->reset; # reset read cursor. try again later
};

# or more easy way. this way automatically call spin or reset method like above.
try {
    $buf->txn_read(sub {
        my $u32   = $buf->read_u32; # read unsigned int
        my $bytes = $buf->read(10); # read 10 bytes
    });
} catch {
    # try again later
};


# write some data to filehandle or buffer
$buf->write_u32(100);
$buf->write("Hello World");

# got written data and reset buffer
my $data = $buf->spin;

=head1 DESCRIPTION

Stub documentation for this module was created by ExtUtils::ModuleMaker.
It looks like the author of the extension was negligent enough
to leave the stub unedited.

Blah blah blah.

=head1 AUTHOR

Daisuke Murase <typester@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2011 by KAYAC Inc.

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut
