package Action::Step;

use Moose::Role;
use namespace::autoclean;
use Modern::Perl;
use Data::Dump qw(dump);

requires qw(
    clone_obj
    reset_obj_state
    state
    execute
    retry_execute
    clean_failed_execute
    undo
    retry_undo
    clean_failed_undo
    exec_stack_runtime_handler
);

1;
