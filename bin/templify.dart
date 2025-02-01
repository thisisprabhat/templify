import 'package:args/args.dart';
import 'package:colored_log/colored_log.dart';
import 'package:templify/templify.dart';

void main(List<String> arguments) {
  var parser = ArgParser();
  var command = parser.addCommand('path');

  // final templify = Templify();
  // templify.operation();
  ColoredLog.yellow(arguments, name: 'Arguments');
}
