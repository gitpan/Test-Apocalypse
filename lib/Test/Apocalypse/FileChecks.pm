#
# This file is part of Test-Apocalypse
#
# This software is copyright (c) 2014 by Apocalypse.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use strict; use warnings;
package Test::Apocalypse::FileChecks;
$Test::Apocalypse::FileChecks::VERSION = '1.004';
BEGIN {
  $Test::Apocalypse::FileChecks::AUTHORITY = 'cpan:APOCAL';
}

# ABSTRACT: Plugin to test for file sanity

use Test::More;
use File::Find::Rule 0.32;
use Test::File 1.29;

sub do_test {
	my @files = qw( Changes Build.PL Makefile.PL LICENSE MANIFEST MANIFEST.SKIP README META.yml );
	my @pmfiles = File::Find::Rule->file()->name( qr/\.pm$/ )->in( 'lib' );

	# check SIGNATURE if it's there
	if ( -e 'SIGNATURE' ) {
		push( @files, 'SIGNATURE' );
	}

	# check META.json if it's there
	if ( -e 'META.json' ) {
		push( @files, 'META.json' );
	}

	plan tests => ( ( scalar @files ) * 4 ) + ( ( scalar @pmfiles ) * 3 );

	# ensure our basic CPAN dist contains everything we need
	foreach my $f ( @files ) {
		file_exists_ok( $f, "file $f exists" );
		file_not_empty_ok( $f, "file $f got data" );
		file_readable_ok( $f, "file $f is readable" );
		file_not_executable_ok( $f, "file $f is not executable" );
	}

	# check all *.pm files for executable too
	foreach my $f ( @pmfiles ) {
		file_not_empty_ok( $f, "file $f got data" );
		file_readable_ok( $f, "file $f is readable" );
		file_not_executable_ok( $f, "file $f is not executable" );
	}

	return;
}

1;

__END__

=pod

=encoding UTF-8

=for :stopwords Apocalypse Niebur Ryan dist

=for Pod::Coverage do_test

=head1 NAME

Test::Apocalypse::FileChecks - Plugin to test for file sanity

=head1 VERSION

  This document describes v1.004 of Test::Apocalypse::FileChecks - released October 24, 2014 as part of Test-Apocalypse.

=head1 DESCRIPTION

This plugin ensures basic sanity for the files in the dist.

=head1 SEE ALSO

Please see those modules/websites for more information related to this module.

=over 4

=item *

L<Test::Apocalypse|Test::Apocalypse>

=back

=head1 AUTHOR

Apocalypse <APOCAL@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Apocalypse.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

The full text of the license can be found in the
F<LICENSE> file included with this distribution.

=head1 DISCLAIMER OF WARRANTY

THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY
APPLICABLE LAW.  EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT
HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY
OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE.  THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
IS WITH YOU.  SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF
ALL NECESSARY SERVICING, REPAIR OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MODIFIES AND/OR CONVEYS
THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES, INCLUDING ANY
GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE
USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED TO LOSS OF
DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD
PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER PROGRAMS),
EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.

=cut
