use Test::More;
use DBIx::Handler;
use DBIx::Sunny;

my $dsn = 'dbi:mysql:dbname=excercise_mysql';
my $handler = DBIx::Handler->connect($dsn, 'root', '', { RootClass => 'DBIx::Sunny' });

is ref $handler, 'DBIx::Handler';
is ref $handler->dbh, 'DBIx::Sunny::db';

done_testing;
