#
# This file is part of Test-Apocalypse
#
# This software is copyright (c) 2011 by Apocalypse.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use strict; use warnings;
package Test::Apocalypse::Strict;
BEGIN {
  $Test::Apocalypse::Strict::VERSION = '1.000';
}
BEGIN {
  $Test::Apocalypse::Strict::AUTHORITY = 'cpan:APOCAL';
}

# ABSTRACT: Plugin for Test::Strict

use Test::Strict 0.14;

sub do_test {
	# Argh, Test::Strict's TEST_SKIP requires full paths!
	my @files = Test::Strict::_all_perl_files();
	@files = grep { /(?:Build\.PL|Makefile\.PL|Build)$/ } @files;

	# Set some useful stuff
	local $Test::Strict::TEST_WARNINGS = 1;	# to silence "used only once typo warning"
	local $Test::Strict::TEST_SKIP = \@files;

	local $Test::Strict::TEST_WARNINGS = 1;
	local $Test::Strict::TEST_SKIP = \@files;

	# Run the test!
	all_perl_files_ok();

	return;
}

1;


__END__
=pod

=for Pod::Coverage do_test

=head1 NAME

Test::Apocalypse::Strict - Plugin for Test::Strict

=head1 VERSION

  This document describes v1.000 of Test::Apocalypse::Strict - released March 04, 2011 as part of Test-Apocalypse.

=head1 DESCRIPTION

Encapsulates L<Test::Strict> functionality. We also enable the warnings check.

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

