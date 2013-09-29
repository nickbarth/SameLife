(function Life () {
  var LIVE = "XX ",
    DEAD = "   "

  function Cell (state, neighbours) {
    this.state = state;
    this.neighbours = neighbours;
  }

  Cell.prototype.getState = function () {
    return this.state;
  }

  Cell.prototype.live = function () {
    if (this.state == LIVE) {
      if (this.neighbours < 2) {
        this.state = DEAD;
      } else if (this.neighbours == 2 || this.neighbours == 3) {
        this.state = LIVE;
      } else if (this.neighbours > 3) {
        this.state = DEAD;
      }
    }

    if (this.state == DEAD) {
      if (this.neighbours == 3) {
        this.state = LIVE;
      }
    }
  }

  function Board (height, width, board) {
      this.height = height || 12;
      this.width = width || 38;
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
      ];
  }

  Board.prototype.step = function (yPos, xPos) {
    var cell, neighbours,
      output = "",
      updatedBoard = [];

    for (y = 0; y < this.height; y++) {
      updatedBoard[y] = [];
      for (x = 0; x < this.width; x++) {
        neighbours = this.countNeighbours(y, x);
        cell = new Cell(this.board[y][x], neighbours);
        cell.live();
        output += cell.getState();
        updatedBoard[y].push(cell.getState());
      }
      output += "\n";
    }

    this.board = updatedBoard;
    console.log(output);
  }

  Board.prototype.isSamePosition = function (y1, x1, y2, x2) {
    return y1 == y2 && x1 == x2;
  }

  Board.prototype.countNeighbours = function (yPos, xPos) {
    var x, y, cell,
      count = 0,
      startY = yPos - 1 > 0 ? yPos - 1 : 0,
      startX = xPos - 1 > 0 ? xPos - 1 : 0,
      endY = yPos + 1 < this.height ? yPos + 1 : this.height - 1,
      endX = xPos + 1 < this.width ? xPos + 1 : this.width - 1;

    for (y = startY; y <= endY; y++) {
      for (x = startX; x <= endX; x++) {
        cell = new Cell(this.board[y][x], 0);
        if (cell.getState() == LIVE && !this.isSamePosition(y, x, yPos, xPos)) {
          count = count + 1;
        }
      }
    }

    return count;
  }

  function Game () {
    this.board = new Board();
  }

  Game.prototype.run = function () {
    setTimeout(function () {
      this.board.step();
      this.run()
    }.bind(this), 200);
  }

  game = new Game();
  game.run();
})();
