import 'dart:html';
import 'dart:math';
import 'dart:async';

void main() {
  final CanvasElement canvas = document.querySelector('#canvas');
  new Life(canvas);
}

class Life {
  CanvasElement canvas;
  Random random;
  int size;
  int width;
  int height;
  List<bool> cells;
  List<bool> drawn;
  var timer;
  
  Life(this.canvas) {
    random = new Random();
    size = 8;
    width = canvas.width ~/ size;
    height = canvas.height ~/ size;
    cells = new List<bool>(width * height);
    drawn = new List<bool>(width * height);
    init(true);
    canvas.onClick.listen((e) {
      init(false);
    });
    timer=new Stream.periodic(const Duration(milliseconds:1),
        (count) =>step());
    timer.listen((result) {
        step();
      });
  }
  
  void init(bool first) {
    double p = 0.25;
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        int i = y * width + x;
        if (first) {
          drawn[i] = false;
        }
        if (random.nextDouble() < p) {
          cells[i] = true;
        }
        else {
          cells[i] = false;
        }
      }
    }
  }
  
  int neighbors(int x, int y) {
    int result = 0;
    for (int ny = y - 1; ny <= y + 1; ny++) {
      for (int nx = x - 1; nx <= x + 1; nx++) {
        if (nx == x && ny == y) {
          continue;
        }
        if (nx < 0 || nx >= width || ny < 0 || ny >= height) {
          continue;
        }
        int i = ny * width + nx;
        if (cells[i]) {
          result += 1;
        }
      }
    }
    return result;
  }
  
  
  void step() {
    List<bool> next = new List<bool>(width * height);
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        int i = y * width + x;
        int n = neighbors(x, y);
        next[i] = false;
        if (cells[i]) {
          if (n == 2 || n == 3) {
            next[i] = true;
          }
        }
        else {
          if (n == 3) {
            next[i] = true;
          }
        }
      }
    }
    cells = next;
    draw();
  }
  
  void draw() {
    var context = canvas.getContext("2d");
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        int i = y * width + x;
        if (cells[i] != drawn[i]) {
          if (cells[i]) {
            context.fillStyle = 'black';
          }
          else {
            context.fillStyle = 'white';
          }
          context.beginPath();
          context.rect(x * size, y * size, size, size);
          context.fill();
          drawn[i] = cells[i];
        }
      }
    }
  }
}
