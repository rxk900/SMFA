#!/usr/bin/perl
# this is the runlist program

$job=$ARGV[0];

chomp($job);
$job=~ s/^\s+|\s+$//g;
$job1=$job;
$list=$ARGV[1];
chomp($list);
$list=~ s/^\s+|\s+$//g;

$num=$ARGV[2];
chomp($num);
$num=~ s/^\s+|\s+$//g;

system("rmdir flagdr 2> /dev/null");
open(RUN,">>RUNNING");
$sl=$num/100;

print RUN "$job\n";

@line=split("IN",$list);
$fin=$line[1];
$out="OUT$fin";

open(DON,">>$out");

$package =`awk 'NR==1,NR==1 {print \$0}' IN_PACKAGE`;
chomp($package);


if ($package == 1) {
$nproc0=1;
@line=split(".com",$job);
$stem=$line[0];
$old=`grep $stem.log $out | wc -l`;
chomp($old);
$old=~ s/^\s+|\s+$//g;
if ( $old == 0 ) {
#$junk=`/short/s01/gamess/rungms $stem.inp serial  > $stem.log`;
$junk=`rungms $stem.inp $nproc0  > $stem.log`;
#system("rungms $stem.inp $nproc0  > $stem.log");
 $ok=`grep 'TERMINATED NORMALLY' $stem.log | wc -l`;
 chomp($ok);
 $ok=~ s/^\s+|\s+$//g;
 if ( $ok == 0 ) {
  open(TMP,">>OUT_SMFA");
  print TMP "calculation may have failed for $stem.inp\n";
  close TMP;
 }else{
  print DON "$stem.log\n";
 }
}


$go=0;
$end=1;
while ($go < $end ) {
RETRY:
system("mkdir flagdr 2> /dev/null");
if( $? > 8 ) {
system("sleep 0.028");
goto RETRY;
}else{
system("sed -i.$num '1d' $list");
system("rmdir flagdr 2> /dev/null");
}
$job =`awk 'NR==1,NR==1 {print \$1}' $list.$num`;
chomp($job);
$job=~ s/^\s+|\s+$//g;
 if ( "$job" eq "" ) {
  $go=2;
  last;
 }
 @line=split(".com",$job);
 $stem=$line[0];
 chomp($stem);
 $stem=~ s/^\s+|\s+$//g;
 $old=`grep $stem.log $out | wc -l`;
 chomp($old);
 $old=~ s/^\s+|\s+$//g;
 $thisone=`grep $job RUNNING | wc -l`;
 chomp($thisone);
 $thisone=~ s/^\s+|\s+$//g;
 if ( $thisone == 0 && $old == 0 ) {
  print RUN "$job\n";
#$junk=`/short/s01/gamess/rungms $stem.inp serial  > $stem.log`;
$junk=`rungms $stem.inp $nproc0  > $stem.log`;
#  system("rungms $stem.inp $nproc0  > $stem.log");
  $ok=`grep 'TERMINATED NORMALLY' $stem.log | wc -l`;
  chomp($ok);
  $ok=~ s/^\s+|\s+$//g;
  if ( $ok == 0 ) {
   open(TMP,">>OUT_SMFA");
   print TMP "calculation may have failed for $stem.inp\n";
   close TMP;
  }else{
   print DON "$stem.log\n";
  }
 }
 }
# end gamess
}


if ($package == 2) {
$nproc0=1;
@line=split(".com",$job);
$stem=$line[0];
$old=`grep $stem.log $out | wc -l`;
chomp($old);
$old=~ s/^\s+|\s+$//g;
if ( $old == 0 ) {
$junk=`g09 < $job > $stem.log`;
# system("g09 < $job > $stem.log");
 $ok=`grep 'Normal termination' $stem.log | wc -l`;
 chomp($ok);
 $ok=~ s/^\s+|\s+$//g;
 if ( $ok == 0 ) {
  open(TMP,">>OUT_SMFA");
  print TMP "calculation may have failed for $stem.com\n";
  close TMP;
 }else{
  print DON "$stem.log\n";
 }
 if( -s "$stem.chk") {
$junk=`formchk $stem.chk $stem.fchk`;
#  system("formchk $stem.chk $stem.fchk");
  system("echo $stem.fchk >> FCHKLIST");
 }
}


$go=0;
$end=1;
while ($go < $end ) {
RETRY:
system("mkdir flagdr 2> /dev/null");
if( $? > 8 ) {
system("sleep 0.028");
goto RETRY;
}else{
system("sed -i.$num '1d' $list");
system("rmdir flagdr 2> /dev/null");
}
$job =`awk 'NR==1,NR==1 {print \$1}' $list.$num`;
chomp($job);
$job=~ s/^\s+|\s+$//g;
 if ( "$job" eq "" ) {
  $go=2;
  last;
 }
 @line=split(".com",$job);
 $stem=$line[0];
 chomp($stem);
 $stem=~ s/^\s+|\s+$//g;
 $old=`grep $stem.log $out | wc -l`;
 chomp($old);
 $old=~ s/^\s+|\s+$//g;
$thisone=`grep $job RUNNING | wc -l`;
chomp($thisone);
$thisone=~ s/^\s+|\s+$//g;
if ( $thisone == 0 && $old == 0 ) {
print RUN "$job\n";
$junk=`g09 < $job > $stem.log`;
#  system("g09 < $job > $stem.log");
  $ok=`grep 'Normal termination' $stem.log | wc -l`;
  chomp($ok);
  $ok=~ s/^\s+|\s+$//g;
  if ( $ok == 0 ) {
   open(TMP,">>OUT_SMFA");
   print TMP "calculation may have failed for $stem.com\n";
   close TMP;
  }else{
   print DON "$stem.log\n";
  }
  if( -s "$stem.chk") {
  $junk=`formchk $stem.chk $stem.fchk`;
#   system("formchk $stem.chk $stem.fchk");
   system("echo $stem.fchk >> FCHKLIST");
  }

 }
 }
# end GAUSSIAN
}

if ($package == 3) {
$nproc0=1;
@line=split(".com",$job);
$stem=$line[0];
$old=`grep $stem.log $out | wc -l`;
chomp($old);
$old=~ s/^\s+|\s+$//g;
if ( $old == 0 ) {
$junk=`nwchem $stem.nw > $stem.log`;
# system("nwchem $stem.nw > $stem.log");
 $ok=`grep 'CITATION' $stem.log | wc -l`;
 chomp($ok);
 $ok=~ s/^\s+|\s+$//g;
 if ( $ok == 0 ) {
  open(TMP,">>OUT_SMFA");
  print TMP "calculation may have failed for $stem.nw\n";
  close TMP;
 }else{
 print DON "$stem.log\n";
 }
}

$go=0;
$end=1;
while ($go < $end ) {
RETRY:
system("mkdir flagdr 2> /dev/null"); 
if( $? > 8 ) {
system("sleep 0.028");
goto RETRY;
}else{
system("sed -i.$num '1d' $list");
system("rmdir flagdr 2> /dev/null");
}
$job =`awk 'NR==1,NR==1 {print \$1}' $list.$num`;
chomp($job);
$job=~ s/^\s+|\s+$//g;
 if ( "$job" eq "" ) {
  $go=2;
  last;
 }
 @line=split(".com",$job);
 $stem=$line[0];
 chomp($stem);
 $stem=~ s/^\s+|\s+$//g;
 $old=`grep $stem.log $out | wc -l`;
 chomp($old);
 $old=~ s/^\s+|\s+$//g;
 $thisone=`grep $job RUNNING | wc -l`;
 chomp($thisone);
 $thisone=~ s/^\s+|\s+$//g;
 if ( $thisone == 0 && $old == 0 ) {
  print RUN "$job\n";
$junk=`nwchem $stem.nw > $stem.log`;
#  system("nwchem $stem.nw > $stem.log");
  $ok=`grep 'CITATION' $stem.log | wc -l`;
  chomp($ok);
  $ok=~ s/^\s+|\s+$//g;
  if ( $ok == 0 ) {
   open(TMP,">>OUT_SMFA");
   print TMP "calculation may have failed for $stem.nw\n";
   close TMP;
  }else{
  print DON "$stem.log\n";
  }
 }
 }
# end nwc
}

if ($package == 4) {
$nproc0=1;
@line=split(".com",$job);
$stem=$line[0];
$old=`grep $stem.log $out | wc -l`;
chomp($old);
$old=~ s/^\s+|\s+$//g;
if ( $old == 0 ) {
# system("qchem -nt $nproc0 $job $stem.log 2> /dev/null");
$junk=`qchem -nt $nproc0 $job $stem.log 2> /dev/null`;
#&timeload("$num","$stem.log");
 $ok=`grep 'Have a nice day' $stem.log | wc -l`;
 chomp($ok);
 $ok=~ s/^\s+|\s+$//g;
 if ( $ok == 0 ) {
  open(TMP,">>OUT_SMFA");
  print TMP "calculation may have failed for $stem.com\n";
  close TMP;
 }else{
 print DON "$stem.log\n";
 }
 if( -s "$stem.chk") {
  system("echo $stem.fchk >> FCHKLIST");
 }
}

$go=0;
$end=1;
while ($go < $end ) {
RETRY:
system("mkdir flagdr 2> /dev/null"); 
if( $? > 8 ) {
system("sleep 0.028");
goto RETRY;
}else{
system("sed -i.$num '1d' $list");
system("rmdir flagdr 2> /dev/null");
}
$job =`awk 'NR==1,NR==1 {print \$1}' $list.$num`;
chomp($job);
$job=~ s/^\s+|\s+$//g;
 if ( "$job" eq "" ) {
  $go=2;
  last;
 }
 @line=split(".com",$job);
 $stem=$line[0];
 chomp($stem);
 $stem=~ s/^\s+|\s+$//g;
 $old=`grep $stem.log $out | wc -l`;
 chomp($old);
 $old=~ s/^\s+|\s+$//g;
 $thisone=`grep $job RUNNING | wc -l`;
 chomp($thisone);
 $thisone=~ s/^\s+|\s+$//g;
 if ( $thisone == 0 && $old == 0 ) {
  print RUN "$job\n";
#  system("qchem -nt $nproc0 $job $stem.log 2> /dev/null");
$junk=`qchem -nt $nproc0 $job $stem.log 2> /dev/null`;
#&timeload("$num","$stem.log");
  $ok=`grep 'Have a nice day' $stem.log | wc -l`;
  chomp($ok);
  $ok=~ s/^\s+|\s+$//g;
  if ( $ok == 0 ) {
   open(TMP,">>OUT_SMFA");
   print TMP "calculation may have failed for $stem.com\n";
   close TMP;
  }else{
  print DON "$stem.log\n";
  }
  if( -s "$stem.chk") {
   system("echo $stem.fchk >> FCHKLIST");
  }

 }
 }
# end qchem
}


sub timeload {
$num=@_[0];
$logfile=@_[1];

if ($package == 4) {
$timeline=`awk '/Total job time/ {print \$4}' $logfile`;
chomp($timeline);
$timeline=~ s/s\(wall\),//;
system("echo '$num      $timeline' >> TIMELOADING");
}


}


