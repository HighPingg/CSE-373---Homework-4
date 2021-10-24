import 'dart:io';

void main() {
  Stopwatch stopwatch = new Stopwatch()..start();

  var fileLines =
      new File('./test_files/testes').readAsStringSync().split('\n');

  /**  Takes each line from fileLines and turns it into a string */
  List<List<int>> sets = [];
  fileLines.forEach((str) => sets.add(toIntArray(str.trim())));

  /** We will save the first element since that is our Max in U, but we dont need the
	 * first 2 elements since they aren't part of our set.
	*/
  int setMax = sets[0][0];
  sets = sets.sublist(2);

  print('Sets: ${sets}');

  var finalResult = setCover(sets, setMax);
  print('Final Solution: ${finalResult}');
  print('Final Size: ${finalResult.length}');

  print('This run: ${stopwatch.elapsed.inMicroseconds} microseconds');
}

bool foundSetCover = false;

List<List<int>> setCover(List<List<int>> sets, int max) {
  foundSetCover = false;
  var finalResult = backtrack([], sets, max);
  if (finalResult != null) {
    /**
   * The greedy solution doesn't yeild an optimal solution as demonstrated in s-X-12-6. What
   * I have decided to do is to reverse the list and then from the end of the list, keep track
   * of which sets in the rear of the list already have elements. If a list in the front is no
   * longer needed since lists in the rear already have all its elements covered. We will not
   * use it in our final solution.
   */
    var reversedList = new List.from(finalResult.reversed);

    List<bool> covered = List.filled(max, false);

    for (var list in reversedList) {
      if (!covered.every((element) => element == true)) {
        for (var element in list) {
          if (!covered[element - 1]) {
            covered[element - 1] = true;
          }
        }
      } else {
        finalResult.remove(list);
      }
    }

    return finalResult;
  }

  return [];
}

List<List<int>>? backtrack(
    List<List<int>> result, List<List<int>> data, int dataRangeMax) {
  if (isSolution(result, dataRangeMax)) {
    foundSetCover = true;
    return result;
  } else {
    List<List<int>> candidates =
        constructCandidates(result, data, dataRangeMax);

    result.add([]);

    for (List<int> possibleSet in candidates) {
      result[result.length - 1] = possibleSet;

      backtrack(result, data, dataRangeMax);

      if (foundSetCover) {
        return result;
      }
    }

    result.removeAt(result.length - 1);
  }
}

List<List<int>> constructCandidates(
    List<List<int>> result, List<List<int>> data, int dataRangeMax) {
  List<bool> covered = List.filled(dataRangeMax, false);
  result.forEach((resultSet) => resultSet.forEach((val) {
        covered[val - 1] = true;
      }));

  List<double> willCover = List.filled(data.length, 0);
  for (int i = 0; i < data.length; i++) {
    int count = 0;
    for (int j = 0; j < data[i].length; j++)
      if (covered[data[i][j] - 1] == false) count++;

    willCover[i] = count.toDouble();
  }

  List<List<int>> candidates = [];
  while (!listEqualZero(willCover)) {
    int maxIndex = willCover.indexOf(getMax(willCover));

    candidates.add(data[maxIndex]);

    willCover[maxIndex] = 0.0;
  }

  return candidates;
}

double getMax(List<double> list) {
  double max = 0;

  for (var num in list) {
    max = num > max ? num : max;
  }

  return max;
}

bool listEqualZero(List<double> list1) {
  for (int i = 0; i < list1.length; i++) {
    if (list1[i] != 0.0) return false;
  }

  return true;
}

bool isSolution(List<List<int>> result, int dataRangeMax) {
  for (int i = 1; i <= dataRangeMax; i++) {
    bool containsNumber = false;

    result.forEach((List list) {
      containsNumber = containsNumber || list.contains(i);
    });

    if (containsNumber == false) return false;
  }

  return true;
}

List<int> toIntArray(String str) {
  if (str.length == 0) return [];

  var strArray = str.split(' ');
  var intArray = <int>[];

  for (int i = 0; i < strArray.length; i++)
    intArray.add(int.parse(strArray[i]));

  return intArray;
}
