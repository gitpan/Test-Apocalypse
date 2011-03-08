#
# This file is part of Test-Apocalypse
#
# This software is copyright (c) 2011 by Apocalypse.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use strict; use warnings;
package Test::Apocalypse::PPPort;
BEGIN {
  $Test::Apocalypse::PPPort::VERSION = '1.001';
}
BEGIN {
  $Test::Apocalypse::PPPort::AUTHORITY = 'cpan:APOCAL';
}

# ABSTRACT: Plugin to test for Devel::PPPort warnings

use Test::More;
use Devel::PPPort 3.19;
use Capture::Tiny 0.10 qw( capture_merged );

sub _do_automated { 0 }

sub do_test {
	plan tests => 2;

	# do we have an existing ppport.h file?
	my $haveppport = 0;
	my $needstrip = 0;
	my $ppp = 'ppport.h';
	SKIP: {
		if ( ! -f $ppp ) {
			# generate our own ppport.h file
			Devel::PPPort::WriteFile( $ppp );

			skip( "Distro did not come with a $ppp file", 1 );
		}

		$haveppport++;

		# was it already stripped or not?
		my $oldver = capture_merged { system( $^X, $ppp, '--version' ) };
		if ( length $oldver ) {
			if ( $oldver =~ /^This is ppport\.h ([\d\.]+)$/ms ) {
				fail( "$ppp file needs to be stripped" );
			} else {
				$needstrip++;
				pass( "$ppp file was already stripped" );
			}
		} else {
			die "Unable to run $ppp and get the output";
		}

		# remove it and create a new one so we have the latest one, always
		unlink( $ppp ) or die "Unable to unlink '$ppp': $!";
		Devel::PPPort::WriteFile( $ppp );
	}

	# Then, we run it :)
	my $result = capture_merged { system( $^X, $ppp ) };

	if ( length $result ) {
		# Did we have any xs files?
		if ( $result =~ /^No input files given/m ) {
			pass( 'No XS files detected' );
		} else {
			# is the last line saying "OK" ?
			if ( $result =~ /Looks good$/m ) {
				# Did we get any warnings? Display them in case they're useful...
				my @warns;
				foreach my $l ( split( "\n", $result ) ) {
					if ( $l =~ /^\*\*\*\s+WARNING:\s+/s ) {
						push( @warns, $l );
					}
				}

				if ( @warns ) {
					pass( "$ppp says you are good to go with some warnings" );
					diag( $_ ) for @warns;
				} else {
					pass( "$ppp says you are good to go" );
				}
			} else {
				fail( "$ppp caught some errors" );
				diag( $result );
			}
		}
	} else {
		die "Unable to run $ppp and get the output";
	}

	# remove our generated ppport.h file
	if ( ! $haveppport ) {
		unlink( $ppp ) or die "Unable to unlink '$ppp': $!";
	} else {
		if ( $needstrip ) {
			$result = capture_merged { system( $^X, $ppp, '--strip' ) };
			if ( length $result ) {
				die "Unable to strip $ppp file: $result";
			}
		}
	}

	return;
}

1;


__END__
=pod

=for :stopwords Apocalypse

=encoding utf-8

=for Pod::Coverage do_test

=head1 NAME

Test::Apocalypse::PPPort - Plugin to test for Devel::PPPort warnings

=head1 VERSION

  This document describes v1.001 of Test::Apocalypse::PPPort - released March 08, 2011 as part of Test-Apocalypse.

=head1 DESCRIPTION

Plugin to test for L<Devel::PPPort> warnings. It automatically updates your bundled F<ppport.h> file to the latest provided by L<Devel::PPPort>!
Also, it will strip the F<ppport.h> file to make it smaller.

=for stopwords ppport

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

