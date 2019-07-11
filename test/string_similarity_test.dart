import 'package:string_similarity/string_similarity.dart';
import 'package:test/test.dart';

class TestData {
  TestData({this.sentenceA, this.sentenceB, this.expected});

  String sentenceA;
  String sentenceB;
  double expected;
}

void main() {
  List<TestData> _testData;
  group('compareTwoStrings', () {
    setUp(() {
      _testData = <TestData>[
        TestData(sentenceA: 'french', sentenceB: 'quebec', expected: 0),
        TestData(sentenceA: 'france', sentenceB: 'france', expected: 1),
        TestData(sentenceA: 'fRaNce', sentenceB: 'france', expected: 0.2),
        TestData(sentenceA: 'healed', sentenceB: 'sealed', expected: 0.8),
        TestData(sentenceA: 'web applications', sentenceB: 'applications of the web', expected: 0.7878787878787878),
        TestData(sentenceA: 'this will have a typo somewhere', sentenceB: 'this will huve a typo somewhere', expected: 0.92),
        TestData(
            sentenceA: 'Olive-green table for sale, in extremely good condition.',
            sentenceB: 'For sale: table in very good  condition, olive green in colour.',
            expected: 0.6060606060606061),
        TestData(
            sentenceA: 'Olive-green table for sale, in extremely good condition.',
            sentenceB: 'For sale: green Subaru Impreza, 210,000 miles',
            expected: 0.2558139534883721),
        TestData(
            sentenceA: 'Olive-green table for sale, in extremely good condition.',
            sentenceB: 'Wanted: mountain bike with at least 21 gears.',
            expected: 0.1411764705882353),
        TestData(sentenceA: 'this has one extra word', sentenceB: 'this has one word', expected: 0.7741935483870968),
        TestData(sentenceA: 'a', sentenceB: 'a', expected: 1),
        TestData(sentenceA: 'a', sentenceB: 'b', expected: 0),
        TestData(sentenceA: '', sentenceB: '', expected: 1),
        TestData(sentenceA: 'a', sentenceB: '', expected: 0),
        TestData(sentenceA: '', sentenceB: 'a', expected: 0),
        TestData(sentenceA: 'apple event', sentenceB: 'apple    event', expected: 1),
        TestData(sentenceA: 'iphone', sentenceB: 'iphone x', expected: 0.9090909090909091)
      ];
    });

    test('returns the correct value for different inputs:', () {
      for (TestData td in _testData) {
        expect(StringSimilarity.compareTwoStrings(td.sentenceA, td.sentenceB), td.expected);
      }
    });
  });

  group('findBestMatch', () {
    setUp(() {
      _testData = <TestData>[
        TestData(sentenceA: 'mailed', expected: 0.4),
        TestData(sentenceA: 'edward', expected: 0.2),
        TestData(sentenceA: 'sealed', expected: 0.8),
        TestData(sentenceA: 'theatre', expected: 0.36363636363636365),
      ];
    });

    test('assigns a similarity rating to each string passed in the array', () {
      final BestMatch matches = StringSimilarity.findBestMatch('healed', _testData.map((TestData testEntry) => testEntry.sentenceA).toList());

      for (int i = 0; i < matches.ratings.length; i++) {
        expect(_testData[i].sentenceA, matches.ratings[i].target);
        expect(_testData[i].expected, matches.ratings[i].rating);
      }
    });

    test('returns the best match and its similarity rating', () {
      final BestMatch matches = StringSimilarity.findBestMatch('healed', _testData.map((TestData testEntry) => testEntry.sentenceA).toList());

      expect(matches.bestMatch.target, 'sealed');
      expect(matches.bestMatch.rating, 0.8);
    });

    test('returns the index of best match from the target strings', () {
      final BestMatch matches = StringSimilarity.findBestMatch('healed', _testData.map((TestData testEntry) => testEntry.sentenceA).toList());

      expect(matches.bestMatchIndex, 2);
    });
  });
}