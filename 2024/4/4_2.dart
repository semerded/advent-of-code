import 'dart:io';

const String inputPath = "4/4.txt";
List<List<String>> wordSearchMatrix = [];
const String xmas = "MAS";

void main() {
  print("Amount of 'X-MAS' found: ${getXMAScountFromMatrix()}");
}

int getXMAScountFromMatrix() {
  int xPos = 0;
  int yPos = 0;
  int xmasCounter = 0;
  List<String> inputData = File(inputPath).readAsLinesSync();
  for (String line in inputData) {
    wordSearchMatrix.add(line.split(""));
  }
  while (yPos + 3 <= wordSearchMatrix.length) {
    while (xPos + 3 <= wordSearchMatrix[0].length) {
      if (searchInSlidingWindow(xPos, yPos)) xmasCounter++;
      xPos++;
    }
    xPos = 0;
    yPos++;
  }
  return xmasCounter;
}

bool searchInSlidingWindow(int xPos, int yPos) {
  List<List<String>> slidingWindowContent = [];
  for (int i = yPos; i < yPos + 3; i++) {
    slidingWindowContent.add(wordSearchMatrix[i].sublist(xPos, xPos + 3));
  }
  String str1 = "";
  String str2 = "";
  for (int j = 0; j < 3; j++) {
    str1 += slidingWindowContent[j][j];
  }

  for (int j = 0; j < 3; j++) {
    str2 += slidingWindowContent[j][(j - 2).abs()];
  }

  return (str1 == xmas || str1 == xmas.split('').reversed.join('')) && (str2 == xmas || str2 == xmas.split('').reversed.join(''));
}
