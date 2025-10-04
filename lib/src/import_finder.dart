import 'package:analyzer/dart/element/element2.dart';
import 'package:source_gen/source_gen.dart';

class ImportFinder {

  final LibraryReader _libraryReader;

  const ImportFinder(this._libraryReader);

  String? getImportUrl(Element2? element) {
    final localElement = element?.library2;
    if (localElement == null) {
      return null;
    }
    return _libraryReader.pathToElement(localElement).toString();
  }
}