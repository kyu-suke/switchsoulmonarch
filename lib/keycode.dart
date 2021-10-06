enum SsmKeys {
  a,
  b,
}

extension GetLabel on SsmKeys {
  static final labels = {
    SsmKeys.a: 'A',
    SsmKeys.b: 'B',
  };

  String? get label => labels[this];
}

extension GetCode on SsmKeys {
  static final labels = {
    SsmKeys.a: 'jdfsoajdfjaoj',
    SsmKeys.b: 'bbbbbbbbbbbbb',
  };

  String? get code => labels[this];
}
