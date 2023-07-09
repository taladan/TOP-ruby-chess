# [The Odin Project - Chess](https://www.theodinproject.com/lessons/ruby-ruby-final-project)

Chess is the Ruby Final Project for the Odin Project.

To begin with, I'm porting over most of my code from my [Knight's Travails](https://github.com/taladan/TOP-ruby-kt) solution.  I'll be pulling out any code that isn't relevant to the chess game.  

## Things to keep in mind:

- [ ] [Chess notation](https://www.dummies.com/article/home-auto-hobbies/games/board-games/chess/understanding-chess-notation-192295/)

The moves of chess are outlined in algebraic notation where:

`1. e4 e5`

Encompasses all of turn one.  'e4' represents the white piece's move and 'e5' represents the black piece's move.  In this case, `e` represents the 'file' where the movement starts.  Because there is no letter designator (K, Q, R, N, B), it indicates that a pawn is being moved, and `4` represents the rank where the piece is ending it's move.  So, the white pawn in file 'e' moves forward to rank '4'.  Then the black pawn in file 'e' moves forward to rank '5'.

When referencing a piece, the abbreviation for that piece is capitalized for white pieces and lowercase for black pieces per the [FEN](https://www.chess.com/terms/fen-chess) standard.
    - K - White King
    - Q - White Queen
    - R - White Rook
    - B - White Bishop
    - N - White Knight
    - P - White Pawn
    - k - Black King
    - q - Black Queen
    - r - Black Rook
    - b - Black Bishop
    - n - Black Knight
    - p - Black Pawn
    
- [ ] Look up [PGN (Portable Game Notation)](https://en.wikipedia.org/wiki/Portable_Game_Notation) stuff

[PGN Standard](https://ia902908.us.archive.org/26/items/pgn-standard-1994-03-12/PGN_standard_1994-03-12.txt) is a plain text format for recording chess games (both moves and related data).

## Todo:
Please note, this is a working list of things to do.  It will likely change and expand over time.

### Changes to make:

#### Notes:
This is mostly going to be stuff that needs to be refactored.  I'm starting out with a good chunk of code that I wrote for [Knight's Travails](https://github.com/taladan/TOP-ruby-kt).  The files I'll be using are:

- [bishop.rb](https://github.com/taladan/TOP-ruby-kt/blob/main/lib/bishop.rb)
- [board.rb](https://github.com/taladan/TOP-ruby-kt/blob/main/lib/board.rb)
- [chess_piece.rb](https://github.com/taladan/TOP-ruby-kt/blob/main/lib/chess_piece.rb)
- [display.rb](https://github.com/taladan/TOP-ruby-kt/blob/main/lib/display.rb)
- [king.rb](https://github.com/taladan/TOP-ruby-kt/blob/main/lib/king.rb)
- [knight.rb](https://github.com/taladan/TOP-ruby-kt/blob/main/lib/knight.rb)
- [pawn.rb](https://github.com/taladan/TOP-ruby-kt/blob/main/lib/pawn.rb)
- [piece_handler.rb](https://github.com/taladan/TOP-ruby-kt/blob/main/lib/piece_handler.rb)
- [queen.rb](https://github.com/taladan/TOP-ruby-kt/blob/main/lib/queen.rb)
- [rook.rb](https://github.com/taladan/TOP-ruby-kt/blob/main/lib/rook.rb)
- [square.rb](https://github.com/taladan/TOP-ruby-kt/blob/main/lib/square.rb)
- [square_handler.rb](https://github.com/taladan/TOP-ruby-kt/blob/main/lib/square_handler.rb)


#### List:
- [ ] Decouple board from pieces and displays
- [ ] Separate data from code:
	- [x] Create lib/data directory
	- [x] Create standard_initial_setup file that stores the starting piece positions for a standard game of chess
- [ ] piece_handler.rb:  
	- [x] need to alter the piece names to use [fen](https://www.chess.com/terms/fen-chess) standard
	- [ ] \#add_piece method seems tightly coupled to square.rb - square_handler should probably be called here to swap square's contents
	- [x] Implement custom errors
	- [ ] decouple \#put_piece from square.rb

---

### Features

#### Needed
- [x] Implement class objects for pieces
- [ ] Define piece movements (POSSIBLE_MOVES)
	- [x] king
	- [x] queen
	- [x] bishop
	- [x] knight
	- [x] rook
	- [ ] pawn
- [ ] executable that runs chess
- [ ] Driver module 
	- [ ] requires:
		- [ ] board.rb - controls board object code
			- [ ] requires square_handler.rb
				- [ ] requires square.rb
		- [ ] piece_handler.rb - controls movement, placement, creation and identification of pieces
			- [ ] requires pieces/pieces.rb - collection of usable pieces
				- [ ] requires chess_piece.rb, king.rb, queen.rb, rook.rb, bishop.rb, knight.rb, pawn.rb
		- [ ] display.rb
		- [ ] version.rb
	  - [ ] features:
		  - [ ] query user for type of game, standard/custom builtin
- [x] An initial setup of the board state for a standard game of chess. 
	- [ ] piece positions:
		- [ ] a8 - black queen's rook
		- [ ] b8 - black queen's knight
		- [ ] c8 - black queen's bishop
		- [ ] d8 - black queen
		- [ ] e8 - black king
		- [ ] f8 - black king's bishop
		- [ ] g8 - black king's knight
		- [ ] h8 - black king's rook
		- [ ] a7-h7 = black pawns
		- [ ] a2-h2 = white pawns
		- [ ] a1 - white queen's rook
		- [ ] b1 - white queen's knight
		- [ ] c1 - white queen's bishop
		- [ ] d1 - white queen
		- [ ] e1 - white king
		- [ ] f1 - white king's bishop
		- [ ] g1 - white king's knight
		- [ ] h1 - white king's rook
- [ ] Turn handling (player 1 is always white, player 2 is always black) 
- [ ] Input handling
- [ ] Piece removal (on capture) - piece_handler.rb
- [ ] Method of recording moves 
- [ ] Method of saving data to file 
- [ ] Method of loading data from file
- [ ] Data structure for saving
- [ ] Move tracking

#### Wanted

- [x] Board display reversability for 2 player play so 'current player' is always at the bottom of the board facing their opponent 
- [ ] Tab completion for moves 
- [ ] Game timer
- [ ] Global options configuration - `--board-setup filename.yml` - checks for `./lib/data/filename.yml` or current directory for filename.yml and loads the board setup from there.
- [ ] [ASCII Chess pieces](https://en.wikipedia.org/wiki/Chess_symbols_in_Unicode)
