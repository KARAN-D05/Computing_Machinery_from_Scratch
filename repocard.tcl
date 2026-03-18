# =============================================================================
#  repocard.tcl — Repository Stats Card Generator
#  Language: Tcl 8.5+
#  Usage:    tclsh repocard.tcl [directory]   (default: current directory)
#            wish  repocard.tcl [directory]   (also works in Vivado console!)
# =============================================================================
#
# WHY TCL?
# --------
# Tcl (Tool Command Language, pronounced "tickle") was created in 1988 and
# is the scripting engine embedded inside:
#   - Vivado (Xilinx/AMD's FPGA toolchain)
#   - Quartus (Intel/Altera's FPGA toolchain)
#   - ModelSim / QuestaSim (simulation tools)
#   - countless EDA tools
#
# This means ANY engineer with Vivado already has a Tcl interpreter.
# Running this script inside Vivado's Tcl console requires zero extra installs.
#
# HOW TCL WORKS (quick mental model):
# ------------------------------------
# 1. EVERYTHING is a string. Numbers are strings. Lists are strings. Commands
#    are strings. Tcl has exactly ONE data type: string.
# 2. Every statement is a COMMAND followed by ARGUMENTS:
#      puts "hello"          ;# puts = print, "hello" = argument
#      set x 42              ;# set  = assign,  x = variable name, 42 = value
#      expr {$x + 1}         ;# expr evaluates math; always wrap in {} 
# 3. Variable substitution: $varname inlines the value of a variable.
# 4. Command substitution: [command] runs a command and inlines its result.
#      set n [llength $myList]   ;# n = length of myList
# 5. {} = literal string (no substitution). "" = substituted string.
# 6. Procedures: proc name {args} { body }
# 7. Lists: {a b c}  or  [list a b c].  lindex $list 0 = first element.
#
# =============================================================================

# =============================================================================
# CONFIGURATION — tweak these to match your style
# =============================================================================

# Known Verilog/SystemVerilog extensions we care about
set HDL_EXTENSIONS {.v .sv .vh .svh}

# Known testbench suffixes (files whose name contains these strings)
set TB_SUFFIXES {_tb _test _sim tb_ testbench}

# =============================================================================
# PROC: string_contains
# Check if a string contains a substring (case-insensitive)
# Args: str — the string to search in
#       sub — the substring to look for
# =============================================================================
proc string_contains {str sub} {
    # string first returns the index of sub in str, or -1 if not found.
    # We do case-insensitive comparison by lowercasing both.
    set idx [string first [string tolower $sub] [string tolower $str]]
    return [expr {$idx >= 0}]   ;# expr{} evaluates boolean: 1=true, 0=false
}

# =============================================================================
# PROC: is_testbench
# Returns 1 if the filename looks like a testbench, 0 otherwise.
# Args: fname — just the filename (no directory path)
# =============================================================================
proc is_testbench {fname} {
    global TB_SUFFIXES   ;# `global` makes the package-level variable visible here

    # Remove the file extension to check just the stem
    set stem [file rootname $fname]   ;# file rootname strips the extension

    foreach suffix $TB_SUFFIXES {
        if {[string_contains $stem $suffix]} {
            return 1
        }
    }
    return 0
}

# =============================================================================
# PROC: get_extension
# Returns the lowercase file extension including the dot, e.g. ".v"
# =============================================================================
proc get_extension {fname} {
    # [file extension fname] returns ".v", ".sv", etc. already with the dot.
    return [string tolower [file extension $fname]]
}

# =============================================================================
# PROC: count_lines
# Count non-blank, non-comment lines in a file.
# Args: fpath — full path to the file
# Returns: integer line count
# =============================================================================
proc count_lines {fpath} {
    # Open file for reading. Tcl file I/O:
    #   open path mode  → returns a channel handle
    #   gets handle var → reads one line into var, returns char count (-1 at EOF)
    #   close handle    → closes the file
    set fh [open $fpath r]
    set count 0

    # Read line by line until EOF
    while {[gets $fh line] >= 0} {
        set trimmed [string trim $line]   ;# remove whitespace from both ends

        # Skip blank lines
        if {$trimmed eq ""} continue

        # Skip single-line Verilog comments  ( // ... )
        if {[string match "//*" $trimmed]} continue

        # Skip block-comment lines that start with *  or  /*
        # IMPORTANT: we use [string index] not [string match "**"] because
        # in Tcl double-quoted strings, \* is just *, so "\**" becomes "**"
        # which is a glob wildcard meaning "anything" — it would skip ALL lines!
        # [string index str 0] safely reads the first character with no magic.
        if {[string index $trimmed 0] eq "*"} continue
        if {[string match "/*" $trimmed]} continue

        incr count   ;# incr = increment a variable by 1 (faster than set x [expr $x+1])
    }

    close $fh
    return $count
}

# =============================================================================
# PROC: count_modules
# Count `module` keyword occurrences in a file (= number of Verilog modules).
# Args: fpath — full path to the file
# =============================================================================
proc count_modules {fpath} {
    set fh [open $fpath r]
    set count 0

    while {[gets $fh line] >= 0} {
        set trimmed [string trim $line]

        # Skip comments
        if {[string match "//*" $trimmed]} continue

        # `regexp` returns 1 if the pattern matches the string.
        # Pattern: line starts with "module" followed by a space or newline.
        # The {\m} is a word-boundary assertion in Tcl's regex dialect.
        if {[regexp {^\s*module\s+} $trimmed]} {
            incr count
        }
    }

    close $fh
    return $count
}

# =============================================================================
# PROC: walk_directory
# Recursively collect all files matching our HDL extensions.
# Args: root — starting directory path
# Returns: a Tcl list of full file paths
# =============================================================================
proc walk_directory {root} {
    global HDL_EXTENSIONS

    set result {}   ;# {} is an empty list in Tcl

    # [glob -nocomplain pattern] returns matching files; -nocomplain = no error
    # if nothing matches (instead of throwing an exception).
    # We use -directory to scope it to our root.

    # First pass: files directly in root
    foreach ext $HDL_EXTENSIONS {
        set pattern [file join $root "*${ext}"]
        foreach f [glob -nocomplain $pattern] {
            lappend result $f   ;# lappend appends to a list
        }
    }

    # Recursive pass: subdirectories
    foreach subdir [glob -nocomplain -type d [file join $root "*"]] {
        # Skip hidden directories (.git, .github, etc.)
        set dname [file tail $subdir]   ;# file tail = last component of path
        if {[string match ".*" $dname]} continue

        # Recurse and extend our result list
        set sub_files [walk_directory $subdir]
        set result [concat $result $sub_files]   ;# concat joins two lists
    }

    return $result
}

# =============================================================================
# PROC: render_card
# Print the repo-card in a nice box using Unicode box-drawing characters.
# Args: stats — a Tcl dict (key-value map) with all computed statistics
# =============================================================================
proc render_card {stats} {
    # `dict get` retrieves a value by key from a dict
    set repo_name  [dict get $stats name]
    set hdl_files  [dict get $stats hdl_files]
    set modules    [dict get $stats modules]
    set hdl_lines  [dict get $stats hdl_lines]
    set testbenches [dict get $stats testbenches]
    set sv_files   [dict get $stats sv_files]

    # ---- plain text card (paste into README as a code block) ----
    puts ""
    puts "```"
    puts "╔══════════════════════════════════════╗"
    # Format the repo name centred in a 38-char field
    set title " $repo_name "
    set pad_total [expr {38 - [string length $title]}]
    set pad_left  [expr {$pad_total / 2}]
    set pad_right [expr {$pad_total - $pad_left}]
    puts "║[string repeat " " $pad_left]${title}[string repeat " " $pad_right]║"
    puts "╠══════════════════════════════════════╣"

    # Helper lambda to print a labelled row
    # In Tcl, `format` works like printf: %-20s = left-align in 20 chars
    puts [format "║  %-20s %15s  ║" "HDL Files"   $hdl_files]
    puts [format "║  %-20s %15s  ║" "  of which .sv"  $sv_files]
    puts [format "║  %-20s %15s  ║" "Modules"     $modules]
    puts [format "║  %-20s %15s  ║" "HDL Lines"   $hdl_lines]
    puts [format "║  %-20s %15s  ║" "Testbenches" $testbenches]
    puts "╚══════════════════════════════════════╝"
    puts "```"
    puts ""
    puts {> *Generated by [repocard](https://github.com/KARAN-D05) — Tcl repo stats*}
    puts ""
}

# =============================================================================
# MAIN — top-level execution
# =============================================================================
# In Tcl there is no main(). Execution starts from the first non-proc line.

# Determine target directory: first CLI arg, or current directory
# `$argv` is a built-in Tcl list of command-line arguments
if {[llength $argv] > 0} {
    set root [lindex $argv 0]   ;# lindex list 0 = first element
} else {
    set root [pwd]              ;# pwd = print working directory
}

# Validate the directory exists
if {![file isdirectory $root]} {
    puts stderr "ERROR: not a directory: $root"
    exit 1
}

# Get the repo name from the directory's last component
set repo_name [file tail $root]
# Special case: if root is "." resolve to the actual folder name
if {$repo_name eq "."} {
    set repo_name [file tail [file normalize $root]]
}

# ---- collect all HDL files ----
set all_files [walk_directory $root]

# ---- compute stats ----
set total_hdl   0   ;# total .v / .sv / .vh / .svh files
set total_sv    0   ;# just .sv and .svh files
set total_mod   0   ;# total module declarations
set total_lines 0   ;# total non-blank non-comment lines
set total_tb    0   ;# testbench files

foreach fpath $all_files {
    set fname [file tail $fpath]
    set ext   [get_extension $fname]

    incr total_hdl

    if {$ext eq ".sv" || $ext eq ".svh"} { incr total_sv }
    if {[is_testbench $fname]}           { incr total_tb  }

    incr total_mod   [count_modules $fpath]
    incr total_lines [count_lines   $fpath]
}

# Pack results into a Tcl dict (like a Python dict)
# `dict create key val key val ...` builds the dict
set stats [dict create \
    name        $repo_name  \
    hdl_files   $total_hdl  \
    sv_files    $total_sv   \
    modules     $total_mod  \
    hdl_lines   $total_lines \
    testbenches $total_tb   \
]

render_card $stats
