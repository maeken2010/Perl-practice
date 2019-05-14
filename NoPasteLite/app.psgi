use Encode qw/encode_utf8 decode_utf8/;
use Data::Section::Simple qw/get_data_section/;
use URI::Escape qw/uri_unescape/;
use JSON qw/encode_json decode_json/;
use HTML::Escape qw/escape_html/;
use DDP;

my $texts = ['this is a sample!'];
my $index = 0;

sub fetch_text {
  my $id = shift;
  return $texts->[$id];
}

sub create {
  my $text = shift;
  my $id = ++$index;
  $texts->[$id] = $text;
  return $id;
}

sub update {
  my ($id, $text) = @_;
  return 0 unless defined fetch_text($id);
  $texts->[$id] = $text;
  return 1;
}

sub extract_text_from_env {
  my $env = shift;
  my $body;
  $env->{'psgi.input'}->read($body, $env->{CONTENT_LENGTH});
  my %body =                 # <= (param1, value1, param2, value2) というリストをハッシュとして解釈する
    map { decode_utf8($_)  } # <= UTF-8としてデコード
    map { uri_unescape($_) } # <= URI Escapeを解除
    map { s/\+/ /g; $_     } # <= application/x-www-form-urlencodedでは'+'はスペースを意味するので置換
    map { split /=/, $_, 2 } # <= '=' で分割 ( "param1=value1" => ("param1", "value1") )
    split(/&/, $body);    # <= '&' で分割 ( "param1=value1&param2=value2" => ("param1=value1", "param2=value2") )
  return $body{text};
}
sub extract_text_from_api_env {
  my $env = shift;
  $env->{'psgi.input'}->read($body, $env->{CONTENT_LENGTH});
  my $body = decode_json(decode_utf8($body));
  return $body->{text};
}
sub redirect {
  my $loaction = shift;
  return [
    '302',
    [
      'Content-Type' => 'text/html; charset=utf-8',
      'Location'     => $loaction,
    ],
    [''],
  ];
}

sub get_root {
  my ($env, $args) = @_;
  return render_response(sprintf get_data_section('form.html'), '/', '', 'create');
}
sub get_id {
  my ($env, $args) = @_;
  my $id = $args->{id};
  my $text = fetch_text($id);
  if (defined $text) {
    return render_response(sprintf get_data_section('form.html'), "/$id", escape_html($text), 'update');
  }
  return render_404();
}
sub post_root {
  my ($env, $args) = @_;
  my $id = create(extract_text_from_env($env));
  return redirect("/$id");
}
sub post_id {
  my ($env, $args) = @_;
  my $id = $args->{id};
  if (update($id, extract_text_from_env($env))) {
      return redirect("/$id");
  }
  return render_404();
}
sub get_id_api {
  my ($env, $args) = @_;
  my $id = $args->{id};
  my $text = fetch_text($id);
  if (defined $text) {
    return render_api_response(sprintf get_data_section('api.json'), $id, $text);
  }
  return render_api_404();
}
sub post_root_api {
  my ($env, $args) = @_;
  my $text = extract_text_from_api_env($env);
  my $id = create($text);
  return render_api_response(sprintf get_data_section('api.json'), $id, $text);
}
sub put_id_api {
  my ($env, $args) = @_;
  my $id = $args->{id};
  my $text = extract_text_from_api_env($env);
  if (update($id, $text)) {
    return render_api_response(sprintf get_data_section('api.json'), $id, $text);
  }
  return render_api_404();
}

sub {
  my $env = shift;
  my $method = $env->{REQUEST_METHOD};
  my $path   = $env->{PATH_INFO};

  if ($method eq 'GET' && $path eq '/') {
    return get_root($env, {});
  }

  if ($method eq 'GET' && $path =~ m{\A/(\d+)\Z}) {
    return get_id($env, {id => $1});
  }

  if ($method eq 'POST' && $path eq '/') {
    return post_root($env, {});
  }

  if ($method eq 'POST' && $path =~ m{\A/(\d+)\Z}) {
    return post_id($env, {id => $1});
  }

  if ($method eq 'GET' && $path =~ m{\A/api/text/(\d+)\Z}) {
    return get_id_api($env, {id => $1});
  }

  if ($method eq 'POST' && $path =~ m{\A/api/text\Z}) {
    return post_root_api($env, {});
  }

  if ($method eq 'PUT' && $path =~ m{\A/api/text/(\d+)\Z}) {
    return put_id_api($env, {id => $1});
  }

  return render_404();
};

sub render_404 {
  return [
    '404',
    ['Content-Type' => 'text/plain'],
    ['404 Not Found.'],
  ];
}

sub render_response {
  my $body = shift;
  my $content = sprintf get_data_section('wrapper.html'), $body;
  return [
    '200',
    ['Content-Type' => 'text/html; charset=utf-8'],
    [encode_utf8 $content],
  ];
}

sub render_api_404 {
  return [
    '404',
    ['Content-Type' => 'application/json'],
    ['{"status_code": 404, "message": "Not Found."}'],
  ];
}

sub render_api_response {
  my $content = shift;
  return [
    '200',
    ['Content-Type' => 'application/json; charset=utf-8'],
    [encode_utf8 $content],
  ];
}

__DATA__

@@ wrapper.html
<html lang="ja">
  <head>
    <meta charset="UTF-8" />
    <title>NoPaste Lite</title>
  </head>
  <body>
    <h1><a href="/">NoPaste Lite</a></h1>
    <hr>
    %s
  </body>
</html>

@@ form.html
<form method="POST" action="%s">
  <textarea name="text" rows="10" cols="50">%s</textarea>
  <input type="submit" value="%s" />
</form>

@@ api.json
{
  "id": %s,
  "text": "%s"
}
