import 'dart:io';

const String inputPath = "4/4.txt";
List<List<String>> wordSearchMatrix = [];
const String xmas = "XMAS";

void main() {
  print("Amount of 'XMAS' found: ${getXMAScountFromMatrix()}");
}

int getXMAScountFromMatrix() {
  int xPos = 0;
  int yPos = 0;
  int xmasCounter = 0;
  List<String> inputData = File(inputPath).readAsLinesSync();
  for (String line in inputData) {
    wordSearchMatrix.add(line.split(""));
  }
  while (yPos + 4 <= wordSearchMatrix.length) {
    while (xPos + 4 <= wordSearchMatrix[0].length) {
      xmasCounter += searchInSlidingWindow(xPos, yPos);
      xPos++;
    }
    xPos = 0;
    yPos++;
  }
  return xmasCounter;
}

int searchInSlidingWindow(int xPos, int yPos) {
  int xmasCounter = 0;
  List<List<String>> slidingWindowContent = [];
  for (int i = yPos; i < yPos + 4; i++) {
    slidingWindowContent.add(wordSearchMatrix[i].sublist(xPos, xPos + 4));
  }

  for (int i = 0; i < 4; i++) {
    if (yPos + 4 == wordSearchMatrix.length && i >= yPos % 4) {
      if (searchHorizontal(i, slidingWindowContent)) xmasCounter++;
    } else if (yPos % 4 == 0) {
      if (searchHorizontal(i, slidingWindowContent)) xmasCounter++;
    }
    if (xPos + 4 == wordSearchMatrix[0].length && i >= xPos % 4) {
      if (searchVertical(i, slidingWindowContent)) xmasCounter++;
    } else if (xPos % 4 == 0) {
      if (searchVertical(i, slidingWindowContent)) xmasCounter++;
    }
    if (i < 2) {
      if (searchDiagonal(i, slidingWindowContent)) xmasCounter++;
    }
  }

  return xmasCounter;
}

bool searchHorizontal(int i, List<List<String>> content) {
  String str = "";
  for (int j = 0; j < 4; j++) {
    str += content[i][j];
  }
  return str == xmas || str == xmas.split('').reversed.join('');
}

bool searchVertical(int i, List<List<String>> content) {
  String str = "";
  for (int j = 0; j < 4; j++) {
    str += content[j][i];
  }
  return str == xmas || str == xmas.split('').reversed.join('');
}

bool searchDiagonal(int i, List<List<String>> content) {
  String str = "";
  if (i == 0) {
    for (int j = 0; j < 4; j++) {
      str += content[j][j];
    }
  } else {
    for (int j = 0; j < 4; j++) {
      str += content[j][(j - 3).abs()];
    }
  }
  return str == xmas || str == xmas.split('').reversed.join('');
}
