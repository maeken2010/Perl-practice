package NoPaste::Web::C::Page;

sub get_root {
    my ($class, $c, $args) = @_;

    return $c->render('form.tx', {
        action => '/',
        button => 'create',
    });
}

sub get_id {
    my ($class, $c, $args) = @_;
    my $id = $args->{id};

    my $row = $c->db->single('text_messages', {'id' => $id});
    unless (defined $row) {
      return $c->res_404;
    }

    my $text = $row->text;

    $c->fillin_form({text => $text});
    return $c->render('form.tx', {
        action => "/$id",
        button => 'update',
    });
}

sub post_root {
    my ($class, $c, $args) = @_;

    my $text = $c->req->parameters->{text}
        or return $c->res_400;

    my $id = $c->db->fast_insert(text_messages => {
      text => $text
    });

    return $c->redirect("/$id");
}

sub post_id {
    my ($class, $c, $args) = @_;
    my $id = $args->{id};

    my $text = $c->req->parameters->{text} or return $c->res_400;

    my $row = $c->db->single('text_messages', {'id' => $id});
    unless (defined $row) {
      return $c->res_404;
    }

    $c->db->update(text_messages => {
      text => $text
    }, { id => $id });

    return $c->redirect("/$id");
}
1;