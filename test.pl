#!/usr/bin/env perl
#

use strict;
use warnings;
use Modern::Perl;
use Data::Dump qw(dump);
use Class::Action;
use FindBin qw($Bin);
use lib "$Bin/lib";
use Action::Step::CreateFile;
use Action::Step::UpdateFile;
use Action::Step::SetupPerlbrew;

my $ca  = Class::Action->new();
#my $file = $ARGV[0] // q(/tmp/test.txt);
#my $o   = Action::Step::CreateFile->new( file => $file );
##$o->file->remove;
#my $o1  = Action::Step::UpdateFile->new( file => $o->file );
my $o = Action::Step::SetupPerlbrew->new();
$ca->set_steps([ $o ]);
$ca->execute;
$ca->undo;
