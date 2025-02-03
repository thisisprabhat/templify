# Learnings

## Running shell command using dart
```dart
// Opening explorer in the current directory
await Process.run('open', ['.']);
```

- Other examples
```dart
void runCommandSync() {
  // Define the command and arguments
  var command = 'git';
  var arguments = ['--version'];
  try {
    // Run the command synchronously
    var result = Process.runSync(command, arguments);

    // Check the exit code and print output
    if (result.exitCode == 0) {
      print('Command output:');
      print(result.stdout);
    } else {
      print('Error running command:');
      print(result.stderr);
    }
  } catch (e) {
    print('Failed to run command: $e');
  }
}
```
