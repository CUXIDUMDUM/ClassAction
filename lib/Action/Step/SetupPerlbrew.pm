package Action::Step::SetupPerlbrew;

use Moose;
use namespace::autoclean;
use File::Copy;
use Modern::Perl;
use Data::Dump qw(dump);
use IPC::Cmd qw(can_run run);
use File::Temp qw/ tempfile tempdir /;

extends 'Action::Step::Base';
use MooseX::Types::Path::Class;

has 'perlbrew_root' => (
    is => 'ro',
    isa => 'Path::Class::Dir',
    required => 1,
    coerce => 1,
    default => q(/tmp/perlbrew_root),
);

has 'perlbrew_home' => (
    is => 'ro',
    isa => 'Path::Class::Dir',
    coerce => 1,
    lazy_build => 1,
);

has 'tmp_file' => (
    is => 'ro',
    isa => 'File::Temp',
    default => sub { File::Temp->new( SUFFIX => '.dat' ) },
);

sub _build_perlbrew_home {
    my ($self) = @_;
    return $self->perlbrew_root;
}

sub init {
    my ($self) = @_;
    $self->perlbrew_root->mkpath;
    $self->perlbrew_home->mkpath;
    $ENV{PERLBREW_ROOT} = $self->perlbrew_root->stringify;
    $ENV{PERLBREW_HOME} = $self->perlbrew_home->stringify;
    return 1;
}

sub get_perlbrew {
    my ($self) = @_;
    my $curl = can_run('curl');
    my $url = q(http://install.perlbrew.pl);
    my @cmd = ($curl, '-o', $self->tmp_file->filename, '-L', $url);
    say dump(\%ENV);
    say "@cmd";
    return scalar run(command => \@cmd, verbose => 1);
}

sub install_perlbrew {
    my ($self) = @_;
    chmod 0755, $self->tmp_file->filename;
    my @cmd;
    @cmd = ('/bin/bash', '-x', $self->tmp_file->filename);
    $ENV{PERLBREW_ROOT} = $self->perlbrew_root->stringify;
    $ENV{PERLBREW_HOME} = $self->perlbrew_home->stringify;
    say dump(\%ENV);
    return scalar run(command => \@cmd, verbose => 1);
}

sub execute {
    my ($self) = @_;
    $self->get_perlbrew;
    $self->install_perlbrew;
    $self->clean_failed_execute;
    return 1;
}

sub undo {
    my ($self) = @_;
    $self->clean_failed_undo;
    use File::Path qw(remove_tree);
    remove_tree($self->perlbrew_root->stringify);
    return 1;
}

1;
