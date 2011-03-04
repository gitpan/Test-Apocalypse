#
# This file is part of Test-Apocalypse
#
# This software is copyright (c) 2011 by Apocalypse.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use strict; use warnings;
package Test::Apocalypse::CPANMeta_YAML;
BEGIN {
  $Test::Apocalypse::CPANMeta_YAML::VERSION = '1.000';
}
BEGIN {
  $Test::Apocalypse::CPANMeta_YAML::AUTHORITY = 'cpan:APOCAL';
}

# ABSTRACT: Plugin for Test::CPAN::Meta

use Test::CPAN::Meta::YAML 0.17;

sub do_test {
	meta_yaml_ok();

	return;
}

1;


__END__
=pod

=for Pod::Coverage do_test

=head1 NAME

Test::Apocalypse::CPANMeta_YAML - Plugin for Test::CPAN::Meta

=head1 VERSION

  This document describes v1.000 of Test::Apocalypse::CPANMeta_YAML - released March 04, 2011 as part of Test-Apocalypse.

=head1 DESCRIPTION

Encapsulates L<Test::CPAN::Meta::YAML> functionality.

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

