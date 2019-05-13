#!/usr/bin/env perl
use strict;
use warnings;

print "hello world\n";

my $string1 = "BOY";

print "hello1\n" if $string1 =~ m/boy/;
print "hello2\n" if $string1 =~  /boy/;  # same but shorter
print "hello3\n" if $string1 =~  /boy/i; # same but case insensitive