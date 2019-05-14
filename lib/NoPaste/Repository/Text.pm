package NoPaste::Repository::Text;
use strict;
use warnings;
use utf8;

my $index = 0;
my $texts = ['this is a sample!'];

sub fetch_by_id {
    my ($class, $id) = @_;

    return $texts->[$id];
}

sub create {
    my ($class, $text) = @_;

    my $id = ++$index;
    $texts->[$id] = $text;

    return $id;
}

sub update {
    my ($class, $id, $text) = @_;

    $texts->[$id] = $text;
}

1;