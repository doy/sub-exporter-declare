#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

BEGIN {
    package My::Exporter;
    use Sub::Exporter::Sugar;

    export 'foo';
    export_default 'bar';

    sub foo {
        return "foo";
    }

    sub bar {
        return "bar";
    }

    $INC{'My/Exporter.pm'} = 1;
}

{
    package Foo;
    use My::Exporter;
    ::ok(!Foo->can('foo'));
    ::is(bar(), 'bar');
}

{
    package Bar;
    use My::Exporter 'foo';
    ::is(foo(), 'foo');
    ::ok(!Bar->can('bar'));
}

{
    package Baz;
    use My::Exporter ':all';
    ::is(foo(), 'foo');
    ::is(bar(), 'bar');
}

done_testing;
