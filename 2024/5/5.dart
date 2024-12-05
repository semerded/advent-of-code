import 'dart:io';

const String dataPath = "5/5.txt";
Map<int, List<int>> rules = {};

List<List<int>> updatedPages = [];

void main() {
  int result = 0;

  getData(dataPath);
  for (List<int> updatedPage in updatedPages) {
    result += getMiddleNumFromValidUpdates(updatedPage);
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

int getMiddleNumFromValidUpdates(List<int> update) {
  for (int i = 0; i < update.length; i++) {
    if (checkIfRuleIsViolated(update, i)) return 0;
  }

  return update[update.length ~/ 2];
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
