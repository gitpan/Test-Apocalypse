#
# This file is part of Test-Apocalypse
#
# This software is copyright (c) 2011 by Apocalypse.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use strict; use warnings;
package Test::Apocalypse::NoBreakpoints;
BEGIN {
  $Test::Apocalypse::NoBreakpoints::VERSION = '1.000';
}
BEGIN {
  $Test::Apocalypse::NoBreakpoints::AUTHORITY = 'cpan:APOCAL';
}

# ABSTRACT: Plugin for Test::NoBreakpoints

use Test::NoBreakpoints 0.13;

sub do_test {
	all_files_no_breakpoints_ok();

	return;
}

1;


__END__
=pod

=for Pod::Coverage do_test

=head1 NAME

Test::Apocalypse::NoBreakpoints - Plugin for Test::NoBreakpoints

=head1 VERSION

  This document describes v1.000 of Test::Apocalypse::NoBreakpoints - released March 04, 2011 as part of Test-Apocalypse.

=head1 DESCRIPTION

Encapsulates L<Test::NoBreakpoints> functionality.

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

