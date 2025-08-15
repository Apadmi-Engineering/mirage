import 'package:code_builder/code_builder.dart';

extension BlockBuilderUtils on BlockBuilder {
  void addStaticCode(String code) => statements.add(Code(code));

  void addCode(Code code) => statements.add(code);
}