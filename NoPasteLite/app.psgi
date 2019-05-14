use Encode qw/encode_utf8 decode_utf8/;
use Data::Section::Simple qw/get_data_section/;

sub {
    my $env = shift;

    my $method = $env->{REQUEST_METHOD};
    my $path   = $env->{PATH_INFO};

    return render_response("<ul><li>method: $method</li><li>path: $path</li></ul>");
};

sub render_response {
    my $body = shift;
    my $content = sprintf get_data_section('wrapper.html'), $body;
    return [
        '200',
        ['Content-Type' => 'text/html; charset=utf-8'],
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
