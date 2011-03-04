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
  $Test::Apocalypse::PPPort::VERSION = '1.000';
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

=for Pod::Coverage do_test

=for stopwords ppport

=head1 NAME

Test::Apocalypse::PPPort - Plugin to test for Devel::PPPort warnings

=head1 VERSION

  This document describes v1.000 of Test::Apocalypse::PPPort - released March 04, 2011 as part of Test-Apocalypse.

=head1 DESCRIPTION

Plugin to test for L<Devel::PPPort> warnings. It automatically updates your bundled F<ppport.h> file to the latest provided by L<Devel::PPPort>!
Also, it will strip the F<ppport.h> file to make it smaller.

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

