package Action::Step::UpdateFile;

use Moose;
use namespace::autoclean;
use File::Copy;
use Modern::Perl;
use Data::Dump qw(dump);
extends 'Action::Step::Base';
use MooseX::Types::Path::Class;

has 'file' => (
    is => 'ro',
    isa => 'Path::Class::File',
    required => 1,
    coerce => 1,
);

has 'backup_file' => (
    is => 'ro',
    isa => 'Path::Class::File',
    coerce => 1,
    lazy_build => 1,
);

sub _build_backup_file {
    my ($self) = @_;
    my $backup_file = $self->file->stringify . '_backup';
    unlink $backup_file if -e $backup_file;
    return $backup_file;
}

sub init {
    my ($self) = @_;
    return unless -e $self->file->stringify;
    File::Copy::copy( $self->file->stringify, $self->backup_file->stringify );
    return 1;
}

sub execute {
    my ($self) = @_;
    say 'Updating File';
    return unless $self->init;
    my $fh = $self->file->opena;
    print {$fh} "test\n";
    $fh->close;
    say $self->file->slurp;
    return 1;
}

sub retry_execute {
    my ($self) = @_;
    say 'Creating File';
    $self->file->touch;
    return 1;
}

sub restore {
    my ($self) = @_;
    File::Copy::copy( $self->backup_file->stringify, $self->file->stringify );
    return 1;
}

sub undo {
    my ($self) = @_;
    say 'Restoring File';
    $self->restore;
    say $self->file->slurp;
    $self->backup_file->remove;
    $self->clean_failed_undo;
    return 1;
}

1;
