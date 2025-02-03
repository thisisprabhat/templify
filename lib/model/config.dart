import 'dart:convert';
import 'dart:io';

import 'package:colored_log/colored_log.dart';

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

  static Future<Config> fromFile() async {
    final dir = Directory.systemTemp;
    final file = File('${dir.path}/config.json');
    if (await file.exists()) {
      final content = await file.readAsString();
      return Config.fromJson(content);
    } else {
      file.createSync();
      final config = Config(
        templatePath: null,
        defaultModuleName: 'test',
      );
      file.createSync(recursive: true);
      file.writeAsStringSync(config.toJson());
      return config;
    }
  }

  static Future<void> reset() async {
    final dir = Directory.systemTemp;
    final file = File('${dir.path}/config.json');
    file.delete(recursive: true);
    ColoredLog.green('Config reset successfully');
  }

  static Future<void> save({String? defaultName, String? templatePath}) async {
    final dir = Directory.systemTemp;
    final file = File('${dir.path}/config.json');
    final config = await fromFile();
    final newConfig = config.copyWith(
      templatePath: templatePath,
      defaultModuleName: defaultName,
    );
    await file.writeAsString(newConfig.toJson());
    print('');
    ColoredLog.green('✅ Configuration saved successfully');
    ColoredLog('${config.templatePath}', name: 'Template Directory');
    ColoredLog('${config.defaultModuleName}', name: 'Default Module Name');
    print('');
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
