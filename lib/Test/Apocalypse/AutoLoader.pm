#
# This file is part of Test-Apocalypse
#
# This software is copyright (c) 2011 by Apocalypse.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use strict; use warnings;
package Test::Apocalypse::AutoLoader;
BEGIN {
  $Test::Apocalypse::AutoLoader::VERSION = '1.000';
}
BEGIN {
  $Test::Apocalypse::AutoLoader::AUTHORITY = 'cpan:APOCAL';
}

# ABSTRACT: Plugin for Test::AutoLoader

use Test::More;
use Test::AutoLoader 0.03;
use YAML 0.70;

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

# loads a yml file
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
	$data = $data->{'provides'};

	# Okay, how many modules do we have?
	if ( scalar keys %$data > 0 ) {
		plan tests => scalar keys %$data;
	} else {
		plan skip_all => "No provided modules found in META.yml";
	}

	# analyze every one of them!
	foreach my $module ( keys %$data ) {
		if ( _module_has_autoload( $module ) ) {
			autoload_ok( $module );
		} else {
			pass( "Skipping '$module' because it has no autoloaded files" );
		}
	}

	return;
}

# basically ripped off from Test::AutoLoader so we don't get the annoying "unable to find autoload directory" failure
sub _module_has_autoload {
	my $pkg = shift;
	my $dirname;

	if (defined($dirname = $INC{"$pkg.pm"})) {
		if ( $^O eq 'MacOS' ) {
			$pkg =~ tr#/#:#;
			$dirname =~ s#^(.*)$pkg\.pm\z#$1auto:$pkg#s;
		} else {
			$dirname =~ s#^(.*)$pkg\.pm\z#$1auto/$pkg#s;
		}
	}
	unless (defined $dirname and -d $dirname && -r _ ) {
		return 0;
	} else {
		return 1;
	}
}

1;


__END__
=pod

=for Pod::Coverage do_test

=head1 NAME

Test::Apocalypse::AutoLoader - Plugin for Test::AutoLoader

=head1 VERSION

  This document describes v1.000 of Test::Apocalypse::AutoLoader - released March 04, 2011 as part of Test-Apocalypse.

=head1 DESCRIPTION

Encapsulates L<Test::AutoLoader> functionality.

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

