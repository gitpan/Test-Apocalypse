#
# This file is part of Test-Apocalypse
#
# This software is copyright (c) 2011 by Apocalypse.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use strict; use warnings;
package Test::Apocalypse::Signature;
BEGIN {
  $Test::Apocalypse::Signature::VERSION = '1.000';
}
BEGIN {
  $Test::Apocalypse::Signature::AUTHORITY = 'cpan:APOCAL';
}

# ABSTRACT: Plugin for Test::Signature

use Test::More;
use Test::Signature 1.10;

# Various people have said SIGNATURE tests are INSANE on end-user install...
sub _do_automated { 0 }

sub do_test {
	# do we have a signature file?
	if ( -e 'SIGNATURE' ) {
		signature_ok();
	} else {
		plan skip_all => 'No SIGNATURE file found';
	}

	return;
}

1;


__END__
=pod

=for Pod::Coverage do_test

=head1 NAME

Test::Apocalypse::Signature - Plugin for Test::Signature

=head1 VERSION

  This document describes v1.000 of Test::Apocalypse::Signature - released March 04, 2011 as part of Test-Apocalypse.

=head1 DESCRIPTION

Encapsulates L<Test::Signature> functionality.

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

