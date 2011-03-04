
use strict;
use warnings;

BEGIN { require 5.008; }

use ExtUtils::MakeMaker 6.31;



my %WriteMakefileArgs = (
  'ABSTRACT' => 'Apocalypse\'s favorite tests bundled into a simple interface',
  'AUTHOR' => 'Apocalypse <APOCAL@cpan.org>',
  'BUILD_REQUIRES' => {
    'File::Find' => '0',
    'File::Temp' => '0',
    'ExtUtils::MakeMaker' => '6.31'
  },
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.31'
  },
  'DISTNAME' => 'Test-Apocalypse',
  'EXE_FILES' => [],
  'LICENSE' => 'perl',
  'NAME' => 'Test::Apocalypse',
  'PREREQ_PM' => {
    'CPANPLUS' => '0.90',
    'CPANPLUS::Backend' => '0',
    'CPANPLUS::Configure' => '0',
    'Capture::Tiny' => '0.10',
    'Data::Dumper' => '0',
    'Devel::PPPort' => '3.19',
    'Exporter' => '0',
    'File::Find::Rule' => '0.32',
    'File::Slurp' => '9999.13',
    'File::Spec' => '3.31',
    'File::Which' => '1.09',
    'JSON::Any' => '1.25',
    'Module::CPANTS::Analyse' => '0.85',
    'Module::CoreList' => '2.23',
    'Module::Pluggable' => '3.9',
    'Perl::Critic::Utils::Constants' => '0',
    'Perl::Metrics::Simple' => '0.13',
    'Perl::PrereqScanner' => '1.000',
    'Pod::Coverage::TrustPod' => '0.092830',
    'Task::Perl::Critic' => '1.007',
    'Test::AutoLoader' => '0.03',
    'Test::Block' => '0.11',
    'Test::Builder' => '0.96',
    'Test::CPAN::Meta' => '0.18',
    'Test::CPAN::Meta::JSON' => '0.10',
    'Test::CPAN::Meta::YAML' => '0.17',
    'Test::CheckChanges' => '0',
    'Test::Compile' => '0.11',
    'Test::ConsistentVersion' => '0.2.2',
    'Test::Deep' => '0.108',
    'Test::Dir' => '1.006',
    'Test::DistManifest' => '1.005',
    'Test::EOL' => '0.3',
    'Test::File' => '1.29',
    'Test::Fixme' => '0.04',
    'Test::HasVersion' => '0.012',
    'Test::MinimumVersion' => '0.101080',
    'Test::More' => '0.96',
    'Test::NoBreakpoints' => '0.13',
    'Test::NoPlan' => '0.0.6',
    'Test::Perl::Critic' => '1.02',
    'Test::Pod' => '1.41',
    'Test::Pod::Coverage' => '1.08',
    'Test::Pod::LinkCheck' => '0.004',
    'Test::Pod::No404s' => '0.01',
    'Test::Pod::Spelling::CommonMistakes' => '1.000',
    'Test::Portability::Files' => '0',
    'Test::Script' => '1.07',
    'Test::Signature' => '1.10',
    'Test::Spelling' => '0.11',
    'Test::Strict' => '0.14',
    'Test::Synopsis' => '0.06',
    'Test::Vars' => '0.001',
    'YAML' => '0.70',
    'YAML::Any' => '0.72',
    'version' => '0.77'
  },
  'VERSION' => '1.000',
  'test' => {
    'TESTS' => 't/*.t'
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



