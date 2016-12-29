#
# Tcl for Xilinx ISE Tool
# Copyright (C) 2016 INTI, Rodrigo A. Melo <rmelo@inti.gob.ar>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

package require cmdline

###################################################################################################
# Functions                                                                                       #
###################################################################################################

proc cmdLineParser {TOOL} {

   set parameters {
       {run.arg  "syn"    "What to RUN  [syn, imp, bit]"}
       {opt.arg  "user"   "OPTimization [user, area, power, speed]"}
   }

   set usage "- A Tcl script to synthesise with $TOOL Tool"
   if {[catch {array set options [cmdline::getoptions ::argv $parameters $usage]}]} {
      puts [cmdline::usage $parameters $usage]
      exit 1
   }

   set ERROR ""

   if {$options(run)!="syn" && $options(run)!="imp" && $options(run)!="bit"} {
      append ERROR "<$options(run)> is not a supported RUN option.\n"
   }

   if {$options(opt)!="user" && $options(opt)!="area" && $options(opt)!="power" && $options(opt)!="speed"} {
      append ERROR "<$options(opt)> is not a supported OPTimization.\n"
   }

   if {$ERROR != ""} {
      puts $ERROR
      puts "Use -help to see available options."
      exit 1
   }

   return [array get options]
 }

proc fpga_device {FPGA {OPT ""} {TOOL ""}} {
   if {$OPT == "" || ($OPT=="-tool" && $TOOL=="ise")} {
      regexp -nocase {(.*)(-.*)-(.*)} $FPGA -> device speed package
      set family "Unknown"
      if {[regexp -nocase {xc7a\d+l} $device]} {
         set family "artix7l"
      } elseif {[regexp -nocase {xc7a} $device]} {
         set family "artix7"
      } elseif {[regexp -nocase {xc7k\d+l} $device]} {
         set family "kintex7l"
      } elseif {[regexp -nocase {xc7k} $device]} {
         set family "kintex7"
      } elseif {[regexp -nocase {xc3sd\d+a} $device]} {
         set family "spartan3adsp"
      } elseif {[regexp -nocase {xc3s\d+a} $device]} {
         set family "spartan3a"
      } elseif {[regexp -nocase {xc3s\d+e} $device]} {
         set family "spartan3e"
      } elseif {[regexp -nocase {xc3s} $device]} {
         set family "spartan3"
      } elseif {[regexp -nocase {xc6s\d+l} $device]} {
         set family "spartan6l"
      } elseif {[regexp -nocase {xc6s} $device]} {
         set family "spartan6"
      } elseif {[regexp -nocase {xc4v} $device]} {
         set family "virtex4"
      } elseif {[regexp -nocase {xc5v} $device]} {
         set family "virtex5"
      } elseif {[regexp -nocase {xc6v\d+l} $device]} {
         set family "virtex6l"
      } elseif {[regexp -nocase {xc6v} $device]} {
         set family "virtex6"
      } elseif {[regexp -nocase {xc7v\d+l} $device]} {
         set family "virtex7l"
      } elseif {[regexp -nocase {xc7v} $device]} {
         set family "virtex7"
      } elseif {[regexp -nocase {xc7z} $device]} {
         set family "zynq"
      } else {
         puts "Family $family not supported."
         exit 1
      }
      project set family  $family
      project set device  $device
      project set package $package
      project set speed   $speed
   }
}

proc fpga_file {FILE {OPTION ""} {VALUE ""}} {
   if {$OPTION!="" && $OPTION!="-lib" && $OPTION!="-top"} {
      puts "Valid options for fpga_file command are -lib and -top."
      exit 1
   }
   if {$OPTION=="-lib"} {
      lib_vhdl new $VALUE
      xfile add $FILE -lib_vhdl $VALUE
   } else {
      xfile add $FILE
   }
   if {$OPTION=="-top"} {
      project set top $VALUE
   }
}

set FPGA_TOOL "ise"

###################################################################################################
# Main                                                                                            #
###################################################################################################

array set options [cmdLineParser "Xilinx ISE"]
set  RUN   $options(run)
set  OPT   $options(opt)

if { [ file exists ise.xise ] } {
   file delete ise.xise
}

set project_file [glob -nocomplain *.xise]

if { $project_file != "" && $project_file != "ise.xise" } {
   puts "Using ISE project ($project_file)"
   project open $project_file
} else {
   puts "Creating a new project (ise.xise)"
   project new ise.xise
   switch $OPT {
      "area"  {
         project set "Optimization Goal" "Area"
      }
      "power" {
         project set "Optimization Goal" "Area"
         project set "Power Reduction"   "true" -process "Synthesize - XST"
         project set "Power Reduction"   "high" -process "Map"
         project set "Power Reduction"   "true" -process "Place & Route"
      }
      "speed" {
         project set "Optimization Goal" "Speed"
      }
   }
   if {[catch {source options.tcl} ERRMSG]} {
      puts "ERROR: something is wrong in options.tcl\n"
      puts $ERRMSG
      exit 1
   }
}

if { $RUN=="syn" || $RUN=="imp" || $RUN=="bit" } {
   if {[catch {
      process run "Synthesize"    -force rerun
   } ERRMSG]} {
      puts "ERROR: there was a problem running synthesis\n"
      puts $ERRMSG
      exit 1
   }
   if { [ file exists [glob -nocomplain *.syr] ] } {
      file copy -force [glob -nocomplain *.syr] ise_syn_$OPT.log
   }
}

if { $RUN=="imp" || $RUN=="bit" } {
   if {[catch {
      process run "Translate"     -force rerun
      process run "Map"           -force rerun
      process run "Place & Route" -force rerun
   } ERRMSG]} {
      puts "ERROR: there was a problem running implementation\n"
      puts $ERRMSG
      exit 1
   }
   if { [ file exists [glob -nocomplain *.par] ] } {
      file copy -force [glob -nocomplain *.par] ise_imp_$OPT.log
   }
}

if { $RUN=="bit" } {
   if {[catch {
      process run "Generate Programming File" -force rerun
   } ERRMSG]} {
      puts "ERROR: there was a problem generating the bitstream\n"
      puts $ERRMSG
      exit 1
   }
}

# Generated with FPGA Synt (FPGA Helpers) v0.1.1