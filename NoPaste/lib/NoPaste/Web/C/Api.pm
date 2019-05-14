package NoPaste::Web::C::Api;

use NoPaste::Repository::Text;

sub get_text_id {
    my ($class, $c, $args) = @_;
    my $id = $args->{id};

    my $text = NoPaste::Repository::Text->fetch_by_id($id)
        or return $c->res_404_json;

    return $c->render_json({
        id   => $id,
        text => $text,
    });
}

sub post_text {
    my ($class, $c, $args) = @_;

    my $text = $c->req->parameters->{text}
        or return $c->res_400_json;

    my $id = NoPaste::Repository::Text->create($text);

    return $c->render_json({
        id   => $id,
        text => $text,
    });
}

sub put_text_id {
    my ($class, $c, $args) = @_;
    my $id = $args->{id};

    my $text = $c->req->parameters->{text} or return $c->res_400_json;
    my $old_text = NoPaste::Repository::Text->fetch_by_id($id) or return $c->res_404_json;

    NoPaste::Repository::Text->update($id, $text);

    return $c->render_json({
        id   => $id,
        text => $text,
    });
}
1;