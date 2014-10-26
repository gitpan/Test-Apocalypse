use strict;
use warnings;
use Test::More 0.88;
# This is a relatively nice way to avoid Test::NoWarnings breaking our
# expectations by adding extra tests, without using no_plan.  It also helps
# avoid any other test module that feels introducing random tests, or even
# test plans, is a nice idea.
our $success = 0;
END { $success && done_testing; }

my $v = "\n";

eval {                     # no excuses!
    # report our Perl details
    my $want = '5.006';
    my $pv = ($^V || $]);
    $v .= "perl: $pv (wanted $want) on $^O from $^X\n\n";
};
defined($@) and diag("$@");

# Now, our module version dependencies:
sub pmver {
    my ($module, $wanted) = @_;
    $wanted = " (want $wanted)";
    my $pmver;
    eval "require $module;";
    if ($@) {
        if ($@ =~ m/Can't locate .* in \@INC/) {
            $pmver = 'module not found.';
        } else {
            diag("${module}: $@");
            $pmver = 'died during require.';
        }
    } else {
        my $version;
        eval { $version = $module->VERSION; };
        if ($@) {
            diag("${module}: $@");
            $pmver = 'died during VERSION check.';
        } elsif (defined $version) {
            $pmver = "$version";
        } else {
            $pmver = '<undef>';
        }
    }

    # So, we should be good, right?
    return sprintf('%-45s => %-10s%-15s%s', $module, $pmver, $wanted, "\n");
}

eval { $v .= pmver('CPANPLUS','0.90') };
eval { $v .= pmver('CPANPLUS::Backend','any version') };
eval { $v .= pmver('CPANPLUS::Configure','any version') };
eval { $v .= pmver('Capture::Tiny','0.10') };
eval { $v .= pmver('Data::Dumper','any version') };
eval { $v .= pmver('Devel::PPPort','3.19') };
eval { $v .= pmver('Exporter','any version') };
eval { $v .= pmver('File::Find','any version') };
eval { $v .= pmver('File::Find::Rule','0.32') };
eval { $v .= pmver('File::Slurp','9999.13') };
eval { $v .= pmver('File::Spec','3.31') };
eval { $v .= pmver('File::Temp','any version') };
eval { $v .= pmver('File::Which','1.09') };
eval { $v .= pmver('JSON::Any','1.25') };
eval { $v .= pmver('Module::Build','0.3601') };
eval { $v .= pmver('Module::CPANTS::Analyse','0.85') };
eval { $v .= pmver('Module::CoreList','2.23') };
eval { $v .= pmver('Module::Pluggable','3.9') };
eval { $v .= pmver('Perl::Critic::Utils::Constants','any version') };
eval { $v .= pmver('Perl::Metrics::Simple','0.13') };
eval { $v .= pmver('Perl::PrereqScanner','1.000') };
eval { $v .= pmver('Pod::Coverage::TrustPod','0.092830') };
eval { $v .= pmver('Task::Perl::Critic','1.007') };
eval { $v .= pmver('Test::AutoLoader','0.03') };
eval { $v .= pmver('Test::Block','0.11') };
eval { $v .= pmver('Test::Builder','0.96') };
eval { $v .= pmver('Test::CPAN::Meta','0.18') };
eval { $v .= pmver('Test::CPAN::Meta::JSON','0.10') };
eval { $v .= pmver('Test::CPAN::Meta::YAML','0.17') };
eval { $v .= pmver('Test::CheckChanges','any version') };
eval { $v .= pmver('Test::Compile','0.11') };
eval { $v .= pmver('Test::ConsistentVersion','0.2.2') };
eval { $v .= pmver('Test::Deep','0.108') };
eval { $v .= pmver('Test::Dir','1.006') };
eval { $v .= pmver('Test::DistManifest','1.005') };
eval { $v .= pmver('Test::EOL','0.3') };
eval { $v .= pmver('Test::File','1.29') };
eval { $v .= pmver('Test::Fixme','0.04') };
eval { $v .= pmver('Test::HasVersion','0.012') };
eval { $v .= pmver('Test::MinimumVersion','0.101080') };
eval { $v .= pmver('Test::More','0.96') };
eval { $v .= pmver('Test::NoBreakpoints','0.13') };
eval { $v .= pmver('Test::NoPlan','0.0.6') };
eval { $v .= pmver('Test::Perl::Critic','1.02') };
eval { $v .= pmver('Test::Pod','1.41') };
eval { $v .= pmver('Test::Pod::Coverage','1.08') };
eval { $v .= pmver('Test::Pod::LinkCheck','0.004') };
eval { $v .= pmver('Test::Pod::No404s','0.01') };
eval { $v .= pmver('Test::Pod::Spelling::CommonMistakes','1.000') };
eval { $v .= pmver('Test::Portability::Files','any version') };
eval { $v .= pmver('Test::Script','1.07') };
eval { $v .= pmver('Test::Signature','1.10') };
eval { $v .= pmver('Test::Spelling','0.11') };
eval { $v .= pmver('Test::Strict','0.14') };
eval { $v .= pmver('Test::Synopsis','0.06') };
eval { $v .= pmver('Test::Vars','0.001') };
eval { $v .= pmver('YAML','0.70') };
eval { $v .= pmver('YAML::Any','0.72') };
eval { $v .= pmver('parent','any version') };
eval { $v .= pmver('version','0.77') };



# All done.
$v .= <<'EOT';

Thanks for using my code.  I hope it works for you.
If not, please try and include this output in the bug report.
That will help me reproduce the issue and solve you problem.

EOT

diag($v);
ok(1, "we really didn't test anything, just reporting data");
$success = 1;

# Work around another nasty module on CPAN. :/
no warnings 'once';
$Template::Test::NO_FLUSH = 1;
exit 0;
