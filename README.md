# Templify

A cli app built using dart, that creates a module or sub module from a template.
- It speeds up the development eliminating to copy paste similar modules or portion of code over and over again
- We can templify similar controllers or ui part in our code and enjoy

## List of commands
templify has three commands
- base command
- config
- create

### templify
```

-v, --version      Prints the version of the application.

-h, --help         It shows all the available commands, 

-t, --template     It shows instructions to create template module.

```


### templify config
```

-d, --dir    The path to the directory where the template will be stored.

-n, --name         Name of the template module.

```


### templify create 
```

-n, --name         Name of the module to be created.

-p, --path         Path to the directory where the module will be created.

```

## Template creation guide

> templateDefaultName = `testModule`
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
5. In the root template directory we can have a file named `name.txt` and inside it we can have name of the template which will be overridden from global `templateDefaultName`<br>
    > name.txt
    ```
    testModule
    ```
5. You may also add `instructions.md` file to be printed after module creation
    > instructions.md
    ```
    ## Copy TestRepo().init() to main() file
    '''
    void main(){
        TestRepo().init();
        ...
    }
    '''

    ....
    .....
    ```

## Example template structure
```ts
templateName
├── components
│   ├── test_card.dart
│   ├── test_details_info_page.dart
│   ├── test_details_side.dart
│   └── test_mobile_view.dart
├── controllers
│   ├── add_update_test_provider.dart
│   └── test_details_provider.dart
├── data
│   ├── dummy_test_data.dart
│   ├── models
│   │   └── test_model.dart
│   └── repositories
│       ├── test_dummy_repo.dart
│       └── test_remote_repo.dart
└── views
    ├── add_update_test.dart
    ├── test_details.dart
    └── test_screen.dart
```

