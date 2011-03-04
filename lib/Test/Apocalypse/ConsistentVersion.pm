#
# This file is part of Test-Apocalypse
#
# This software is copyright (c) 2011 by Apocalypse.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use strict; use warnings;
package Test::Apocalypse::ConsistentVersion;
BEGIN {
  $Test::Apocalypse::ConsistentVersion::VERSION = '1.000';
}
BEGIN {
  $Test::Apocalypse::ConsistentVersion::AUTHORITY = 'cpan:APOCAL';
}

# ABSTRACT: Plugin for Test::ConsistentVersion

use Test::ConsistentVersion 0.2.2;

sub do_test {
	Test::ConsistentVersion::check_consistent_versions(
		no_pod		=> 1,
		no_readme	=> 1,
	);

	return;
}

1;


__END__
=pod

=for Pod::Coverage do_test

=head1 NAME

Test::Apocalypse::ConsistentVersion - Plugin for Test::ConsistentVersion

=head1 VERSION

  This document describes v1.000 of Test::Apocalypse::ConsistentVersion - released March 04, 2011 as part of Test-Apocalypse.

=head1 DESCRIPTION

Encapsulates L<Test::ConsistentVersion> functionality. We disable the pod/readme checks because it's not "common practice" to put
them in POD, I think...

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

