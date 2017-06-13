use v6;
use Test;
use lib 'lib';
use Log::Async;

plan 4;

my @lines;
my $out = IO::Handle but role { method say($arg) { @lines.push: $arg } };

my $one = logger.send-to($out, formatter => -> $m, :$fh { @lines.push: "one" } );
my $two = logger.send-to($out, formatter => -> $m, :$fh { @lines.push: "two" } );
my $three = logger.send-to($out, formatter => -> $m, :$fh { @lines.push: "three" } );

isa-ok $one, Tap, 'got a tap';
isa-ok $two, Tap, 'got a tap';
isa-ok $three, Tap, 'got a tap';

logger.remove-tap($two);

info "hello";
logger.done;

is-deeply @lines, [ "one", "three" ], "two out of three taps still there";
