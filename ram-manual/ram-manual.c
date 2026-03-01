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

    printf("\n+--------------------------------------------------+\n");
    printf("  Search results for: %s\n", q);
    printf("+--------------------------------------------------+\n");

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

            printf("\n  Component : %s\n", components[i].name);
            printf("  Version   : %s\n",   components[i].version);
            printf("  Function  : %s\n",   components[i].function);
            printf("  Notes     : %s\n",   components[i].note);
            printf("\n  --------------------------------------------------\n");
            found++;
        }
    }

    if (found == 0)
        printf("\n  No results found for '%s'\n", q);
    else
        printf("\n  %d result(s) found.\n", found);

    printf("+--------------------------------------------------+\n");
}

// ─────────────────────────────────────────
// VERSION MANUALS
// ─────────────────────────────────────────

void manual_v0() {
    printf("\n");
    printf("+------------------------------------------------------+\n");
    printf("|      RAM Engine (V0) - Proof of Concept              |\n");
    printf("+------------------------------------------------------+\n");

    printf("\n ABOUT\n");
    printf(" -----\n");
    printf(" The very first implementation of the Repeated\n");
    printf(" Arithmetic Machine idea. A proof of concept that\n");
    printf(" repeated arithmetic and feedback could form the\n");
    printf(" basis of a machine.\n");

    printf("\n FEATURES\n");
    printf(" --------\n");
    printf("   * Supports Addition and Subtraction\n");
    printf("   * Selector pin to choose operation\n");
    printf("   * Feedback pin to feed output back to input A\n");
    printf("   * Reset pin to clear machine state\n");
    printf("   * Output pin for result\n");

    printf("\n HOW TO USE\n");
    printf(" ----------\n");
    printf("   1. Feed input to A and B\n");
    printf("   2. Choose mode via Selector pin\n");
    printf("      Selector = 0 -> Addition\n");
    printf("      Selector = 1 -> Subtraction\n");
    printf("   3. Read output\n");
    printf("   4. Feed output back to A via Feedback pin\n");
    printf("      for further chained operations\n");

    printf("\n LIMITATIONS\n");
    printf(" -----------\n");
    printf("   * No error correction\n");
    printf("   * No overflow detection\n");
    printf("   * Gives errors if result goes below 0 (subtraction)\n");
    printf("   * Gives errors if result goes past 15 (addition)\n");

    printf("\n CIRCUIT FILE\n");
    printf(" ------------\n");
    printf("   r_a_m_Engine.circ\n");

    printf("\n+------------------------------------------------------+\n");
}

void manual_v1() {
    printf("\n");
    printf("+------------------------------------------------------+\n");
    printf("|         RAM V1 - 2s Complement Handling              |\n");
    printf("+------------------------------------------------------+\n");

    printf("\n ABOUT\n");
    printf(" -----\n");
    printf(" A minimal extension to the RAM Engine.\n");
    printf(" Introduces 2s complement result handling for\n");
    printf(" subtraction when result goes negative.\n");

    printf("\n FEATURES\n");
    printf(" --------\n");
    printf("   * All features of V0\n");
    printf("   * Handles 2s complement result\n");
    printf("   * Outputs correct result for negative subtraction\n");
    printf("   * Manual B>A pin for subtraction correction\n");

    printf("\n HOW TO USE\n");
    printf(" ----------\n");
    printf("   1. Feed input to A and B\n");
    printf("   2. If performing subtraction and B > A:\n");
    printf("      Set the manual B>A pin HIGH before operation\n");
    printf("      This enables 2s complement correction\n");
    printf("   3. Choose mode via Selector pin\n");
    printf("   4. Read corrected output\n");

    printf("\n LIMITATIONS\n");
    printf(" -----------\n");
    printf("   * No overflow detection\n");
    printf("   * Must manually check and set B>A pin\n");
    printf("   * Human intervention still required\n");

    printf("\n CIRCUIT FILE\n");
    printf(" ------------\n");
    printf("   r_a_mv1.circ  (in RAM_V1 folder)\n");

    printf("\n+------------------------------------------------------+\n");
}

void manual_v2() {
    printf("\n");
    printf("+------------------------------------------------------+\n");
    printf("|         RAM V2 - Automated 2s Complement             |\n");
    printf("+------------------------------------------------------+\n");

    printf("\n ABOUT\n");
    printf(" -----\n");
    printf(" Full automation for 2s complement result handling.\n");
    printf(" Minimal extension to V1 -- now with automatic\n");
    printf(" correction for negative results. No manual\n");
    printf(" intervention needed.\n");

    printf("\n FEATURES\n");
    printf(" --------\n");
    printf("   * All features of V1\n");
    printf("   * Automatically detects if B > A using comparator\n");
    printf("   * Corrects 2s complement output automatically\n");
    printf("   * No manual B>A pin required\n");

    printf("\n HOW TO USE\n");
    printf(" ----------\n");
    printf("   1. Feed input to A and B\n");
    printf("   2. Choose mode via Selector pin\n");
    printf("   3. Machine automatically handles B > A case\n");
    printf("   4. Read corrected output directly\n");
    printf("   No manual adjustments needed.\n");

    printf("\n LIMITATIONS\n");
    printf(" -----------\n");
    printf("   * Overflow detection still not implemented\n");

    printf("\n CIRCUIT FILE\n");
    printf(" ------------\n");
    printf("   r_a_mv2.circ  (in RAM_V2 folder)\n");

    printf("\n+------------------------------------------------------+\n");
}

void manual_v3() {
    printf("\n");
    printf("+------------------------------------------------------+\n");
    printf("|    RAM V3 - Full Autonomous Arithmetic Machine       |\n");
    printf("+------------------------------------------------------+\n");

    printf("\n ABOUT\n");
    printf(" -----\n");
    printf(" Full-fledged autonomous Repeated Arithmetic Machine.\n");
    printf(" Self-aware, self-correcting and intelligent system\n");
    printf(" with over 400 logic gates.\n");
    printf(" Developed iteratively from Engine through V1 and V2,\n");
    printf(" now incorporating advanced automation and full\n");
    printf(" error handling.\n");

    printf("\n FEATURES\n");
    printf(" --------\n");
    printf("   * Output feedback system\n");
    printf("   * Overflow error detection system\n");
    printf("   * Overflow type indicators\n");
    printf("   * Signed result handling\n");
    printf("   * Automatic halting to prevent data corruption\n");
    printf("   * Subtraction output form correction unit\n");
    printf("   * Simultaneous activation detectors for flip flops\n");
    printf("   * Output overshoot correction logic\n");
    printf("   * Multiplicative convergence detector\n");
    printf("   * Divisibility convergence detector\n");
    printf("   * Edge case handling (division/multiplication by 0)\n");
    printf("   * Invalid input form detector\n");
    printf("   * Division, Multiplication, Addition, Subtraction\n");

    printf("\n HOW TO USE\n");
    printf(" ----------\n");
    printf("   1. Feed input to A and B\n");
    printf("   2. Choose operation\n");
    printf("      Default: Addition\n");
    printf("      Selector pin: Subtraction\n");
    printf("      Multiply/Divide pins for those operations\n");
    printf("   3. Machine handles all corrections automatically\n");
    printf("   4. Watch output LEDs for feedback and corrections\n");
    printf("   5. Overflow indicators will flag if result is\n");
    printf("      out of valid 4-bit range\n");
    printf("   6. Machine auto-halts on overflow to prevent\n");
    printf("      data corruption\n");

    printf("\n SIGNIFICANCE\n");
    printf(" ------------\n");
    printf("   Demonstrates a complete autonomous arithmetic\n");
    printf("   computing system built from first principles\n");
    printf("   using logic gates. Showcases modular design,\n");
    printf("   iterative development and intelligent automation.\n");

    printf("\n CIRCUIT FILE\n");
    printf(" ------------\n");
    printf("   r_a_mv3.circ  (in RAM_V3 folder)\n");

    printf("\n+------------------------------------------------------+\n");
}

void manual_v4() {
    printf("\n");
    printf("+------------------------------------------------------+\n");
    printf("|    RAM V4 - Stored Program Architecture              |\n");
    printf("+------------------------------------------------------+\n");

    printf("\n ABOUT\n");
    printf(" -----\n");
    printf(" Programmable stored instruction system.\n");
    printf(" Instructions in machine code are stored in memory\n");
    printf(" and executed sequentially. Instead of manually\n");
    printf(" controlling each operation, V4 loads and executes\n");
    printf(" a sequence of instructions stored in memory.\n");
    printf(" Bridges the gap between data processing (V3) and\n");
    printf(" instruction processing (V4).\n");

    printf("\n FEATURES\n");
    printf(" --------\n");
    printf("   * All features of V3\n");
    printf("   * Memory unit to store the program\n");
    printf("   * Sequential instruction execution\n");
    printf("   * 16-bit instruction format\n");
    printf("   * Expandable memory via chained modules\n");
    printf("   * No intervention needed after program load\n");

    printf("\n 16-BIT INSTRUCTION FORMAT\n");
    printf(" -------------------------\n");
    printf("   Bit 1  -> Feedback\n");
    printf("   Bit 2  -> Store\n");
    printf("   Bit 3  -> Selector\n");
    printf("   Bit 4  -> Data1\n");
    printf("   Bit 5  -> Mode\n");
    printf("   Bit 6  -> Reset\n");
    printf("   Bit 7  -> Data2\n");
    printf("   Bit 8  -> Multiply\n");
    printf("   Bit 9  -> Divide\n");
    printf("   Bit 10 -> Override System Halt\n");
    printf("   Bit 11 -> Data4\n");
    printf("   Bit 12 -> Data8\n");
    printf("   Bit 13 -> Multiplier = 1\n");
    printf("   Bit 14 -> Multiplier = 2\n");
    printf("   Bit 15 -> Multiplier = 4\n");
    printf("   Bit 16 -> Multiplier = 8\n");

    printf("\n PROGRAM MEMORY\n");
    printf(" --------------\n");
    printf("   Pins labeled as Ix_y:\n");
    printf("     x = instruction number\n");
    printf("     y = instruction bit\n");
    printf("   Each module: 4 instructions x 16 bits = 8 bytes\n");
    printf("   Two modules connected = 16 bytes total\n");
    printf("   More modules can be chained for larger programs\n");
    printf("   Made up of sets of 16 D-flip flops\n");
    printf("   Interface module holds currently executing instruction\n");

    printf("\n LOADING A PROGRAM\n");
    printf(" -----------------\n");
    printf("   1. Enter instruction bits via initial load pins\n");
    printf("   2. Make Load_Ix pin HIGH to store instruction\n");
    printf("   3. Remove instruction from load pins after storing\n");
    printf("      (if not removed, machine keeps re-executing it)\n");
    printf("   4. Repeat for each instruction\n");
    printf("   5. Ix_y where x=1,2,3,4 is execution sequence order\n");

    printf("\n ARITHMETIC OPERATION SIGNALS\n");
    printf(" ----------------------------\n");
    printf("   Default operation : Addition\n");
    printf("   Subtraction       : Set Bit 5 (Mode) HIGH\n");
    printf("   Division          : Set Bit 9 HIGH\n");
    printf("   Multiplication    : Set Bit 8 HIGH\n");
    printf("                       + Set Multiplier bits (13-16)\n");

    printf("\n HOW TO USE\n");
    printf(" ----------\n");
    printf("   1. Open r_a_mv4.circ in Logisim Evolution\n");
    printf("   2. Start with small programs (load data + add)\n");
    printf("   3. Understand instruction format before programming\n");
    printf("   4. Refer V3 to understand how operations are\n");
    printf("      implemented in hardware before writing programs\n");
    printf("   5. Load program via load pins\n");
    printf("   6. Initiate execution\n");
    printf("   7. Observe sequential autonomous operation\n");

    printf("\n SIGNIFICANCE\n");
    printf(" ------------\n");
    printf("   Represents a significant step towards understanding\n");
    printf("   and recreating principles behind early programmable\n");
    printf("   computers. Demonstrates how instructions stored in\n");
    printf("   memory and executed sequentially forms the basis\n");
    printf("   of the Stored Program Execution model.\n");

    printf("\n CIRCUIT FILE\n");
    printf(" ------------\n");
    printf("   r_a_mv4.circ  (in RAM_v4 folder)\n");

    printf("\n+------------------------------------------------------+\n");
}

void manual_all() {
    printf("\n");
    printf("+------------------------------------------------------+\n");
    printf("|        RAM Manual - All Versions                     |\n");
    printf("+------------------------------------------------------+\n");
    printf("\n  V0 -> Proof of concept, ADD + SUB, no error handling\n");
    printf("  V1 -> 2s complement, manual B>A correction\n");
    printf("  V2 -> Auto B>A detection, automated correction\n");
    printf("  V3 -> Full autonomous machine, 400+ gates\n");
    printf("  V4 -> Stored program architecture, 16-bit instructions\n");
    printf("\n Showing all versions...\n");
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

    // ./ram-manual --search overflow
    if (argc >= 3 && strcmp(argv[1], "--search") == 0) {
        search(argv[2]);
        return 0;
    }

    // ./ram-manual --search (no query)
    if (argc == 2 && strcmp(argv[1], "--search") == 0) {
        printf("Usage: ./ram-manual --search <term>\n");
        printf("Example: ./ram-manual --search overflow\n");
        return 1;
    }

    // interactive mode
    char input[20];

    printf("+------------------------------------------------------+\n");
    printf("|     Computing Machinery from Scratch - Manual        |\n");
    printf("|       Repeated Arithmetic Machine (R.A.M) Docs       |\n");
    printf("+------------------------------------------------------+\n");
    printf(" Tip: search a component directly from terminal:\n");
    printf("      ./ram-manual --search overflow\n");

    while (1) {
        printf("\n Available: V0 | V1 | V2 | V3 | V4 | all | search | exit\n");
        printf(" Enter version: ");
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
            printf(" Enter term to search: ");
            scanf("%s", query);
            search(query);
        } else if (strcmp(input, "exit") == 0) {
            printf("\n Goodbye!\n");
            break;
        } else {
            printf("\n [ERROR] Unknown input '%s'\n", input);
            printf(" Try: V0, V1, V2, V3, V4, all, search, exit\n");
        }
    }

    return 0;
}
