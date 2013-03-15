use Mojo::Base -strict;

use Mojo::JSON 'j';
use File::Spec;
use Galileo::DB::Deploy;

use Test::More;
use Test::Mojo;

my $home = $ENV{GALILEO_HOME} = File::Spec->rel2abs(File::Spec->catdir( qw/ t locations / ));

my $t = Galileo::DB::Deploy->create_test_object({ test => 1 });
$t->ua->max_redirects(2);
my $app = $t->app;

is( $app->home, $home, 'home dir detected from GALILEO_HOME' );

$t->get_ok('/test.html')
  ->status_is(200)
  ->text_is('body' => 'test text')
  ->or( sub { diag "'static' should be in @{ $app->static->paths }" } );

done_testing();

