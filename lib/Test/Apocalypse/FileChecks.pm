#
# This file is part of Test-Apocalypse
#
# This software is copyright (c) 2011 by Apocalypse.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use strict; use warnings;
package Test::Apocalypse::FileChecks;
BEGIN {
  $Test::Apocalypse::FileChecks::VERSION = '1.000';
}
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

=for Pod::Coverage do_test

=for stopwords dist

=head1 NAME

Test::Apocalypse::FileChecks - Plugin to test for file sanity

=head1 VERSION

  This document describes v1.000 of Test::Apocalypse::FileChecks - released March 04, 2011 as part of Test-Apocalypse.

=head1 DESCRIPTION

This plugin ensures basic sanity for the files in the dist.

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

