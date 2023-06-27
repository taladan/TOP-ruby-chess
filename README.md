# [The Odin Project - Chess](https://www.theodinproject.com/lessons/ruby-ruby-final-project)

Chess is the Ruby Final Project for the Odin Project.

To begin with, I'm porting over most of my code from my [Knight's Travails](https://github.com/taladan/TOP-ruby-kt) solution.  I'll be pulling out any code that isn't relevant to the chess game.  

## Things to keep in mind:

- [ ] [Chess notation](https://www.dummies.com/article/home-auto-hobbies/games/board-games/chess/understanding-chess-notation-192295/)

The moves of chess are outlined in algebraic notation where:

`1. e4 e5`

Encompases all of turn one.  e4 represents the white piece's move and e5 represents the black piece's move.  In this case, `e` represents the 'file' where the movement starts.  Because there is no letter designator (K, Q, R, N, B), it indicates that a pawn is being moved, and `4` represents the rank where the piece is ending it's move.  So, the white pawn in file 'e' moves forward to rank '4'.  Then the black pawn in file 'e' moves forward to rank '5'.

When referencing a piece, the abbreviation for that piece is always capitalized:
    - K - king
    - Q - queen
    - R - rook
    - B - bishop
    - N - knight
    
- [ ] Look up [PGN (Portable Game Notation)](https://en.wikipedia.org/wiki/Portable_Game_Notation) stuff

[PGN Standard](https://ia902908.us.archive.org/26/items/pgn-standard-1994-03-12/PGN_standard_1994-03-12.txt) is a plain text format for recording chess games (both moves and related data).

## Todo:

### Needs:

- [ ] An initial setup of the board state for a standard game of chess. 
- [ ] Turn handling (player 1 is always white, player 2 is always black) 
- [ ] Input handler 
- [ ] Piece removal (on capture)
- [ ] Method of recording moves 
- [ ] Method of saving data to file 
- [ ] Method of loading data from file
- [ ]  

### Wants:
- [ ] Board display reversability for 2 player play so 'current player' is always at the bottom of the board facing their opponent 
- [ ] Tab completion for moves 
- [ ] 