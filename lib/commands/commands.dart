import 'dart:io';

import 'package:args/args.dart';
import 'package:colored_log/colored_log.dart';
import 'package:templify/docs/docs.dart';
import 'package:templify/model/config.dart';
import 'package:yaml/yaml.dart';

class Commands {
  static handleCommands({
    required ArgParser parser,
    required ArgParser createParser,
    required ArgParser configParser,
    required List<String> arguments,
  }) async {
    final argResult = parser.parse(arguments);
    final bool isOpenCommand = argResult.command?.name == 'open';
    final bool isResetCommand = argResult.command?.name == 'reset';
    final bool isVersionCheck = argResult['version'];
    final bool isHelpFlag = argResult['help'];
    final bool isCreateCommand = argResult.command?.name == 'create';
    final bool isConfigCommand = argResult.command?.name == 'config';
    if (isVersionCheck) {
      await showVersion();
    } else if (isOpenCommand) {
      await openTemplateDirectory();
    } else if (isResetCommand) {
      await Config.reset();
    } else if (isCreateCommand) {
      await createCommandHandler(createParser.parse(arguments));
    } else if (isConfigCommand) {
      await configCommandHandler(configParser.parse(arguments));
    } else if (isHelpFlag) {
      help(
        parser: parser,
        createParser: createParser,
        configParser: configParser,
      );
    } else {
      throw 'Invalid command';
    }
  }

  static Future<void> createCommandHandler(ArgResults argResult) async {
    final destinationPath = argResult['path'];
    final moduleName = argResult['name'];
  }

  static Future<void> configCommandHandler(ArgResults argResult) async {
    final templatePath = argResult['dir'];
    final defaultName = argResult['name'];
    // ColoredLog(templatePath, name: 'Template Path');
    // ColoredLog(defaultName, name: 'Default Name');

    final config = await Config.fromFile();

    if (templatePath == null && defaultName == null) {
      print('');
      ColoredLog.white('Current Configuration :');
      ColoredLog('${config.templatePath}', name: 'Current template directory');
      ColoredLog('${config.defaultModuleName}', name: 'Default module name');

      print('');

      if (templatePath == null && defaultName == null) {
        ColoredLog.yellow(
          'To update the template directory use the below command',
        );
        ColoredLog('templify config -d "TEMPLATE DIRECTORY"', name: 'Option 1');
        ColoredLog(
          'templify config --dir "TEMPLATE DIRECTORY"',
          name: 'Option 2',
        );
        print('');
        ColoredLog.yellow(
          'To update the defaultTemplateModule name use the below command',
        );
        ColoredLog(
          'templify config -n "TEMPLATE MODULE NAME"',
          name: 'Option 1',
        );
        ColoredLog(
          'templify config --name "TEMPLATE MODULE NAME"',
          name: 'Option 2',
        );
        print('');
      } else {
        await Config.save(
          templatePath: config.templatePath,
          defaultName: config.defaultModuleName,
        );
      }

      // if (config.templatePath != null) {
      //   ColoredLog.yellow(
      //     'Do you want to update the templateDirectory (y/N):',
      //     name: 'Input',
      //   );
      //   final input = stdin.readLineSync();
      //   if ((input ?? '') == 'y' ||
      //       (input ?? '') == 'Y' ||
      //       (input ?? '') == 'yes') {
      //     config.templatePath = null;
      //   }
      // }
      // if (config.templatePath == null) {
      //   ColoredLog.yellow(
      //     'Do you want to update the templateDirectory (y/N):',
      //     name: 'Input',
      //   );
      //   final input = stdin.readLineSync();
      //   if ((input ?? '') == 'y' ||
      //       (input ?? '') == 'Y' ||
      //       (input ?? '') == 'yes') {
      //     ColoredLog.white(
      //       'Enter the path of the template directory where you will store all your templates :',
      //       name: 'Input',
      //     );
      //     final path = stdin.readLineSync();
      //     if (path != null) {
      //       final temPath = Directory(path);
      //       temPath.create(recursive: true);
      //       await Config.save(templatePath: temPath.path);
      //     }
      //   }
      //   return;
      // }
      return;
    }

    await Config.save(
      templatePath: templatePath,
      defaultName: defaultName,
    );
  }

  static openTemplateDirectory() async {
    final Config config = await Config.fromFile();
    final path = config.templatePath;
    Directory dir = Directory('${Directory.current.path}/templates');
    if (path == null) {
      if (await dir.exists()) {
        await Config.save(templatePath: dir.path);
      } else {
        ColoredLog.yellow(
          'No template folder found! Do you want to create template folder in the working directory (y/N):',
          name: 'Input',
        );
        final input = stdin.readLineSync();
        if ((input ?? '') == 'y' ||
            (input ?? '') == 'Y' ||
            (input ?? '') == 'yes') {
          await dir.create(recursive: true);
          ColoredLog.green(dir.path, name: 'Directory created');
        } else {
          ColoredLog.white(
            'Enter the path of the template directory where you will store all your templates :',
            name: 'Input',
          );
          final path = stdin.readLineSync();
          if (path != null) {
            final temPath = Directory('path');
            temPath.create(recursive: true);
            dir = temPath;
            await Config.save(templatePath: temPath.path);
          } else {
            ColoredLog.red('invalid input', name: 'Error');
            ColoredLog.magenta(
                'Try setting up your template directory using the below command');
            ColoredLog.yellow('templify config --dir <path>');
            print('or');
            ColoredLog.yellow('templify config -d <path>');
            exit(0);
          }
        }
      }
    }
    await openDirectory(path ?? dir.path);
  }

  static help({
    required ArgParser parser,
    required ArgParser createParser,
    required ArgParser configParser,
    bool version = false,
  }) {
    if (version) showVersion();
    Docs.printHelp(
      parser: parser,
      createParser: createParser,
      configParser: configParser,
    );
    print('');
    Docs.printTemplateCreationLogic();
  }

  static showVersion() {
    String filePath = Platform.script.path;
    filePath = filePath.replaceAll('bin/templify.dart', 'pubspec.yaml');
    final fileString = File(filePath).readAsStringSync();
    var doc = loadYaml(fileString);
    ColoredLog.yellow(doc['version'], name: 'Version');
  }

  static openDirectory(String? path) async {
    final dir = path ?? '.';
    ColoredLog.white('Opening directory at $dir');
    try {
      if (Platform.isWindows) {
        await Process.run('explorer', [dir]);
      } else if (Platform.isMacOS) {
        await Process.run('open', [dir]);
      } else if (Platform.isLinux) {
        await Process.run('xdg-open', [dir]);
      } else {
        ColoredLog.red(
          'Unsupported platform for opening file explorer',
          name: 'Failed',
        );
        throw 'Unsupported platform';
      }
    } catch (e) {
      throw 'Failed to open directory';
    }
  }
}
