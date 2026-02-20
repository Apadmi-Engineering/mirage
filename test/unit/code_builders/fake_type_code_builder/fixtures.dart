part of 'fake_type_code_builder_test.dart';

Lazy<MockVoidType> _voidType = Lazy(() {
  return MockVoidType();
});

Lazy<MockDartType> _coreType = Lazy(() {
  final mockLibrary = MockLibraryElement()
    ..stubReturn((it) => it.isDartCore, true);
  final mockElement = MockClassElement()
    ..stubReturn((it) => it.library, mockLibrary);
  final out = MockDartType()
    ..stubReturn((it) => it.isDartCoreString, true)
    ..stubReturn((it) => it.element, mockElement);
  return out;
});

Lazy<MockDartType> _interfaceType = Lazy(() {
  final mockLibrary = MockLibraryElement()
    ..stubReturn((it) => it.isDartCore, false)
    ..stubReturn((it) => it.isDartAsync, false);
  final mockClassElement = MockClassElement()
    ..stubReturn((it) => it.name, "MyClass")
    ..stubReturn((it) => it.library, mockLibrary)
    ..stubReturn((it) => it.isPublic, true);
  final out = MockDartType()..stubReturn((it) => it.element, mockClassElement);
  return out;
});

Lazy<MockDartType> _enumType = Lazy(() {
  final mockLibrary = MockLibraryElement()
    ..stubReturn((it) => it.isDartCore, false);
  final mockEnumElement = MockEnumElement()
    ..stubReturn((it) => it.library, mockLibrary)
    ..stubReturn((it) => it.name, "MyEnum");
  final out = MockDartType()..stubReturn((it) => it.element, mockEnumElement);
  return out;
});

Lazy<MockParameterizedType> _futureType = Lazy(() {
  final mockLibrary = MockLibraryElement()
    ..stubReturn((it) => it.isDartCore, false)
    ..stubReturn((it) => it.isDartAsync, true);
  final mockClassElement = MockClassElement()
    ..stubReturn((it) => it.library, mockLibrary)
    ..stubReturn((it) => it.isPublic, true);
  final out = MockParameterizedType()
    ..stubReturn((it) => it.element, mockClassElement)
    ..stubReturn((it) => it.isDartAsyncFuture, true)
    ..stubReturn((it) => it.typeArguments, [_interfaceType()]);
  return out;
});

Lazy<MockParameterizedType> _streamType = Lazy(() {
  final mockLibrary = MockLibraryElement()
    ..stubReturn((it) => it.isDartCore, false)
    ..stubReturn(
      (it) => it.isDartAsync,
      true,
    );
  final mockClassElement = MockClassElement()
    ..stubReturn((it) => it.library, mockLibrary)
    ..stubReturn((it) => it.isPublic, true);
  final out = MockParameterizedType()
    ..stubReturn((it) => it.element, mockClassElement)
    ..stubReturn((it) => it.isDartAsyncStream, true)
    ..stubReturn((it) => it.typeArguments, [_interfaceType()]);
  return out;
});

Lazy<MockParameterizedType> _genericType = Lazy(() {
  final mockLibraryElement = MockLibraryElement();
  final mockInnerClassElement = MockTypeParameterElement()
    ..stubReturn((it) => it.name, "InnerClass")
    ..stubReturn((it) => it.library, mockLibraryElement)
    ..stubReturn((it) => it.isPublic, true);
  final mockInnerType = MockDartType()
  ..stubReturn((it) => it.element, mockInnerClassElement);
  final mockOuterClassElement = MockClassElement()
    ..stubReturn((it) => it.name, "OuterClass")
    ..stubReturn((it) => it.library, mockLibraryElement)
    ..stubReturn((it) => it.isPublic, true)
    ..stubReturn((it) => it.typeParameters, [mockInnerClassElement]);
  return MockParameterizedType()
    ..stubReturn((it) => it.element, mockOuterClassElement)
    ..stubReturn((it) => it.typeArguments, [mockInnerType]);
});

Lazy<MockDartType> _privateType = Lazy(() {
  final mockLibraryElement = MockLibraryElement();
  final mockInterfaceElement = MockClassElement()
    ..stubReturn((it) => it.name, "_PrivateType")
  ..stubReturn((it) => it.library, mockLibraryElement);
  return MockDartType()..stubReturn((it) => it.element, mockInterfaceElement);
});

Lazy<MockDartType> _finalType = Lazy(() {
  final mockLibraryElement = MockLibraryElement();
  final mockClassElement = MockClassElement()
    ..stubReturn((it) => it.name, "FinalType")
    ..stubReturn((it) => it.library, mockLibraryElement)
    ..stubReturn((it) => it.isFinal, true)
    ..stubReturn((it) => it.isPublic, true);
  return MockDartType()..stubReturn((it) => it.element, mockClassElement);
});

Lazy<MockDartType> _sealedType = Lazy(() {
  final mockLibraryElement = MockLibraryElement();
  final mockClassElement = MockClassElement()
    ..stubReturn((it) => it.name, "SealedType")
    ..stubReturn((it) => it.library, mockLibraryElement)
    ..stubReturn((it) => it.isSealed, true)
    ..stubReturn((it) => it.isPublic, true);
  return MockDartType()..stubReturn((it) => it.element, mockClassElement);
});
