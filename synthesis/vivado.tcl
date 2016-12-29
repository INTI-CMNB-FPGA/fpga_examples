#
# Tcl for Xilinx Vivado Tool
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

proc writeFile {PATH MODE DATA} {set fp [open $PATH $MODE];puts $fp $DATA;close $fp}

proc fpga_device {FPGA {OPT ""} {TOOL ""}} {
   if {$OPT == "" || ($OPT=="-tool" && $TOOL=="vivado")} {
      set_property "part" $FPGA [current_project]
   }
}

proc fpga_file {FILE {OPTION ""} {VALUE ""}} {
   if {$OPTION!="" && $OPTION!="-lib" && $OPTION!="-top"} {
      puts "Valid options for fpga_file command are -lib and -top."
      exit 1
   }
   add_files $FILE
   if {$OPTION=="-lib"} {
      set_property library $VALUE [get_files $FILE]
   }
   if {$OPTION=="-top"} {
      set_property top $VALUE [current_fileset]
   }
}

set FPGA_TOOL "vivado"

###################################################################################################
# Main                                                                                            #
###################################################################################################

array set options [cmdLineParser "Xilinx Vivado"]
set  RUN   $options(run)
set  OPT   $options(opt)

if { [ file exists vivado.xpr ] } {
   file delete vivado.xpr
}

set project_file [glob -nocomplain *.xpr]

if { $project_file != "" } {
   puts "Using Vivado project ($project_file)"
   open_project $project_file
} else {
   puts "Creating a new project (vivado.xpr)"
   create_project -force vivado
   switch $OPT {
      "area"  {
         set obj [get_runs synth_1]
         set_property strategy "Flow_AreaOptimized_high"                       $obj
         set_property "steps.synth_design.args.directive" "AreaOptimized_high" $obj
         set_property "steps.synth_design.args.control_set_opt_threshold" "1"  $obj

         set obj [get_runs impl_1]
         set_property strategy "Area_Explore"                                  $obj
         set_property "steps.opt_design.args.directive" "ExploreArea"          $obj
      }
      "power" {
         #enable power_opt_design and phys_opt_design
         set obj [get_runs synth_1]
         set_property strategy "Vivado Synthesis Defaults"                     $obj

         set obj [get_runs impl_1]
         set_property strategy "Power_DefaultOpt"                              $obj
         set_property "steps.power_opt_design.is_enabled" "1"                  $obj
         set_property "steps.phys_opt_design.is_enabled" "1"                   $obj
      }
      "speed" {
         #enable phys_opt_design
         set obj [get_runs synth_1]
         set_property strategy "Flow_PerfOptimized_high"                       $obj
         set_property "steps.synth_design.args.fanout_limit" "400"             $obj
         set_property "steps.synth_design.args.keep_equivalent_registers" "1"  $obj
         set_property "steps.synth_design.args.resource_sharing" "off"         $obj
         set_property "steps.synth_design.args.no_lc" "1"                      $obj
         set_property "steps.synth_design.args.shreg_min_size" "5"             $obj

         set obj [get_runs impl_1]
         set_property strategy "Performance_Explore"                           $obj
         set_property "steps.opt_design.args.directive" "Explore"              $obj
         set_property "steps.place_design.args.directive" "Explore"            $obj
         set_property "steps.phys_opt_design.is_enabled" "1"                   $obj
         set_property "steps.phys_opt_design.args.directive" "Explore"         $obj
         set_property "steps.route_design.args.directive" "Explore"            $obj
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
      reset_run synth_1
      launch_runs synth_1
      wait_on_run synth_1
      open_run synth_1
      set UTILIZATION [report_utilization -return_string]
      set TIMING [report_timing -return_string]
      writeFile vivado_syn_$OPT.log w $UTILIZATION
      writeFile vivado_syn_$OPT.log a $TIMING
   } ERRMSG]} {
      puts "ERROR: there was a problem running synthesis\n"
      puts $ERRMSG
      exit 1
   }
}

if { $RUN=="imp" || $RUN=="bit" } {
   if {[catch {
      launch_runs impl_1
      wait_on_run impl_1
      open_run impl_1
      report_io    -file io_imp.rpt
      report_power -file power_imp.rpt
      set UTILIZATION [report_utilization -return_string]
      set TIMING [report_timing -return_string]
      writeFile vivado_imp_$OPT.log w $UTILIZATION
      writeFile vivado_imp_$OPT.log a $TIMING
   } ERRMSG]} {
      puts "ERROR: there was a problem running implementation\n"
      puts $ERRMSG
      exit 1
   }
}

if {$RUN=="bit" } {
   if {[catch {
      launch_run impl_1 -to_step write_bitstream
      wait_on_run impl_1
   } ERRMSG]} {
      puts "ERROR: there was a problem generating the bitstream\n"
      puts $ERRMSG
      exit 1
   }
}

# Generated with FPGA Synt (FPGA Helpers) v0.1.1