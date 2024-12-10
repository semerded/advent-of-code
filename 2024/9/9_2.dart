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
  List<String> handledIds = [];
  for (int i = diskBlocks.length - 1; i >= 0; i--) {
    print("${((diskBlocks.length - i) / diskBlocks.length * 100).toStringAsFixed(3)}%");

    if (diskBlocks[i] == "." || handledIds.contains(diskBlocks[i])) continue;

    bool succes = true;
    int blockLength = 0;

    String block = diskBlocks[i];

    int blockIterator = i;

    handledIds.add(block);

    while (diskBlocks[blockIterator] == block) {
      blockLength++;
      blockIterator--;
      if (blockIterator < 0) {
        succes = false;
        break;
      }
    }
    if (!succes) continue;

    int emptySpot = diskBlocks.indexOf(".");
    int emptySpotLength = 0;
    int emptySpotIterator = emptySpot;
    while (emptySpotLength < blockLength) {
      if (emptySpotIterator >= diskBlocks.length) {
        succes = false;
        break;
      }

      if (diskBlocks[emptySpotIterator] != ".") {
        emptySpotLength = 0;
      } else {
        emptySpotLength++;
      }
      emptySpotIterator++;
    }

    if (!succes || emptySpotIterator > i) continue;

    for (int j = emptySpotIterator - emptySpotLength; j < emptySpotIterator; j++) diskBlocks[j] = block;

    for (int j = blockIterator + 1; j < blockIterator + blockLength + 1; j++) diskBlocks[j] = ".";
  }
}

int calculateChecksum() {
  int checksum = 0;
  for (int i = 0; i < diskBlocks.length; i++) {
    if (diskBlocks[i] != ".") checksum += i * int.parse(diskBlocks[i]);
  }
  return checksum;
}
