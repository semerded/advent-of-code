import 'dart:io';

class RedNosedReportChecker {
  String? filename;
  List<String>? report;

  RedNosedReportChecker(this.filename) {
    report = File(this.filename!).readAsLinesSync();
  }

  int checkReports({bool tolerateSingleBadLevel = false}) {
    int safeReports = 0;
    for (String line in this.report!) {
      List<int> lineContent = line.split(" ").map(int.parse).toList();
      if (!tolerateSingleBadLevel) {
        if (_checkSingleReport(lineContent)) safeReports++;
      } else {
        if (_checkSingleReportsWithSingleTolerate(lineContent)) safeReports++;
      }
    }
    return safeReports;
  }

  bool _checkSingleReport(List<int> lineContent) {
    bool? ascending;
    int? previousNumber;

    for (int i = 0; i < lineContent.length; i++) {
      int number = lineContent[i];
      if (i == 0) {
        previousNumber = number;
        continue;
      }

      // check for direction breach
      if (ascending == null) {
        ascending = previousNumber! < number;
      }
      if ((previousNumber! < number && !ascending) || (previousNumber > number && ascending) || previousNumber == number) {
        return false;
      }

      // check for jump breach
      if ((previousNumber - number).abs() > 3) {
        return false;
      }

      previousNumber = number;
    }

    return true;
  }

  bool _checkSingleReportsWithSingleTolerate(List<int> lineContent) {
    for (int i = 0; i < lineContent.length; i++) {
      List<int> singleTolerate = List<int>.from(lineContent);
      singleTolerate.removeAt(i);
      if (_checkSingleReport(singleTolerate)) return true;
    }
    return false;
  }
}

void main() {
  RedNosedReportChecker reportChecker = RedNosedReportChecker("2024/day/2.txt");
  print("Part 1: ${reportChecker.checkReports()}");
  print("Part 2: ${reportChecker.checkReports(tolerateSingleBadLevel: true)}");
}
