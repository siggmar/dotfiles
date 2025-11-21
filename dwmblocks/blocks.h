// Modify this file to change what commands output to your statusbar, and
// recompile using the make command.
static const Block blocks[] = {
    /*Icon*/ /*Command*/ /*Update Interval*/ /*Update Signal*/

    {"", "date '+%I:%M'", 5, 0},
    {"", "~/dotfiles/dwmblocks/scripts/battery", 30, 0}};

// sets delimiter between status commands. NULL character ('\0') means no
// delimiter.
static char delim[] = " | ";
static unsigned int delimLen = 5;
