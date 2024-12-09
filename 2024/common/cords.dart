class Cord {
  int x;
  int y;

  Cord(this.x, this.y);

  String get string {
    return "$x$y";
  }

  List<int> get list {
    return [x, y];
  }

  bool compare(Cord compareCord) {
    return this.x == compareCord.x && this.y == compareCord.y;
  }
}
