import 'dart:io';

import 'package:args/args.dart';
import 'package:colored_log/colored_log.dart';

void main(List<String> arguments) async {
  try {
    ArgParser parser = ArgParser();
    const appVersion = '1.0.0';

    //! Flag to print the version of the application ~~~~
    parser.addFlag(
      'version',
      abbr: 'v',
      help: 'Prints the version of the application.',
      negatable: false,
    );

    parser.addFlag(
      'help',
      abbr: 'h',
      help: 'It shows all the available commands and options',
    );

    parser.addFlag(
      'template',
      abbr: 't',
      help: 'It shows instructions to create template module.',
    );

    //! Command to open the template directory ~~~~~~~~
    parser.addCommand('open');
    //! Command to reset the config ~~~~~~~~~~~~~~~~~~~
    parser.addCommand('reset');

    //! Command to configure the template directory ~~~
    ArgParser configParser = ArgParser();
    //? Configuring template directory
    configParser.addOption(
      'dir',
      abbr: 'd',
      help: 'The path to the directory where the template will be stored.',
    );
    //? Configuring template module name
    configParser.addOption(
      'name',
      abbr: 'n',
      help: 'Name of the template module.',
    );
    parser.addCommand('config', configParser);
    //? __________________________________________________

    //! Command to create a new module ~~~~~~~~~~~~~~~~~~~
    ArgParser createParser = ArgParser();
    createParser.addOption(
      'name',
      abbr: 'n',
      help: 'Name of the module to be created.',
    );

    createParser.addOption(
      'path',
      abbr: 'p',
      help: 'Path to the directory where the module will be created.',
    );

    parser.addCommand('create', createParser);

    ArgResults argResults = parser.parse(arguments);

    final bool isOpenCommand = argResults.command?.name == 'open';

    // ColoredLog(argResults.options, name: 'name');
    // ColoredLog(argResults.command?.name, name: 'Sub Command');
    // ColoredLog(argResults['version'], name: 'version');
    // if (argResults['version'] == true) {
    ColoredLog.green('My CLI Project version: $appVersion');
    // } else if (argResults.command?.option('name') != null) {
    //   ColoredLog(argResults['name'], name: 'name Option');
    // }
    if (isOpenCommand) {
      ColoredLog.green('Opening the current directory...');
      //! Open the current directory
      await Process.run('open', ['.']);
    }

    ColoredLog(argResults, name: 'Commands');

    ColoredLog(argResults.command?.name, name: 'Command');

    ColoredLog.yellow(arguments, name: 'Arguments');
    ColoredLog.yellow('\ntemplify');
    ColoredLog.green(parser.usage);
    ColoredLog.yellow('\ntemplify config');
    ColoredLog.green(configParser.usage);
    ColoredLog.yellow('\ntemplify create');
    ColoredLog.green(createParser.usage);
  } on FormatException catch (e) {
    ColoredLog.red(e.message, name: 'Invalid', style: LogStyle.italicized);
  } catch (e) {
    ColoredLog.red('An error occurred');
  }
}
