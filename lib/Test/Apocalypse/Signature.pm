# Declare our package
package Test::Apocalypse::Signature;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.03';

# setup our tests and etc
use Test::More;
use Test::Signature;

# does our stuff!
sub do_test {
	plan tests => 1;

	# do we have a signature file?
	SKIP: {
		if ( -e 'SIGNATURE' ) {
			signature_ok();
		} else {
			skip( 'no SIGNATURE file found', 1 );
		}
	}

	return;
}

1;
__END__
=head1 NAME

Test::Apocalypse::Signature - Plugin for Test::Signature

=head1 SYNOPSIS

	Please do not use this module directly.

=head1 ABSTRACT

Encapsulates Test::Signature functionality.

=head1 DESCRIPTION

Encapsulates Test::Signature functionality.

=head1 EXPORT

None.

=head1 SEE ALSO

L<Test::Apocalypse>

L<Test::Signature>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
