package NoPaste::DB::Schema;
use strict;
package NoPaste::DB::Schema;

use warnings;
use utf8;

use Teng::Schema::Declare;

base_row_class 'NoPaste::DB::Row';

table {
    name 'text_messages';
    pk 'id';
    columns qw(id text);
};

1;
