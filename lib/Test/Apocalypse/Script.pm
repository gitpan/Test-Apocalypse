#
# This file is part of Test-Apocalypse
#
# This software is copyright (c) 2011 by Apocalypse.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use strict; use warnings;
package Test::Apocalypse::Script;
BEGIN {
  $Test::Apocalypse::Script::VERSION = '1.000';
}
BEGIN {
  $Test::Apocalypse::Script::AUTHORITY = 'cpan:APOCAL';
}

# ABSTRACT: Plugin for Test::Script

use Test::More;
use Test::Script 1.07;
use File::Find::Rule 0.32;

sub do_test {
	# Find the number of tests
	# TODO we need to search more locations/extensions/etc?
	my @files = File::Find::Rule->file->name( qr/\.pl$/ )->in( qw( examples bin scripts ) );

	# Skip if no scripts
	if ( ! scalar @files ) {
		plan skip_all => 'No script files found in the distribution';
	} else {
		plan tests => scalar @files;
		foreach my $f ( @files ) {
			script_compiles( $f );
		}
	}

	return;
}

1;


__END__
=pod

=for Pod::Coverage do_test

=head1 NAME

Test::Apocalypse::Script - Plugin for Test::Script

=head1 VERSION

  This document describes v1.000 of Test::Apocalypse::Script - released March 04, 2011 as part of Test-Apocalypse.

=head1 DESCRIPTION

Encapsulates L<Test::Script> functionality.

=head1 SEE ALSO

Please see those modules/websites for more information related to this module.

=over 4

=item *

L<Test::Apocalypse>

=back

=head1 AUTHOR

Apocalypse <APOCAL@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Apocalypse.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

The full text of the license can be found in the LICENSE file included with this distribution.

=cut

