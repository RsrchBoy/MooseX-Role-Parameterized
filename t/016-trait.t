#!/usr/bin/env perl
use strict;
use warnings;
use Test::More skip_all => "Moose doesn't yet support traits with parameters";
#use Test::More tests => 2;

do {
    package MyTrait::Label;
    use MooseX::Role::Parameterized;

    parameter default => (
        is  => 'rw',
        isa => 'Str',
    );

    role {
        my $p = shift;

        has label => (
            is      => 'rw',
            isa     => 'Str',
            default => $p->default,
        );
    };
};

do {
    package MyClass::LabeledURL;
    use Moose;

    has url => (
        traits => [
            'MyTrait::Label' => { default => 'yay' },
        ],
        is  => 'rw',
        isa => 'Str',
    );
};

do {
    package MyClass::LabeledURL::Redux;
    use Moose;
    extends 'MyClass::LabeledURL';

    has '+url' => (
        label => 'overridden',
    );
};

is(MyClass::LabeledURL->meta->get_attribute('url')->label, 'yay');
is(MyClass::LabeledURL::Redux->meta->get_attribute('url')->label, 'overridden');
