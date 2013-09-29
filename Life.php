<?php

namespace Life;

const LIVE = "XX ";
const DEAD = "   ";

class Cell {
  private $state;
  private $neighbours;

  public function __construct ($state, $neighbours) {
    $this->state = $state;
    $this->neighbours = $neighbours;
  }

  public function getState () {
    return $this->state;
  }

  public function live () {
    if ($this->state == LIVE) {
      if ($this->neighbours < 2) {
        $this->state = DEAD;
      } else if ($this->neighbours == 2 || $this->neighbours == 3) {
        $this->state = LIVE;
      } else if ($this->neighbours > 3) {
        $this->state = DEAD;
      }
    }

    if ($this->state == DEAD) {
      if ($this->neighbours == 3) {
        $this->state = LIVE;
      }
    }
  }
}

class Board {
  private $width;
  private $height;
  private $board;

  public function __construct () {
    $this->height = 12;
    $this->width = 38;
    $this->board = array(
      array(DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD),
      array(DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD),
      array(DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,DEAD,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD),
      array(DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,LIVE,DEAD),
      array(DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,DEAD,DEAD,DEAD,LIVE,DEAD,DEAD,DEAD,DEAD,LIVE,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,LIVE,DEAD),
      array(DEAD,LIVE,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,DEAD,DEAD,DEAD,LIVE,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD),
      array(DEAD,LIVE,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,DEAD,DEAD,DEAD,LIVE,DEAD,LIVE,LIVE,DEAD,DEAD,DEAD,DEAD,LIVE,DEAD,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD),
      array(DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD),
      array(DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,DEAD,DEAD,DEAD,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD),
      array(DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,LIVE,LIVE,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD),
      array(DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD),
      array(DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD,DEAD)
    );
  }

  public function step () {
    $cell = null;
    $neighbours;
    $output = "";
    $updatedBoard = array();

    for ($y = 0; $y < $this->height; $y++) {
      for ($x = 0; $x < $this->width; $x++) {
        $neighbours = $this->countNeighbours($y, $x);
        $cell = new Cell($this->board[$y][$x], $neighbours);
        $cell->live();
        $output .= $cell->getState();
        $updatedBoard[$y][] = $cell->getState();
      }
      $output .= "\n";
    }

    $this->board = $updatedBoard;
    echo $output;
  }

  private function isSamePosition ($y1, $x1, $y2, $x2) {
    return $y1 == $y2 && $x1 == $x2;
  }

  public function countNeighbours ($yPos, $xPos) {
    $cell = null;
    $count = 0;

    $startY = $yPos - 1 > 0 ? $yPos - 1 : 0;
    $startX = $xPos - 1 > 0 ? $xPos - 1 : 0;
    $endY = $yPos + 1 < $this->height ? $yPos + 1 : $this->height - 1;
    $endX = $xPos + 1 < $this->width ? $xPos + 1 : $this->width - 1;

    for ($y = $startY; $y <= $endY; $y++) {
      for ($x = $startX; $x <= $endX; $x++) {
        $cell = new Cell($this->board[$y][$x], 0);
        if ($cell->getState() == LIVE && !$this->isSamePosition($y, $x, $yPos, $xPos)) {
          $count++;
        }
      }
    }

    return $count;
  }
}

class Game {
  private $board;

  public function __construct () {
    $this->board = new Board();
  }

  public function run () {
    while (true) {
      $this->board->step();
      usleep(200000);
    }
  }
}

if (!count(debug_backtrace())) {
  $game = new Game();
  $game->run();
}
