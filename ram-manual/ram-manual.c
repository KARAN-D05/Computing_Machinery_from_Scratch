// ============================================================
//  ram-manual.c
// ------------------------------------------------------------
//  This project began from a simple idea: what if the output
//  of an arithmetic operation could be fed back into the
//  input? The first prototype was very basic - it could only
//  perform addition and take feedback. But as the exploration
//  continued, the machine kept improving.
//
//  This program is that reference. A manual baked directly
//  into the toolchain so the machine architecture is always
//  one command away, no browser, no file explorer, just run
//  it and get your answer.
//
//  Every time the machine evolves, the manual evolves.
// ------------------------------------------------------------
//  Project  : Computing Machinery from Scratch
//  Machine  : Repeated Arithmetic Machine (R.A.M)
//  File     : ram-manual.c
//  Covers   : RAM Engine (V0), V1, V2, V3, V4
//  Author   : KARAN-D05
//  Date     : 2026
// ============================================================

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// ─────────────────────────────────────────
// ANSI COLOR CODES
// ─────────────────────────────────────────

#define RESET       "\033[0m"
#define BOLD        "\033[1m"
#define DIM         "\033[2m"
#define GREEN       "\033[32m"
#define YELLOW      "\033[33m"
#define CYAN        "\033[36m"
#define BOLD_WHITE  "\033[1;37m"
#define BOLD_CYAN   "\033[1;36m"
#define BOLD_YELLOW "\033[1;33m"
#define BOLD_GREEN  "\033[1;32m"
#define BOLD_RED    "\033[1;31m"

// ─────────────────────────────────────────
// PRINT HELPERS
// ─────────────────────────────────────────

void print_divider() {
    printf(DIM "+------------------------------------------------------+" RESET "\n");
}

void print_header(char *title) {
    print_divider();
    printf(DIM "|" RESET BOLD_CYAN "  %-52s" RESET DIM "|" RESET "\n", title);
    print_divider();
}

void print_section(char *title) {
    printf("\n" BOLD_WHITE " %s" RESET "\n", title);
    printf(DIM " ");
    for (int i = 0; i < (int)strlen(title); i++) printf("-");
    printf(RESET "\n");
}

void print_bullet(char *text) {
    printf(GREEN "   * " RESET "%s\n", text);
}

void print_limitation(char *text) {
    printf(YELLOW "   ! " RESET "%s\n", text);
}

void print_step(int num, char *text) {
    printf(CYAN "   %d. " RESET "%s\n", num, text);
}

void print_arrow(char *key, char *value) {
    printf("      " CYAN "%s" RESET " -> %s\n", key, value);
}

void print_bit(char *bit, char *value) {
    printf("   " CYAN "%-8s" RESET "-> %s\n", bit, value);
}

void print_field(char *key, char *value) {
    printf(CYAN "   %-12s" RESET ": %s\n", key, value);
}

// ─────────────────────────────────────────
// COMPONENT DATABASE (for search)
// ─────────────────────────────────────────

typedef struct {
    char name[40];
    char version[20];
    char function[300];
    char note[300];
} Component;

Component components[] = {
    {
        "Selector Pin",
        "V0+",
        "Selects the arithmetic operation to perform.",
        "Selector = 0 -> Addition | Selector = 1 -> Subtraction"
    },
    {
        "Feedback Pin",
        "V0+",
        "Feeds the output back into input A for chained operations.",
        "Core idea of the machine. Output of one operation becomes input of the next."
    },
    {
        "Reset Pin",
        "V0+",
        "Resets the machine state.",
        "Clears registers and output back to initial state."
    },
    {
        "Output Pin",
        "V0+",
        "Outputs the result of the arithmetic operation.",
        "4-bit output. Goes past 15 on overflow in V0 and V1. Handled automatically from V3."
    },
    {
        "2s Complement",
        "V1+",
        "Handles negative results from subtraction using 2s complement representation.",
        "V1: manual B>A pin required. V2: automatic B>A detection via comparator. V3+: fully automated."
    },
    {
        "Manual B>A Pin",
        "V1",
        "Manual pin to indicate B > A before subtraction for correct 2s complement output.",
        "Only in V1. Removed in V2 where comparator automatically detects B > A condition."
    },
    {
        "Comparator",
        "V2+",
        "Automatically detects if B > A before subtraction.",
        "Removes need for manual B>A pin. Triggers 2s complement correction automatically."
    },
    {
        "Overflow Detection",
        "V3+",
        "Detects when result exceeds 4-bit range (above 15 or below 0).",
        "Triggers automatic halt to prevent data corruption. Overflow type indicators show which kind of overflow occurred."
    },
    {
        "Auto Halt",
        "V3+",
        "Automatically halts the machine to prevent data corruption on overflow.",
        "Part of the self-correction system. Machine stops before bad data propagates."
    },
    {
        "Signed Result Handling",
        "V3+",
        "Handles signed results correctly for all arithmetic operations.",
        "Works with the subtraction output form correction unit for correct signed output."
    },
    {
        "Subtraction Correction Unit",
        "V3+",
        "Corrects subtraction output form automatically.",
        "Works alongside signed result handling. No manual intervention required."
    },
    {
        "Flip Flop Detector",
        "V3+",
        "Simultaneous activation detector for series flip flops.",
        "Prevents race conditions and incorrect state transitions in the sequential logic."
    },
    {
        "Overshoot Correction",
        "V3+",
        "Corrects output overshoot during arithmetic operations.",
        "Catches cases where intermediate results temporarily exceed valid range."
    },
    {
        "Convergence Detector",
        "V3+",
        "Multiplicative and Divisibility Convergence detectors.",
        "Detects when multiplication or division has reached its final converged result."
    },
    {
        "Edge Case Handler",
        "V3+",
        "Handles edge cases like division by zero and multiplication by zero.",
        "Prevents undefined behavior. Machine responds gracefully to invalid mathematical operations."
    },
    {
        "Invalid Input Detector",
        "V3+",
        "Detects invalid input forms before processing.",
        "Catches malformed or out of range inputs before they corrupt machine state."
    },
    {
        "Program Memory",
        "V4",
        "Stores machine code instructions for sequential execution.",
        "Each module stores 4 instructions of 16 bits each = 8 bytes. Two modules connected = 16 bytes. More modules can be chained for larger programs. Pins labeled Ix_y where x=instruction number, y=bit."
    },
    {
        "Interface Module",
        "V4",
        "D flip-flop set directly connected to machine. Holds currently executing instruction.",
        "Acts as interface between program memory and machine. Instructions flow from memory through interface module to control the machine."
    },
    {
        "Instruction Format",
        "V4",
        "16-bit instruction format for machine code programming.",
        "Bit1=Feedback | Bit2=Store | Bit3=Selector | Bit4=Data1 | Bit5=Mode | Bit6=Reset | Bit7=Data2 | Bit8=Multiply | Bit9=Divide | Bit10=Override Halt | Bit11=Data4 | Bit12=Data8 | Bit13=Multiplier1 | Bit14=Multiplier2 | Bit15=Multiplier4 | Bit16=Multiplier8"
    },
    {
        "Load Pins",
        "V4",
        "Initial load pins used to manually enter instructions into program memory.",
        "Set instruction bits, make Load_Ix high to store. Remove from load pins after storing or machine will keep re-executing that instruction."
    },
    {
        "Multiplication",
        "V3+",
        "Repeated addition based multiplication.",
        "Uses convergence detector to know when result is reached. Edge case: multiply by zero handled."
    },
    {
        "Division",
        "V3+",
        "Repeated subtraction based division.",
        "Uses convergence detector to know when result is reached. Edge case: divide by zero handled."
    },
    {
        "Addition",
        "V0+",
        "Default arithmetic operation of the machine.",
        "Selector = 0. No overflow detection in V0 and V1. Full overflow handling from V3."
    },
    {
        "Subtraction",
        "V0+",
        "Arithmetic subtraction. Result may go negative.",
        "V0: errors below 0. V1: manual B>A correction. V2: auto correction. V3: fully automated signed handling."
    },
};

int component_count = 24;

// ─────────────────────────────────────────
// SEARCH HELPER
// ─────────────────────────────────────────

void to_upper(char *str) {
    for (int i = 0; str[i]; i++)
        if (str[i] >= 'a' && str[i] <= 'z')
            str[i] -= 32;
}

// ─────────────────────────────────────────
// SEARCH FUNCTION
// ─────────────────────────────────────────

void search(char *query) {
    char q[50];
    strncpy(q, query, 49);
    q[49] = '\0';
    to_upper(q);

    int found = 0;

    printf("\n");
    print_divider();
    printf(BOLD_CYAN "  Search results for: %s" RESET "\n", q);
    print_divider();

    for (int i = 0; i < component_count; i++) {
        char name_upper[40];
        char func_upper[300];
        char note_upper[300];

        strncpy(name_upper, components[i].name,     39);  name_upper[39]  = '\0';
        strncpy(func_upper, components[i].function, 299); func_upper[299] = '\0';
        strncpy(note_upper, components[i].note,     299); note_upper[299] = '\0';

        to_upper(name_upper);
        to_upper(func_upper);
        to_upper(note_upper);

        if (strstr(name_upper, q) ||
            strstr(func_upper, q) ||
            strstr(note_upper, q)) {

            printf("\n");
            printf(BOLD_YELLOW "  Component" RESET " : " BOLD_WHITE "%s" RESET "\n", components[i].name);
            printf(CYAN        "  Version  " RESET " : %s\n", components[i].version);
            printf(            "  Function  : %s\n", components[i].function);
            printf(DIM         "  Notes     : %s" RESET "\n", components[i].note);
            printf(DIM "\n  ------------------------------------------------------" RESET "\n");
            found++;
        }
    }

    if (found == 0)
        printf(BOLD_RED "\n  No results found for '%s'\n" RESET, q);
    else
        printf(BOLD_GREEN "\n  %d result(s) found.\n" RESET, found);

    print_divider();
}

// ─────────────────────────────────────────
// VERSION MANUALS
// ─────────────────────────────────────────

void manual_v0() {
    printf("\n");
    print_header("RAM Engine (V0) - Proof of Concept");

    print_section("ABOUT");
    printf(" The very first implementation of the Repeated\n");
    printf(" Arithmetic Machine idea. A proof of concept that\n");
    printf(" repeated arithmetic and feedback could form the\n");
    printf(" basis of a machine.\n");

    print_section("FEATURES");
    print_bullet("Supports Addition and Subtraction");
    print_bullet("Selector pin to choose operation");
    print_bullet("Feedback pin to feed output back to input A");
    print_bullet("Reset pin to clear machine state");
    print_bullet("Output pin for result");

    print_section("HOW TO USE");
    print_step(1, "Feed input to A and B");
    print_step(2, "Choose mode via Selector pin");
    print_arrow("Selector = 0", "Addition");
    print_arrow("Selector = 1", "Subtraction");
    print_step(3, "Read output");
    print_step(4, "Feed output back to A via Feedback pin");
    printf("      for further chained operations\n");

    print_section("LIMITATIONS");
    print_limitation("No error correction");
    print_limitation("No overflow detection");
    print_limitation("Gives errors if result goes below 0 (subtraction)");
    print_limitation("Gives errors if result goes past 15 (addition)");

    print_section("CIRCUIT FILE");
    printf("   r_a_m_Engine.circ\n");

    printf("\n");
    print_divider();
}

void manual_v1() {
    printf("\n");
    print_header("RAM V1 - 2s Complement Handling");

    print_section("ABOUT");
    printf(" A minimal extension to the RAM Engine.\n");
    printf(" Introduces 2s complement result handling for\n");
    printf(" subtraction when result goes negative.\n");

    print_section("FEATURES");
    print_bullet("All features of V0");
    print_bullet("Handles 2s complement result");
    print_bullet("Outputs correct result for negative subtraction");
    print_bullet("Manual B>A pin for subtraction correction");

    print_section("HOW TO USE");
    print_step(1, "Feed input to A and B");
    print_step(2, "If performing subtraction and B > A:");
    printf("      Set the manual B>A pin HIGH before operation\n");
    printf("      This enables 2s complement correction\n");
    print_step(3, "Choose mode via Selector pin");
    print_step(4, "Read corrected output");

    print_section("LIMITATIONS");
    print_limitation("No overflow detection");
    print_limitation("Must manually check and set B>A pin");
    print_limitation("Human intervention still required");

    print_section("CIRCUIT FILE");
    printf("   r_a_mv1.circ  (in RAM_V1 folder)\n");

    printf("\n");
    print_divider();
}

void manual_v2() {
    printf("\n");
    print_header("RAM V2 - Automated 2s Complement");

    print_section("ABOUT");
    printf(" Full automation for 2s complement result handling.\n");
    printf(" Minimal extension to V1 -- now with automatic\n");
    printf(" correction for negative results. No manual\n");
    printf(" intervention needed.\n");

    print_section("FEATURES");
    print_bullet("All features of V1");
    print_bullet("Automatically detects if B > A using comparator");
    print_bullet("Corrects 2s complement output automatically");
    print_bullet("No manual B>A pin required");

    print_section("HOW TO USE");
    print_step(1, "Feed input to A and B");
    print_step(2, "Choose mode via Selector pin");
    print_step(3, "Machine automatically handles B > A case");
    print_step(4, "Read corrected output directly");
    printf("   No manual adjustments needed.\n");

    print_section("LIMITATIONS");
    print_limitation("Overflow detection still not implemented");

    print_section("CIRCUIT FILE");
    printf("   r_a_mv2.circ  (in RAM_V2 folder)\n");

    printf("\n");
    print_divider();
}

void manual_v3() {
    printf("\n");
    print_header("RAM V3 - Full Autonomous Arithmetic Machine");

    print_section("ABOUT");
    printf(" Full-fledged autonomous Repeated Arithmetic Machine.\n");
    printf(" Self-aware, self-correcting and intelligent system\n");
    printf(" with over 400 logic gates.\n");
    printf(" Developed iteratively from Engine through V1 and V2,\n");
    printf(" now incorporating advanced automation and full\n");
    printf(" error handling.\n");

    print_section("FEATURES");
    print_bullet("Output feedback system");
    print_bullet("Overflow error detection system");
    print_bullet("Overflow type indicators");
    print_bullet("Signed result handling");
    print_bullet("Automatic halting to prevent data corruption");
    print_bullet("Subtraction output form correction unit");
    print_bullet("Simultaneous activation detectors for flip flops");
    print_bullet("Output overshoot correction logic");
    print_bullet("Multiplicative convergence detector");
    print_bullet("Divisibility convergence detector");
    print_bullet("Edge case handling (division/multiplication by 0)");
    print_bullet("Invalid input form detector");
    print_bullet("Division, Multiplication, Addition, Subtraction");

    print_section("HOW TO USE");
    print_step(1, "Feed input to A and B");
    print_step(2, "Choose operation");
    printf("      Default: Addition\n");
    printf("      Selector pin: Subtraction\n");
    printf("      Multiply/Divide pins for those operations\n");
    print_step(3, "Machine handles all corrections automatically");
    print_step(4, "Watch output LEDs for feedback and corrections");
    print_step(5, "Overflow indicators will flag if result is");
    printf("      out of valid 4-bit range\n");
    print_step(6, "Machine auto-halts on overflow to prevent");
    printf("      data corruption\n");

    print_section("SIGNIFICANCE");
    printf("   Demonstrates a complete autonomous arithmetic\n");
    printf("   computing system built from first principles\n");
    printf("   using logic gates. Showcases modular design,\n");
    printf("   iterative development and intelligent automation.\n");

    print_section("CIRCUIT FILE");
    printf("   r_a_mv3.circ  (in RAM_V3 folder)\n");

    printf("\n");
    print_divider();
}

void manual_v4() {
    printf("\n");
    print_header("RAM V4 - Stored Program Architecture");

    print_section("ABOUT");
    printf(" Programmable stored instruction system.\n");
    printf(" Instructions in machine code are stored in memory\n");
    printf(" and executed sequentially. Instead of manually\n");
    printf(" controlling each operation, V4 loads and executes\n");
    printf(" a sequence of instructions stored in memory.\n");
    printf(" Bridges the gap between data processing (V3) and\n");
    printf(" instruction processing (V4).\n");

    print_section("FEATURES");
    print_bullet("All features of V3");
    print_bullet("Memory unit to store the program");
    print_bullet("Sequential instruction execution");
    print_bullet("16-bit instruction format");
    print_bullet("Expandable memory via chained modules");
    print_bullet("No intervention needed after program load");

    print_section("16-BIT INSTRUCTION FORMAT");
    print_bit("Bit 1 ", "Feedback");
    print_bit("Bit 2 ", "Store");
    print_bit("Bit 3 ", "Selector");
    print_bit("Bit 4 ", "Data1");
    print_bit("Bit 5 ", "Mode");
    print_bit("Bit 6 ", "Reset");
    print_bit("Bit 7 ", "Data2");
    print_bit("Bit 8 ", "Multiply");
    print_bit("Bit 9 ", "Divide");
    print_bit("Bit 10", "Override System Halt");
    print_bit("Bit 11", "Data4");
    print_bit("Bit 12", "Data8");
    print_bit("Bit 13", "Multiplier = 1");
    print_bit("Bit 14", "Multiplier = 2");
    print_bit("Bit 15", "Multiplier = 4");
    print_bit("Bit 16", "Multiplier = 8");

    print_section("PROGRAM MEMORY");
    printf("   Pins labeled as Ix_y:\n");
    printf("     x = instruction number\n");
    printf("     y = instruction bit\n");
    printf("   Each module: 4 instructions x 16 bits = 8 bytes\n");
    printf("   Two modules connected = 16 bytes total\n");
    printf("   More modules can be chained for larger programs\n");
    printf("   Made up of sets of 16 D-flip flops\n");
    printf("   Interface module holds currently executing instruction\n");

    print_section("LOADING A PROGRAM");
    print_step(1, "Enter instruction bits via initial load pins");
    print_step(2, "Make Load_Ix pin HIGH to store instruction");
    print_step(3, "Remove instruction from load pins after storing");
    printf("      (if not removed, machine keeps re-executing it)\n");
    print_step(4, "Repeat for each instruction");
    print_step(5, "Ix_y where x=1,2,3,4 is execution sequence order");

    print_section("ARITHMETIC OPERATION SIGNALS");
    print_field("Default", "Addition");
    print_field("Subtraction", "Set Bit 5 (Mode) HIGH");
    print_field("Division", "Set Bit 9 HIGH");
    print_field("Multiplication", "Set Bit 8 HIGH");
    printf("               " "+ Set Multiplier bits (13-16)\n");

    print_section("HOW TO USE");
    print_step(1, "Open r_a_mv4.circ in Logisim Evolution");
    print_step(2, "Start with small programs (load data + add)");
    print_step(3, "Understand instruction format before programming");
    print_step(4, "Refer V3 to understand how operations are");
    printf("      implemented in hardware before writing programs\n");
    print_step(5, "Load program via load pins");
    print_step(6, "Initiate execution");
    print_step(7, "Observe sequential autonomous operation");

    print_section("SIGNIFICANCE");
    printf("   Represents a significant step towards understanding\n");
    printf("   and recreating principles behind early programmable\n");
    printf("   computers. Demonstrates how instructions stored in\n");
    printf("   memory and executed sequentially forms the basis\n");
    printf("   of the Stored Program Execution model.\n");

    print_section("CIRCUIT FILE");
    printf("   r_a_mv4.circ  (in RAM_v4 folder)\n");

    printf("\n");
    print_divider();
}

void manual_all() {
    printf("\n");
    print_header("RAM Manual - All Versions");
    printf(CYAN "  V0" RESET " -> Proof of concept, ADD + SUB, no error handling\n");
    printf(CYAN "  V1" RESET " -> 2s complement, manual B>A correction\n");
    printf(CYAN "  V2" RESET " -> Auto B>A detection, automated correction\n");
    printf(CYAN "  V3" RESET " -> Full autonomous machine, 400+ gates\n");
    printf(CYAN "  V4" RESET " -> Stored program architecture, 16-bit instructions\n");
    printf(DIM "\n Showing all versions...\n" RESET);
    manual_v0();
    manual_v1();
    manual_v2();
    manual_v3();
    manual_v4();
}

// ─────────────────────────────────────────
// MAIN
// ─────────────────────────────────────────

int main(int argc, char *argv[]) {

    if (argc >= 3 && strcmp(argv[1], "--search") == 0) {
        search(argv[2]);
        return 0;
    }

    if (argc == 2 && strcmp(argv[1], "--search") == 0) {
        printf(BOLD_WHITE "Usage  : " RESET "./ram-manual --search <term>\n");
        printf(BOLD_WHITE "Example: " RESET "./ram-manual --search overflow\n");
        return 1;
    }

    char input[20];

    printf("\n");
    print_divider();
    printf(DIM "|" RESET BOLD_CYAN "  %-52s" RESET DIM "|" RESET "\n", "Computing Machinery from Scratch - Manual");
    printf(DIM "|" RESET "  %-52s" DIM "|" RESET "\n", "Repeated Arithmetic Machine (R.A.M) Docs");
    print_divider();
    printf(DIM " Tip: " RESET "search a component directly from terminal:\n");
    printf(CYAN "      ./ram-manual --search overflow\n" RESET);

    while (1) {
        printf("\n" DIM " Available: " RESET
               CYAN "V0" RESET " | "
               CYAN "V1" RESET " | "
               CYAN "V2" RESET " | "
               CYAN "V3" RESET " | "
               CYAN "V4" RESET " | "
               CYAN "all" RESET " | "
               CYAN "search" RESET " | "
               CYAN "exit" RESET "\n");
        printf(BOLD_WHITE " Enter version: " RESET);
        scanf("%s", input);

        if (strcmp(input, "V0") == 0 || strcmp(input, "v0") == 0) {
            manual_v0();
        } else if (strcmp(input, "V1") == 0 || strcmp(input, "v1") == 0) {
            manual_v1();
        } else if (strcmp(input, "V2") == 0 || strcmp(input, "v2") == 0) {
            manual_v2();
        } else if (strcmp(input, "V3") == 0 || strcmp(input, "v3") == 0) {
            manual_v3();
        } else if (strcmp(input, "V4") == 0 || strcmp(input, "v4") == 0) {
            manual_v4();
        } else if (strcmp(input, "all") == 0) {
            manual_all();
        } else if (strcmp(input, "search") == 0) {
            char query[50];
            printf(BOLD_WHITE " Enter term to search: " RESET);
            scanf("%s", query);
            search(query);
        } else if (strcmp(input, "exit") == 0) {
            printf(BOLD_GREEN "\n Goodbye!\n" RESET);
            break;
        } else {
            printf(BOLD_RED "\n [ERROR]" RESET " Unknown input '%s'\n", input);
            printf(DIM " Try: V0, V1, V2, V3, V4, all, search, exit\n" RESET);
        }
    }

    return 0;
}
