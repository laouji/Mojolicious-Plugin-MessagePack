package Mojolicious::Plugin::MessagePack;
use Mojo::Base 'Mojolicious::Plugin';
use Data::MessagePack;

sub register {
  my ($self, $app, $args) = @_;

    $app->types->type(msgpack => 'application/x-msgpack;charset=UTF-8');
    
    $app->renderer->add_handler(msgpack => sub {
        my ($renderer, $c, $output, $options) = @_;
        
        #prevent Mojo from reencoding output
        $options->{encoding} = undef;         
        $options->{format} = 'msgpack';         

        my $msgpack = Data::MessagePack->new();
        $msgpack->utf8;
        
        $$output = $msgpack->pack($c->stash->{pack});
    });
}

1;
