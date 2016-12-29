#
# Tcl for Altera Quartus2 Tool
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
package require ::quartus::project
package require ::quartus::flow

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
   if {$OPT == "" || ($OPT=="-tool" && $TOOL=="quartus2")} {
      set_global_assignment -name DEVICE $FPGA
   }
}

proc fpga_file {FILE {OPTION ""} {VALUE ""}} {
   if {$OPTION!="" && $OPTION!="-lib" && $OPTION!="-top"} {
      puts "Valid options for fpga_file command are -lib and -top."
      exit 1
   }
   regexp -nocase {\.(\w*)$} $FILE -> ext
   if {$ext == "v"} {
      set TYPE VERILOG_FILE
   } elseif {$ext == "sv"} {
      set TYPE SYSTEMVERILOG_FILE
   } else {
      set TYPE VHDL_FILE
   }
   if {$OPTION=="-lib"} {
      set_global_assignment -name $TYPE $FILE -library $VALUE
   } else {
      set_global_assignment -name $TYPE $FILE
   }
   if {$OPTION=="-top"} {
      set_global_assignment -name TOP_LEVEL_ENTITY $VALUE
   }
}

set FPGA_TOOL "quartus2"

###################################################################################################
# Main                                                                                            #
###################################################################################################

array set options [cmdLineParser "Altera Quartus2"]
set  RUN   $options(run)
set  OPT   $options(opt)

if { [ file exists quartus2.qpf ] } {file delete quartus2.qpf}
if { [ file exists quartus2.qsf ] } {file delete quartus2.qsf}

set project_file [glob -nocomplain *.qpf]

if { $project_file != "" } {
   puts "Using Quartus2 project ($project_file)"
   project_open -force $project_file
} else {
   puts "Creating a new project (quartus2.qpf)"
   project_new quartus2 -overwrite
   switch $OPT {
      "area"  {
         set_global_assignment -name OPTIMIZATION_MODE "AGGRESSIVE AREA"
         set_global_assignment -name OPTIMIZATION_TECHNIQUE AREA
      }
      "power" {
         set_global_assignment -name OPTIMIZATION_MODE "AGGRESSIVE POWER"
         set_global_assignment -name OPTIMIZE_POWER_DURING_SYNTHESIS "EXTRA EFFORT"
         set_global_assignment -name OPTIMIZE_POWER_DURING_FITTING "EXTRA EFFORT"
      }
      "speed" {
         set_global_assignment -name OPTIMIZATION_MODE "AGGRESSIVE PERFORMANCE"
         set_global_assignment -name OPTIMIZATION_TECHNIQUE SPEED
      }
   }
   if {[catch {source options.tcl} ERRMSG]} {
      puts "ERROR: something is wrong in options.tcl\n"
      puts $ERRMSG
      exit 1
   }
}

foreach_in_collection asgn_id [get_all_assignments -type global -name PROJECT_OUTPUT_DIRECTORY] {
   set ODIR [get_assignment_info $asgn_id -value]
}
if {![info exists ODIR]} {
   set ODIR .
}

if { $RUN=="syn" || $RUN=="imp" || $RUN=="bit" } {
   if {[catch {
      execute_module -tool map
   } ERRMSG]} {
      puts "ERROR: there was a problem running synthesis\n"
      puts $ERRMSG
      exit 1
   }
   if { [ file exists [glob -nocomplain $ODIR/*.map.rpt] ] } {
      file copy -force [glob -nocomplain $ODIR/*.map.rpt] quartus2_syn_$OPT.log
   }
}

if { $RUN=="imp" || $RUN=="bit" } {
   if {[catch {
      execute_module -tool fit
      execute_module -tool sta
   } ERRMSG]} {
      puts "ERROR: there was a problem running implementation\n"
      puts $ERRMSG
      exit 1
   }
   if { [ file exists [glob -nocomplain $ODIR/*.fit.rpt] ] } {
      file copy -force [glob -nocomplain $ODIR/*.fit.rpt] quartus2_imp_$OPT.log
   }
}

if { $RUN=="bit" } {
   if {[catch {
      execute_module -tool asm
   } ERRMSG]} {
      puts "ERROR: there was a problem generating the bitstream\n"
      puts $ERRMSG
      exit 1
   }
}

project_close

# Generated with FPGA Synt (FPGA Helpers) v0.1.1