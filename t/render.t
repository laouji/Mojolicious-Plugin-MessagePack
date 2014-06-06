use Mojo::Base -strict;
use Test::More;
use Mojolicious::Lite;
use Test::Mojo;
use File::FindLib '../lib';

use Data::MessagePack;

plugin 'MessagePack';

sub msg_unpack {
    my $content = shift;
    my $msgpack = Data::MessagePack->new();
    return $msgpack->unpack($content);
}

get '/default' => sub {
    my $self = shift;
    $self->render(pack => { a => 1, b => 2 }, handler => 'msgpack');
};

my $t = Test::Mojo->new;

$t->get_ok('/default')
      ->status_is(200, 'HTTP status OK')
      ->header_is("content-type" => 'application/x-msgpack;charset=UTF-8', 'content-type OK');
    
    my $content = $t->tx->res->content->{asset}->{content};
    is( msg_unpack($content)->{a}, 1, 'content intact after unpack');
    is( msg_unpack($content)->{b}, 2, 'content intact after unpack');

done_testing();
