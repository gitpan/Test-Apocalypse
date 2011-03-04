#
# This file is part of Test-Apocalypse
#
# This software is copyright (c) 2011 by Apocalypse.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use strict; use warnings;
package Test::Apocalypse::Pod_Coverage;
BEGIN {
  $Test::Apocalypse::Pod_Coverage::VERSION = '1.000';
}
BEGIN {
  $Test::Apocalypse::Pod_Coverage::AUTHORITY = 'cpan:APOCAL';
}

# ABSTRACT: Plugin for Test::Pod::Coverage

use Test::More;
use Test::Pod::Coverage 1.08;
use Pod::Coverage::TrustPod 0.092830;

sub do_test {
	TODO: {
		local $TODO = "Pod_Coverage";
		all_pod_coverage_ok( {
			coverage_class => 'Pod::Coverage::TrustPod',
		} );
	}

	return;
}

1;


__END__
=pod

=for Pod::Coverage do_test

=head1 NAME

Test::Apocalypse::Pod_Coverage - Plugin for Test::Pod::Coverage

=head1 VERSION

  This document describes v1.000 of Test::Apocalypse::Pod_Coverage - released March 04, 2011 as part of Test-Apocalypse.

=head1 DESCRIPTION

Encapsulates L<Test::Pod::Coverage> functionality. Automatically uses the L<Pod::Coverage::TrustPod> class.

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

