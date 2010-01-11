# Declare our package
package Test::Apocalypse::Distribution;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.06';

use Test::More;

sub do_test {
	my %MODULES = (
		'Test::Distribution'	=> '2.00',
	);

	while (my ($module, $version) = each %MODULES) {
		eval "use $module $version ()";	## no critic ( ProhibitStringyEval )
		next unless $@;

		if ( $ENV{RELEASE_TESTING} ) {
			die 'Could not load release-testing module ' . $module . " -> $@";
		} else {
			plan skip_all => $module . ' not available for testing';
		}
	}

	# Run the test!
	# we ignore podcover because we already have a plugin for it...
	Test::Distribution->import( not => 'podcover', distversion => 1 );

	return;
}

1;
__END__

=for stopwords distversion podcover

=head1 NAME

Test::Apocalypse::Distribution - Plugin for Test::Distribution

=head1 SYNOPSIS

	die "Don't use this module directly. Please use Test::Apocalypse instead.";

=head1 ABSTRACT

Encapsulates Test::Distribution functionality.

=head1 DESCRIPTION

Encapsulates Test::Distribution functionality. We disable the podcover test, as we already have a plugin for that. Also, we enable the
distversion test.

=head2 do_test()

The main entry point for this plugin. Automatically called by L<Test::Apocalypse>, you don't need to know anything more :)

=head1 SEE ALSO

L<Test::Apocalypse>

L<Test::Distribution>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
