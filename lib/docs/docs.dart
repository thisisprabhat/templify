import 'package:args/args.dart';
import 'package:colored_log/colored_log.dart';

class Docs {
  static printTemplateCreationLogic() {
    ColoredLog.yellow('''
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                  Template creation guide
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
''');
    ColoredLog.magenta('''
> templateDefaultName = `testModule`
''');
    ColoredLog.white('''
1. Naming files
    * test_module_model.dart
    * test_module_controller.dart

2. Naming variables, functions and class
    * testModuleStatus
    * fetchTestModuleData()
    * class TestModuleModel()
3. Using Title and text as
    * test module
    * Test Module
    * test-module

4. Structure folder structure
    * root folder should have name of the template
    * Inside the root folder we should have all the folders and files
5. In the root template directory we can have a file named `name.txt` and inside it we can have name of the template which will be overridden from global `templateDefaultName`
    > name.txt
    ```````````
    testModule
    ```````````
6. You may also add `instructions.md` file to be printed after module creation''');
  }

  static printHelp({
    required ArgParser parser,
    required ArgParser createParser,
    required ArgParser configParser,
    String? error,
  }) {
    if (error != null) {
      ColoredLog.red(
        '''
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$error
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
''',
        style: LogStyle.blinkSlow,
      );
      ColoredLog.white('See the available commands and options below:');
    }

    ColoredLog.yellow('\ntemplify');
    ColoredLog.green(parser.usage);
    ColoredLog.yellow('\ntemplify config');
    ColoredLog.green(configParser.usage);
    ColoredLog.yellow('\ntemplify create');
    ColoredLog.green(createParser.usage);
    print('');
  }
}
