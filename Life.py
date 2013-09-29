import time

LIVE = "XX "
DEAD = "   "

class Cell:

  def __init__(self, state, neighbours):
    self.state = state
    self.neighbours = neighbours

  def get_state(self):
    return self.state

  def live(self):
    if self.state == LIVE:
      if self.neighbours < 2:
        self.state = DEAD
      elif self.neighbours == 2 or self.neighbours == 3:
        self.state = LIVE
      elif self.neighbours > 3:
        self.state = DEAD

    elif self.state == DEAD:
      if self.neighbours == 3:
        self.state = LIVE

class Board:

  def __init__(self, height=12, width=38, board=None):
    self.height = height
    self.width = width
    self.board = board or [
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

  def step(self):
    output = "";
    updated_board = [[]]

    for y in range(0, self.height):
      for x in range(0, self.width):
        neighbours = self.countNeighbours(y, x)
        cell = Cell(self.board[y][x], neighbours)
        cell.live()
        output += cell.get_state()
        updated_board[y].append(cell.get_state())

      output += "\n";
      updated_board.append([])

    self.board = updated_board;
    print(output)

  def isSamePosition (self, y1, x1, y2, x2):
    return y1 == y2 and x1 == x2

  def countNeighbours (self, yPos, xPos):
    count = 0;

    startY = yPos - 1 if yPos - 1 > 0 else 0
    startX = xPos - 1 if xPos - 1 > 0 else 0
    Y = yPos + 1 if yPos + 1 < self.height else self.height - 1
    X = xPos + 1 if xPos + 1 < self.width else self.width - 1

    for y in range(startY, Y+1):
      for x in range(startX, X+1):
        cell = Cell(self.board[y][x], 0)
        if cell.get_state() == LIVE and not self.isSamePosition(y, x, yPos, xPos):
          count = count + 1;

    return count

class Game:

  def __init__(self):
    self.board = Board()

  def run(self):
    while True:
      self.board.step()
      time.sleep(0.2)

if __name__ == '__main__':
  game = Game()
  game.run()
