---
aliases: [The Odin Project - Chess]
linter-yaml-title-alias: The Odin Project - Chess
created: Sunday, June 18th 2023, 6:20:15 pm
modified: Wednesday, August 16th 2023, 4:09:27 pm
---
# [The Odin Project - Chess](https://www.theodinproject.com/lessons/ruby-ruby-final-project)

Chess is the Ruby Final Project for the Odin Project.

To begin with, I'm porting over most of my code from my [Knight's Travails](https://github.com/taladan/TOP-ruby-kt) solution.  I'll be pulling out any code that isn't relevant to the chess game.  

## Things to Keep in Mind:

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

### Changes to Make:

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


#### Refactor List:
- [ ] Decouple board from pieces and displays
- [ ] Separate data from code:
	- [x] Create lib/data directory
	- [x] Create standard_initial_setup file that stores the starting piece positions for a standard game of chess
- [ ] piece_handler.rb:  
	- [x] need to alter the piece names to use [fen](https://www.chess.com/terms/fen-chess) standard
	- [x] \#add_piece method seems tightly coupled to square.rb - square_handler should probably be called here to swap square's contents
	- [x] Implement custom errors
	- [ ] [[#PieceHandler notes]]
- [ ] display.rb
	- [ ] self.query_for_players
		- [x] Tie in prompts through Messages
	- [ ] self.query_for_game_type
		- [x] Tie in prompts through Messages

 
---

### Features

#### Needed
- [x] Implement class objects for pieces
- [ ] Piece Movement
	- [x] Define piece movements (POSSIBLE_MOVES)
		- [x] king
		- [x] queen
		- [x] bishop
		- [x] knight
		- [x] rook
		- [x] pawn
	- [ ] Pathing
		- [ ] path_clear?
			- [ ] pawn movement
				- [ ] Is the square we're going to occupied?
				- [ ] If it is occupied, is the direction we're going 'forward'(n for white, s for black), or 'diagonal'(ne/nw for white, se/sw for black)
					- [ ] If it is diagonal, is the piece our color?
						- [ ] If it's our color, error
						- [ ] if it's not our color, attack?
					- [ ] if it is forward, error
				- [ ] if it is not occupied, move the piece
				- [ ] En Passant?
			- [x] knight movement
				- [x] Is the square we're going to occupied?
				- [x] If it is occupied, is the piece our color?
					- [x] If it's our color, error
					- [x] if it's not our color, attack?
				- [x] if it is not occupied, move the piece
			- [x] queen movement
			- [ ] king movement
				- [ ] Threatened squares
				- [ ] Castling
			- [x] rook movement
			- [x] bishop movement
- [ ] executable that runs chess
- [ ] Driver module: `./main.rb`
	- [ ] requires:
		- [x] board - `./lib/chess/board.rb' controls board object code
			- [ ] requires square_handler.rb
				- [ ] requires square.rb
		- [x] piece_handler  `./lib/chess/piece_handler.rb` controls movement, placement, creation and identification of pieces
			- [ ] requires chess_pieces(`Pieces`)- `./lib/chess/chess_piece.rb` collection of usable pieces
				- [ ] requires chess_piece.rb, king.rb, queen.rb, rook.rb, bishop.rb, knight.rb, pawn.rb
		- [x] display.rb
		- [x] version.rb
- [ ] Game Startup
	- [x] Print game name/version/author info
	- [x] query user for type of game, standard/custom builtin
	- [ ] query user for computer vs. player or player vs. player
- [x] An initial setup of the board state for a standard game of chess.
	- [x] piece positions:
		- [x] a8 - black queen's rook
		- [x] b8 - black queen's knight
		- [x] c8 - black queen's bishop
		- [x] d8 - black queen
		- [x] e8 - black king
		- [x] f8 - black king's bishop
		- [x] g8 - black king's knight
		- [x] h8 - black king's rook
		- [x] a7-h7 = black pawns
		- [x] a2-h2 = white pawns
		- [x] a1 - white queen's rook
		- [x] b1 - white queen's knight
		- [x] c1 - white queen's bishop
		- [x] d1 - white queen
		- [x] e1 - white king
		- [x] f1 - white king's bishop
		- [x] g1 - white king's knight
		- [x] h1 - white king's rook
- [x] Turn handling (player 1 is always white, player 2 is always black)
- [x] Load custom starting board setups (yml files only)
- [ ] Input handling
- [ ] Piece removal (on capture) - piece_handler.rb
- [ ] Method of recording moves
- [ ] Method of saving data to file
- [ ] Method of loading data from file
- [ ] Data structure for saving
- [ ] Move tracking

#### Wanted

- [x] [[Display]] Board display reversability for 2 player play so 'current player' is always at the bottom of the board facing their opponent
- [ ] Tab completion for moves
- [x] Tab completion for loading custom game setup
- [ ] Game timer
- [ ] Global options configuration - `--board-setup filename.yml` - checks for `./lib/data/filename.yml` or current directory for filename.yml and loads the board setup from there.
- [x] [ASCII Chess pieces](https://en.wikipedia.org/wiki/Chess_symbols_in_Unicode)
- [ ] Help system
- [ ] Color indicated squares to visually indicate squares referenced by the game. (ex: Blocked movements, briefly highlighting the square before moving the piece, etc.)


#### PieceHandler Notes
Okay, so, there's a lot going on in piece handler, and I'm writing this to try and separate out interests here.

**Current requirements:**

"chess_piece"
"piece_maker"
"king"
"queen"
"bishop"
"knight"
"rook"
"pawn"
"errors"

*Are there any ways to compact this?*

**Module declaration**

Currently includes:
- `Pieces` module (provided by `chess_pieces.rb`)
- `ChessErrors` module (provided by `errors.rb`)

We have a class variable declaration `@@valid_piece_names` (_**outside a class**_ This is bad practice and should be moved into a class).  It gives an array of string characters representing all valid piece names.

Below we will have a list of all methods that currently exist in piece handler.  A breakdown of the method will be:
**What does it do?**
**Where does it belong?**

**Methods:**
- `add_piece(piece,position)`
	This method takes a single string character in the form of 'P' `piece`, and a square name in the form of 'a1' `position` - should change from position to 'square_name'.  

	**What does it do?**
	1. It checks that the square's name is in the @valid_squares instance variable and errors if it isn't.
	2. It checks that the class var `@@valid_piece_names` includes the piece name, and errors if it doesn't
	3. Sets the color to "white" if the value of piece is uppercase
	4. Sets the color to "black" if the value of the piece is lowercase
	5. gets the class object of the `position` using `find_square_by_name` which is provided by `square_handler.rb` and sets it to the variable `square`
	6. makes a chesspiece calling PieceMaker.make_piece(piece, color, square)
	7. sets square.contents to the value of chesspiece

	This method is parsing strings to: retrieve a board square's object, create a piece, and assigns that piece to the square.
 
	**Where does it belong?**
 
	`PieceHandler`
 
- `calculate_possible_moves(from_square)`
	takes either a string representation of a square name or a square object

	**What does it do?**
 
	1. sets up an empty array named `possible_moves`.
	2. Sets 'piece' to the contents of from_square
			1. If from_square is a string it uses `find_square_by_name`
			2. if it's a square, it just pulls the square contents
	3. sets the pieces' current x,y position to 'current'
	4. iterates through all possible moves on a piece and:
		1. calls `add_current_and_possible_squares(current, move)` to get a two value array that reflects a possible board position
		2. wraps the above call in a call to `validate_position` to ensure the position returned a valid position on the board and isn't occupied by a piece of the same color
		3. rescue invalid targets so they're not added to the `possible_moves` array.
	5. returns a compacted array `possible_moves` to remove any `nil` values

	This method is supposed to calculate all possible moves for a piece in a given square.  It might be better to refactor this down and move it to either square handler or directly to the `ChessPiece` class
 
	**Where does it belong?**

	At this point, I feel like it should go into the `ChessPiece` class so the syntax would change to `Piece.calculate_possible_moves`.
 
 
- `self.all_possible_opponents(color)`
	Takes a string `color` that should be either `"black"` or `"white"`

	**What does it do?**
	1. create an empty array named `output`
	2. Iterate through all objects `ChessPiece` and pack only pieces that have a `color` attribute that doesn't match the `color` variable passed in the initial call
	3. return the array `output` of piece objects

	**Where does it belong?**
	`PieceHandler` - but it could probably have a better name `all_opponent_pieces` or something similar.  Also may be able to shorten it (get rid of empty array declaration) by using the select method:
	
	`ObjectSpace.each_object(ChessPiece).select {|piece| piece.color != color`
 
 
- `create_piece(piece, color, square)`
	Takes a single character string for `piece`, a string value for `color` and a string value for `square`
 
	**What does it do?**
	Runs through a case statement matching against uppercase piece names and calls the `new` method on each individual piece to instantiate a piece class
 
	**Where does it belong?**
	 `PieceHandler`
 

##### Pathing stuff
 
- `path_clear?(from, to, player)`
	Takes a `Square` object `from` and a `Square` object `to` and a `player` object
	
	**What does it do?**
	Too much!
	1. gets the direction of movement `direction` by calling `determine_direction(from, to)`
	2. grabs the `piece` that's trying to move in `from.contents`
	3. sets an array of squares as `path` with `get_path(from, to, direction` unless the `piece` is a `Knight` object (knights don't path like any other piece in the game as they jump for their movements)
	4. if piece is a `Pawn` object, call `pawn_check(piece, direction, path)`
	5. if piece is a `Knight` object, call `knight_check(piece, to)
	6. if piece is a `King` object, call `castle_check` if the piece hasn't moved, is moving either east or west and the path is exactly 3 squares long (inclusive). otherwise, call `king_check`
	7. call `piece_check(player, path)` for all other pieces
 
	**Where does it belong?**
	 I feel like this probably needs to be broken down and segregated out into some sort of `Pathing` class?  Not sure yet.
 
- `pawn_check(piece, direction, path)`
	Takes a `piece` object, a `direction` key and an array of squares `path`
 
	**What does it do?**
	1. Raises an error if piece can't move in the direction indicated
	2. Determines if movement is a standard movement or an attack movement (pawns can only attack diagonally, can only move forward).
 
	**Where does it belong?**
	This feels like it belongs in pathing
 
- `pawn_movement(piece, path)`
	takes a `piece` object and a `path` array

	**What does it do?**
	 1. raises an error if the path length is greater than the `piece.move_limit(:move)`
	 2. raise an error if the last square of `path` is occupied (pawns can't attack when moving forward)
	 3. sets the `piece.has_moved` value to true unless it's already true
	 4. returns true
  
	**Where does it belong?**
	  This is doing too much - shouldn't be setting values and returning false/true. I'm not sure where this should live yet, though it is dealing with pathing, it's tied closely to `Pawn` objects.
 
- `pawn_attack(piece, path)`
	Takes a `piece` object and a `path` array.

	**What does it do?**
	1. raise an error if the path length is greater than the `piece.move_limit(:attack)` (pawns can only move one space during an attack)
	2. set `target` to the last square object in `path`
	3. returns false unless target is occupied and its contents are an opponent's piece (not the same color as the attacking piece)
	4. returns true by default
	 
	**Where does it belong?**
	possibly pathing, possibly on a pawn-rules specific object
 
- `en_passant?(piece, path)`

	**What does it do?**
	 returns true/false checking against:
		 path.count must be equal to 3,
		 `path.last.position[0]` (row/rank number) must be equal to the correct row/rank for en_passant (5 for 'black', 4 for 'white'),
		 and a call to the target square's `en_passant_neighbors?` method
	 if any of these checks are false, it returns false, if all are true, it returns true
 
	**Where does it belong?**
	possibly pathing, possibly a pawn-rules specific object
 
- `en_passant`

	**What does it do?**
	nothing right now - this method hasn't been completed yet
 
	**Where does it belong?**
	 probably pathing
 
- `knight_check(piece, target)`
	takes `piece` object and `target` square object

	**What does it do?**
	returns false if a piece that matches `piece.color` is on the target square
	returns true otherwise
	
	**Where does it belong?**
	possibly pathing, possibly PieceHandler
 
- `king_check(piece, path)`
	takes a `piece` object and a `path` array

	**What does it do?**
	Currently not working
 
	**Where does it belong?**
	possibly pathing, possibly PieceHandler
 
- `castle_check`

	**What does it do?**
	 currently not working
 
	**Where does it belong?**
	possibly pathing, possibly PieceHandler
 
- `piece_check(player, path)`
	takes a `player` object and `path` array of `Square` objects
	
	**What does it do?**
	1. sets `output` to `true`
	2. iterates through path
		1. skip the first square in `path`
		2. if the current square we're iterating over is the last object in the `path` array
			1. maintain output = true if the square is occupied by an opponent's piece
		3. if current square isn't the last and it's occupied, set `output` to `false`
		4. return the value of output
 
	**Where does it belong?**
	This could be cleaned up, possibly with filter or reduce.  Should probably live in pathing
 
- `old_path_clear?(from, to, player)`
	this is an old method that has only been left for reference and will be removed
 
	**What does it do?**
	 NA
  
	**Where does it belong?**
	 NA
  
- `determine_direction(from, to)`
	takes two `Square` objects `from` and `to`
	
	**What does it do?**
	 1. uses a spaceship operator (<=>)  to set a value for `row` (either -1, 0 or 1) by comparing `from.x` and `to.x`
	 2. uses a spaceship operator (<=>)  to set a value for `col`  (either -1, 0 or 1) by comparing `from.y` and `to.y`
	 3. passes the value of `[row,col]` to a case statement to determine direction of movement of the piece
 
	**Where does it belong?**
	 probably pathing
  
- `get_path(from, to, direction, current_postion = from.position, output = [])`
	takes two `Square` objects (`from` and `to`), a `direction` key/symbol, an x/y position (defaults to `from.position`) and an `output` array that defaults to an empty array
 
	**What does it do?**
	This is a recursive method.
	1. gets the square object from `current_position` with `find_square_by_position`
	2. pushes `square` into the `output` array
	3. return the value of output if `current_position` is equal to `to.position`
	4. gets the value of the next position in `direction`
	5. recurses with `next_position` in place of `current_position` in the `get_path` call
 
	**Where does it belong?**
	 pathing


##### Square handling methods
- `validate_position(square, color)`
	Takes an x/y position array or a `Square` object as `square` and a string `color`
	
	**What does it do?**
	1. If `square` is an array, get the square object with `find_square_by_position(square)` & set it to `target_square`
	2. If `square` is a `Square` object, set it to `target_square`
	3. raise error if `target_square.position` isn't on the board
	4. raise an error if `target_square` is occupied by a matching piece (`color`)
	5. return the value of `target_square` if it's empty
	6. return the value of `target_square` if it's occupied by an opponent's piece
 
	**Where does it belong?**
	 `SquareHandler`
  
- `swap_contents(from, to, piece)`
	takes a `Square` object in `from`, a `Square` object in `to` and a `ChessPiece` object as `Piece`
	**What does it do?**
	 1. sets the contents of `to` to the value of `from.contents`
	 2. sets the contents of `from` to `nil`
	 3. sets the value of `piece.current_square` to the value of to
 
	**Where does it belong?**
	 `SquareHandler`

- `move_piece(from_square, to_square, player, override: false)`
	Takes string square name for `from_square` and string square name for `to_square`,  `player` object, and a boolean key `:override`

	**What does it do?**
	1. perform check that `from_square` is in the `@valid_squares` instance variable (from `Board`)
	2. perform check that `to_square` is in the `@valid_squares` instance variable (from `Board`)
	3. an override check when false:
		1. sets `valid_moves` variable to an array of x,y square positions via `get_square_positions(calculate_possible_moves(from_square))`
		2. sets `target` square using `find_square_by_name(to_square)`
		3. Raises an error unless `target.position` is in `valid_moves`
	4. call `put_piece(from_square, to_square, player)`
	5. return `nil`
 
	**Where does it belong?**
	This feels like it should belong in SquareHandler. May change my mind on this.
 
- `put_piece(from_square, to_square, player)`
	takes a string `from_square` and a string `to_square` that are both square names (i.e. a1), and a `player` object.

	**What does it do?**
	1. load `square` object into `from` using `find_square_by_name` (provided by square handler)
	2.  load `square` object into `to` using `find_square_by_name` (provided by square handler)
	3. load `piece` (`from.contents`)
	4. raise error if `from` is empty
	5. raise error if `path_clear?` check is false
	6. call `swap_contents(from, to, piece)` unless `validate_position(to.position, piece.color)` returns nil
 
	**Where does it belong?**
	This method feels like it's doing a lot and could either live in `PieceHandler` or `SquareHandler`.  This is the first (and only) call to `path_clear?` Although pathing is a relatively complex subject here.  Pathing may need to just be broken out into a class on its own.
 
- `get_square_positions(array_of_squares)`
	Takes an array of square objects
 
	**What does it do?**
	Outputs an array of square x/y positions
 
	**Where does it belong?**
	 `SquareHandler`
  
- `self.calculate_opponent_threats(square)`
	Takes a `Square` object, acts as an class method
	
	**What does it do?**
	1. get an array of all of the pieces that oppose the piece in `square`
	2. create an empty `threat_array`
	3. iterate through the array of opponent pieces
		1. get an array of possible moves for each piece in `piece_moves`
		2. pack that piece if `piece_moves` includes `square` (should refactor to either check against `square.position` or have `calculate_possible_moves` return an array of square objects instead of positions)
	4. return the value of `threat_array`
 
	**Where does it belong?**
	This is calculating squares, it should probably be in `SquareHandler`
 
- `add_current_and_possible_squares(current, possible)`
	Takes a two value array `current` and a two value array `possible`
 
	**What does it do?**
	1. combines current & possible into a single array `[current, possible]` then `transpose` to mutate the arrays so that we end up with `[[current[0], possible[0], [current[1], possibe[1]]` as our working array, then `map` over each pair of values a `reduce` to add them together.

 
	**Where does it belong?**
	This is calculating square positionals, so it should be in `SquareHandler`