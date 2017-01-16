#
# Tcl for Microsemi Libero-SoC
# Copyright (C) 2017 INTI, Rodrigo A. Melo <rmelo@inti.gob.ar>
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

#package require cmdline # Not supported by libero?

###################################################################################################
# Functions                                                                                       #
###################################################################################################

proc cmdLineParser {TOOL} {

   #set parameters {
   #    {task.arg "syn"    "TASK         [syn, imp, bit]"}
   #    {opt.arg  "user"   "OPTimization [user, area, power, speed]"}
   #}

   #set usage "- A Tcl script to synthesise with $TOOL Tool"
   #if {[catch {array set options [cmdline::getoptions ::argv $parameters $usage]}]} {
   #   puts [cmdline::usage $parameters $usage]
   #   exit 1
   #}

   set options(task) [expr {[lindex $::argv 1] eq "" ? "syn"  : [lindex $::argv 1]}]
   set options(opt)  [expr {[lindex $::argv 3] eq "" ? "user" : [lindex $::argv 3]}]

   set ERROR ""

   if {$options(task)!="syn" && $options(task)!="imp" && $options(task)!="bit"} {
      append ERROR "<$options(task)> is not a supported TASK option.\n"
   }

   if {$options(opt)!="user" && $options(opt)!="area" && $options(opt)!="power" && $options(opt)!="speed"} {
      append ERROR "<$options(opt)> is not a supported OPTimization.\n"
   }

   if {$ERROR != ""} {
      puts $ERROR
      # puts "Use -help to see available options."
      exit 1
   }

   return [array get options]
}

#proc writeFile {PATH MODE DATA} {set fp [open $PATH $MODE];puts $fp $DATA;close $fp}

proc fpga_device {FPGA {OPT ""} {TOOL ""}} {
   if {$OPT == "" || ($OPT=="-tool" && $TOOL=="libero-soc")} {
      regexp -nocase {(.*)(-.*)-(.*)} $FPGA -> device speed package
      set family "Unknown"
      if {[regexp -nocase {m2s} $device]} {
         set family "SmartFusion2"
      } elseif {[regexp -nocase {m2gl} $device]} {
         set family "Igloo2"
      } elseif {[regexp -nocase {rt4g} $device]} {
         set family "RTG4"
      } elseif {[regexp -nocase {a2f} $device]} {
         set family "SmartFusion"
      } elseif {[regexp -nocase {afs} $device]} {
         set family "Fusion"
      } elseif {[regexp -nocase {aglp} $device]} {
         set family "IGLOO+"
      } elseif {[regexp -nocase {agle} $device]} {
         set family "IGLOOE"
      } elseif {[regexp -nocase {agl} $device]} {
         set family "IGLOO"
      } elseif {[regexp -nocase {a3p\d+l} $device]} {
         set family "ProAsic3L"
      } elseif {[regexp -nocase {a3pe} $device]} {
         set family "ProAsic3E"
      } elseif {[regexp -nocase {a3p} $device]} {
         set family "ProAsic3"
      } else {
         puts "Family $family not supported."
         exit 1
      }
      set_device -family $family -die $device -package $package -speed $speed
   }
}

proc fpga_file {FILE {OPTION ""} {VALUE ""}} {
   if {$OPTION!="" && $OPTION!="-lib" && $OPTION!="-top"} {
      puts "Valid options for fpga_file command are -lib and -top."
      exit 1
   }
   regexp -nocase {\.(\w*)$} $FILE -> ext
   if {$ext == "pdc"} {
      create_links -io_pdc $FILE
      organize_tool_files -tool {PLACEROUTE} -file $FILE -input_type {constraint}
   } elseif {$ext == "sdc"} {
      create_links -sdc $FILE
      organize_tool_files -tool {SYNTHESIZE} -file $FILE -input_type {constraint} 
      organize_tool_files -tool {VERIFYTIMING} -file $FILE -input_type {constraint}
   } else {
      create_links -hdl_source $FILE
   }
   if {$OPTION=="-lib"} {
      add_library -library $VALUE
      add_file_to_library -library $VALUE -file $FILE
   }
   if {$OPTION=="-top"} {
      set_root $VALUE
   }
}

set FPGA_TOOL "libero-soc"

proc do_syn {OPT} {
   #run_tool -name {SYNTHESIZE}
   run_tool -name {COMPILE}
   if { [ file exists [glob -nocomplain libero-soc/synthesis/*.srr] ] } {
      file copy -force [glob -nocomplain libero-soc/synthesis/*.srr] libero-soc_syn_$OPT.log
   }
}

proc do_imp {OPT} {
   run_tool -name {PLACEROUTE}
   run_tool -name {VERIFYTIMING}
   if { [ file exists [glob -nocomplain libero-soc/designer/*/*_layout_log.log] ] } {
      file copy -force [glob -nocomplain libero-soc/designer/*/*_layout_log.log] libero-soc_imp_$OPT.log
   }
}

proc do_bit {} {
   run_tool -name {GENERATEPROGRAMMINGFILE}
}

###################################################################################################
# Main                                                                                            #
###################################################################################################

array set options [cmdLineParser "Microsemi Libero-SoC"]
set TASK $options(task)
set OPT  $options(opt)

if { [ file exists libero-soc ] } {
   file delete -force -- libero-soc
}

set project_file [glob -nocomplain *.prjx]

if { $project_file != "" } {
   puts "Using Libero-SoC project ($project_file)"
   open_project $project_file
} else {
   puts "Creating a new project (libero-soc.prjx)"
   new_project -name "libero-soc" -location {libero-soc} -hdl {VHDL} -family {Fusion}
   switch $OPT {
      "area"  {
          configure_tool -name {SYNTHESIZE} -params {RAM_OPTIMIZED_FOR_POWER:true}
      }
      "power" {
          configure_tool -name {SYNTHESIZE} -params {RAM_OPTIMIZED_FOR_POWER:true}
          configure_tool -name {PLACEROUTE} -params {PDPR:true}
      }
      "speed" {
          configure_tool -name {SYNTHESIZE} -params {RAM_OPTIMIZED_FOR_POWER:false}
          configure_tool -name {PLACEROUTE} -params {EFFORT_LEVEL:true}
      }
   }
   if {[catch {source options.tcl} ERRMSG]} {
      puts "ERROR: something is wrong in options.tcl\n"
      puts $ERRMSG
      exit 1
   }
}

if {[catch {
   configure_tool -name {PLACEROUTE} -params {REPAIR_MIN_DELAY:true}
   switch $TASK {
      "syn"  {
         do_syn $OPT
      }
      "imp" {
         do_syn $OPT
         do_imp $OPT
      }
      "bit" {
         do_syn $OPT
         do_imp $OPT
         do_bit
      }
   }
} ERRMSG]} {
   puts "ERROR: there was a problem running $TASK\n"
   puts $ERRMSG
   exit 1
}

# Generated with FPGA Synt (FPGA Helpers) v0.2.0