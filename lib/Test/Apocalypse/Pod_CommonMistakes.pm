#
# This file is part of Test-Apocalypse
#
# This software is copyright (c) 2011 by Apocalypse.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use strict; use warnings;
package Test::Apocalypse::Pod_CommonMistakes;
BEGIN {
  $Test::Apocalypse::Pod_CommonMistakes::VERSION = '1.000';
}
BEGIN {
  $Test::Apocalypse::Pod_CommonMistakes::AUTHORITY = 'cpan:APOCAL';
}

# ABSTRACT: Plugin for Test::Pod::Spelling::CommonMistakes

use Test::Pod::Spelling::CommonMistakes 1.000;

# We don't disable this on automated because it doesn't depend on system binaries or any other whacky stuff :)

sub do_test {
	all_pod_files_ok();

	return;
}

1;


__END__
=pod

=for Pod::Coverage do_test

=head1 NAME

Test::Apocalypse::Pod_CommonMistakes - Plugin for Test::Pod::Spelling::CommonMistakes

=head1 VERSION

  This document describes v1.000 of Test::Apocalypse::Pod_CommonMistakes - released March 04, 2011 as part of Test-Apocalypse.

=head1 DESCRIPTION

Encapsulates L<Test::Pod::Spelling::CommonMistakes> functionality.

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

