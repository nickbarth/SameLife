#include <iostream>
#include <string>
#include <unistd.h>

using namespace std;

namespace Life {
  const string LIVE = "XX ";
  const string DEAD = "   ";

  class CRectangle {
    private:
      int x, y;
    public:
      void set_values (int,int);
      int area () {return (x*y);}
      string test ();
  };

  void CRectangle::set_values (int a, int b) {
    x = a;
    y = b;
  }

  string CRectangle::test () {
    return LIVE;
  }

  class Cell {
    private:
      int neighbours;
      string state;
    public:
      Cell (string, int);
      string getState ();
      void live ();
  };

  Cell::Cell (string state, int neighbours) {
    this->state = state;
    this->neighbours = neighbours;
  }

  string Cell::getState () {
    return state;
  }

  void Cell::live () {
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

  class Board {
    private:
      int width;
      int height;
      string board[12][38];
    public:
      Board ();
      void step ();
      bool isSamePosition (int, int, int, int);
      int countNeighbours (int, int);
  };

  Board::Board () : board {
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
  } {
    this->height = 12;
    this->width = 38;
  };

  void Board::step () {
    int neighbours;
    string output = "";
    string updatedBoard[12][38];

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        neighbours = countNeighbours(y, x);
        Cell cell (board[y][x], neighbours);
        cell.live();
        output += cell.getState();
        updatedBoard[y][x] = cell.getState();
      }
      output += "\n";
    }

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        board[y][x] = updatedBoard[y][x];
      }
    }

    cout << output;
  }

  bool Board::isSamePosition (int y1, int x1, int y2, int x2) {
    return y1 == y2 && x1 == x2;
  }

  int Board::countNeighbours (int yPos, int xPos) {
    int count = 0;

    int startY = yPos - 1 > 0 ? yPos - 1 : 0;
    int startX = xPos - 1 > 0 ? xPos - 1 : 0;
    int endY = yPos + 1 < height ? yPos + 1 : height - 1;
    int endX = xPos + 1 < width  ? xPos + 1 : width - 1;

    for (int y = startY; y <= endY; y++) {
      for (int x = startX; x <= endX; x++) {
        Cell cell (board[y][x], 0);
        if (cell.getState() == LIVE && !isSamePosition(y, x, yPos, xPos)) {
          count = count + 1;
        }
      }
    }

    return count;
  }

  class Game {
    private:
      Board board;
    public:
      Game ();
      void run ();
  };

  Game::Game () {
    Board board();
  }

  void Game::run () {
    while (true) {
      board.step();
      usleep(200000);
    }
  }
}

int main () {
  Life::Game game;
  game.run();
  return 0;
}
