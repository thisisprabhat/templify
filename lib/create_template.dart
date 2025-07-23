import 'dart:io';

import 'package:colored_log/colored_log.dart';
import 'package:templify/utils/print_helper.dart';

import 'docs/docs.dart';
import '/model/config.dart';
import '/commands/commands.dart';
import 'utils/string_extension.dart';

String get platformPathSaperator => Platform.pathSeparator;

class CreateTemplate {
  CreateTemplate({String? moduleName, String? destinationDir}) {
    if (destinationDir != null) _destinationDirectoryPath = destinationDir;
    if (moduleName != null) _moduleName = moduleName;

    if (moduleName != null) ColoredLog.magenta(moduleName, name: moduleName);
    if (destinationDir != null) {
      ColoredLog.yellow(
        _destinationDirectoryPath,
        name: 'Destination Directory',
      );
    }
  }

  String _moduleName = '';
  String? _defaultName;
  String get defaultName => _defaultName ?? 'employee';
  String _templateDirectoryPath =
      '${Directory.current.path}${platformPathSaperator}templates';
  String _destinationDirectoryPath = '';

  Directory _templateRootDirectory =
      Directory('${Directory.current.path}${platformPathSaperator}templates');

  Directory get templateDirectory => Directory(_templateDirectoryPath);
  set setTemplateDirectory(String path) {
    ColoredLog.yellow(path, name: 'Template Directory');
    _templateDirectoryPath = path;
  }

  set setDestinationDirectory(String path) {
    ColoredLog.yellow(path, name: 'Destination Directory');
    _destinationDirectoryPath = path;
  }

  String get moduleName => _moduleName;
  set setModuleName(String name) => _moduleName = name;

  Future operation() async {
    try {
      final templateRootPath = await Commands.getTemplateDirectoryPath();
      _templateRootDirectory = Directory(templateRootPath!);

      await getModuleName();
      await getDestinationDirectory();
      await getTemplateDirectory();
      await getDefaultModuleName();
      ColoredLog.magenta(templateDirectory, name: 'Source Directory');
      ColoredLog.magenta(
        _destinationDirectoryPath,
        name: 'Destination Directory',
      );
      ColoredLog.magenta(defaultName, name: 'Default Module Name');
      final destinationDirectory = Directory(
          '$_destinationDirectoryPath$platformPathSaperator${moduleName.toCamelCase}');
      if (!await destinationDirectory.exists()) {
        await destinationDirectory.create(recursive: true);
        ColoredLog.green('Directory created: ${destinationDirectory.path}');
      } else {
        ColoredLog.cyan('Directory already exists.');
      }
      ColoredLog.magenta(destinationDirectory, name: 'Destination Directory');
      await copyDirectory(
        source: templateDirectory,
        destination: destinationDirectory,
        isMainDest: true,
      );
      printDirectoryTree(destinationDirectory, '', true);
      print('\n\n');
      ColoredLog.green('Successfully Created', name: '✅');
      await printInstructions(
        templateDirectory: templateDirectory,
        defaultName: defaultName,
        moduleName: moduleName,
      );
    } catch (e) {
      ColoredLog.red(e, name: 'Error creating template');
    }
  }

  getModuleName() async {
    print('\n');
    if (_moduleName.isNotEmpty) return;
    ColoredLog.magenta(
      'Module name should be in format smaller case with space',
      name: 'Instruction',
    );
    ColoredLog.magenta(
      'Module Name :  "$defaultName module" or "$defaultName"',
      name: 'Eg',
    );
    print('\n');
    ColoredLog.white('Enter Module Name :', name: 'Input');
    final input = stdin.readLineSync();
    if ((input ?? '').isNotEmpty) {
      setModuleName = input!;
    } else {
      ColoredLog.red(
        'invalid input',
        name: 'Error',
        style: LogStyle.blinkSlow,
      );
      exit(0);
    }
    ColoredLog.green(moduleName, name: 'Module Name');
    print('\n');
  }

  getDestinationDirectory() async {
    if (_destinationDirectoryPath.isNotEmpty) return;
    print('\n');
    ColoredLog.magenta(
      'Enter Destination Directory where module will be created',
      name: 'Instruction',
    );
    ColoredLog.magenta(
      'Directory Path :  "User${platformPathSaperator}username${platformPathSaperator}Projects${platformPathSaperator}flutter${platformPathSaperator}auth"',
      name: 'Eg',
    );
    print('\n');
    ColoredLog.white('Enter Directory path:', name: 'Input');
    final input = stdin.readLineSync();
    if ((input ?? '').isNotEmpty) {
      String path = input!.replaceAll('\'', '');
      path = path.replaceAll('"', '');
      _destinationDirectoryPath = path;
    } else {
      ColoredLog.red(
        'invalid input',
        name: 'Error',
        style: LogStyle.blinkSlow,
      );
      exit(0);
    }
    ColoredLog.green(
      _destinationDirectoryPath,
      name: 'Destination Directory Path',
    );
    print('\n');
  }

  Future individualFileOperations({
    required File file,
    required String newPath,
  }) async {
    String fileContents = await file.readAsString();
    fileContents = fileContents.replaceCaseWith(
      defaultName.toSnakeCase,
      moduleName.toSnakeCase,
    );

    final newFile = File(newPath);
    await newFile.writeAsString(
      fileContents,
      flush: true,
      mode: FileMode.writeOnly,
    );
    ColoredLog.white('${newFile.path}\n', name: 'Created');
  }

  Future<void> copyDirectory({
    required Directory source,
    required Directory destination,
    bool? isMainDest,
  }) async {
    try {
      if (!await destination.exists()) {
        await destination.create(recursive: true);
        print('Directory created: ${destination.path}');
      } else {
        print('Directory already exists.');
      }

      await for (FileSystemEntity entity in source.list(recursive: false)) {
        if (entity.path.split(platformPathSaperator).last.startsWith('.')) {
          continue;
        }
        if (entity is Directory) {
          String directoryName = entity.path.split(platformPathSaperator).last;
          if (directoryName.containsAvoidableDirectory) continue;
          directoryName = directoryName.toSnakeCase;
          String newPath =
              '${destination.path}$platformPathSaperator$directoryName';
          ColoredLog.yellow(entity.path, name: 'New Directory');

          await copyDirectory(source: entity, destination: Directory(newPath));
        } else if (entity is File) {
          ColoredLog.blue(entity.path, name: 'File');
          String fileName = entity.uri.pathSegments.last;
          if (fileName.containsAvoidableFiles) continue;

          fileName = fileName.replaceAll(
            defaultName.toSnakeCase,
            moduleName.toSnakeCase,
          );

          File newFile =
              File('${destination.path}$platformPathSaperator$fileName');
          await individualFileOperations(file: entity, newPath: newFile.path);
        }
      }
    } catch (e) {
      ColoredLog.red(e, name: 'Copy Directory Failed');
      exit(0);
    }
  }

  printDirectoryContents(Directory directory, {int level = 0}) async {
    String indent = ' ' * (level * 2);

    await for (FileSystemEntity entity
        in directory.list(recursive: false, followLinks: false)) {
      if (entity is File) {
        ColoredLog.white('$indent: ${entity.path}', name: 'File');
      } else if (entity is Directory) {
        ColoredLog.yellow('$indent: ${entity.path}', name: 'Directory');
        await printDirectoryContents(entity, level: level + 1);
      }
    }
  }

  getTemplateDirectory() async {
    try {
      List<Directory> directories = [];
      await for (FileSystemEntity entity in _templateRootDirectory.list(
          recursive: false, followLinks: false)) {
        if (entity.path.containsAvoidableDirectory) continue;
        if (entity is Directory) {
          if (entity.path
              .split(platformPathSaperator)
              .last
              .containsAvoidableDirectory) {
            continue;
          }
          directories.add(entity);
        }
      }
      ColoredLog.red(directories, name: 'Directories');

      print('\n');
      ColoredLog.white('Select template index from below options');
      for (int i = 0; i < directories.length; i++) {
        ColoredLog.green(
          directories[i].path.split(platformPathSaperator).last.toTitleCase,
          name: i.toString(),
        );
      }
      // If no template found in the template directory then print the below message
      // and open the template directory
      if (directories.isEmpty) {
        ColoredLog.red(
          'No template found in the template directory',
          name: 'Error',
          style: LogStyle.blinkSlow,
        );
        Docs.printTemplateCreationLogic();
        await Future.delayed(Duration(seconds: 1));
        Commands.openDirectory(templateDirectory.path);
        exit(0);
      }

      ColoredLog.white('Enter Index :');
      final input = stdin.readLineSync();
      if ((input ?? '').isNotEmpty) {
        final availableOptions = List.generate(directories.length, (i) => i);

        if (availableOptions.contains(int.tryParse(input!))) {
          final dir = directories[int.tryParse(input.toString()) ?? 0];
          setTemplateDirectory = dir.path;
        } else {
          ColoredLog.red(
            'invalid input',
            name: 'Error',
            style: LogStyle.blinkSlow,
          );
          exit(0);
        }
      } else {
        ColoredLog.red(
          'invalid input',
          name: 'Error',
          style: LogStyle.blinkSlow,
        );
        exit(0);
      }

      ColoredLog.green(
        templateDirectory.path.split(platformPathSaperator).last,
        name: 'Selected Template',
      );
      ColoredLog.green(
        templateDirectory.path,
        name: 'Selected Template Path',
      );
      print('\n');
    } catch (e) {
      Docs.printTemplateCreationLogic();
    }
  }

  Future<void> getDefaultModuleName() async {
    final nameDirectoryPath =
        '${templateDirectory.path}${platformPathSaperator}name.txt';
    final exists = await File(Directory(nameDirectoryPath).path).exists();
    if (exists) {
      final nameFile = File(nameDirectoryPath);

      final name = await nameFile.readAsString();
      if (name.isNotEmpty) {
        _defaultName = name.trim();
        return;
      }
    }
    final config = await Config.fromFile();
    _defaultName = config.defaultModuleName;
  }
}
