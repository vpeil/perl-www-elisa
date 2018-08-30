package WWW::ELISA;

our $VERSION = '0.01';

use strict;
use warnings;
use Carp;
use Digest::MD5 qw( md5_hex );
use HTTP::Request;
use JSON::XS;
use LWP::UserAgent;

sub new {
    my $class = shift;
    my %args  = (
        endpoint => 'https://elisa.hbz-nrw.de:8091/api/rest',
        callerID => 'https://xkcd.com',
        secret   => 'info.0.json',
        @_,
    );

    return bless {%args}, $class;
}

sub push {
    my ($self, $notepad) = @_;

    $self->_create_notepad($notepad);
}

sub _create_notepad {
    my ($self, $notepad) = @_;

    my $data = {
        userID      => $notepad->{userID},
        token       => $self->_authenticate(),
        notepadName => $notepad->{notepadName},
        titleList   => $notepad->{titleList},
    };

    my $response = $self->_do_request("/createNotepad", $data);
}

sub _authenticate {
    my $self = shift;

    my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst)
        = localtime(time);

    my $timestamp = sprintf(
        "%04d-%02d-%02dT%02d:%02d:%02dZ",
        $year + 1900,
        $mon + 1, $mday, $hour, $min, $sec
    );
    my $timestamp2 = sprintf(
        "%04d%02d%02dT%02d%02d%02dZ",
        $year + 1900,
        $mon + 1, $mday, $hour, $min, $sec
    );

    my $auth = {
        callerID  => $self->{callerID},
        timestamp => $timestamp,
        hash      => md5_hex($self->{callerID} . $timestamp2 . $self->{secret}),
    };

    my $res = $self->_do_request("/authenticate", $auth);
    return $res->{token};
}

sub _do_request {
    my ($self, $path, $content) = @_;

    my $endpoint = $self->{endpoint};

    my $ua = LWP::UserAgent->new;
    $ua->timeout(20);
    $ua->env_proxy;
    $ua->ssl_opts(verify_hostname => 0, SSL_verify_mode => 0x00);

    my $req = HTTP::Request->new('POST', $endpoint . $path);
    $req->header('Content-Type' => 'application/json');
    $req->content(encode_json($content));

    my $res = $ua->request($req);

    return decode_json($res->decoded_content);
}

1;

__END__

=encoding utf-8

=head1 NAME

WWWW::ELISA - a module for working the the REST API ELi:SA (https://elisa.hbz-nrw.de/)

=head1 SYNOPSIS

    use WWWW::Elisa;

    my $api = WWW::ELISA->new(callerID => "user1", secret => "s3cret");

    my $data = {
        userID      => 'me@example.com',
        notepadName => "Wishlist_1",
        titleList => [
            {title => {isbn => "9780822363804", notiz => "WWW::ELISA Test",}},
            {title => {isbn => "9788793379312", notiz => "WWW::ELISA Test2",}}
        ];
    }

    $api->push($data);

=head1 METHODS

=head2 new()

=item * endpoint

=back

=head1 AUTHOR

Vitali Peil E<lt>vitali.peil@uni-bielefeld.deE<gt>

=head1 COPYRIGHT

Copyright 2018- Vitali Peil

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
