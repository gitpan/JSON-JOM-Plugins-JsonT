use lib "lib";
use lib "../JSON-JOM/lib";
use JSON::JOM;

my $jom = JSON::JOM::to_jom({
	test => {
		foo  => [{quux=>1},{quux=>2},{quux=>3}],
		bar  => [{quux=>4},{quux=>5},{quux=>6}],
		},
	});

my @nodes = $jom->{test}->findNodes("\$[*][*]");
foreach my $node (@nodes)
{
	if ($node->matchesPath("\$[*]['bar'][*]"))
	{
		print "bar has object with quux=".$node->{quux}."\n";
	}
}
