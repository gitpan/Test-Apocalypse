#
# This file is part of Test-Apocalypse
#
# This software is copyright (c) 2011 by Apocalypse.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use strict; use warnings;
package Test::Apocalypse::PerlCritic;
BEGIN {
  $Test::Apocalypse::PerlCritic::VERSION = '1.001';
}
BEGIN {
  $Test::Apocalypse::PerlCritic::AUTHORITY = 'cpan:APOCAL';
}

# ABSTRACT: Plugin for Test::Perl::Critic

use Test::More;
use Test::Perl::Critic 1.02;
use File::Spec 3.31;

# This is so we always have all PerlCritic plugins installed, yay!
use Task::Perl::Critic 1.007;

sub _do_automated { 0 }

sub do_test {
	# set default opts
	require Perl::Critic::Utils::Constants;
	my %opts = (
		'-verbose' => 8, # sets "[%p] %m at line %l, column %c.  (Severity: %s)\n"
		'-severity' => 'brutal',
		'-profile-strictness' => $Perl::Critic::Utils::Constants::PROFILE_STRICTNESS_FATAL,
	);

	# Do we have a perlcriticrc?
	my $rcfile = File::Spec->catfile( 't', 'perlcriticrc' );
	my $default_rcfile; # did we generate a default?
	if ( ! -e $rcfile ) {
		# Maybe it's in the CWD?
		if ( ! -e 'perlcriticrc' ) {
			# Generate it using the default!
			if ( ! -d 't' ) {
				# We're already in the test dir
				$rcfile = 'perlcriticrc';
			}

			open( my $rc, '>', $rcfile ) or die "Unable to open $rcfile for writing: $!";
			print $rc _default_perlcriticrc();
			close $rc or die "Unable to close $rcfile: $!";
			$default_rcfile = 1;
		} else {
			$rcfile = 'perlcriticrc';
		}
	}
	Test::Perl::Critic->import( %opts, '-profile' => $rcfile );

	TODO: {
		local $TODO = "PerlCritic";
		all_critic_ok();
	}

	if ( $default_rcfile ) {
		unlink $rcfile or die "Unable to remove $rcfile: $!";
	}

	return;
}

sub _default_perlcriticrc {
	# Build a default file
	my $rcfile = <<'EOF';
# If you're wondering why there's a gazillion exclusions in here...
# It's because I installed every Perl::Critic policy there is ;)

# ---------------------------------------------
# Policies that is already covered by other tests in Test::Apocalypse
# ---------------------------------------------

[-Compatibility::PerlMinimumVersionAndWhy]
[-Modules::RequirePerlVersion]
# covered by MinimumVersion

[-Documentation::PodSpelling]
# covered by Pod_Spelling

# ---------------------------------------------
# editor/style stuff that is too strict
# ---------------------------------------------

[-Bangs::ProhibitCommentedOutCode]
[-Bangs::ProhibitFlagComments]
[-Bangs::ProhibitVagueNames]
[-CodeLayout::ProhibitHardTabs]
[-CodeLayout::ProhibitParensWithBuiltins]
[-CodeLayout::RequireTidyCode]
[-CodeLayout::RequireUseUTF8]
[-Documentation::RequirePodLinksIncludeText]
[-Documentation::RequirePODUseEncodingUTF8]
[-Editor::RequireEmacsFileVariables]
[-Miscellanea::RequireRcsKeywords]
[-NamingConventions::Capitalization]
[-NamingConventions::ProhibitMixedCaseVars]
[-Subroutines::ProhibitExcessComplexity]
[-Tics::ProhibitLongLines]
[-ValuesAndExpressions::ProhibitMagicNumbers]
[-ValuesAndExpressions::ProhibitNoisyQuotes]


# ---------------------------------------------
# miscellaneous policies that is just plain annoying
# ---------------------------------------------

[-BuiltinFunctions::ProhibitStringyEval]
[-BuiltinFunctions::ProhibitStringySplit]
[-Compatibility::ProhibitThreeArgumentOpen]
[-ControlStructures::ProhibitPostfixControls]
[-ControlStructures::ProhibitCascadingIfElse]
[-ErrorHandling::RequireCarping]
[-ErrorHandling::RequireCheckingReturnValueOfEval]
[-ErrorHandling::RequireUseOfExceptions]
[-InputOutput::RequireBracedFileHandleWithPrint]
[-InputOutput::RequireCheckedSyscalls]
[-Lax::ProhibitEmptyQuotes::ExceptAsFallback]
[-Lax::ProhibitStringyEval::ExceptForRequire]
[-Miscellanea::ProhibitTies]
[-Modules::ProhibitAutomaticExportation]
[-Modules::RequireExplicitPackage]
[-NamingConventions::ProhibitMixedCaseSubs]
[-References::ProhibitDoubleSigils]
[-RegularExpressions::ProhibitEscapedMetacharacters]
[-RegularExpressions::ProhibitFixedStringMatches]
[-RegularExpressions::RequireDotMatchAnything]
[-RegularExpressions::RequireExtendedFormatting]
[-RegularExpressions::RequireLineBoundaryMatching]
[-Subroutines::ProhibitCallsToUndeclaredSubs]
[-Subroutines::ProhibitCallsToUnexportedSubs]
[-Subroutines::ProhibitManyArgs]
[-Subroutines::ProhibitUnusedPrivateSubroutines]
[-Subroutines::ProtectPrivateSubs]
[-Subroutines::RequireArgUnpacking]
[-Subroutines::RequireFinalReturn]
[-TestingAndDebugging::ProhibitNoStrict]
[-TestingAndDebugging::ProhibitNoWarnings]
[-ValuesAndExpressions::ProhibitAccessOfPrivateData]
[-ValuesAndExpressions::ProhibitCommaSeparatedStatements]
[-ValuesAndExpressions::ProhibitEmptyQuotes]
[-ValuesAndExpressions::ProhibitFiletest_f]
[-ValuesAndExpressions::ProhibitInterpolationOfLiterals]
[-ValuesAndExpressions::RequireInterpolationOfMetachars]
[-Variables::ProhibitLocalVars]
[-Variables::ProhibitPunctuationVars]
[-Variables::RequireInitializationForLocalVars]

# ---------------------------------------------
# TODO probably sane policies but need to do a lot of work to fix them...
# ---------------------------------------------

[-CodeLayout::ProhibitHashBarewords]
# sometimes we're lazy!

[-Compatibility::PodMinimumVersion]
# there should be a Test::Apocalypse check for that!

[-ControlStructures::ProhibitUnlessBlocks]
# it's so easy to be lazy!

[-Documentation::RequirePodSections]
# what is the "default" list? Obviously not PBP because it requires way too much sections!

[-Miscellanea::ProhibitUselessNoCritic]
# I don't want to go through my old code and clean them up... laziness again!

[-Modules::RequireExplicitInclusion]
# while this makes sense sometimes it's a drag to list the modules that you *know* a prereq will pull in...

[-RegularExpressions::ProhibitUnusualDelimiters]
# sometimes we like other delims...

[-ValuesAndExpressions::ProhibitMixedBooleanOperators]
# sometimes it feels "natural" to code in that style...

[-ValuesAndExpressions::ProhibitVersionStrings]
# is this really a problem? If so, it's still a lot of work to go through code and figure out the proper string...

EOF

	return $rcfile;
}

1;


__END__
=pod

=for :stopwords Apocalypse

=encoding utf-8

=for Pod::Coverage do_test

=head1 NAME

Test::Apocalypse::PerlCritic - Plugin for Test::Perl::Critic

=head1 VERSION

  This document describes v1.001 of Test::Apocalypse::PerlCritic - released March 08, 2011 as part of Test-Apocalypse.

=head1 DESCRIPTION

Encapsulates L<Test::Perl::Critic> functionality.

Automatically sets the following options:

	-verbose => 8,
	-severity => 'brutal',
	-profile => 't/perlcriticrc',
	-profile-strictness => 'fatal',

If the C<t/perlcriticrc> file isn't present a default one will be generated and used. Please see the source of this module
for the default config, it is too lengthy to copy and paste into this POD! If you want to override the critic options,
please create your own C<t/perlcriticrc> file in the distribution!

=head1 SEE ALSO

Please see those modules/websites for more information related to this module.

=over 4

=item *

L<Test::Apocalypse|Test::Apocalypse>

=item *

L<Perl::Critic|Perl::Critic>

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

