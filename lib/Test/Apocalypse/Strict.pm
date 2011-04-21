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
  $Test::Apocalypse::Strict::VERSION = '1.002';
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

=for :stopwords Apocalypse

=encoding utf-8

=for Pod::Coverage do_test

=head1 NAME

Test::Apocalypse::Strict - Plugin for Test::Strict

=head1 VERSION

  This document describes v1.002 of Test::Apocalypse::Strict - released April 21, 2011 as part of Test-Apocalypse.

=head1 DESCRIPTION

Encapsulates L<Test::Strict> functionality. We also enable the warnings check.

=head1 SEE ALSO

Please see those modules/websites for more information related to this module.

=over 4

=item *

L<Test::Apocalypse|Test::Apocalypse>

=back

=head1 AUTHOR

Apocalypse <APOCAL@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Apocalypse.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

The full text of the license can be found in the LICENSE file included with this distribution.

=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT
WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER
PARTIES PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND,
EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE
SOFTWARE IS WITH YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME
THE COST OF ALL NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE LIABLE
TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE
SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH
DAMAGES.

=cut

