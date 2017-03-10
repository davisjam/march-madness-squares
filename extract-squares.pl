#!/usr/bin/env perl

use strict;
use warnings;

my @files = @ARGV;
if (not @files) {
  die "Usage: $0 f1 f2 ...";
}

print STDERR "files <@files>\n";

my @squares = &getNewSquares(); 
my $numMatches = 0;
for my $f (@files) {
  my @matches = &getMatches($f);
  for my $match (@matches) {
    my $highSeedOnes = &onesPlace($match->{highSeedScore});
    my $lowSeedOnes = &onesPlace($match->{lowSeedScore});
    $squares[$highSeedOnes][$lowSeedOnes]++;
    $numMatches++;
  }
}

print STDERR "Analyzed a total of $numMatches matches\n";
&printSquares(\@squares, $numMatches);

exit 0;

################

# input: ($file)
# output: (@matches) list of hashrefs with keys: matchNum highSeed lowSeed highSeedScore lowSeedScore
sub getMatches {
  my ($f) = @_;
  my @lines = `cat $f`;
  chomp @lines;

  my @matches;

  my $nextMatchNum = 0;

  my $inFinals = 0;

  my %finalsIxs;
  $finalsIxs{HighSeed} = 0;
  $finalsIxs{HighSeedSchool} = 1;
  $finalsIxs{HighSeedScore} = 2;
  $finalsIxs{LowSeedScore} = 3;
  $finalsIxs{LowSeed} = 4;
  $finalsIxs{LowSeedSchool} = 5;

  my %normalIxs;
  $normalIxs{HighSeed} = 0;
  $normalIxs{HighSeedSchool} = 1;
  $normalIxs{HighSeedScore} = 2;
  $normalIxs{LowSeed} = 3;
  $normalIxs{LowSeedSchool} = 4;
  $normalIxs{LowSeedScore} = 5;

  my $inResult = 0;
  my @tmp;
  for my $l (@lines) {
    #print "l <$l>\n";
    if ($l =~ m/Championship/) {
      $inFinals = 1;
    }
    next if ($l =~ m/Logo/ or $l =~ m/Championship/ or $l =~ m/Four/);
    #print "kept l <$l>\n";
    # Load up @tmp
    if ($inResult) {
      push @tmp, $l;
    }
    # Once @tmp has 6 entries, interpret as @match
    if (scalar(@tmp) eq 6) {
      #print "tmp <@tmp>\n";
      my $ixs = $inFinals ? \%finalsIxs : \%normalIxs;
      my %match;
      $match{matchNum} = $nextMatchNum++;
      $match{highSeed} = int($tmp[$ixs->{HighSeed}]);
      $match{highSeedScore} = int($tmp[$ixs->{HighSeedScore}]);
      $match{lowSeed} = int($tmp[$ixs->{LowSeed}]);
      $match{lowSeedScore} = int($tmp[$ixs->{LowSeedScore}]);
      push @matches, \%match;

      $inResult = 0;
      $inFinals = 0;
      @tmp = ();
    }

    if ($l =~ m/^\s*Final\s*$/) {
      $inResult = 1;
    }
  }

  if ($inResult) {
    die "Error, while parsing. tmp <@tmp>";
  }

  return @matches;
}

# Initialize squares, a 10x10 
# $squares[higherSeed_onesPlace][lowerSeed_onesPlace] is the number of times this was the winning "square" across the tournament.
sub getNewSquares {
  my @squares;
  for my $i (0 .. 9) {
    for my $j (0 .. 9) {
      $squares[$i][$j] = 0;
    }
  }

  return @squares;
}

sub onesPlace {
  my ($num) = @_;
  return $num % 10;
}

sub printSquares {
  my ($squares, $expectedSum) = @_;
  my @squares = @$squares;

  my $sum = 0;
  for (my $i = 0; $i < 10; $i++) {
    for (my $j = 0; $j < 10; $j++) {
      my $val = $squares[$i][$j];
      print "squares[$i][$j] = $val\n";
      $sum += $val;
    }
  }

  die "sum $sum != expected $expectedSum" if ($sum != $expectedSum);
}
