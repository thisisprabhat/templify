import 'dart:convert';

class Config {
  String? templatePath;
  String? defaultModuleName;
  Config({
    this.templatePath,
    this.defaultModuleName,
  });

  Config copyWith({
    String? templatePath,
    String? defaultModuleName,
  }) {
    return Config(
      templatePath: templatePath ?? this.templatePath,
      defaultModuleName: defaultModuleName ?? this.defaultModuleName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'templatePath': templatePath,
      'defaultModuleName': defaultModuleName,
    };
  }

  factory Config.fromMap(Map<String, dynamic> map) {
    return Config(
      templatePath:
          map['templatePath'] != null ? map['templatePath'] as String : null,
      defaultModuleName: map['defaultModuleName'] != null
          ? map['defaultModuleName'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Config.fromJson(String source) =>
      Config.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Config(templatePath: $templatePath, defaultModuleName: $defaultModuleName)';

  @override
  bool operator ==(covariant Config other) {
    if (identical(this, other)) return true;

    return other.templatePath == templatePath &&
        other.defaultModuleName == defaultModuleName;
  }

  @override
  int get hashCode => templatePath.hashCode ^ defaultModuleName.hashCode;
}
