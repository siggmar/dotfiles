// Modify this file to change what commands output to your statusbar, and
// recompile using the make command.
static const Block blocks[] = {
    /*Icon*/ /*Command*/ /*Update Interval*/ /*Update Signal*/

    // {"", "~/dotfiles/dwmblocks/scripts/ram", 5, 0},
    // {"", "~/dotfiles/dwmblocks/scripts/disk", 60, 0},
    // {"", "~/dotfiles/dwmblocks/scripts/temperature", 10, 0},
    {"", "~/dotfiles/dwmblocks/scripts/battery", 30, 0},
    {"", "~/dotfiles/dwmblocks/scripts/network", 5, 2},
    {"", "~/dotfiles/dwmblocks/scripts/date", 1, 3}
};

// sets delimiter between status commands. NULL character ('\0') means no
// delimiter.
static char delim[] = " | ";
static unsigned int delimLen = 7;
