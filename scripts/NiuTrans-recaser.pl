##################################################################################
#
# NiuTrans - SMT platform
# Copyright (C) 2011, NEU-NLPLab (http://www.nlplab.com/). All rights reserved.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public
# License as published by the Free Software Foundation; either
# version 2 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public
# License along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA
#
##################################################################################

#######################################
#   version   : 1.2.0 Beta
#   Function  : Recaser
#   Author    : Qiang Li
#   Email     : liqiangneu@gmail.com
#   Date      : 01/24/2013
#   last Modified by :
#     2013/01/24 add "-opnull" selection by Qiang Li
#######################################


use strict;
use File::Copy;

my $logo =   "########### SCRIPT ########### SCRIPT ############ SCRIPT ##########\n".
             "#                                                                  #\n".
             "# NiuTrans Recaser (version 1.0.0 Beta )          --www.nlplab.com #\n".
             "#                                                                  #\n".
             "########### SCRIPT ########### SCRIPT ############ SCRIPT ##########\n";

print STDERR $logo;

my %param;
getParameter( @ARGV );
my $exec;
if( exists $param{ "-output" } )
{
        $exec = "../bin/NiuTrans.Decoder -decoding $param{ \"-test\" } -config $param{ \"-config\" } -output $param{ \"-output\" } -recasing";
}
else
{
        $exec = "../bin/NiuTrans.Decoder -decoding $param{ \"-test\" } -config $param{ \"-config\" } -recasing";
}

$exec = $exec." -outputoov $param{ \"-opnull\" } -nbest 1 -nthread $param{ \"-nthread\" }";

print STDERR $exec."\n";
ssystem( $exec );
unlink "decoding.log.txt",
       "lm.log.txt",
       "MERT.xt.log.txt",
       "mert.xt.result.txt",
       "MERT.zh.log.txt",
       "pattern.log";

sub getParameter
{
          if( ( scalar( @_ ) < 2 ) || ( scalar( @_ ) % 2 != 0 ) )
          {
                    print STDERR "[USAGE]       :\n".
                                 "           NiuTrans-recaser.pl                   [OPTIONS]\n".
                                 "[OPTION]      :\n".
                                 "    -config   :  Decoder Config File.\n".
                                 "    -test     :  Test data set.                  [optional]\n".
                                 "                    Default is Niu.test.txt set.\n".
                                 "    -output   :  Translation Result.             [optional]\n".
                                 "                    Default is \"STDOUT\" on current dir.\n".
                                 "    -opnull   :  Output OUT-OF-VOCABULARY.       [optional]\n".
                                 "                    If the value is 1, output OOV.\n".
                                 "                    Default value is 1.\n".
                                 "    -nthread  :  Number of threads.              [optional]\n".
                                 "                    Default value is 4.\n".
                                 "[EXAMPLE]  :\n".
                                 "         perl NiuTrans-recaser.pl              [-config FILE]\n".
                                 "                                               [-test   FILE]\n".
                                 "                                               [-output FILE]\n";
                    exit( 0 );
          }
          
          my $pos;
          for( $pos = 0; $pos < scalar( @_ ); ++$pos )
          {
                    my $key = $ARGV[ $pos ];
                    ++$pos;
                    my $value = $ARGV[ $pos ];
                    $param{ $key } = $value;
          }

          if( !exists $param{ "-l" } )
          {
                    $param{ "-l" } = "decoder-model.log";
          }

          if( !exists $param{ "-config" } )
          {
                    print STDERR "Error: please assign your decoder config file!\n";
                    exit( 1 );
          }

          if( !exists $param{ "-test" } )
          {
                    $param{ "-test" } = "../sample-data/sample-submission-version/Test-set/Niu.test.txt" ;
                    if( !(-e $param{ "-test" } ) )
                    {
                              print STDERR "$param{ \"-test\" } does not exist!\n";
                              exit( 1 );
                    }
          }
          if( !exists $param{ "-nthread" } )
          {
                    $param{ "-nthread" } = 4;
          }
          if( !exists $param{ "-opnull" } )
          {
                    $param{ "-opnull" } = 1;
          }
}

sub ssystem
{
          print STDERR "Running: @_\n";
          system( @_ );
          if( $? == -1 )
          {
                    print STDERR "Error: Failed to execute: @_\n  $!\n";
                    exit( 1 );
          }
          elsif( $? & 127 )
          {
                    printf STDERR "Error: Execution of: @_\n   die with signal %d, %s coredump\n",
                    ($? & 127 ), ( $? & 128 ) ? 'with' : 'without';
                    exit( 1 );
          }
          else
          {
                    my $exitcode = $? >> 8;
                    print STDERR "Exit code: $exitcode\n" if $exitcode;
                    return ! $exitcode;
          }         
}
