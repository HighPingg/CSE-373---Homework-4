import 'dart:io';

void main() {
  Stopwatch stopwatch = new Stopwatch()..start();

  var fileLines =
      new File('./test_files/s-X-12-6').readAsStringSync().split('\n');

  /**  Takes each line from fileLines and turns it into a string */
  List<List<int>> sets = [];
  fileLines.forEach((str) => sets.add(toIntArray(str.trim())));

  /** We will save the first element since that is our Max in U, but we dont need the
	 * first 2 elements since they aren't part of our set.
	*/
  int setMax = sets[0][0];
  sets = sets.sublist(2);

  print('Sets: ${sets}');

  setCover(sets, setMax);

  print('This run: ${stopwatch.elapsed.inMicroseconds} microsecs');
}

List<List<int>> finalResult = [];

void setCover(List<List<int>> sets, int max) {
  finalResult = [];
  backtrack(List.filled(sets.length, []), -1, removeSublists(sets, max), max);
  print('Final Solution: ${finalResult}');
  print('Final Size: ${finalResult.length}');
}

void backtrack(
    List<List<int>> result, int count, List<List<int>> data, int dataRangeMax) {
  if (isSolution(result.sublist(0, count + 1), dataRangeMax)) {
    //print(result.sublist(0, count + 1));

    if ((count + 1 < finalResult.length) || (finalResult.length == 0)) {
      finalResult = result.sublist(0, count + 1);

      return;
    }
  } else {
    List<List<int>> candidates =
        constructCandidates(result.sublist(0, count + 1), data, dataRangeMax);

    count++;

    for (int i = 0; i < candidates.length; i++) {
      result[count] = candidates[i];

      backtrack(result, count, data, dataRangeMax);

      if (count + 1 > finalResult.length) return;
    }
  }
}

List<List<int>> constructCandidates(
    List<List<int>> result, List<List<int>> data, int dataRangeMax) {
  List<bool> covered = List.filled(dataRangeMax, false);
  result.forEach((resultSet) => resultSet.forEach((val) {
        covered[val - 1] = true;
      }));

  List<List<int>> candidates = [];

  for (var list in data) {
    for (var item in list) {
      if (!covered[item - 1]) {
        candidates.add(list);
        break;
      }
    }
  }

  //print(candidates);

  return candidates;
}

int getMax(List<int> list) {
  int max = 0;

  for (var num in list) {
    max = num > max ? num : max;
  }

  return max;
}

bool listEqual(List<int> list1, List<int> list2) {
  if (list1.length != list2.length) return false;

  for (int i = 0; i < list1.length; i++) {
    if (list1[i] != list2[i]) return false;
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

List<List<int>> removeSublists(List<List<int>> sets, int max) {

  List covered = List.filled(max, false);

  sets.sort((a, b) => b.length.compareTo(a.length));

  var copy = new List.from(sets);

  for (var list in copy) {
    if (!covered.every((element) => element == false)) {
      for (var item in list) {
        covered[item - 1] = true;
      }
    } else {
      if (list.length == 0 || covered[list[0] - 1]) {
        sets.remove(list);
      }
    }
  }

  return sets;
}