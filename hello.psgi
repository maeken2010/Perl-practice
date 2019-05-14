use DDP;

my $app = sub {
  my $env = shift;

  if($env->{PATH_INFO} =~ m!^/hello/([^/]+?)$!m) {
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