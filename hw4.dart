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

  setCover(sets, setMax);

  print('This run: ${stopwatch.elapsed.inMicroseconds} microsecs');
}

List<List<int>> finalResult = [];

void setCover(List<List<int>> sets, int max) {
  finalResult = [];
  backtrack([], sets, max);
  print('Final Solution: ${finalResult}');
  print('Final Size: ${finalResult.length}');
}

void backtrack(List<List<int>> result, List<List<int>> data, int dataRangeMax) {
  if ((result.length > finalResult.length) && (finalResult.length != 0)) return;

  if (isSolution(result, dataRangeMax)) {
    //print(result);

    if ((result.length < finalResult.length) || (finalResult.length == 0)) {
      finalResult = [];
      result.forEach((element) => finalResult.add(element));

      return;
    }
  } else {
    List<List<int>> candidates =
        constructCandidates(result, data, dataRangeMax);

    result.add([]);

    for (List<int> possibleSet in candidates) {
      result[result.length - 1] = possibleSet;

      backtrack(result, data, dataRangeMax);
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

  List<int> willCover = List.filled(data.length, 0);
  for (int i = 0; i < data.length; i++) {
    int count = 0;
    for (int j = 0; j < data[i].length; j++)
      if (covered[data[i][j] - 1] == false) count++;

    willCover[i] = count;
  }

  List<List<int>> candidates = [];
  while (!listEqual(willCover, List.filled(data.length, 0))) {
    int maxIndex = willCover.indexOf((getMax(willCover)));

    candidates.add(data[maxIndex]);

    willCover[maxIndex] = 0;
  }

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
