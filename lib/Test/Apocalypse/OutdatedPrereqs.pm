#
# This file is part of Test-Apocalypse
#
# This software is copyright (c) 2014 by Apocalypse.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use strict; use warnings;
package Test::Apocalypse::OutdatedPrereqs;
$Test::Apocalypse::OutdatedPrereqs::VERSION = '1.003';
BEGIN {
  $Test::Apocalypse::OutdatedPrereqs::AUTHORITY = 'cpan:APOCAL';
}

# ABSTRACT: Plugin to detect outdated prereqs

use Test::More;
use YAML 0.70;
use CPANPLUS 0.90;
use CPANPLUS::Configure; # TODO no version here, so we added CPANPLUS 0.90, ( should we use CPANPLUS::Internals instead? )
use CPANPLUS::Backend;
use version 0.77;
use Module::CoreList 2.23;

sub _do_automated { 0 }

sub do_test {
	# does META.yml exist?
	if ( -e 'META.yml' and -f _ ) {
		_load_yml( 'META.yml' );
	} else {
		# maybe one directory up?
		if ( -e '../META.yml' and -f _ ) {
			_load_yml( '../META.yml' );
		} else {
			plan tests => 1;
			fail( 'META.yml is missing, unable to process it!' );
		}
	}

	return;
}

sub _load_yml {
	# we'll load a file
	my $file = shift;

	# okay, proceed to load it!
	my $data;
	eval {
		$data = YAML::LoadFile( $file );
	};
	if ( $@ ) {
		plan tests => 1;
		fail( "Unable to load $file => $@" );
		return;
	}

	# massage the data
	$data = $data->{'requires'};
	delete $data->{'perl'} if exists $data->{'perl'};

	# init the backend ( and set some options )
	my $cpanconfig = CPANPLUS::Configure->new;
	$cpanconfig->set_conf( 'verbose' => 0 );
	$cpanconfig->set_conf( 'no_update' => 1 );

	# ARGH, CPANIDX doesn't work well with this kind of search...
	if ( $cpanconfig->get_conf( 'source_engine' ) =~ /CPANIDX/ ) {
		diag( "Disabling CPANIDX for CPANPLUS" );
		$cpanconfig->set_conf( 'source_engine' => 'CPANPLUS::Internals::Source::Memory' );
	}

	my $cpanplus = CPANPLUS::Backend->new( $cpanconfig );

	# silence CPANPLUS!
	eval "no warnings; sub Log::Message::store { return }";

	# Okay, how many prereqs do we have?
	if ( scalar keys %$data == 0 ) {
		plan skip_all => "No prereqs found in META.yml";
		return;
	}

	# Argh, check for CPANPLUS sanity!
#   Failed test 'no warnings'
#   at /usr/local/share/perl/5.10.0/Test/NoWarnings.pm line 45.
# There were 1 warning(s)
# 	Previous test 189 'no breakpoint test of blib/lib/POE/Component/SSLify/ClientHandle.pm'
# 	Key 'archive' (/home/apoc/.cpanplus/01mailrc.txt.gz) is of invalid type for 'Archive::Extract::new' provided by CPANPLUS::Internals::Source::__create_author_tree at /usr/share/perl/5.10/CPANPLUS/Internals/Source.pm line 539
#  at /usr/share/perl/5.10/Params/Check.pm line 565
# 	Params::Check::_store_error('Key \'archive\' (/home/apoc/.cpanplus/01mailrc.txt.gz) is of ...', 1) called at /usr/share/perl/5.10/Params/Check.pm line 345
# 	Params::Check::check('HASH(0x3ce9f50)', 'HASH(0x3cf7b08)') called at /usr/share/perl/5.10/Archive/Extract.pm line 227
	{
		my $warn_seen = 0;
		local $SIG{'__WARN__'} = sub { $warn_seen = 1; return; };
		my $module = $cpanplus->parse_module( 'module' => 'Test::More' );
		if ( $warn_seen ) {
			plan skip_all => "Unable to sanely use CPANPLUS, aborting!";
			return;
		}
	}

	# analyze every one of them!
	plan tests => scalar keys %$data;
	foreach my $prereq ( keys %$data ) {
		_check_cpan( $cpanplus, $prereq, $data->{ $prereq } );
	}

	return;
}

# checks a prereq against CPAN
sub _check_cpan {
	my $backend = shift;
	my $prereq = shift;
	my $version = shift;

	# check CPANPLUS
	my $module = $backend->parse_module( 'module' => $prereq );
	if ( defined $module ) {
		# okay, for starters we check to see if it's version 0 then we skip it
		if ( $version eq '0' ) {
			pass( "Skipping '$prereq' because it is specified as version 0" );
			return;
		}

		# Does the prereq have funky characters that we're unable to process now?
		if ( $version =~ /[<>=,!]+/ ) {
			# simple style of parsing, may blow up in the future!
			my @versions = split( ',', $version );

			# sort them by version, descending
			s/[\s<>=!]+// for @versions;
			@versions = reverse sort { $a <=> $b }
				map { version->new( $_ ) } @versions;

			# pick the highest version to use as comparison
			$version = $versions[0];
		}

		# convert both objects to version objects so we can compare
		$version = version->new( $version ) if ! ref $version;
		my $cpanversion = version->new( $module->version );

		# Make sure that the prereq version exists on CPAN
		if ( $cpanversion < $version ) {
			fail( "Warning: '$prereq' version $version is not found on CPAN!" );
		} else {
			# The version we specified should be the latest CPAN version
			TODO: {
				local $TODO = "OutdatedPrereqs";
				cmp_ok( $cpanversion, '==', $version, "Comparing '$prereq' to CPAN version" );
			}
		}
	} else {
		my $release = Module::CoreList->first_release( $prereq );
		if ( defined $release ) {
			pass( "Skipping '$prereq' because it is a CORE module" );
		} else {
			fail( "Warning: '$prereq' is not found on CPAN!" );
		}
	}

	return;
}

1;

__END__

=pod

=encoding UTF-8

=for :stopwords Apocalypse Niebur Ryan CPAN prereq prereqs backend

=for Pod::Coverage do_test

=head1 NAME

Test::Apocalypse::OutdatedPrereqs - Plugin to detect outdated prereqs

=head1 VERSION

  This document describes v1.003 of Test::Apocalypse::OutdatedPrereqs - released October 24, 2014 as part of Test-Apocalypse.

=head1 DESCRIPTION

This plugin detects outdated prereqs in F<META.yml> specified relative to CPAN. It uses L<CPANPLUS> as the backend.

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
