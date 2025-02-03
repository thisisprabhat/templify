import 'package:args/args.dart';

import 'package:templify/commands/commands.dart';
import 'package:templify/docs/docs.dart';

void main(List<String> arguments) async {
  ArgParser parser = ArgParser();
  ArgParser configParser = ArgParser();
  ArgParser createParser = ArgParser();
  try {
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
      negatable: false,
      help: 'It shows all the available commands and options',
    );

    //! Command to open the template directory ~~~~~~~~
    parser.addCommand('open');
    //! Command to reset the config ~~~~~~~~~~~~~~~~~~~
    parser.addCommand('reset');

    //! Command to configure the template directory ~~~

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

    if (arguments.isEmpty) {
      Commands.help(
        parser: parser,
        createParser: createParser,
        configParser: configParser,
        version: true,
      );
      return;
    }

    //! Handling the All Commands ~~~~~~~~~~~~~~~~~~~~~~~~
    Commands.handleCommands(
      arguments: arguments,
      parser: parser,
      configParser: configParser,
      createParser: createParser,
    );
    //! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  } on FormatException catch (e) {
    Docs.printHelp(
      parser: parser,
      createParser: createParser,
      configParser: configParser,
      error: e.message,
    );
  } catch (e) {
    Docs.printHelp(
      parser: parser,
      createParser: createParser,
      configParser: configParser,
      error: e.toString(),
    );
  }
}
