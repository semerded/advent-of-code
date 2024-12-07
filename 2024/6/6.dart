import 'dart:io';

List<List<String>> map = [];
const String mapPath = "6/6.txt";

void main() {
  getMap();
  Guard guard = Guard(map);

  while (!guard.isOutOfBoundary()) {
    guard.moveOnePos();
    guard.stepTracer!.traceStep(guard.pos!);
  }
  print(guard.stepTracer!.getSteps);
}

void getMap() {
  List<String> lines = File(mapPath).readAsLinesSync();
  for (String line in lines) {
    map.add(line.split(""));
  }
}

class Guard {
  final List<List<int>> directionMapping = [
    [0, -1],
    [1, 0],
    [0, 1],
    [-1, 0]
  ].toList(growable: false); // up, right, down, left
  int directionIndex = 0;
  List<List<String>> map;
  List<int>? pos;
  StepTracer? stepTracer;

  Guard(this.map) {
    getStartingPos();
    this.stepTracer = StepTracer(pos!);
  }

  void getStartingPos() {
    for (int row = 0; row < this.map.length; row++) {
      final int column = map[row].indexOf("^");
      if (column != -1) {
        this.pos = [column, row]; // x y
      }
    }
  }

  void moveOnePos() {
    List<int> newPos = _getNewPos;
    if (this.map[newPos[1]][newPos[0]] == "#") {
      directionIndex++;
      if (directionIndex > 3) directionIndex = 0;
    }
    this.pos = _getNewPos;
  }

  List<int> get _getNewPos {
    return [this.pos![0] + directionMapping[directionIndex][0], this.pos![1] + directionMapping[directionIndex][1]];
  }

  bool isOutOfBoundary() {
    return _getNewPos[1] == this.map.length || _getNewPos[0] == this.map[0].length || _getNewPos[1] == -1 || _getNewPos[0] == -1;
  }
}

class StepTracer {
  List<List<int>> uniqueSteps = [];

  StepTracer(List<int> startPos) {
    uniqueSteps.add(startPos);
  }

  void traceStep(List<int> pos) {
    if (!uniqueSteps.any((element) => element.toString() == pos.toString())) uniqueSteps.add(pos);
  }

  int get getSteps {
    return uniqueSteps.length;
  }
}
