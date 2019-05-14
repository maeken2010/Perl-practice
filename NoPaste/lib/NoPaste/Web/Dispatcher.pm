package NoPaste::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::RouterBoom;

use NoPaste::Web::C::Page;
use NoPaste::Web::C::Api;

base 'NoPaste::Web::C';

get  '/'    => 'Page#get_root';
get  '/:id' => 'Page#get_id';
post '/'    => 'Page#post_root';
post '/:id' => 'Page#post_id';

get  '/api/text/:id' => 'Api#get_text_id';
post '/api/text'     => 'Api#post_text';
put  '/api/text/:id' => 'Api#put_text_id';
