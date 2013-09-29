module Life
  LIVE = "XX "
  DEAD = "   "

  class Cell
    attr_accessor :state, :neighbours

    def initialize (state, neighbours)
      self.state = state
      self.neighbours = neighbours
    end

    def get_state
      state
    end

    def live
      if state == LIVE
        if neighbours < 2
          self.state = DEAD
        elsif neighbours == 2 or self.neighbours == 3
          self.state = LIVE
        elsif neighbours > 3
          self.state = DEAD
        end
      elsif state == DEAD
        if neighbours == 3
          self.state = LIVE
        end
      end
    end
  end

  class Board
    attr_accessor :height, :width, :board

    def initialize (height=12, width=38, board=nil)
      self.height = height
      self.width = width
      self.board = board || [
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
    end

    def step
      output = ""
      updated_board = [[]]

      for y in 0...height
        for x in 0...width
          neighbours = countNeighbours(y, x)
          cell = Cell.new(board[y][x], neighbours)
          cell.live
          output += cell.get_state
          updated_board[y].push cell.get_state
        end
        output += "\n"
        updated_board.push([])
      end

      self.board = updated_board
      puts output
    end

    def samePosition? (y1, x1, y2, x2)
      y1 == y2 && x1 == x2
    end

    def countNeighbours (yPos, xPos)
      count = 0

      startY = yPos - 1 > 0 ? yPos - 1 : 0
      startX = xPos - 1 > 0 ? xPos - 1 : 0
      endY = yPos + 1 < height ? yPos + 1 : height - 1
      endX = xPos + 1 < width  ? xPos + 1 : width - 1

      for y in startY..endY
        for x in startX..endX
          cell = Cell.new(board[y][x], 0)
          if cell.get_state == LIVE and not samePosition?(y, x, yPos, xPos)
            count = count + 1
          end
        end
      end

      count
    end
  end

  class Game
    attr_accessor :board

    def initialize
      self.board = Board.new
    end

    def run
      while true do
        board.step
        sleep 0.2
      end
    end
  end
end

if __FILE__ == $0
  game = Life::Game.new
  game.run
end
