import 'dart:io';

const inputPath = "10/10.txt";

List<List<int>> map = [];
const List<List<int>> neighbors = [
  [-1, 0],
  [0, -1],
  [0, 1],
  [1, 0],
];

void main() {
  int score = 0;
  getData();

  for (int row = 0; row < map.length; row++) {
    for (int column = 0; column < map[0].length; column++) {
      if (map[row][column] == 0) {
        List<String> trailheads = [];

        walkTrail(0, row, column, trailheads);
        score += trailheads.length;
      }
    }
  }
  print(score);
}

void getData() {
  List<String> data = File(inputPath).readAsLinesSync();
  for (String line in data) {
    map.add(line.split("").map(int.parse).toList());
  }
}

void walkTrail(int path, int row, int column, List<String> trailheads) {
  for (List<int> neighbor in neighbors) {
    if (outOfMapBoundary(row + neighbor[0], column + neighbor[1])) {
      continue;
    }
    if (map[row + neighbor[0]][column + neighbor[1]] == path + 1) {
      if (map[row + neighbor[0]][column + neighbor[1]] == 9) {
        trailheads.add("${[row + neighbor[0]]}${[column + neighbor[1]]}");
      } else {
        walkTrail(path + 1, row + neighbor[0], column + neighbor[1], trailheads);
      }
    }
  }

  // return score;
}

bool outOfMapBoundary(int row, int column) {
  return row < 0 || row >= map.length || column < 0 || column >= map[0].length;
}
