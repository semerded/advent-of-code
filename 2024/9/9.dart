import 'dart:io';

const String inputPath = "9/9.txt";

String diskMap = "";
List<String> diskBlocks = [];

void main() {
  getData();
  getDiskBlocks();
  moveDiskBlocks();

  print(calculateChecksum());
}

void getData() {
  diskMap = File(inputPath).readAsLinesSync()[0];
}

void getDiskBlocks() {
  List<String> diskSplit = diskMap.split("");
  diskBlocks = [];
  int id = 0;
  for (int i = 0; i < diskSplit.length; i++) {
    if (i % 2 == 0) {
      for (int j = 0; j < int.parse(diskSplit[i]); j++) {
        diskBlocks.add(id.toString());
      }
      id++;
    } else {
      for (int j = 0; j < int.parse(diskSplit[i]); j++) {
        diskBlocks.add(".");
      }
    }
  }
}

void moveDiskBlocks() {
  for (int i = 0; i < diskBlocks.length; i++) {
    int emptySpot = diskBlocks.indexOf(".");
    int block = diskBlocks.lastIndexWhere((block) => int.tryParse(block) != null);

    diskBlocks[emptySpot] = diskBlocks[block];
    diskBlocks[block] = ".";
  }
}

int calculateChecksum() {
  int checksum = 0;
  for (int i = 0; i < diskBlocks.length; i++) {
    if (diskBlocks[i] != ".") checksum += i * int.parse(diskBlocks[i]);
  }
  return checksum;
}
