#
# This file is part of Test-Apocalypse
#
# This software is copyright (c) 2011 by Apocalypse.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use strict; use warnings;
package Test::Apocalypse::Pod_Spelling;
BEGIN {
  $Test::Apocalypse::Pod_Spelling::VERSION = '1.000';
}
BEGIN {
  $Test::Apocalypse::Pod_Spelling::AUTHORITY = 'cpan:APOCAL';
}

# ABSTRACT: Plugin for Test::Spelling

use Test::More;
use Test::Spelling 0.11;
use File::Spec 3.31;
use File::Which 1.09;

# TODO because spelling test almost always FAILs even with stopwords added to it...
sub _do_automated { 0 }
sub _is_disabled { 1 }

sub do_test {
	# Thanks to CPANTESTERS, not everyone have "spell" installed...
	# FIXME pester Test::Spelling author to be more smarter about this failure mode!
	my $binary = which( 'spell' );
	if ( ! defined $binary ) {
		plan skip_all => 'The binary "spell" is not found, unable to test spelling!';
		return;
	} else {
		# Set the spell path, to be sure!
		set_spell_cmd( $binary );
	}

	# get our list of files, and add the "namespaces" as stopwords
	foreach my $p ( Test::Spelling::all_pod_files() ) {
		foreach my $word ( File::Spec->splitdir( $p ) ) {
			next if ! length $word;
			if ( $word =~ /^(.+)\.\w+$/ ) {
				add_stopwords( $1 );
			} else {
				add_stopwords( $word );
			}
		}
	}

	# Run the test!
	TODO: {
		local $TODO = "Pod_Spelling";
		all_pod_files_spelling_ok();
	}

	return;
}

1;


__END__
=pod

=for Pod::Coverage do_test

=for stopwords spellchecker stopword stopwords pm

=head1 NAME

Test::Apocalypse::Pod_Spelling - Plugin for Test::Spelling

=head1 VERSION

  This document describes v1.000 of Test::Apocalypse::Pod_Spelling - released March 04, 2011 as part of Test-Apocalypse.

=head1 DESCRIPTION

Encapsulates L<Test::Spelling> functionality. We also add each filename as a stopword, to reduce "noise" from the spellchecker.

If you need to add stopwords, please look at L<Pod::Spell> for ways to add it to each .pm file!

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

