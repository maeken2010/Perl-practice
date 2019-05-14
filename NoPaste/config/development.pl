use File::Spec;
use File::Basename qw(dirname);

+{
    'DBI' => [
        "dbi:mysql:dbname=nopaste", 'root', '',
        +{
             RootClass => 'DBIx::Sunny'
        }
    ],
};
