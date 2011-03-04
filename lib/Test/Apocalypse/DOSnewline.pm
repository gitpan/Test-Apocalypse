#
# This file is part of Test-Apocalypse
#
# This software is copyright (c) 2011 by Apocalypse.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use strict; use warnings;
package Test::Apocalypse::DOSnewline;
BEGIN {
  $Test::Apocalypse::DOSnewline::VERSION = '1.000';
}
BEGIN {
  $Test::Apocalypse::DOSnewline::AUTHORITY = 'cpan:APOCAL';
}

# ABSTRACT: Plugin to detect presence of DOS newlines

use Test::More;
use File::Find::Rule 0.32;

# TODO If a win32 user downloads the tarball, it will have DOS newlines in it?
sub _do_automated { 0 }

sub do_test {
	plan tests => 1;

	# generate the file list
	my @files = File::Find::Rule->grep( qr/\r\n/ )->in( '.' );

	# for now, we skip SVN + git stuff
	# also skip any tarballs
	@files = grep { $_ !~ /(?:\.svn\/|\.git\/|tar(?:\.gz|\.bz2)?|tgz|zip)/ } @files;

	# test it!
	if ( scalar @files ) {
		fail( 'DOS-style newline detected in the distribution' );
		foreach my $f ( @files ) {
			diag( "DOS-style newline found in: $f" );
		}
	} else {
		pass( 'No files have DOS-style newline in it' );
	}

	return;
}

1;


__END__
=pod

=for Pod::Coverage do_test

=for stopwords dist

=head1 NAME

Test::Apocalypse::DOSnewline - Plugin to detect presence of DOS newlines

=head1 VERSION

  This document describes v1.000 of Test::Apocalypse::DOSnewline - released March 04, 2011 as part of Test-Apocalypse.

=head1 DESCRIPTION

This plugin detects the presence of DOS newlines in the dist.

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

