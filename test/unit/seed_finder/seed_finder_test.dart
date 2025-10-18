import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:mirage/src/seed_finder.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';

import '../util/stubbing_utils.dart';
import 'seed_finder_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<InterfaceType>(),
  MockSpec<VoidType>(),
  MockSpec<ClassElement2>(),
  MockSpec<MethodElement2>(),
])
void main() {
  group("Seed finder unit tests", () {
    late SeedFinder sut;

    setUp(() {
      sut = SeedFinder();
    });

    test("getSeedType - builder returns void - returns null", () {
      // Setup
      final builderType = MockVoidType();
      final methodFixture = MockMethodElement2()
        ..stubReturn((it) => it.name3, "build")
        ..stubReturn((it) => it.returnType, builderType);
      final input = MockClassElement2()
        ..stubReturn((it) => it.methods2, [methodFixture]);

      // Run test & verify
      expect(sut.getNonVoidSeedType(input), null);
    });

    test("getSeedType - builder returns interface - returns null", () {
      // Setup
      final builderType = MockInterfaceType();
      final methodFixture = MockMethodElement2()
        ..stubReturn((it) => it.name3, "build")
        ..stubReturn((it) => it.returnType, builderType);
      final input = MockClassElement2()
        ..stubReturn((it) => it.methods2, [methodFixture]);

      // Run test & verify
      expect(sut.getNonVoidSeedType(input), builderType);
    });

    test("getSeedType - builder returns future with void - returns null", () {
      // Setup
      final builderParamType = MockVoidType();
      final builderType = MockInterfaceType()
        ..stubReturn((it) => it.typeArguments, [builderParamType])
        ..stubReturn((it) => it.isDartAsyncFuture, true);
      final methodFixture = MockMethodElement2()
        ..stubReturn((it) => it.name3, "build")
        ..stubReturn((it) => it.returnType, builderType);
      final input = MockClassElement2()
        ..stubReturn((it) => it.methods2, [methodFixture]);

      // Run test & verify
      expect(sut.getNonVoidSeedType(input), null);
    });

    test("getSeedType - builder returns future with interface - returns interface", () {
      // Setup
      final builderParamType = MockInterfaceType();
      final builderType = MockInterfaceType()
        ..stubReturn((it) => it.typeArguments, [builderParamType])
        ..stubReturn((it) => it.isDartAsyncFuture, true);
      final methodFixture = MockMethodElement2()
        ..stubReturn((it) => it.name3, "build")
        ..stubReturn((it) => it.returnType, builderType);
      final input = MockClassElement2()
        ..stubReturn((it) => it.methods2, [methodFixture]);

      // Run test & verify
      expect(sut.getNonVoidSeedType(input), builderType);
    });

    test("getSeedType - builder returns generic parameter type with void - returns parameter type", () {
      // Setup
      final builderParamType = MockVoidType();
      final builderType = MockInterfaceType()
        ..stubReturn((it) => it.typeArguments, [builderParamType]);
      final methodFixture = MockMethodElement2()
        ..stubReturn((it) => it.name3, "build")
        ..stubReturn((it) => it.returnType, builderType);
      final input = MockClassElement2()
        ..stubReturn((it) => it.methods2, [methodFixture]);

      // Run test & verify
      expect(sut.getNonVoidSeedType(input), builderType);
    });

    test("getNonVoidSeedType - builder returns stream with void - returns interface", () {
      // Setup
      final builderParamType = MockVoidType();
      final builderType = MockInterfaceType()
        ..stubReturn((it) => it.typeArguments, [builderParamType])
        ..stubReturn((it) => it.isDartAsyncStream, true);
      final methodFixture = MockMethodElement2()
        ..stubReturn((it) => it.name3, "build")
        ..stubReturn((it) => it.returnType, builderType);
      final input = MockClassElement2()
        ..stubReturn((it) => it.methods2, [methodFixture]);

      // Run test & verify
      expect(sut.getNonVoidSeedType(input), null);
    });

    test("getNonVoidSeedType - builder returns stream with interface - returns interface", () {
      // Setup
      final builderParamType = MockInterfaceType();
      final builderType = MockInterfaceType()
        ..stubReturn((it) => it.typeArguments, [builderParamType])
        ..stubReturn((it) => it.isDartAsyncStream, true);
      final methodFixture = MockMethodElement2()
        ..stubReturn((it) => it.name3, "build")
        ..stubReturn((it) => it.returnType, builderType);
      final input = MockClassElement2()
        ..stubReturn((it) => it.methods2, [methodFixture]);

      // Run test & verify
      expect(sut.getNonVoidSeedType(input), builderType);
    });
  });
}
