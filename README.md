# Chess Hacks

> A collection of chess-related command-line functions.

## Dependencies and first steps
To install dependencies, to load all functions, and to make the [Encyclopedia of Chess Openings](https://en.wikipedia.org/wiki/Encyclopaedia_of_Chess_Openings) available to you, just run:
`chesshacks.sh install`

Alternatively, if you prefer, you can also install it by hand. Copy this and paste it in your terminal:
```bash
sudo apt-get install pgn-extract xsel moreutils lynx
sudo updatedb && locate eco.pgn > my_eco.pgn_file_is_here.txt
export ECO_FILE=`cat my_eco.pgn_file_is_here.txt`
echo -en '\n# Make ECO file and its more than 2,000 openings and variations available to pgn-extract\nexport ECO_FILE="' >> ~/.bashrc
cat my_eco.pgn_file_is_here.txt >> ~/.bashrc
echo -en '"\n\n# Loads chess hacks functions\nif [ -f ~/bin/chesshacks.sh ]; then\n   . ~/bin/chesshacks.sh load\nfi\n' >> ~/.bashrc
rm my_eco.pgn_file_is_here.txt
mkdir -p ~/bin
cp chesshacks.sh ~/bin/
. ~/.bashrc
chesshacks.sh load
```

## Loading the functions
If **Chess Hacks** has been installed but in the future you notice that its functions are not working, you can fix it with `chesshacks.sh load` or starting a new bash instance (which reloads `~/.bashrc`).


## Getting help
See usage and example for all these functions, plus some examples of the one-line queries of the `pgn-extract` package, with `chesshacks.sh usage`  OR  `chesshacks.sh -u`.

## Usage

Before anything, let's go through some quick one-liners, most of them using `pgn-extract` package.

### One-liners

*Insert in files.pgn: ECO, Opening, Variation (if any), FEN*

`pgn-extract -s -e -F file.pgn | sponge file.pgn`


*Insert in all PGN files in folder: ECO, Opening, Variation (if any), FEN*

`for i in *.pgn; do pgn-extract -s -e -F $i | sponge $i ; done && clear`


*For file.pgn, give me only the moves, no numbering, no tags*

`pgn-extract --nomovenumbers --noresults --notags -C -N -V file.pgn`


*Splits lotsofmatches.pgn into single files with one game each*

`pgn-extract -#1 lotsofmatches.pgn`


*Easy to read, clean, table, one move per line, Chessmaster format*

`pgn-extract -Wcm file.pgn`


*Query the openings of all matches in this folder*

`cat *.pgn | sed -n '/^.Opening/ s/.*"\(.*\)".*/\1/ p'`


For more on how to use the pgn-extract package, try `pgn-extract -h` or see `pgn-extract`'s [author's page](http://cs.kent.ac.uk/people/staff/djb/pgn-extract/help.html).


And here are the new functions that come with this script:

### Saving a pgn from a 365chess.com link and making it tidy

`pgn365 www.365chess.com/view_game.php?g=3962489`  or   `pgn365 3962489`


### Handling PGN files

Commands: `pgneco`, `pgnfen`, `pgnecofen`, `pgnsummary`, `pgnscore`.

Note: for all commands herein, it is assumed that there is one game per pgn file.

```
FUNCTION        ARGS.             DESCRIPTION
-------------   ---------------   ----------------------------------------------------------------------
pgneco          file.pgn | -all   Adds ECO, Opening, Variation
pgnfen          file.pgn | -all   Adds end-game position (FEN)
pgnecofen       file.pgn | -all   Adds ECO, Opening, Variation, plus end-game position (FEN)
pgnsummary      file.pgn | -all   Outputs data of pgn file(s). Execute with no arguments to get help.
pgnscore        playername        Outputs scores for the player, over all pgn files in current folder.
```

### Direct querying

Commands are: `str2eco`, `moves2eco`, `fen2board`, `moves2board`, `moves2anim`.  

#### str2eco
Queries the Encyclopedia of Chess Openings for all openings with given string(s)
e.g: (1) single input; (2) two inputs: print any; (3) two inputs: separated by unescaped space: both must occur
```
(1) str2eco elephant
(1) str2eco ruy\ lopez         # escaped spaces: counts as one string
(2) str2eco bayonet\|crab      # bayonet OR crab
(3) str2eco KGD gambit         # show all gambits stemming from KGD (i.e. gambit AND KGD)
(3) str2eco "1. e4 c6" gambit  # show all gambits that start with Caro-Kann
```

#### moves2eco
Gets chess moves from the clipboard and outputs best fit of ECO, Opening, Variation. Besides FIDE-enforced SAN, formats may be Coordinate (with or without dashes, in lowercase), LAN, RAN. Check [Chess notation](https://en.wikipedia.org/wiki/Chess_notation) for more information. 

Clipboard input must have an ending (score or *). E.g.: `1. d4 Nf6 2. c4 g6 3. Nc3 Bg7 4. e4 d6 5. Nf3 O-O 6. Be2 e5 7. O-O Nc6 *`. 

Copying the above and running `moves2eco` returns:

`(E97) King's Indian, orthodox, Aronin-Taimanov variation (Yugoslav attack / Mar del Plata variation)`

#### fen2board
Converts a [FEN](https://en.wikipedia.org/wiki/Forsyth–Edwards_Notation) stored in clipboard to a board position. Try with this in your clipboard: `r5r1/5Rbk/p6Q/1p1PpN2/4P1p1/8/PP3PP1/6K1 b - - 0 37`. To use figurines instead of letters, enter `fen2board w` if you have a white background, or `fen2board d` for dark background. 

For example, running the former would yield:
```
♜ . . . . . ♜ . 
. . . . . ♖ ♝ ♚ 
♟ . . . . . . ♕ 
. ♟ . ♙ ♟ ♘ . . 
. . . . ♙ . ♟ . 
. . . . . . . . 
♙ ♙ . . . ♙ ♙ . 
. . . . . . ♔ . 
```

#### moves2board
Gets chess moves from the clipboard and outputs the board at the final position. Try with this in your clipboard:   `1. e4 e5 2. Nf3 Nc6 3. Bb5 Nf6 4. O-O Nxe4 5. d4 Be7 6. dxe5 *`. To use figurines instead of letters, enter `moves2board w` if you have a white background, or `moves2board d` for dark background. You can add `-r` to see the board from the blacks perspective.

For example, running `moves2board w` would yield:
```
♜ . ♝ ♛ ♚ . . ♜ 
♟ ♟ ♟ ♟ ♝ ♟ ♟ ♟ 
. . ♞ . . . . . 
. ♗ . . ♙ . . . 
. . . . ♞ . . . 
. . . . . ♘ . . 
♙ ♙ ♙ . . ♙ ♙ ♙ 
♖ ♘ ♗ ♕ . ♖ ♔ . 
```

#### moves2anim
Gets moves from the clipboard and shows the board move by move. Try with this in your clipboard:   `1. e4 e5 2. Nf3 Nc6 3. Bb5 Nf6 4. O-O Nxe4 5. d4 Be7 6. dxe5 *`. 

To use figurines instead of letters, enter `moves2anim w` if you have a white background, or `moves2anim d` for dark background. You can add `-r` to see the board from the blacks perspective. 

Running `moves2anim w` with the above would refresh the screen and keep playing the game as `enter` is pressed, showing this after the fifth ply:
```
1. e4 e5 2. Nf3 Nc6 3. Bb5 Nf6 4. O-O Nxe4 5. d4 Be7 6. dxe5 *

   3. Bb5
   
   ♜ . ♝ ♛ ♚ ♝ ♞ ♜ 
   ♟ ♟ ♟ ♟ . ♟ ♟ ♟ 
   . . ♞ . . . . . 
   . ♗ . . ♟ . . . 
   . . . . ♙ . . . 
   . . . . . ♘ . . 
   ♙ ♙ ♙ ♙ . ♙ ♙ ♙ 
   ♖ ♘ ♗ ♕ ♔ . . ♖ 
```

Enjoy!
