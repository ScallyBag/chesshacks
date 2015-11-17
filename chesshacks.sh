#!/bin/bash

#-------------------------------------------------------------------------#
#
#                    ▌           ▌        ▌          ▌  
#                 ▞▀▖▛▀▖▞▀▖▞▀▘▞▀▘▛▀▖▝▀▖▞▀▖▌▗▘▞▀▘  ▞▀▘▛▀▖
#                 ▌ ▖▌ ▌▛▀ ▝▀▖▝▀▖▌ ▌▞▀▌▌ ▖▛▚ ▝▀▖▗▖▝▀▖▌ ▌
#                 ▝▀ ▘ ▘▝▀▘▀▀ ▀▀ ▘ ▘▝▀▘▝▀ ▘ ▘▀▀ ▝▘▀▀ ▘ ▘
#                                                                              
# Description:
#    A collection of chess-related command-line functions.
#    Try  chesshacks.sh -u  for usage examples.
#
#-------------------------------------------------------------------------
#
# Found this useful? Appalling? Appealing? Please let me know.
# The Unabashed welcomes your impressions. 
#
# You will find the
#   unabashed
# at the location opposite to
#   moc • thgimliam
#
#-------------------------------------------------------------------------
#
# License:
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
#
#-------------------------------------------------------------------------#

#-------------------------------------------------------------------------#
# METACOMMENT. This program was first  written quite some time before the #
# published  date.  At that  time,  I  had  the habit  of  overcommenting #
# everything  —  stuff like "this  is what  I'm doing here".  While  some #
# people  may appreciate  that  as  good redundancy  and  a  nice way  of #
# learning to  code, more experienced  programmers may find  it annoying. #
# That said, I  chose to publish the  code as it is  without cleaning up. #
#-------------------------------------------------------------------------#


# Program name from its filename
prog=${0##*/}

# Usage if argument isn't given
LIGHTRED='\e[1;31m'
LIGHTPURPLE='\e[1;35m'
YELLOW='\e[1;33m'
NC='\e[0m'

# Calling for help or calling with more than one argument is the same as calling without arguments.
case $1 in --help|-[h?])  $prog; exit 1  ;; esac
[[ $# -gt 1 ]] && { $prog; exit 1 ; }

# Usage if argument isn't given
[[ $# -eq 0 ]] && {
    clear
    echo -e "
${LIGHTRED}Description:${NC}
    A collection of chess-related command-line functions.

${LIGHTRED}Dependencies and first steps:${NC}
    To install dependencies, to load all functions, and to make the Encyclopedia of Chess Openings available to you, just run:
    ${YELLOW}$prog install${NC}

    Alternatively, if you prefer, you can also install it by hand. Copy this and paste it in your terminal:${YELLOW}
    sudo apt-get install pgn-extract xsel moreutils lynx
    sudo updatedb && locate eco.pgn > my_eco.pgn_file_is_here.txt
    export ECO_FILE=\`cat my_eco.pgn_file_is_here.txt\`
    echo -en '\\\n# Make ECO file and its more than 2,000 openings and variations available to pgn-extract\\\nexport ECO_FILE=\"' >> ~/.bashrc
    cat my_eco.pgn_file_is_here.txt >> ~/.bashrc
    echo -en '\"\\\n\\\n# Loads chess hacks functions\\\nif [ -f ~/bin/$prog ]; then\\\n   . ~/bin/$prog load\\\nfi\\\n' >> ~/.bashrc
    rm my_eco.pgn_file_is_here.txt
    mkdir -p ~/bin
    cp $prog ~/bin/
    . ~/.bashrc
    $prog load${NC}

${LIGHTRED}Loading it:${NC}
    If $prog has been installed but in the future you notice that its functions 
    are not working, you can probably fix it with:
    ${YELLOW}$prog load${NC}

${LIGHTRED}Usage:${NC}
    See usage and example for all these functions, plus some examples of the one-line queries of the pgn-extract package:
    ${YELLOW}$prog usage${NC}  OR  ${YELLOW}$prog -u${NC}
"
    exit 1
}

opt=$1
case $(echo $opt | tr -d '-' | tr '[A-Z]' '[a-z]') in
    u | usage)
        # Educates the user on how to use these functions and examples of pgn-extract package
        clear
        echo -e "
${LIGHTRED}======================== HANDLING PGN FILES ========================${NC}
Note: for all commands herein, it is assumed that there is one game per pgn file.

${LIGHTRED}FUNCTION        ARGS.             DESCRIPTION${NC}
-------------   ---------------   ----------------------------------------------------------------------
${YELLOW}pgneco${NC}          file.pgn | -all   Adds ECO, Opening, Variation
${YELLOW}pgnfen${NC}          file.pgn | -all   Adds end-game position (FEN)
${YELLOW}pgnecofen${NC}       file.pgn | -all   Adds ECO, Opening, Variation, plus end-game position (FEN)
${YELLOW}pgnsummary${NC}      file.pgn | -all   Outputs data of pgn file(s). Execute with no arguments to get help.
${YELLOW}pgnscore${NC}        playername        Outputs summary scores for that player, over all pgn files in current folder.

${LIGHTRED}STRAIGHTFORWARD COMMANDS FROM pgn-extract PACKAGE${NC}
    Insert in files.pgn (or below: in all files in folder): ECO, Opening, Variation (if any), FEN
        ${YELLOW}pgn-extract -s -e -F file.pgn | sponge file.pgn${NC}
        ${YELLOW}for i in *.pgn; do pgn-extract -s -e -F "\$i" | sponge "\$i" ; done && clear${NC}

    For file.pgn, give me only the moves, no numbering, no tags
        ${YELLOW}pgn-extract --nomovenumbers --noresults --notags -C -N -V file.pgn${NC}

    Splits lotsofmatches.pgn into single files with one game each
        ${YELLOW}pgn-extract -#1 lotsofmatches.pgn${NC}

    Easy to read, clean, table, one move per line, Chessmaster format
        ${YELLOW}pgn-extract -Wcm file.pgn${NC}

    For more on how to use the pgn-extract package, try ${YELLOW}pgn-extract -h${NC} or see:
    ${LIGHTPURPLE}http://cs.kent.ac.uk/people/staff/djb/pgn-extract/help.html${NC}

${LIGHTRED}BASH ONE-LINER${NC}
    Query the openings of all matches in this folder
        ${YELLOW}cat *.pgn | sed -n '/^.Opening/ s/.*\"\(.*\)\".*/\1/ p'${NC}

${LIGHTRED}DOWNLOADING GAMES${NC}
    Saves pgn from a 365chess.com link and makes it tidy
        ${YELLOW}pgn365 www.365chess.com/view_game.php?g=3962489${NC}
        ${YELLOW}pgn365 3962489${NC}

${LIGHTRED}======================== DIRECT QUERYING ========================${NC}

${YELLOW}str2eco${NC}
Queries the Encyclopedia of Chess Openings for all openings with given string(s)
e.g: (1) single input; (2) two inputs: print any; (3) two inputs: separated by unescaped space: both must occur
    (1) ${YELLOW}str2eco elephant${NC}
    (1) ${YELLOW}str2eco ruy\ lopez${NC}            # escaped spaces: counts as one string
    (2) ${YELLOW}str2eco bayonet\|crab${NC}         # bayonet OR crab
    (3) ${YELLOW}str2eco KGD gambit${NC}            # show all gambits stemming from KGD (i.e. gambit AND KGD)
    (3) ${YELLOW}str2eco \"1. e4 c6\" gambit${NC}     # show all gambits that start with Caro-Kann

${YELLOW}moves2eco${NC}
Gets chess moves from the clipboard and outputs best fit of ECO, Opening, Variation.
Besides FIDE-enforced SAN, formats may be Coordinate (with or without dashes, in lowercase), LAN, RAN.
    Check ${LIGHTPURPLE}https://en.wikipedia.org/wiki/Chess_notation${NC} for more information.
Clipboard input must have an ending (score or *). Function has no variables. E.g.:
1. d4 Nf6 2. c4 g6 3. Nc3 Bg7 4. e4 d6 5. Nf3 O-O 6. Be2 e5 7. O-O Nc6 *
Copying the above and running the command returns:
(E97) King's Indian, orthodox, Aronin-Taimanov variation (Yugoslav attack / Mar del Plata variation)

${YELLOW}fen2board${NC}
Converts a FEN stored in clipboard to a board position
Try with this in your clipboard:   r5r1/5Rbk/p6Q/1p1PpN2/4P1p1/8/PP3PP1/6K1 b - - 0 37
To use figurines instead of letters, enter ${YELLOW}fen2board w${NC} if you have a white background, or ${YELLOW}fen2board d${NC} for dark background.

${YELLOW}moves2board${NC}
Gets chess moves from the clipboard and outputs the board at the final position.
Try with this in your clipboard:   1. e4 e5 2. Nf3 Nc6 3. Bb5 Nf6 4. O-O Nxe4 5. d4 Be7 6. dxe5 *
To use figurines instead of letters, enter ${YELLOW}moves2board w${NC} if you have a white background, or ${YELLOW}moves2board d${NC} for dark background. You can add ${YELLOW}-r${NC} to see the board from the blacks perspective.

${YELLOW}moves2anim${NC}
Gets moves from the clipboard and shows the board move by move.
Try with this in your clipboard:   1. e4 e5 2. Nf3 Nc6 3. Bb5 Nf6 4. O-O Nxe4 5. d4 Be7 6. dxe5 *
To use figurines instead of letters, enter ${YELLOW}moves2anim w${NC} if you have a white background, or ${YELLOW}moves2anim d${NC} for dark background. You can add ${YELLOW}-r${NC} to see the board from the blacks perspective.
          " | more
    ;;

    install)
        sudo apt-get install pgn-extract xsel moreutils lynx
        sudo updatedb && locate eco.pgn > ~/Desktop/my_eco.pgn_file_is_here.txt
        export ECO_FILE=`cat ~/Desktop/my_eco.pgn_file_is_here.txt`
        echo -en '\n# Make ECO file and its 2,014 openings and variations available to pgn-extract\nexport ECO_FILE="' >> ~/.bashrc
        cat ~/Desktop/my_eco.pgn_file_is_here.txt >> ~/.bashrc
        echo -en '"\n\n# Loads chess hacks functions\nif [ -f ~/bin/chesshacks.sh ]; then\n   . ~/bin/chesshacks.sh load\nfi\n' >> ~/.bashrc
        rm ~/Desktop/my_eco.pgn_file_is_here.txt
        mkdir -p ~/bin
        cp $prog ~/bin/
        . ~/.bashrc
        $prog load
    ;;

    l | load)
    # Loads the functions below; re-indenting...
   # 1...
  # 2...
 # 3...
#--------------------------------------------------------------------------
# Check for missing commands
needed_commands="sed awk pgn-extract xsel sponge pee curl perl"

missing_counter=0
for needed_command in $needed_commands; do
    if ! hash "$needed_command" >/dev/null 2>&1; then
        printf "Command not found in PATH: %s\n" "$needed_command" >&2
        : $((missing_counter++))
    fi
done

if [[ $missing_counter -eq 1 ]]; then
    printf "At least %d command is missing, install it\n" "$missing_counter" >&2
    exit 1
elif [[ $missing_counter -gt 1 ]]; then
    printf "At least %d commands are missing, install them\n" "$missing_counter" >&2
    exit 2
fi
#--------------------------------------------------------------------------


# = CHESS HACKS = #

#--------------------------------------------------------------------------
# = Functions to manipulate and enhance data in .pgn files =
#
# Careful: option with FEN can duplicate the FEN comment (ugly); apply only
# if FEN is really missing
#
# Openings come from  ftp://ftp.cs.kent.ac.uk/pub/djb/Extract/eco.pgn, 
# which also comes with the  pgn-extract package

# Edits PGN files: adds ECO, Opening, Variation
pgneco ()
{
    if [[ "$1" = "-all" ]]
    then
        for i in *.pgn; do pgneco "$i"; done
    else
        pgn-extract -s -e "$1" | sponge "$1" ;
    fi
}
export -f pgneco

# Edits PGN files: adds end-game FEN
pgnfen ()
{
    if [[ "$1" = "-all" ]]
    then
        for i in *.pgn; do pgnfen "$i"; done
    else
        pgn-extract -s -F "$1" | sponge "$1" ;
    fi
}
export -f pgnfen

# Edits PGN files: adds ECO, Opening, Variation, plus end-game FEN
pgnecofen ()
{
    if [[ "$1" = "-all" ]]
    then
        for i in *.pgn; do pgnecofen "$i"; done
    else
        pgn-extract -s -F -e "$1" | sponge "$1" ;
    fi
}
export -f pgnecofen

#--------------------------------------------------------------------------

pgn365 ()
{
     # Saves and tidify pgn from a 365chess.com link
     # Usage example:
     #    pgn365 www.365chess.com/view_game.php?g=3962489
     # or simply
     #    pgn365 3962489

     # Temporary file
     mkdir -p $HOME/tmp  &&  temp_file=$(mktemp --tmpdir=$HOME/tmp ${prog}.XXXXXXXXXX)

     input=$(echo "$1" | sed 's#http://www.365chess.com/view_game.php?g=##')
     my_url="http://www.365chess.com/view_game.php?g=$input"

     lynx -dump "$my_url" 2>&- > $temp_file
     sed -i '
          s#^  *##
          /^ *$/ d
          s# vs. #_#
          s#\[wp.gif\]  #White: #
          s#\[bp.gif\]  #Black: #
          s#Date:#\n&#
          s#Score:#\nResult:#
          s#½#1/2#g
          /^Looking up/ d
          /BUTTON/,$ d' $temp_file

     title=$(sed 1q $temp_file | sed "s/ /_/g")
     year=$(sed -n '/Date/ p' $temp_file | sed 's#^.*\(....\) *$#\1#')

     sed -i '
          1,/Close/ d
          /BUTTON/,$ d
          s# *$##
          s#.*#[&]#
          s#: # "#
          s#\]$#"&#' $temp_file

     echo >> $temp_file

     curl -s "$my_url" |
          sed -n '/game1.ApplyPgnMoveText/ p' |
          sed "s#.*game1.ApplyPgnMoveText('\(.*\)'.*#\1#" |
          sed 's#  *# #g' | 
          fold -w 78 -s >> $temp_file

     pgn-extract -s -F -e $temp_file > $input-$title.pgn
     rm -f $temp_file
}
export -f pgn365

#--------------------------------------------------------------------------

grepp ()
# Auxiliary function to grep by paragraphs
{
    [[ $# -eq 1 ]] && perl -00ne "print if /$1/i" || perl -00ne "print if /$1/i" < "$2"
}
export -f grepp

#--------------------------------------------------------------------------

str2eco ()
# Lists all openings with given string(s)
     # e.g: (1) single input; (2) two inputs: print any; (3) two inputs: separated by unescaped space: both must occur
     # (1) str2eco elephant
     # (1) str2eco ruy\ lopez           # escaped spaces: counts as one string
     # (2) str2eco bayonet\|crab        # bayonet OR crab
     # (3) str2eco KGD gambit           # show all gambits stemming from KGD (i.e. gambit AND KGD)
     # (3) str2eco "1. e4 c6" gambit    # show all gambits that start with Caro-Kann
{
     echo
     # Parses the input string to transform input variables 'a b c AND d' into string 'grepp "a b c" | grepp "d" | bash'
#    USERINPUTGREPP=$(echo "$*" | sed 's/^/grepp \"/' | sed 's/ *AND */" \| grepp  "/g' | sed 's/$/"/')
     cat $ECO_FILE | sed '/^[[:blank:]]*$/d' |   # Remove blank lines from the eco.pgn file
          sed 's/^\[ECO/\n&/' |                  # Add blank line before the line with the tag ECO
          grepp "$1" | grepp "$2" | grepp "$3" | # From the result, grep paragraphs that match all of up to 3 strings
          sed '/^\[Opening/ s/\(.*\)\"/\1,"/' |  # Then in the value of tag Opening, add a comma at the end
          sed '/^\[ECO/ s/\"\(.*\)\"/"(\1)"/' |  # Enclose between parentheses the value of tag ECO (the ECO code)
          sed 's/.*\"\(.*\)\".*/"\1"/' |         # Then in the lines with the tags, keep only the values and their ""
          sed ':a ; N ; $!ba ; s/\"\n\"/" "/g' | # Double quotes connected by a line break become connected by space
          sed ':a ; N ; $!ba ; s/\([^"\n]\)\n\([^"\n]\)/\1 \2/g' |    # Same applies to line breaks connecting any other two non-" characters; obviously, then, when there is a " connecting something else, the line break stays
          sed 's/\"//g' | sed 's/, *$//'         # Get rid of the " and eventual trailing commas (whenever no Variation)
}
export -f str2eco

#--------------------------------------------------------------------------

moves2eco ()
# Gets chess moves from the clipboard and outputs ECO, Opening, Variation. SAN = Standard Algebric Notation — but it accepts any.
# Clipboard input must have an ending (score or *). Function has no variables. E.g.:
# 1. d4 Nf6 2. c4 g6 3. Nc3 Bg7 4. e4 d6 5. Nf3 O-O 6. Be2 e5 7. O-O Nc6 *
# returns:
# (E97) King's Indian, orthodox, Aronin-Taimanov variation (Yugoslav attack / Mar del Plata variation)
#
{
     # Temporary file
     mkdir -p $HOME/tmp  &&  temp_file=$(mktemp --tmpdir=$HOME/tmp ${prog}.XXXXXXXXXX)
     
     echo -e "ECO\nOpening\nVariation" > $temp_file.roster  # Create a roster file, to specify the tags in order
     xsel -ob | sed '$ s/$/ */' > $temp_file.input     # Create a file from clipboard input; the "*" is a dummy result
     pgn-extract -R$temp_file.roster -e -s $temp_file.input  |      # Create pgn format, with the specified tags, blank line, and the moves
          sed '/^ *$/,$d' |                  # Delete the moves
          sed 's/.*\"\(.*\)\".*/\1/' |       # Grep only the tag values, inside the quotes
          sed '2 s/$/,/' | sed '$ s/,$//' |  # Put "," at end of L2; subtract it from L$ ("Variation" may be absent)
          sed ':a ; N ; $!ba ; s/\n/ /g'     # Paste lines together, separated by space

     rm -f $temp_file{,.roster,.input} ;     # Remove temp files — and voilà!, you have official opening name
}
export -f moves2eco

#--------------------------------------------------------------------------

fen2board ()
# Converts a FEN stored in clipboard to a board position
# Usage fen2board [w|W|l|L | b|B|d|D]
# Argument is optional; without it, display will be in letters.
# Try it with { "r5r1/5Rbk/p6Q/1p1PpN2/4P1p1/8/PP3PP1/6K1 b - - 0 37" }
{
    # Temporary file
    mkdir -p $HOME/tmp  &&  temp_file=$(mktemp --tmpdir=$HOME/tmp ${prog}.XXXXXXXXXX)
     
    xsel -ob > $temp_file
    echo
    cat $temp_file | sed 's#^[ "{]*\([^ ]*\) .*$#\1#g' |  # Leaves only the position itself
        sed 's#\/#\n#g' |                       # Line breaks: one line per rank
        sed 's#1#.#g' |                         # Changes number 1 to one dot; etc
        sed 's#2#..#g' |
        sed 's#3#...#g' |
        sed 's#4#....#g' |
        sed 's#5#.....#g' |
        sed 's#6#......#g' |
        sed 's#7#.......#g' |
        sed 's#8#........#g' |
        sed "s#.#& #g" |                        # Adds a space after any character
        if [[ "$1" ]]                           # Tests for any inputs; if none, remains as letters
            then
            case "$1" in                        # Determines conversion of UTF-8 figurines depending on background
                W|w|L|l)                        # W(hite) or (L)ight background (e.g.: online chats)
                    sed 'y/PNBRQKpnbrqk/♙♘♗♖♕♔♟♞♝♜♛♚/'  ;;
                B|b|D|d)                        # B(lack) or (D)ark background (e.g.: terminal)
                    sed 'y/PNBRQKpnbrqk/♟♞♝♜♛♚♙♘♗♖♕♔/'  ;;
                *) ;;
            esac
        else
            cat                             # Dummy, to do nothing and not leave an "open pipe" from above
        fi
    cat $temp_file | xsel -ib
    echo -e "\n"
    rm -f $temp_file
}
export -f fen2board

#--------------------------------------------------------------------------

moves2board ()
# Hack to show the board after a series of opening moves stored in clipboard.
# e.g.: if clipboard has "1. e4 e5 2. Nf3 Nc6 3. Bb5 Nf6 4. O-O Nxe4 5. d4 Be7 6. dxe5 *",
# output of "moves2board" will be the below:
#     r . b q k . . r
#     p p p p b p p p
#     . . n . . . . .
#     . B . . P . . .
#     . . . . n . . .
#     . . . . . N . .
#     P P P . . P P P
#     R N B Q . R K .
# To use UTF-8 figurines, enter "moves2board w" if you have a white background, or "moves2board b" for dark background.
# You can add -r to see the board from the blacks perspective
{
    # Temporary file
    mkdir -p $HOME/tmp  &&  temp_file=$(mktemp --tmpdir=$HOME/tmp ${prog}.XXXXXXXXXX)
    
    xsel -ob > $temp_file.A                     # Gets contents from clipboard
    xsel -ob |
        sed 's/\t/ /g' |                        # Replaces tabs for spaces
        sed '/^ *$/d' |                         # Strips away empty lines
        sed '$ s/ *\* *$//' |                   # Strips away marker of unfinished match at end of selection
        sed '$ s/ *[01]-[10] *$//' |            # Strips away markers of 1-0 and 0-1 at end of selection
        sed '$ s| *1/2-1/2 *$||' |              # Strips away markers of 1/2-1/2 at end of selection
        sed '$ s/$/ 94. Ba1-a2/' |              # Adds nonsense move to end, which will trigger an error with a board
        xsel -ib                                # Sends it all back to clipboard
    xsel -ob | moves2eco 2> $temp_file.B &&     # Executes moves2eco function (above) on it; stores the error message
    cat $temp_file.B |                          
        sed '1,/^Failed/d' | sed '1 s/^/\n/' |  # Delete the heading (irrelevant, non-board) lines of error message
        sed 's/./& /g' |                        # Adds horizontal spacing, so the board looks squarish on terminal
        if [[ "$1" ]]                           # Tests for any inputs; if none, remains as letters
        then
            case "$1" in                        # Determines conversion of UTF-8 figurines depending on background
                W|w|L|l)                        # W(hite) or (L)ight background (e.g.: online chats)
                    sed 'y/PNBRQKpnbrqk/♙♘♗♖♕♔♟♞♝♜♛♚/' ;;
                B|b|D|d)                        # B(lack) or (D)ark background (e.g.: terminal)
                    sed 'y/PNBRQKpnbrqk/♟♞♝♜♛♚♙♘♗♖♕♔/' ;;
                R|r|-R|-r)
                    rev | tac ;;
                *) ;;
            esac
        else
            cat                                 # Dummy, to do nothing and not leave an "open pipe" from above
        fi |
        if [[ "$2" ]]                           # Tests for reversal option
        then
            case "$2" in
                R|r|-R|-r)
                    rev | tac ;;
                *)
                    cat ;;
            esac
        else
            cat                                 # Dummy, to do nothing and not leave an "open pipe" from above
        fi
     cat $temp_file.A | xsel -ib                # Sends the original back to clipboard
     rm -f $temp_file{,.A,.B}
}
export -f moves2board

#--------------------------------------------------------------------------

moves2anim ()
# Hack to show the board move by move for a given opening sequence stored in clipboard.
# Try it with e.g.  1. e4 e5 2. Nf3 Nc6 3. Bb5 Nf6 4. O-O Nxe4 5. d4 Be7 6. dxe5 *   in your clipboard
# To use UTF-8 figurines, enter "moves2anim w" if you have a white background, or "moves2anim d" for dark background.
# You can add -r to see the board from the blacks perspective
{
    # Temporary file
    mkdir -p $HOME/tmp  &&  temp_file=$(mktemp --tmpdir=$HOME/tmp ${prog}.XXXXXXXXXX)
    
    # Processes the clipboard
    xsel -ob | sed '/^\[/d' |                   # Gets contents from clipboard, stripping tags
        sed 's/^ *{.*} *$//' |                  # Strips header comments
        sed 's/\t/ /g' |                        # Changes tabs for spaces
        sed '/^ *$/d' > $temp_file.1            # Strips away empty lines
    cat $temp_file.1 |
        sed '$ s/ *\* *$//' |                   # Strips away marker of unfinished match at end of selection
        sed '$ s/ *[01]-[10] *$//' |            # Strips away markers of 1-0 and 0-1 at end of selection
        sed '$ s| *1/2-1/2 *$||' |              # Strips away markers of 1/2-1/2 at end of selection
        sed 's/ *[0-9]\+\. */ /g' |             # Removes numbering
        sed 's/^ *//' |                         # Removes leading spaces
        sed 's/;.*//' |                         # Removes comments
        sed ':a ; N ; $!ba ; s/\n/ /g' > $temp_file.3  # Pastes lines together, separated by space
    cat $temp_file.3 |
        sed 's/{.*}//' |                        # Removes more comments
        sed 's/ \+/\n/g' > $temp_file.2         # Inserts line breaks and sends to another temp file
    sed -i '/^ *$/d' $temp_file.2               # Strips away empty lines

    tput smcup                                  # Saves terminal/screen contents

    plycount=$(cat $temp_file.2 | wc -l)        # Counts number of plies (half-moves) = lines in $temp_file.2
    plynow=0                                    # Starts a counter
    while [[ $plynow -le $plycount ]]           # Loops, each time adding a new line, until the maximum
    do
        plynow=$(($plynow + 1))                 # Increments counter
        cat $temp_file.2 |
            sed -n "1,$plynow p" |              # Gets current line
            xsel -ib                            # Sends it to clipboard
        clear                                   # Clears screen
        echo " "
        cat $temp_file.1                        # Shows moves
        echo -en "\n\n"

        if [[ $(($plynow % 2)) -eq 1 ]]
        then
            echo -en "   $(($plynow / 2 + 1)). "
        else
            echo -en "   $(($plynow / 2))... "
        fi
        cat $temp_file.2 | sed -n "$plynow p"

        if [[ "$1" ]]
        then
            if [[ "$2" ]]                        # Tests for reversal option
            then
                moves2board $1 $2 | sed 's/^/   /'
            else
                moves2board $1 | sed 's/^/   /'
            fi
        else
            moves2board | sed 's/^/   /'         # Adds some leading spacing in previous output
        fi

        echo -e "\n"
        read -sn 1 -p ""
    done
    echo -e "\n"
    read -n1 -p "Press any key to end and go back..."
    tput rmcup                                   # Restores terminal/screen contents

    cat $temp_file.1 | xsel -ib                  # Sends the original back to clipboard
    rm -f $temp_file{,.1,.2,.3}
}
# TODO or FIXME: 
# someone bold enough could rewrite this function to improve on two things:
# 1) Insert every new move without repainting the screen, using escape sequences
# 2) Insert controls to go back and see previous move
export -f moves2anim

#--------------------------------------------------------------------------

pgnsummary ()
{
    # Usage if argument isn't given, or more than one argument
    [[ $# -ne 1 ]] && {
        clear
        echo -e "
     ${LIGHTRED}Description:${NC}
          Gets metadata from all pgn files in current folder and prints it on screen

     ${LIGHTRED}Usage:${NC}
          Displays the date, match result, players, and openings used — for one file or all in folder
          ${YELLOW}pgnsummary file.pgn${NC}
          ${YELLOW}pgnsummary -all${NC}

     ${LIGHTRED}Example:${NC}
          ${YELLOW}pgnsummary fischer_spassky_1992.pgn${NC}
          ${YELLOW}pgnsummary -all${NC}

     ${LIGHTRED}Suggestions:${NC}
          Before running this function, have all pgn files updated, esp. with openings.
          So, run this in the directory:
          ${YELLOW}for i in *.pgn; do pgn-extract -s -e -F \$i | sponge \$i ; done${NC}
        "
        return 1
    } 

    # Temporary file
    mkdir -p $HOME/tmp  &&  temp_file=$(mktemp --tmpdir=$HOME/tmp ${prog}.XXXXXXXXXX)
    
    case $1 in
        all | -all)
            echo -e "${YELLOW}
Date        Result   White                 Black                 ECO  Opening
----------  -------  --------------------  --------------------  ---  ------------------------------------------------------------${NC}"
            for i in *.pgn; do pgnsummary "$i" ; done
            echo
        ;;

        *)
            # Make sure only wanted tags are there, ordered; then delete 1st empty line until eof; then get quotes
            echo -e "Date\nResult\nWhite\nBlack\nECO\nOpening\nVariation" > $temp_file.roster
            pgn-extract -R$temp_file.roster -s "$1" | 
                sed '/^ *$/,$d' | 
                sed 's/.*\"\(.*\)\".*/\1/' > $temp_file.stripped
            # Sometimes the Variation for the opening is being omitted, so we have to check it.
            num_tags=$(cat $temp_file.stripped | wc -l)
            cat $temp_file.stripped |
                sed -e :a -e '1 s/^.\{1,10\}$/& /;ta' |    # correct size of all columns
                sed -e :a -e '2 s/^.\{1,7\}$/& /;ta'  |    
                sed -e :a -e '3 s/^.\{1,20\}$/& /;ta' |
                sed -e :a -e '4 s/^.\{1,20\}$/& /;ta' |
                sed -e :a -e '5 s/^.\{1,3\}$/& /;ta'  |
                if [[ $num_tags -eq 7 ]]
                then
                    sed '6 s/$/,/' |                   # that's just a comma before the variation, if exists
                    sed ':a ; N ; $!ba ; s/\n/ /g'     # pastes lines together
                else
                    sed ':a ; N ; $!ba ; s/\n/ /g'     # pastes lines together
                fi
            # Note: if other tag (like result, white, etc) is missing, we are screwed; I assumed it will not.
            # TODO More elegant: delete a comma at end of last line; no need for 'ifs'
            # TODO After the above, forget the stripped, and just pipe everything all through.
            rm -f $temp_file{,.roster,.stripped}
        ;;
    esac      # This finishes the case for pgnsummary
}
export -f pgnsummary

#--------------------------------------------------------------------------

pgnscore ()
# Gives summary scores for the games
# Example: pgnscore ChessAttack
#    gives a summary of scores from player ChessAttack
# Must have one game per pgn file
{
    if [[ $# -ne 1 ]]; then
        echo "Usage: pgnscore NameofPlayer"
    else
        pgnsummary -all | sed -n "4,$ p" | sed -n "/$1/ p" > pgnsummary.tmp
        # WARNING: commands below depend on exact spacing of the output of function pgnsummary().
        # Change one bit of such function and pgnscore() probably breaks.
        # Should have used more awk then sed.
        # But it was the first approach that occurred to me, and seemed good enough.

        # This crazy kind of parsing:
        # cat pgnsummary.tmp | sed "s|^\(.\{12\}\)\(.\{9\}\)\(.\{22\}\)\(.\{22\}\)\(.*\)|\2|" | sed "s| *$||" > pgnsummary_score.tmp
        # has been simplified for the more elegant one that follows:
        awk '{print $2}' pgnsummary.tmp > pgnsummary_score.tmp
        awk '{print $3}' pgnsummary.tmp > pgnsummary_white.tmp
        awk '{print $4}' pgnsummary.tmp > pgnsummary_black.tmp

        # ------------------------------------------------------------------- #
        # TODO:  Rewrite scoring  and  tables  below  with  awk  — would  be  #
        # simpler,  more  elegant, more  robust.  But  it isn't  broken,  so, #
        # not important. Only glitch is columns not perfectly aligned.        #
        # ------------------------------------------------------------------- #
        paste pgnsummary_white.tmp pgnsummary_score.tmp |
            sed -n "/$1/ p" | sed "s|.*\t||" |
            pee "grep -oi ^1-0 | wc -l" "grep -oi ^0-1 | wc -l" "grep -oi ^1/2-1/2 | wc -l" > pgnsummary_white_score.tmp

        paste pgnsummary_black.tmp pgnsummary_score.tmp |
            sed -n "/$1/ p" | sed "s|.*\t||" |
            pee "grep -oi ^0-1 | wc -l" "grep -oi ^1-0 | wc -l" "grep -oi ^1/2-1/2 | wc -l" > pgnsummary_black_score.tmp

        paste pgnsummary_white_score.tmp pgnsummary_black_score.tmp |
            sed "s|^\([0-9]*\)\t*\([0-9]*\)|echo \$((\1 + \2))|" > pgnsummary_overall_score.tmp

        games_played=$(sed -n "$=" pgnsummary.tmp)

        winning=$(source pgnsummary_overall_score.tmp | sed "2d" | sed ':i ; $ bf ; N ; s/\n/ / ; bi ; :f' | sed "s,^\([0-9]*\) *\([0-9]*\),echo \"scale=1;100 * (\1 + \2 / 2) / $games_played\" | bc," | bash)


        echo
        echo -e "${YELLOW}Score summary for player ${LIGHTRED}$1${NC}"
        echo "________________________________________________"
        echo -e "                    ${YELLOW}Wins       Losses     Draws${NC}"

        echo -en "Playing as White    "
        cat pgnsummary_white_score.tmp |
            sed ':i ; $ bf ; N ; s/\n/ / ; bi ; :f' |
            sed "s|^\([0-9]*\) \([0-9]*\) \([0-9]*\)|+\1        -\2        =\3|"
        echo -en "Playing as Black    "
        cat pgnsummary_black_score.tmp |
            sed ':i ; $ bf ; N ; s/\n/ / ; bi ; :f' |
            sed "s|^\([0-9]*\) \([0-9]*\) \([0-9]*\)|+\1        -\2        =\3|"
        echo -e "                    ............................"
        echo -en "Overall score       "
        . pgnsummary_overall_score.tmp |
            sed ':i ; $ bf ; N ; s/\n/ / ; bi ; :f' |
            sed "s|^\([0-9]*\) \([0-9]*\) \([0-9]*\)|+\1        -\2        =\3|"
        echo
        echo -e "Games played        $games_played"
        echo -e "Overall winning %   $winning%"
        echo "________________________________________________"
        echo -e "\n"

        rm pgnsummary*.tmp

        # Overall winning percentage = (wins + draws/2) / total games"
    fi
}
export -f pgnscore
# Recovering indentation in ... 
 # 1...
  # 2... 
   # 3...
    ;;
esac      # This finished the case for the input variables ($1)


#------------------END of PROGRAM----------------------------

