import 'package:analyzer/dart/element/element2.dart';
import 'package:mirage/src/import_finder.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

import '../util/stubbing_utils.dart';
import 'import_finder_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LibraryReader>(),
  MockSpec<Element2>(),
  MockSpec<LibraryElement2>(),
])
void main() {
  group("Import finder unit tests", () {
    final mockLibraryReader = MockLibraryReader();
    late ImportFinder sut;

    setUp(() {
      reset(mockLibraryReader);
      sut = ImportFinder(mockLibraryReader);
    });

    test("getImportUrl - with null element - returns null", () {
      // Run test & verify
      expect(sut.getImportUrl(null), null);
    });

    test("getImportUrl - with element - resolution exception - throws", () {
      // Setup
      final exceptionFixture = Exception();
      final elementFixture = MockElement2()
        ..stubReturn((it) => it.library2, MockLibraryElement2());
      when(mockLibraryReader.pathToElement(any)).thenThrow(exceptionFixture);

      // Run test
      expect(() => sut.getImportUrl(elementFixture), throwsA(exceptionFixture));
    });

    test("getImportUrl - with element - resolution success - returns path", () {
      // Setup
      when(mockLibraryReader.pathToElement(any))
          .thenReturn(Uri.parse("dart:core"));
      final elementFixture = MockElement2()
        ..stubReturn((it) => it.library2, MockLibraryElement2());

      // Run test
      expect(sut.getImportUrl(elementFixture), "dart:core");
    });
  });
}
