import 'dart:io';
import 'package:collection/collection.dart';

List<List<String>> map = [];
List<List<int>> initialPath = [];
const String mapPath = "6/6.txt";

const ListEquality listEquality = ListEquality();

void main() {
  Stopwatch stopwatch = Stopwatch()..start();

  getMap();

  int loopPossibilities = 0;

  Guard initialGuard = Guard(map);

  while (!initialGuard.isOutOfBoundary()) {
    initialGuard.moveOnePos();
    initialGuard.stepTracer!.traceStep(initialGuard.pos!, initialGuard.directionIndex);
  }
  initialPath = initialGuard.stepTracer!.steps;

  for (int i = 0; i < initialPath.length - 1; i++) {
    // -1 to skip the last valid tile

    print("${(i / (initialPath.length - 1) * 100).toStringAsPrecision(3)}%");

    Guard guard = Guard(map);
    // guard.setPosToTracedStep(initialGuard.stepTracer!, i);
    while (!guard.isOutOfBoundary()) {
      // print("${(i / (initialPath.length - 1) * 100).toStringAsPrecision(3)}% ${guard.stepTracer!.getSteps}" );

      if (guard.isLooping(initialPath[i + 1]) || guard.stepTracer!.getSteps == 50000) {
        loopPossibilities++;

        break;
      }
      guard.moveOnePosWithVirtualWall(initialPath[i + 1]);
      guard.stepTracer!.traceStep(guard.pos!, guard.directionIndex);
    }
  }
  stopwatch.stop();

  print("found $loopPossibilities loop possibilities");
  print("found in ${stopwatch.elapsed.inSeconds} s");
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
  List<int>? startPos;
  int repeatedStepCount = 0;

  Guard(this.map) {
      this.pos = getStartingPos()!;
      this.startPos = this.pos;
      this.stepTracer = StepTracer(this.pos!, this.directionIndex);
  }

  List<int>? getStartingPos() {
    for (int row = 0; row < this.map.length; row++) {
      final int column = map[row].indexOf("^");
      if (column != -1) {
        return [column, row]; // x y
      }
    }
    return null;
  }

  void moveOnePos() {
    List<int> newPos = _getNextTile;
    if (this.map[newPos[1]][newPos[0]] == "#") {
      directionIndex++;
      if (directionIndex > 3) directionIndex = 0;
    }
    this.pos = _getNextTile;
  }

  void moveOnePosWithVirtualWall(List<int> virtualWallPos) {
    List<int> newPos = _getNextTile;
    if (this.map[newPos[1]][newPos[0]] == "#" || listEquality.equals(newPos, virtualWallPos)) {
      directionIndex++;
      if (directionIndex > 3) directionIndex = 0;
    }
    this.pos = _getNextTile;
  }

  List<int> virtualMoveWithVirtualWall(List<int> virtualWallPos) {
     List<int> newPos = _getNextTile;
     int dirI = this.directionIndex;
    if (this.map[newPos[1]][newPos[0]] == "#" || listEquality.equals(newPos, virtualWallPos)) {
      dirI++;
      if (dirI > 3) dirI = 0;
    }
    return  _getNextTile;
  }

  List<int> get _getNextTile {
    return [this.pos![0] + directionMapping[directionIndex][0], this.pos![1] + directionMapping[directionIndex][1]];
  }



  bool isLooping(List<int> virtualWallPos) {
    List<int> virualNextPos = virtualMoveWithVirtualWall(virtualWallPos);
    int index = this.stepTracer!.steps.indexWhere((list) => listEquality.equals(list, virualNextPos));
    return index != -1 && index != this.stepTracer!.direction.length - 1 && this.directionIndex == this.stepTracer!.direction[index];
  }

  void setPosToTracedStep(StepTracer stepTracer, int startIndex) {
    this.pos = stepTracer.steps[startIndex];
    this.directionIndex = stepTracer.direction[startIndex];
  }

  bool isOutOfBoundary() {
    return _getNextTile[1] == this.map.length || _getNextTile[0] == this.map[0].length || _getNextTile[1] == -1 || _getNextTile[0] == -1;
  }
}

class StepTracer {
  List<List<int>> steps = [];
  List<int> direction = [];

  StepTracer(List<int> startPos, int directionIndex) {
    steps.add(startPos);
    direction.add(directionIndex);
  }

  void traceStep(List<int> pos, int directionIndex) {
    steps.add(pos);
    direction.add(directionIndex);
  }

  void traceUniqueStep(List<int> pos, int directionIndex) {
    if (!steps.any((element) => element.toString() == pos.toString())) {
      steps.add(pos);
      direction.add(directionIndex);
    }
  }

  int get getSteps {
    return steps.length;
  }
}
