part of 'fake_type_code_builder_test.dart';

Lazy<MockVoidType> _voidType = Lazy(() {
  return MockVoidType();
});

Lazy<MockDartType> _coreType = Lazy(() {
  final mockLibrary = MockLibraryElement2()
    ..stubReturn((it) => it.isDartCore, true);
  final mockElement = MockClassElement2()
    ..stubReturn((it) => it.library2, mockLibrary);
  final out = MockDartType()
    ..stubReturn((it) => it.isDartCoreString, true)
    ..stubReturn((it) => it.element3, mockElement);
  return out;
});

Lazy<MockDartType> _interfaceType = Lazy(() {
  final mockLibrary = MockLibraryElement2()
    ..stubReturn((it) => it.isDartCore, false)
    ..stubReturn((it) => it.isDartAsync, false);
  final mockClassElement = MockClassElement2()
    ..stubReturn((it) => it.name3, "MyClass")
    ..stubReturn((it) => it.library2, mockLibrary)
    ..stubReturn((it) => it.isPublic, true);
  final out = MockDartType()..stubReturn((it) => it.element3, mockClassElement);
  return out;
});

Lazy<MockDartType> _enumType = Lazy(() {
  final mockLibrary = MockLibraryElement2()
    ..stubReturn((it) => it.isDartCore, false);
  final mockEnumElement = MockEnumElement2()
    ..stubReturn((it) => it.library2, mockLibrary)
    ..stubReturn((it) => it.name3, "MyEnum");
  final out = MockDartType()..stubReturn((it) => it.element3, mockEnumElement);
  return out;
});

Lazy<MockParameterizedType> _futureType = Lazy(() {
  final mockLibrary = MockLibraryElement2()
    ..stubReturn((it) => it.isDartCore, false)
    ..stubReturn((it) => it.isDartAsync, true);
  final mockClassElement = MockClassElement2()
    ..stubReturn((it) => it.library2, mockLibrary)
    ..stubReturn((it) => it.isPublic, true);
  final out = MockParameterizedType()
    ..stubReturn((it) => it.element3, mockClassElement)
    ..stubReturn((it) => it.isDartAsyncFuture, true)
    ..stubReturn((it) => it.typeArguments, [_interfaceType()]);
  return out;
});

Lazy<MockParameterizedType> _streamType = Lazy(() {
  final mockLibrary = MockLibraryElement2()
    ..stubReturn((it) => it.isDartCore, false)
    ..stubReturn(
      (it) => it.isDartAsync,
      true,
    );
  final mockClassElement = MockClassElement2()
    ..stubReturn((it) => it.library2, mockLibrary)
    ..stubReturn((it) => it.isPublic, true);
  final out = MockParameterizedType()
    ..stubReturn((it) => it.element3, mockClassElement)
    ..stubReturn((it) => it.isDartAsyncStream, true)
    ..stubReturn((it) => it.typeArguments, [_interfaceType()]);
  return out;
});

Lazy<MockParameterizedType> _genericType = Lazy(() {
  final mockLibraryElement = MockLibraryElement2();
  final mockInnerClassElement = MockTypeParameterElement2()
    ..stubReturn((it) => it.name3, "InnerClass")
    ..stubReturn((it) => it.library2, mockLibraryElement)
    ..stubReturn((it) => it.isPublic, true);
  final mockInnerType = MockDartType()
  ..stubReturn((it) => it.element3, mockInnerClassElement);
  final mockOuterClassElement = MockClassElement2()
    ..stubReturn((it) => it.name3, "OuterClass")
    ..stubReturn((it) => it.library2, mockLibraryElement)
    ..stubReturn((it) => it.isPublic, true)
    ..stubReturn((it) => it.typeParameters2, [mockInnerClassElement]);
  return MockParameterizedType()
    ..stubReturn((it) => it.element3, mockOuterClassElement)
    ..stubReturn((it) => it.typeArguments, [mockInnerType]);
});

Lazy<MockDartType> _privateType = Lazy(() {
  final mockLibraryElement = MockLibraryElement2();
  final mockInterfaceElement = MockClassElement2()
    ..stubReturn((it) => it.name3, "_PrivateType")
  ..stubReturn((it) => it.library2, mockLibraryElement);
  return MockDartType()..stubReturn((it) => it.element3, mockInterfaceElement);
});

Lazy<MockDartType> _finalType = Lazy(() {
  final mockLibraryElement = MockLibraryElement2();
  final mockClassElement = MockClassElement2()
    ..stubReturn((it) => it.name3, "FinalType")
    ..stubReturn((it) => it.library2, mockLibraryElement)
    ..stubReturn((it) => it.isFinal, true)
    ..stubReturn((it) => it.isPublic, true);
  return MockDartType()..stubReturn((it) => it.element3, mockClassElement);
});

Lazy<MockDartType> _sealedType = Lazy(() {
  final mockLibraryElement = MockLibraryElement2();
  final mockClassElement = MockClassElement2()
    ..stubReturn((it) => it.name3, "SealedType")
    ..stubReturn((it) => it.library2, mockLibraryElement)
    ..stubReturn((it) => it.isSealed, true)
    ..stubReturn((it) => it.isPublic, true);
  return MockDartType()..stubReturn((it) => it.element3, mockClassElement);
});
