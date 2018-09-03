# NAME

WWW::ELISA - a module for working the the REST API ELi:SA (https://elisa.hbz-nrw.de/)

# SYNOPSIS

    use WWW::Elisa;

    my $api = WWW::ELISA->new(callerID => "user1", secret => "s3cret");

    my $data = {
        userID      => 'me@example.com',
        notepadName => "Wishlist_1",
        titleList => [
            {title => {isbn => "9780822363804", notiz => "WWW::ELISA Test"}},
            {title => {isbn => "9788793379312", notiz => "WWW::ELISA Test2"}},
        ];
    };

    $api->push($data);

# METHODS

## new($opts)

- endpoint

    Optional. Default is to https://elisa.hbz-nrw.de:8091/api/rest

- callerID

    Required.

- secret

    Required.

## push($data)

Pushes the notepad data to ELi:SA.

# AUTHOR

Vitali Peil <vitali.peil@uni-bielefeld.de>

# COPYRIGHT

Copyright 2018- Vitali Peil

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO
