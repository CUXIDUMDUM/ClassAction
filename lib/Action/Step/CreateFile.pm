package Action::Step::CreateFile;

use Moose;
use namespace::autoclean;
use Modern::Perl;
extends 'Action::Step::Base';
use MooseX::Types::Path::Class;

has 'file' => (
    is => 'ro',
    isa => 'Path::Class::File',
    required => 1,
    coerce => 1,
);

sub execute {
    my ($self) = @_;
    say 'Touching File';
    $self->file->touch;
    return -e $self->file->stringify;
}

sub undo {
    my ($self) = @_;
    say 'Removing File';
    $self->file->remove;
    $self->clean_failed_undo;
    return 1;
}

1;
