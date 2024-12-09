import 'dart:io';

const filePath = "7/7.txt";
const operators = ["+", "*", "||"];

List<Map<String, dynamic>> calibrationEquations = [];
List<List<String>> operatorCombinations = [];

void main() async {
  int total = 0;

  getData();
  await getOperatorCombinationsPerLength();
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
            case "||":
              result = int.parse(result.toString() + number.toString());
              print(result);
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

Future<void> getOperatorCombinationsPerLength() async {
  int longestEquation = calibrationEquations.reduce((a, b) => a['numbers'].length > b['numbers'].length ? a : b)["numbers"].length;
  for (int i = 0; i < longestEquation; i++) {
    operatorCombinations.add([]);
    (await generateOperatorCombinations(operators, i + 2, "", operatorCombinations[i]));
  }
}

Future<void> generateOperatorCombinations(
    List<String> operators, int length, String current, List<String> result) async {
  
  if (current.length == length) {
    result.add(current);
    return;
  }

  for (var char in operators) {
    await generateOperatorCombinations(operators, length, current + char, result);

    await Future.delayed(Duration(milliseconds: 0));
  }
    }