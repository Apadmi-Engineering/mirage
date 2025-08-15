import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

class ImportFinder {

  final LibraryReader _libraryReader;

  const ImportFinder(this._libraryReader);

  String? getImportUrl(Element? element) {
    final localElement = element?.library;
    if (localElement == null) {
      return null;
    }
    return _libraryReader.pathToElement(localElement).toString();
  }
}