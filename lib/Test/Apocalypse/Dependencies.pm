#
# This file is part of Test-Apocalypse
#
# This software is copyright (c) 2011 by Apocalypse.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use strict; use warnings;
package Test::Apocalypse::Dependencies;
BEGIN {
  $Test::Apocalypse::Dependencies::VERSION = '1.002';
}
BEGIN {
  $Test::Apocalypse::Dependencies::AUTHORITY = 'cpan:APOCAL';
}

# ABSTRACT: Plugin to check for metadata dependencies

use Test::More;
use File::Slurp 9999.13;
use YAML::Any 0.72;
use JSON::Any 1.25;
use File::Find::Rule 0.32;
use Perl::PrereqScanner 1.000;
use Test::Deep 0.108;

sub _do_automated { 0 }

sub do_test {
	# load the metadata
	my $runtime_req;
	my $test_req;
	my $provides;
	if ( -e 'META.json' ) {
		my $file = read_file( 'META.json' );
		my $metadata = JSON::Any->new->Load( $file );
		$runtime_req = $metadata->{'prereqs'}{'runtime'}{'requires'};
		$test_req = $metadata->{'prereqs'}{'test'}{'requires'};
		$provides = $metadata->{'provides'} if exists $metadata->{'provides'};
	} elsif ( -e 'META.yml' ) {
		my $file = read_file( 'META.yml' );
		my $metadata = Load( $file );
		$runtime_req = $metadata->{'requires'};
		$provides = $metadata->{'provides'} if exists $metadata->{'provides'};
	} else {
		die 'No META.(json|yml) found!';
	}

	# remove 'perl' dep - we check it in MinimumVersion anyway
	delete $runtime_req->{'perl'} if exists $runtime_req->{'perl'};
	delete $test_req->{'perl'} if defined $test_req and exists $test_req->{'perl'};

	# Convert version objects to regular
	$runtime_req->{ $_ } =~ s/^v// for keys %$runtime_req;
	$test_req->{ $_ } =~ s/^v// for keys %$test_req;

	# Okay, scan the files
	my $found_runtime = Version::Requirements->new;
	my $found_test = Version::Requirements->new;
	foreach my $file ( File::Find::Rule->file()->name( qr/\.pm$/ )->in( 'lib' ) ) {
		$found_runtime->add_requirements( Perl::PrereqScanner->new->scan_file( $file ) );
	}

	# scan the test dir only if we have test metadata
	if ( defined $test_req ) {
		foreach my $file ( File::Find::Rule->file()->name( qr/\.(pm|t|pl)$/ )->in( 't' ) ) {
			$found_test->add_requirements( Perl::PrereqScanner->new->scan_file( $file ) );
		}
	}

	# Okay, the spec says that anything already in the runtime req shouldn't be listed in test req
	# That means we need to "fake" the prereq and make sure the comparison is OK
	if ( defined $test_req ) {
		my %temp = %{ $found_test->as_string_hash };
		foreach my $mod ( keys %temp ) {
			if ( ! exists $test_req->{ $mod } and exists $runtime_req->{ $mod } ) {
				# don't copy runtime_req's version because it might be different and cmp_deeply will complain!
				$test_req->{ $mod } = $temp{ $mod };
			}
		}
	}

	# We remove any prereqs that we provided in the package
	if ( defined $provides ) {
		foreach my $p ( keys %$provides ) {
			$found_runtime->clear_requirement( $p );
			$found_test->clear_requirement( $p );
		}
	}

	# Thanks to PoCo::SmokeBox::Uploads::Rsync's use of PoCo::Generic, we have to do this
	# Mangle the found version to the required one if it was 0
	{
		my %temp = %{ $found_runtime->as_string_hash };
		foreach my $p ( keys %temp ) {
			if ( $runtime_req->{ $p } ne '0' and $temp{ $p } eq '0' ) {
				$found_runtime->clear_requirement( $p );
				$found_runtime->add_minimum( $p => $runtime_req->{ $p } );
			}
		}
	}

	# Do the same for the test stuff
	if ( defined $test_req ) {
		my %temp = %{ $found_test->as_string_hash };
		foreach my $p ( keys %temp ) {
			if ( $test_req->{ $p } ne '0' and $temp{ $p } eq '0' ) {
				$found_test->clear_requirement( $p );
				$found_test->add_minimum( $p => $runtime_req->{ $p } );
			}
		}
	}

	# Do the actual comparison!
	if ( defined $test_req ) {
		plan tests => 2;
	} else {
		plan tests => 1;
	}

	cmp_deeply( $found_runtime->as_string_hash, $runtime_req, "Runtime requires" );
	cmp_deeply( $found_test->as_string_hash, $test_req, "Test requires" ) if defined $test_req;

	return;
}

1;


__END__
=pod

=for :stopwords Apocalypse metadata

=encoding utf-8

=for Pod::Coverage do_test

=head1 NAME

Test::Apocalypse::Dependencies - Plugin to check for metadata dependencies

=head1 VERSION

  This document describes v1.002 of Test::Apocalypse::Dependencies - released April 21, 2011 as part of Test-Apocalypse.

=head1 DESCRIPTION

Loads the metadata and uses L<Perl::PrereqScanner> to look for dependencies and compares the lists.

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

