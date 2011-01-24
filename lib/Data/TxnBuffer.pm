package Data::TxnBuffer;
use strict;
use warnings;

use Try::Tiny;

our $VERSION = '0.01';

our $BACKEND;
unless ($ENV{PERL_ONLY}) {
    eval {
        require XSLoader;
        XSLoader::load(__PACKAGE__, $VERSION);
        $BACKEND = 'XS';
    };
    if ($@) {
        die $@;
    }
}

unless (__PACKAGE__->can('new')) {
    eval q{
        use parent 'Data::TxnBuffer::PP';
        $BACKEND = 'PP';
    };
}

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
    
    # got written data
    my $data = $buf->data;
    
    # clear all data from buffer
    $buf->clear;

=head1 DESCRIPTION

Stub documentation for this module was created by ExtUtils::ModuleMaker.
It looks like the author of the extension was negligent enough
to leave the stub unedited.

Blah blah blah.

=head1 CLASS METHOD

=head2 my $buf = Data::TxnBuffer->new($data);

Create a Data::TxnBuffer object.
If you passed some C<$data>, create buffer from the data.

=head1 ACCESSORS

=head2 $buf->cursor

=head2 $buf->data

=head1 BASIC METHODS

=head2 $buf->read($bytes)

=head2 $buf->write($data)

=head2 $buf->spin

=head2 $buf->reset

=head2 $buf->clear

=head1 TRANSACTION READ

=head2 $buf->txn_read($code)


=head1 READ/WRITE HELPER METHODS

=head2 $buf->read_u32

=head2 $buf->read_u24

=head2 $buf->read_u16

=head2 $buf->read_u8


=head2 $buf->read_i32

=head2 $buf->read_i24

=head2 $buf->read_i16

=head2 $buf->read_i8


=head2 $buf->write_u32

=head2 $buf->write_u24

=head2 $buf->write_u16

=head2 $buf->write_u8


=head2 $buf->write_i32

=head2 $buf->write_i24

=head2 $buf->write_i16

=head2 $buf->write_i8


=head2 $buf->read_n32

=head2 $buf->read_n24

=head2 $buf->read_n16

=head2 $buf->write_n32

=head2 $buf->write_n24

=head2 $buf->write_n16

=head1 AUTHOR

Daisuke Murase <typester@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2011 by KAYAC Inc.

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut
