import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

///## An extension on the [String] class that provides methods for transforming text.
///
/// This extension adds various text transformation methods such as converting a string
/// to title case, small case, camel case, hyphen case, snake case, and capitalizing
/// the first letter of each word. These methods can be used to modify string formats
/// for various use cases.
extension StringExtensions on String {
  //!~~~~~~~~~~~~~~~~~~~~~~~ Title Case ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ///## Converts the string to title case.
  ///* This method splits the string by spaces, hyphens, or underscores, and capitalizes
  /// each word while making other letters lowercase.
  ///* Returns a new string with each word capitalized and separated by a space.
  ///
  ///### Example:
  /// ```dart
  /// "hello_world".toTitleCase; // Returns "Hello World"
  /// ```
  ///
  ///### Returns: A [String] in title case.
  String get toTitleCase {
    // Split the string by non-alphabetic characters (spaces, underscores, etc.)
    List<String> words = replaceAll(
            RegExp(r'[_-]'), ' ') // Replace underscores and hyphens with spaces
        .split(' ') // Split by spaces
        .map((word) => word.trim()) // Remove any leading or trailing spaces
        .where((word) => word.isNotEmpty) // Remove empty words if any
        .toList();

    // Capitalize the first letter of each word and join them back together
    return words
        .map((word) => word.isNotEmpty
            ? word[0].toUpperCase() + word.substring(1).toLowerCase()
            : '')
        .join(' ');
  }

  //!~~~~~~~~~~~~~~~~~~~~~~~ Small Case Text ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ///## Converts the string to small case text.
  ///* This method splits the string by spaces, hyphens, or underscores, and converts
  /// each word to lowercase.
  ///* Returns a new string with all letters in lowercase, separated by spaces.
  ///
  ///### Example:
  /// ```dart
  /// "Hello_World".toSmallCaseText; // Returns "hello world"
  /// ```
  ///
  ///### Returns: A [String] in small case text.
  String get toSmallCaseText {
    List<String> words = split(RegExp(r'[-_]'));
    for (int i = 0; i < words.length; i++) {
      words[i] = words[i].isEmpty ? '' : words[i].toLowerCase();
    }
    return words.join(' ');
  }

  //!~~~~~~~~~~~~~~~~~~~~~~~ Pascal Case ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ///## Capitalizes the first letter of each word in the string.
  ///* This method splits the string by spaces, hyphens, or underscores and capitalizes
  /// the first letter of each word while making the rest of the letters lowercase.
  ///* Returns a new string where each word's first letter is capitalized, and the rest
  /// of the word is in lowercase.
  ///
  ///### Example:
  /// ```dart
  /// "hello world".toPascalCase; // Returns "HelloWorld"
  /// ```
  ///
  ///### Returns: A [String] with the first letter of each word capitalized.
  String get toPascalCase {
    return split(RegExp(r'[\s_-]+')).map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join('');
  }

  //!~~~~~~~~~~~~~~~~~~~~~~~ Kebab Case ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ///## Converts the string to hyphen case.
  ///* This method splits the string by spaces, hyphens, or underscores and then joins
  /// the words with kebab in lowercase.
  ///* Returns a new string in kebab case, with all words in lowercase and separated by hyphens.
  ///
  ///### Example:
  /// ```dart
  /// "Hello World".toKebabCase; // Returns "hello-world"
  /// ```
  ///
  ///### Returns: A [String] in kebab case.
  String get toKebabCase {
    return split(RegExp(r'[\s_-]+'))
        .map((word) => word.toLowerCase())
        .join('-');
  }

  //!~~~~~~~~~~~~~~~~~~~~~~~ Camel Case ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ///## Converts the string to camel case.
  ///* This method splits the string by spaces, hyphens, or underscores and converts
  /// it into camel case, where the first word is lowercase and all subsequent words
  /// start with an uppercase letter.
  ///* Returns a new string in camel case.
  ///
  ///### Example:
  /// ```dart
  /// "hello world".toCamelCase; // Returns "helloWorld"
  /// ```
  ///
  ///### Returns: A [String] in camel case.
  String get toCamelCase {
    List<String> words = split(RegExp(r'[\s_-]+'));
    if (words.isEmpty) return this;
    return words.first.toLowerCase() +
        words.skip(1).map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        }).join('');
  }

  //!~~~~~~~~~~~~~~~~~~~~~~~ Snake Case ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ///## Converts the string to snake case.
  ///* This method splits the string by spaces, hyphens, or underscores and joins
  /// the words with underscores in lowercase.
  ///* Returns a new string in snake case, with all words in lowercase and separated by underscores.
  ///
  ///### Example:
  /// ```dart
  /// "Hello World".toSnakeCase; // Returns "hello_world"
  /// ```
  ///
  ///### Returns: A [String] in snake case.
  String get toSnakeCase {
    return split(RegExp(r'[\s_-]+'))
        .map((word) => word.toLowerCase())
        .join('_');
  }

  ///!~~~~~~~~~~~~~~~~~~~~~~~ Initials ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ///## Returns the initials of the words in the string, up to a maximum of three.
  ///
  /// This method splits the string by spaces and extracts the first letter of each
  /// word, converting it to uppercase. It returns a string containing the
  /// initials.  Only the first three words are considered.
  ///
  /// Example:
  /// ```dart
  /// "John Doe".initials; // Returns "JD"
  /// "Jane Mary Doe".initials; // Returns "JMD"
  /// "A B C D".initials; // Returns "ABC"
  /// "  John Doe".initials; // Returns "JD" (handles leading spaces)
  /// "".initials; // Returns "" (handles empty string)
  /// "John".initials; // Returns "J"
  /// ```
  ///
  /// Returns: A [String] containing the initials.
  String get initials {
    List<String> words = split(' ');
    String initials = '';
    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      if (i < 3) {
        initials += (word.isNotEmpty ? word[0] : '').toUpperCase();
      }
    }
    return initials;
  }

  ///!~~~~~~~~~~~~~~~~~~~~~~~ Currency Symbol ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ///
  /// Returns a new string with the currency symbol prefixed to the original string.
  ///
  /// we can set any currency symbol statically or dynamically as per requirement.
  /// Example:
  /// ```dart
  /// "100".withCurrencySymbol; // Returns "₹ 100"
  /// "1000.50".withCurrencySymbol; // Returns "₹ 1000.50"
  /// "".withCurrencySymbol; // Returns "₹ "
  /// ```
  ///
  /// Returns:
  ///   A [String] with the currency symbol.
  String get withCurrencySymbol => '₹ $this';

  String? validate(String? v) {
    if ((v ?? '').isEmpty) {
      return '$this is required'.tran;
    } else {
      return null;
    }
  }

  ///!~~~~~~~~~~~~~~~~~~~~~~~ string to enum ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ///## Converts a string to an enum value of type `T`.
  ///
  /// This method attempts to find an enum value in the provided list
  /// `enumValues` that matches the string representation of the enum's name.
  /// The comparison is done against the part of the enum value's string
  /// representation after the last dot (`.`).  If no match is found, it
  /// returns `null`.
  ///
  /// Example:
  /// ```dart
  /// enum Color { red, green, blue }
  ///
  /// "red".toEnum(Color.values); // Returns Color.red
  /// "green".toEnum(Color.values); // Returns Color.green
  /// "blue".toEnum(Color.values); // Returns Color.blue
  /// "RED".toEnum(Color.values); // Returns null (case-sensitive)
  /// "purple".toEnum(Color.values); // Returns null (not in enum)
  /// ```
  ///
  /// Type parameters:
  ///   * `T`: The enum type.
  ///
  /// Parameters:
  ///   * `enumValues`: A list of enum values of type `T` to search within.
  ///
  /// Returns:
  ///   The enum value of type `T` that matches the string, or `null` if no match is found.
  T? toEnum<T>(List<T> enumValues) =>
      enumValues.firstWhereOrNull((e) => e.toString().split('.').last == this);

//! Extension for translation to be used later when required
  String get tran {
    // transalatedKeyValuData[this] = this;
    // ColoredLog(jsonEncode(transalatedKeyValuData));
    // return this;
    // getNewKeys();
    return this;
  }

  ///!~~~~~~~~~~~~~~~~~~~~~~~ Obfuscate ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ///## Obfuscates a string by replacing the middle characters with asterisks.
  ///
  /// If the string's length is less than or equal to 3, it returns the
  /// original string unchanged. Otherwise, it keeps the first three and
  /// last three characters and replaces the characters in between with
  /// asterisks.
  ///
  /// Example:
  /// ```dart
  /// "1234567890".obfuscate; // Returns "123*******0"
  /// "abcdef".obfuscate;   // Returns "abc***f"
  /// "abc".obfuscate;      // Returns "abc" (length <= 3)
  /// "ab".obfuscate;       // Returns "ab"  (length <= 3)
  /// "a".obfuscate;        // Returns "a" (length <= 3)
  /// "".obfuscate;         // Returns "" (length <= 3)
  /// ```
  ///
  /// Returns:
  ///   The obfuscated string, or the original string if its length is less
  ///   than or equal to 3.
  String get obfuscate {
    if (length <= 3) return this;
    String start = substring(0, 3);
    String end = substring(length - 3);
    String obfuscatedText = '$start${'*' * (length - 6)}$end';
    return obfuscatedText;
  }

  ///!~~~~~~~~~~~~~~~~~~~~~~~ To Date Time ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ///## Parses a string representation of a date and time into a [DateTime] object.
  ///
  /// This extension method attempts to parse the string as a date and time
  /// using several common formats. It returns `null` if the string cannot be
  /// parsed as a valid date and time.  It prioritizes parsing using
  /// `DateTime.tryParse` for ISO 8601 format, then it attempts parsing
  /// with `intl`'s `DateFormat` for other common formats.
  ///
  /// Example:
  /// ```dart
  /// "2024-03-15 10:30:00".toDateTime; // Returns DateTime(2024, 3, 15, 10, 30, 0)
  /// "2024-03-15".toDateTime;       // Returns DateTime(2024, 3, 15, 0, 0, 0)
  /// "15/03/2024".toDateTime;       // Returns DateTime(2024, 3, 15, 0, 0, 0)
  /// "March 15, 2024".toDateTime;    // Returns DateTime(2024, 3, 15, 0, 0, 0)
  /// "invalid date".toDateTime;      // Returns null
  /// null.toDateTime;                // Returns null
  /// ```
  ///
  /// Returns: A [DateTime] object if the string can be parsed, or `null` otherwise.
  DateTime? get toDateTime {
    final input = this;
    return DateTime.tryParse(input) ?? // Try ISO 8601 first
        DateFormat('yyyy-MM-dd').tryParse(input) ??
        DateFormat('dd/MM/yyyy').tryParse(input) ??
        DateFormat('MM/dd/yyyy').tryParse(input) ??
        DateFormat('MMM dd, yyyy').tryParse(input) ?? // Example: March 15, 2024
        DateFormat('MMMM dd, yyyy').tryParse(input); // Example: March 15, 2024
  }

  String replaceCaseWith(String oldValue, String newValue) {
    String fileContents = replaceAll(
      oldValue.toCamelCase,
      newValue.toCamelCase,
    );

    fileContents = fileContents.replaceAll(
      oldValue.toTitleCase,
      newValue.toTitleCase,
    );

    fileContents = fileContents.replaceAll(
      oldValue.toUpperCase(),
      newValue.toUpperCase(),
    );

    fileContents = fileContents.replaceAll(
      oldValue.toKebabCase,
      newValue.toKebabCase,
    );

    fileContents = fileContents.replaceAll(
      oldValue.toSnakeCase,
      newValue.toSnakeCase,
    );

    fileContents = fileContents.replaceAll(
      oldValue.toLowerCase(),
      newValue.toLowerCase(),
    );

    return fileContents;
  }

  bool get containsAvoidableFiles {
    final avoidableFiles = ['name.txt', 'instructions.md', 'config.yaml'];
    return avoidableFiles.contains(this);
  }

  bool get containsAvoidableDirectory {
    final avoidableDirectory = ['.git', '.dart_tools', 'node_modules'];
    return avoidableDirectory.contains(this);
  }
}
