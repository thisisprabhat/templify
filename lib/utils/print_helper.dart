import 'dart:io';
import 'package:colored_log/colored_log.dart';
import 'package:path/path.dart' as p;
import 'package:templify/utils/string_extension.dart';

import '../create_template.dart';

/// Recursively prints the directory tree structure.
void printDirectoryTree(Directory dir, String prefix, bool isLast) {
  // Get all entities in the directory, excluding hidden ones.
  final List<FileSystemEntity> entities = dir
      .listSync()
      .where((entity) => !p.basename(entity.path).startsWith('.'))
      .toList();

  // Sort entities alphabetically, directories first.
  entities.sort((a, b) {
    if (a is Directory && b is File) return -1;
    if (a is File && b is Directory) return 1;
    return p.basename(a.path).compareTo(p.basename(b.path));
  });

  // Print the current directory name.
  print(ColoredLog.getStylizedText(
    '$prefix${isLast ? '└── ' : '├── '}${p.basename(dir.path)}/',
    color: LogColor.green,
  ));

  // Iterate over the entities and print them.
  for (int i = 0; i < entities.length; i++) {
    final entity = entities[i];
    final bool isLastEntity = i == entities.length - 1;
    final String newPrefix = '$prefix${isLast ? '    ' : '│   '}';

    if (entity is Directory) {
      // If it's a directory, call the function recursively.
      printDirectoryTree(entity, newPrefix, isLastEntity);
    } else if (entity is File) {
      // If it's a file, print its name.
      print(ColoredLog.getStylizedText(
        '$newPrefix${isLastEntity ? '└── ' : '├── '}${p.basename(entity.path)}',
        color: LogColor.green,
      ));
    }
  }
}

printInstructions({
  required Directory templateDirectory,
  required String defaultName,
  required String moduleName,
}) async {
  final instructionsPath =
      '${templateDirectory.path}${platformPathSaperator}instructions.md';
  final exists = await File(instructionsPath).exists();
  if (exists) {
    final instructionsFile = File(instructionsPath);

    String instructions = await instructionsFile.readAsString();
    instructions = instructions.replaceCaseWith(
      defaultName.toCamelCase,
      moduleName.toCamelCase,
    );

    print('\n\n\n');
    ColoredLog.cyan(
      '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n'
      '~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Instrutions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~',
    );
    ColoredLog.markdown(instructions);
  }
}
