import 'dart:convert';
import 'dart:io' as io;

import 'package:yaml/yaml.dart';

void main() {
  Map<String, dynamic> settings = loadSettingsFromFile('settings.yaml');

  saveSettingsToFile(settings, 'settings.yaml');
}

Map<String, dynamic> loadSettingsFromFile(String filePath) {
  if (io.File(filePath).existsSync()) {
    String fileContent = io.File(filePath).readAsStringSync();

    return loadYaml(fileContent) as Map<String, dynamic>;
  }

  return {};
}

void saveSettingsToFile(Map<String, dynamic> data, String filePath) {
  String yamlString = jsonEncode(data);

  io.File(filePath).writeAsStringSync(yamlString);
}
