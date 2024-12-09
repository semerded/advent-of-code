import 'dart:io';

import '../common/cords.dart';

Map<String, List<Cord>> antennas = {};
List<List<String>> map = [];
List<Cord> antizones = [];

const String inputPath = "8/8.txt";

void main() {
  getData();
  locateAntennas();
  findAntispots();
  print(antizones.length);
}

void getData() {
  List<String> lines = File(inputPath).readAsLinesSync();
  for (String line in lines) {
    map.add(line.split(""));
  }
}

void locateAntennas() {
  for (int i = 0; i < map.length; i++) {
    for (int j = 0; j < map[i].length; j++) {
      String item = map[i][j];
      if (item != ".") {
        if (antennas.containsKey(item)) {
          antennas[item]!.add(Cord(j, i));
        } else {
          antennas[item] = [Cord(j, i)];
        }
      }
    }
  }
}

void findAntispots() {
  for (List<Cord> positions in antennas.values) {
    for (int i = 0; i < positions.length; i++) {
      for (int j = i + 1; j < positions.length; j++) {
        List<Cord> antennasPos = [positions[i], positions[j]];
        int xDif = antennasPos[0].x - antennasPos[1].x;
        int yDif = antennasPos[0].y - antennasPos[1].y;

        for (int k = 0; k < 2; k++) {
          int counter = 0;
          Cord antennaPos = antennasPos[k];
          if (k == 1) {
            xDif *= -1;
            yDif *= -1;
          }
          while (true) {
            Cord antizone = Cord(antennaPos.x + (xDif * counter), antennaPos.y + (yDif * counter));

            if (!(antizone.x >= 0 && antizone.x < map[0].length && antizone.y >= 0 && antizone.y < map.length)) break;
            if (!antizones.any((cord) => cord.compare(antizone))) {
              antizones.add(antizone);
            }
            counter++;
          }
        }
      }
    }
  }
}
