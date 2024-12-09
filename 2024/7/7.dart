import 'dart:io';

const filePath = "7/7.txt";
const operators = ["+", "*"];

List<Map<String, dynamic>> calibrationEquations = [];
List<List<String>> operatorCombinations = [];

void main() {
  int total = 0;

  getData();
  getOperatorCombinationsPerLength();
  for (Map<String, dynamic> calibrationEquation in calibrationEquations) {
    List<String> _operatorCombinations = operatorCombinations[calibrationEquation["numbers"].length - 1];
    int expectedResult = calibrationEquation["result"];
    for (String operatorCombination in _operatorCombinations) {
      List<String> _operatorCombination = operatorCombination.split("");
      int? result = null;
      for (int i = 0; i < calibrationEquation["numbers"].length; i++) {
        int number = calibrationEquation["numbers"][i];
        if (result == null) {
          result = number;
        } else {
          switch (_operatorCombination[i]) {
            case "+":
              result += number;
            case "*":
              result *= number;
          }
        }
      }
      if (result == expectedResult) {
        total += result!;
        break;
      }
    }
  }
  print(total);
}

void getData() {
  List<String> lines = File(filePath).readAsLinesSync();
  for (String line in lines) {
    List<String> _line = line.split(": ");
    calibrationEquations.add({"result": int.parse(_line[0]), "numbers": _line[1].split(" ").map(int.parse).toList()});
  }
}

void getOperatorCombinationsPerLength() {
  int longestEquation = calibrationEquations.reduce((a, b) => a['numbers'].length > b['numbers'].length ? a : b)["numbers"].length;
  for (int i = 0; i < longestEquation; i++) {
    operatorCombinations.add([]);
    (generateOperatorCombinations(operators, "", i + 2, operatorCombinations[i]));
  }
}

void generateOperatorCombinations(List<String> operators, String current, int length, List<String> result) {
  if (current.length == length) {
    result.add(current);
    return;
  }

  for (var operator in operators) {
    generateOperatorCombinations(operators, current + operator, length, result);
  }
}
