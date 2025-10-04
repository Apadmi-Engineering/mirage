import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/dart/element/type_system.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:mirage/src/code_builders/classes/family_notifier_delegate.dart';
import 'package:mirage/src/code_builders/classes/simple_notifier_delegate.dart';
import 'package:mirage/src/code_builders/classes/provider_code_builder.dart';
import 'package:mirage/src/code_builders/fake_type_code_builder.dart';
import 'package:mirage/src/code_builders/method_code_builder.dart';
import 'package:mirage/src/seed_finder.dart';
import 'package:mirage/src/type_referencer.dart';
import 'package:source_gen/source_gen.dart';

import 'import_finder.dart';

class ServiceLocator {
  static ImportFinder getImportFinder(LibraryElement2 library) =>
      ImportFinder(getLibraryReader(library));

  static LibraryReader getLibraryReader(LibraryElement2 library) =>
      LibraryReader(library);

  static TypeSystem getTypeSystem(LibraryElement2 library) => library.typeSystem;

  static SeedFinder getSeedFinder() => SeedFinder();

  static TypeReferencer getTypeReferencer(LibraryElement2 library) =>
      TypeReferencer(
        getImportFinder(library),
        getTypeSystem(library),
      );

  static FakeTypeCodeBuilder getFakeTypeCodeBuilder(LibraryElement2 library) =>
      FakeTypeCodeBuilder(
        getLibraryReader(library),
        getImportFinder(library),
      );

  static MethodCodeBuilder getMethodGenerator(LibraryElement2 library) =>
      MethodCodeBuilder(
        getFakeTypeCodeBuilder(library),
        getTypeReferencer(library),
      );

  static SimpleNotifierDelegate getNotifierDelegate(LibraryElement2 library) =>
      SimpleNotifierDelegate(
        getFakeTypeCodeBuilder(library),
        getImportFinder(library),
        getMethodGenerator(library),
        getSeedFinder(),
        getTypeReferencer(library),
      );

  static FamilyNotifierDelegate getFamilyDelegate(LibraryElement2 library) =>
      FamilyNotifierDelegate(
        getFakeTypeCodeBuilder(library),
        getImportFinder(library),
        getMethodGenerator(library),
        getSeedFinder(),
        getTypeReferencer(library),
      );

  static ProviderCodeBuilder getProviderGenerator(LibraryElement2 library) =>
      ProviderCodeBuilder(
        getNotifierDelegate(library),
        getFamilyDelegate(library),
      );

  static DartFormatter formatter = DartFormatter(
    languageVersion: DartFormatter.latestLanguageVersion,
    pageWidth: 80,
  );

  static DartEmitter get emitter =>
      DartEmitter.scoped(useNullSafetySyntax: true);
}
