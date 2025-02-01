import 'dart:io';

import 'package:colored_log/colored_log.dart';
import 'utils/string_extension.dart';

class Templify {
  String _moduleName = '';
  String _defaultName = 'banana';
  String _templateDirectoryPath = 'templates';
  String _destinationDirectoryPath = 'destination';

  set setTemplateDirectory(String path) {
    ColoredLog.yellow(path, name: 'Template Directory');
    _templateDirectory = Directory(path);
  }

  set setDestinationDirectory(String path) {
    ColoredLog.yellow(path, name: 'Destination Directory');
    _destinationDirectoryPath = path;
  }

  String get moduleName => _moduleName;
  set setModuleName(String name) {
    _moduleName = name;
  }

  Directory _templateDirectory = Directory.current;

  Directory get templateDirectory => _templateDirectory;

  Future operation() async {
    try {
      await getModuleName();
      await getTemplateDirectory();
      ColoredLog.magenta(templateDirectory, name: 'Source Directory');
      ColoredLog.magenta(Directory.current, name: 'Destination Directory');
      final destinationDirectory =
          Directory('${Directory.current.path}/${moduleName.toCamelCase}');
      if (!await destinationDirectory.exists()) {
        await destinationDirectory.create(recursive: true);
        ColoredLog.green('Directory created: ${destinationDirectory.path}');
      } else {
        ColoredLog.cyan('Directory already exists.');
      }
      ColoredLog.magenta(destinationDirectory, name: 'Destination Directory');
      await copyDirectory(templateDirectory, destinationDirectory);
      printPostInstructions();
    } catch (e) {
      ColoredLog.red(e, name: 'Error');
    }
  }

  getModuleName() async {
    print('\n');
    ColoredLog.magenta(
      'Module name should be in format smaller case with space',
      name: 'Instruction',
    );
    ColoredLog.magenta(
      'Module Name :  "$_defaultName module" or "$_defaultName"',
      name: 'Eg',
    );
    print('\n');
    ColoredLog.white('Enter Module Name :', name: 'Input');
    final input = stdin.readLineSync();
    if ((input ?? '').isNotEmpty) {
      setModuleName = input!;
    } else {
      ColoredLog.red('invalid input', name: 'Error');
      exit(0);
    }
    ColoredLog.green(moduleName, name: 'Module Name');
    print('\n');
  }

  Future individualFileOperations({
    required File file,
    required String newPath,
  }) async {
    String fileContents = await file.readAsString();
    fileContents = fileContents.replaceAll(
      _defaultName.toCamelCase,
      moduleName.toCamelCase,
    );
    fileContents = fileContents.replaceAll(
      _defaultName.toTitleCase,
      moduleName.toTitleCase,
    );

    fileContents = fileContents.replaceAll(
      _defaultName.toUpperCase(),
      moduleName.toUpperCase(),
    );
    fileContents = fileContents.replaceAll(
      _defaultName.toKebabCase,
      moduleName.toKebabCase,
    );
    fileContents = fileContents.replaceAll(
      _defaultName.toSnakeCase,
      moduleName.toSnakeCase,
    );

    fileContents = fileContents.replaceAll(
      _defaultName.toLowerCase(),
      moduleName.toLowerCase(),
    );

    final newFile = File(newPath);
    await newFile.writeAsString(
      fileContents,
      flush: true,
      mode: FileMode.writeOnly,
    );
    ColoredLog.white(newFile.path, name: 'Created');
  }

  Future<void> copyDirectory(Directory source, Directory destination) async {
    try {
      if (!await destination.exists()) {
        await destination.create(recursive: true);
        print('Directory created: ${destination.path}');
      } else {
        print('Directory already exists.');
      }

      ColoredLog.cyan(await destination.exists(), name: 'Destination_exists');

      await for (FileSystemEntity entity in source.list(recursive: false)) {
        if (entity is Directory) {
          var newDirectory =
              Directory('${destination.path}/${entity.path.split('/').last}');
          ColoredLog.yellow(entity.path, name: 'New Directory');

          await copyDirectory(entity, newDirectory);
        } else if (entity is File) {
          ColoredLog.blue(entity.path, name: 'File');
          String fileName = entity.uri.pathSegments.last;
          fileName = fileName.replaceAll(
            _defaultName.toSnakeCase,
            moduleName.toSnakeCase,
          );
          var newFile = File('${destination.path}/$fileName');
          await individualFileOperations(file: entity, newPath: newFile.path);
        }
      }
    } catch (e) {
      ColoredLog.red(e, name: 'Copy Directory Failed');
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
    List<Directory> directories = [];
    final runnerDir = runnerDirectory();
    Directory templateDirectory = Directory('${runnerDir.path}/templates');
    await for (FileSystemEntity entity
        in templateDirectory.list(recursive: false, followLinks: false)) {
      if (entity is Directory) directories.add(entity);
    }
    print('\n');
    ColoredLog.white('Select template index from below options');
    for (int i = 0; i < directories.length; i++) {
      ColoredLog.green(
        directories[i].path.split('/').last,
        name: i.toString(),
      );
    }

    ColoredLog.white('Enter Index :');
    final input = stdin.readLineSync();
    if ((input ?? '').isNotEmpty) {
      final availableOptions = List.generate(directories.length, (i) => i);

      if (availableOptions.contains(int.tryParse(input!))) {
        final dir = directories[int.tryParse(input.toString()) ?? 0];
        setTemplateDirectory = dir.path;
      } else {
        ColoredLog.red('invalid input', name: 'Error');
        exit(0);
      }
    } else {
      ColoredLog.red('invalid input', name: 'Error');
      exit(0);
    }

    ColoredLog.green(
      templateDirectory.path.split('/').last,
      name: 'Selected Template',
    );
    ColoredLog.green(
      templateDirectory.path,
      name: 'Selected Template',
    );
    print('\n');
  }

  Directory runnerDirectory() {
    Uri scriptUri = Platform.script;
    String scriptPath = scriptUri.toFilePath();
    String scriptDirectory = File(scriptPath).parent.path;
    Directory runnerDirectory = Directory(scriptDirectory);
    // ColoredLog.yellow(runnerDirectory.path, name: 'Script Directory');
    return runnerDirectory;
  }

  printPostInstructions() {
    ColoredLog.cyan('''
# Create module using command

### Step 1 : Take user input
    - Take module name input in dart

### Step 2 : Directories
    - Read the template directories
    - Create all the required directories with proper name

### Step 3 : creating Files
    - Read files one by one
    - Rename 'test' according the param provided in camel case
    - Rename 'Test' to capital first accord. to param provided
    - Now create file in the specified directory for the param provided in snake_case

### Step 4 : Print Success message
    - Print beautifully printed success message
''');
  }
}
