package JSON::JOM::Plugins::JsonT;

use 5.008;
use common::sense;

use Carp qw[];
use JSON::JOM qw[];
use JSON::T qw[];
use Scalar::Util qw[];

our $VERSION = '0.001';

sub extensions
{
	my ($class) = @_;
	return (
		['ARRAY', 'transform',            \&_t  ],
		['ARRAY', 'transform_tojom',      \&_tj ],
		['ARRAY', 'transform_replace',    \&_tr ],
		['HASH',  'transform',            \&_t  ],
		['HASH',  'transform_tojom',      \&_tj ],
		['HASH',  'transform_replace',    \&_tr ],
		);
}

sub _t
{
	my ($self, @params) = @_;
	
	my $t;
	if (Scalar::Util::blessed($params[0]) and $params[0]->isa('JSON::T'))
	{
		$t = shift @params;
	}
	else
	{
		$t = JSON::T->new(shift @params, shift @params);
	}

	if (defined $params[0] and CORE::ref($params[0]) eq 'HASH')
	{
		$t->parameters(%{ $params[0] })
	}
	
	return $t->transform($self);
}

sub _tj
{
	return JSON::JOM::from_json( _t(@_) );
}

sub _tr
{
	my $self        = shift;
	
	Carp::croak "transform_replace cannot be called on root node."
		if $self->isRootNode;
	
	my $replacement = _tj($self, @_);
	my $parent      = $self->parentNode;
	
	if ($parent->typeof eq 'ARRAY')
	{
		$parent->[ $self->nodeIndex ] = $replacement;
	}
	else
	{
		$parent->{ $self->nodeIndex } = $replacement;
	}
}

1;

__END__

=head1 NAME

JSON::JOM::Plugins::JsonT - transform a JOM structure with JsonT

=head1 DESCRIPTION

This JOM plugin adds the following method to JOM objects and arrays:

=over 4

=item * C<< transform($jsont) >> - transforms the node using JsonT, returning a string.

=item * C<< transform_tojom($jsont) >> - as C<transform>, but parses the result as JSON.

=item * C<< transform_replace($jsont) >> - as C<transform_tojom>, and replaces the node in its parent structure.

=back

C<transform_replace> cannot be called on root nodes.

=head1 BUGS

Please report any bugs to L<http://rt.cpan.org/>.

=head1 SEE ALSO

L<JSON::JOM>, L<JSON::JOM::Plugins>.

L<JSON::T>.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT

Copyright 2010 Toby Inkster

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

