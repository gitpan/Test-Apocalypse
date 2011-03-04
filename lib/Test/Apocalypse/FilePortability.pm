#
# This file is part of Test-Apocalypse
#
# This software is copyright (c) 2011 by Apocalypse.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use strict; use warnings;
package Test::Apocalypse::FilePortability;
BEGIN {
  $Test::Apocalypse::FilePortability::VERSION = '1.000';
}
BEGIN {
  $Test::Apocalypse::FilePortability::AUTHORITY = 'cpan:APOCAL';
}

# ABSTRACT: Plugin for Test::Portability::Files

# TODO oh please don't set plan in import!
#use Test::Portability::Files 0.05;

sub do_test {
	require Test::Portability::Files;
	Test::Portability::Files->import;
	Test::Portability::Files::run_tests();

	return;
}

1;


__END__
=pod

=for Pod::Coverage do_test

=head1 NAME

Test::Apocalypse::FilePortability - Plugin for Test::Portability::Files

=head1 VERSION

  This document describes v1.000 of Test::Apocalypse::FilePortability - released March 04, 2011 as part of Test-Apocalypse.

=head1 DESCRIPTION

Encapsulates L<Test::Portability::Files> functionality.

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

