use DDP;

sub {
    my $env = shift;

    if($env->{PATH_INFO} =~ m!^/([^/]+?)$!m) {
      return [
        '200',
        ['Content-Type' => 'text/plain'],
        ["Hello, $1\n"],
      ];
    } else {
      return [
        '400',
        ['Content-Type' => 'text/plain'],
        ["error!"],
      ];
    }
};