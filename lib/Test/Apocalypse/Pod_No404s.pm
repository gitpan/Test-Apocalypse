#
# This file is part of Test-Apocalypse
#
# This software is copyright (c) 2011 by Apocalypse.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use strict; use warnings;
package Test::Apocalypse::Pod_No404s;
BEGIN {
  $Test::Apocalypse::Pod_No404s::VERSION = '1.000';
}
BEGIN {
  $Test::Apocalypse::Pod_No404s::AUTHORITY = 'cpan:APOCAL';
}

# ABSTRACT: Plugin for Test::Pod::No404s

use Test::More;
use Test::Pod::No404s 0.01;

# TODO since cpants is down, all of my tests FAIL... :(
sub _is_disabled { 1 }

# Don't hammer the internet on smokers' machines :)
sub _do_automated { 0 }

sub do_test {
	TODO: {
		local $TODO = "Pod_No404s";
		all_pod_files_ok();
	}

	return;
}

1;


__END__
=pod

=for Pod::Coverage do_test

=head1 NAME

Test::Apocalypse::Pod_No404s - Plugin for Test::Pod::No404s

=head1 VERSION

  This document describes v1.000 of Test::Apocalypse::Pod_No404s - released March 04, 2011 as part of Test-Apocalypse.

=head1 DESCRIPTION

Encapsulates L<Test::Pod::No404s> functionality.

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

