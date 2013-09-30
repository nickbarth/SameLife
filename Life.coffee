LIVE = "XX "
DEAD = "   "

class Cell
  constructor: (state, neighbours) ->
    this.state = state
    this.neighbours = neighbours

  get_state:  ->
    this.state

  live: ->
    if this.state == LIVE
      if this.neighbours < 2
        this.state = DEAD
       else if this.neighbours == 2 or this.neighbours == 3
        this.state = LIVE
       else if this.neighbours > 3
        this.state = DEAD

    if this.state == DEAD
      if this.neighbours == 3
        this.state = LIVE

class Board
  constructor: (height, width, board) ->
    this.height = height || 12
    this.width = width || 38
    this.board = board || [
      [DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD],
      [DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD],
      [DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,DEAD,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD],
      [DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,LIVE,DEAD],
      [DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,DEAD,DEAD,DEAD,LIVE,DEAD,DEAD,DEAD,DEAD,LIVE,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,LIVE,DEAD],
      [DEAD,LIVE,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,DEAD,DEAD,DEAD,LIVE,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD],
      [DEAD,LIVE,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,DEAD,DEAD,DEAD,LIVE,DEAD,LIVE,LIVE,DEAD,DEAD,DEAD,DEAD,LIVE,DEAD,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD],
      [DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD],
      [DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,DEAD,DEAD,DEAD,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD],
      [DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD],
      [DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD],
      [DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD]
    ]

  step: (y_pos, x_pos) ->
    output = ""
    updated_board = []

    for y in [0...this.height]
      updated_board[y] = []
      for x in [0...this.width]
        neighbours = this.count_neighbours(y, x)
        cell = new Cell(this.board[y][x], neighbours)
        cell.live()
        output += cell.get_state()
        updated_board[y].push cell.get_state()

      output += "\n"

    this.board = updated_board
    console.log output

  same_position: (y1, x1, y2, x2) ->
    y1 == y2 && x1 == x2

  count_neighbours: (y_pos, x_pos) ->
    count = 0

    start_y = if y_pos - 1 > 0 then y_pos - 1 else 0
    start_x = if x_pos - 1 > 0 then x_pos - 1 else 0
    end_y = if y_pos + 1 < this.height then y_pos + 1 else this.height - 1
    end_x = if x_pos + 1 < this.width then x_pos + 1 else this.width - 1

    for y in [start_y..end_y]
      for x in [start_x..end_x]
        cell = new Cell(this.board[y][x], 0)
        if cell.get_state() == LIVE and not this.same_position(y, x, y_pos, x_pos)
          count = count + 1

    count

class Game
  constructor: () ->
    this.board = new Board()

  run: () ->
    setTimeout () =>
      this.board.step()
      this.run()
    , 200

game = new Game()
game.run()
