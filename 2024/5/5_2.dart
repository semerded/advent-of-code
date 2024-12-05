import 'dart:io';

const String dataPath = "5/5.txt";
Map<int, List<int>> rules = {};

List<List<int>> updatedPages = [];

void main() {
  int result = 0;

  getData(dataPath);
  for (List<int> updatedPage in updatedPages) {
    result += getMiddleNumFromInvalidUpdate(updatedPage);
  }

  print("result: $result");
}

void getData(String path) {
  List<String> data = File(path).readAsLinesSync();

  bool updatedPart = false;
  for (String line in data) {
    line.replaceAll("\n", "");
    if (line == "" && !updatedPart) {
      updatedPart = true;
      continue;
    }
    if (updatedPart) {
      updatedPages.add(line.split(",").map(int.parse).toList());
    } else {
      List<int> pageRule = line.split("|").map(int.parse).toList();
      if (rules.containsKey(pageRule[0])) {
        rules[pageRule[0]]!.add(pageRule[1]);
      } else {
        rules[pageRule[0]] = [pageRule[1]];
      }
    }
  }
}

int getMiddleNumFromInvalidUpdate(List<int> update) {
  for (int i = 0; i < update.length; i++) {
    if (checkIfRuleIsViolated(update, i)) {
      update = fixUpdate(update);
      return update[update.length ~/ 2];
    }
  }
  print(false);
  return 0;
}

bool checkIfRuleIsViolated(List<int> update, int i) {
  if (i == update.length - 1) return false;
  int num = update[i];
  List<int> appliedRules = [];
  for (MapEntry<int, List<int>> entry in rules.entries) {
    if (entry.value.contains(num)) {
      appliedRules.add(entry.key);
    }
  }

  return update.sublist(i + 1, update.length).any((element) => appliedRules.contains(element));
}

List<int> fixUpdate(List<int> update) {
  List<int> validUpdate = List.from(update);
  while (true) {
    int test = 0;
    for (int i = 0; i < update.length; i++) {
      if (checkIfRuleIsViolated(validUpdate, i)) {
        int temp = validUpdate[i];
        validUpdate[i] = validUpdate[i + 1];
        validUpdate[i + 1] = temp;
        test++;
      }
    }
    if (test == 0) {
      break;
    }
  }
  return validUpdate;
}
