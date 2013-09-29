using System;

public class Life
{
  private const string LIVE = "XX ";
  private const string DEAD = "   ";

  class Cell {

    private string state;
    private int neighbours;

    public Cell (string state, int neighbours) {
      this.state = state;
      this.neighbours = neighbours;
    }

    public string getState () {
      return state;
    }

    public void live () {
      if (state == LIVE) {
        if (neighbours < 2) {
          state = DEAD;
        } else if (neighbours == 2 || neighbours == 3) {
          state = LIVE;
        } else if (neighbours > 3) {
          state = DEAD;
        }
      }

      if (state == DEAD) {
        if (neighbours == 3) {
          state = LIVE;
        }
      }
    }
  }

  class Board {
    private int width;
    private int height;
    private string[,] board;

    public Board () {
      height = 12;
      width = 38;
      board = new string[,] {
        {DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD},
        {DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD},
        {DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,DEAD,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD},
        {DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,LIVE,DEAD},
        {DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,DEAD,DEAD,DEAD,LIVE,DEAD,DEAD,DEAD,DEAD,LIVE,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,LIVE,DEAD},
        {DEAD,LIVE,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,DEAD,DEAD,DEAD,LIVE,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD},
        {DEAD,LIVE,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,DEAD,DEAD,DEAD,LIVE,DEAD,LIVE,LIVE,DEAD,DEAD,DEAD,DEAD,LIVE,DEAD,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD},
        {DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD},
        {DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,DEAD,DEAD,DEAD,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD},
        {DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD},
        {DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD},
        {DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD}
      };
    }

    public void step () {
      Cell cell;
      int neighbours;
      string output = "";
      string[,] updatedBoard = new string[height,width];

      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          neighbours = countNeighbours(y, x);
          cell = new Cell(board[y,x], neighbours);
          cell.live();
          output += cell.getState();
          updatedBoard[y,x] = cell.getState();
        }
        output += "\n";
      }

      board = updatedBoard;
      Console.WriteLine(output);
    }

    private bool isSamePosition (int y1, int x1, int y2, int x2) {
      return y1 == y2 && x1 == x2;
    }

    public int countNeighbours (int yPos, int xPos) {
      Cell cell;
      int count = 0;

      int startY = yPos - 1 > 0 ? yPos - 1 : 0;
      int startX = xPos - 1 > 0 ? xPos - 1 : 0;
      int endY = yPos + 1 < height ? yPos + 1 : height - 1;
      int endX = xPos + 1 < width  ? xPos + 1 : width - 1;

      for (int y = startY; y <= endY; y++) {
        for (int x = startX; x <= endX; x++) {
          cell = new Cell(board[y,x], 0);
          if (cell.getState() == LIVE && !isSamePosition(y, x, yPos, xPos)) {
            count = count + 1;
          }
        }
      }

      return count;
    }
  }

  class Game {
    Board board;

    public Game () {
      board = new Board();
    }

    public void run () {
      while (true) {
        board.step();
        System.Threading.Thread.Sleep(200);
      }
    }
  }

  public static void Main (string[] args) {
    Game game = new Game();
    game.run();
  }
}
