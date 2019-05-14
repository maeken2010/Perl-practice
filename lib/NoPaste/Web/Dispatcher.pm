package NoPaste::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::RouterBoom;
use NoPaste::Repository::Text;

get '/' => sub {
    my ($c, $args) = @_;

    return $c->render('form.tx', {
        action => '/',
        button => 'create',
    });
};

get '/:id' => sub {
    my ($c, $args) = @_;
    my $id = $args->{id};

    my $text = NoPaste::Repository::Text->fetch_by_id($id)
        or return $c->res_404;

    $c->fillin_form({text => $text});
    return $c->render('form.tx', {
        action => "/$id",
        button => 'update',
    });
};

post '/' => sub {
    my ($c, $args) = @_;

    my $text = $c->req->parameters->{text}
        or return $c->res_400;

    my $id = NoPaste::Repository::Text->create($text);

    return $c->redirect("/$id");
};

post '/:id' => sub {
    my ($c, $args) = @_;
    my $id = $args->{id};

    my $text = $c->req->parameters->{text} or return $c->res_400;
    my $old_text = NoPaste::Repository::Text->fetch_by_id($id) or return $c->res_404;

    NoPaste::Repository::Text->update($id, $text);

    return $c->redirect("/$id");
};

post '/reset_counter' => sub {
    my $c = shift;
    $c->session->remove('counter');
    return $c->redirect('/');
};

post '/account/logout' => sub {
    my ($c) = @_;
    $c->session->expire();
    return $c->redirect('/');
};

1;
