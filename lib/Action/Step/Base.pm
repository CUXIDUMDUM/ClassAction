package Action::Step::Base;

use Moose;
use namespace::autoclean;
use Modern::Perl;
use Data::Dump qw(dump);
use Clone qw/clone/;

with 'Action::Step';

sub clone_obj {
    my ($self, %params) = @_;
    say 'In clone obj';
    return $self->meta->clone_object($self,%params);
}

sub reset_obj_state {
    my ($self) = @_;
    say 'In reset obj state';
    for my $attr ( $self->meta->get_all_attributes ) {
        my $clearer = 'clear_' . $attr;
        $self->$clearer;
    }
}

sub state {
    my ($self) = @_;
    #say q(In state ) . ref($self);
}

sub execute {
    my ($self) = @_;
    say 'In execute';
    return 1;
}

sub retry_execute {
    my ($self) = @_;
    say 'In retry execute';
    $self->clean_failed_execute;
    return 1;
}

sub clean_failed_execute {
    my ($self) = @_;
    say 'In clean failed execute';
    return 1;
}

sub undo {
    my ($self) = @_;
    say 'In undo';
    return 1;
}

sub retry_undo {
    my ($self) = @_;
    say 'In retry undo';
    $self->clean_failed_undo;
    return 1;
}

sub clean_failed_undo {
    my ($self) = @_;
    say 'In clean failed undo';
    return 1;
}

sub exec_stack_runtime_handler {
    my ($self) = @_;
    #say 'In exec_stack_runtime_handler ' . ref($self);
    return 1;
}

1;
