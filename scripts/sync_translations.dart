import 'dart:convert';
import 'dart:io';

const translationDirectory = 'assets/lang';
const localeFiles = {
  'en': 'en-US.json',
  'ar': 'ar-SA.json',
};

void main(List<String> args) {
  final root = Directory.current;
  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    stderr.writeln(
        'Could not find lib/ directory in ${root.path}. Run this from the project root.');
    exit(1);
  }

  final sourceFiles = collectDartFiles(libDir);
  final keys = extractTranslationKeys(sourceFiles);
  if (keys.isEmpty) {
    print('No translation keys found in lib/.');
    return;
  }

  final missing = <String, List<String>>{};

  for (final locale in localeFiles.keys) {
    final filePath = '${translationDirectory}/${localeFiles[locale]}';
    final file = File(filePath);
    if (!file.existsSync()) {
      stderr.writeln('Missing translation file: $filePath');
      exit(1);
    }

    final jsonMap = loadJsonMap(file);
    final missingKeys = <String>[];
    for (final key in keys) {
      if (!jsonMap.containsKey(key)) {
        missingKeys.add(key);
        jsonMap[key] = key;
      }
    }

    if (missingKeys.isNotEmpty) {
      missing[locale] = missingKeys;
      writeJsonMap(file, jsonMap);
    }
  }

  if (missing.isEmpty) {
    print(
        'All translation keys are present in ${localeFiles.values.join(', ')}.');
  } else {
    print('Added missing translation keys to JSON files:');
    for (final locale in missing.keys) {
      print('- ${localeFiles[locale]}: ${missing[locale]!.length} new keys');
    }
  }
}

List<File> collectDartFiles(Directory dir) {
  final files = <File>[];
  for (final entity in dir.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      files.add(entity);
    }
  }
  return files;
}

Set<String> extractTranslationKeys(List<File> files) {
  final keyPattern1 =
      RegExp(r'''(?:\b(?:easy|e)\.tr|\btr)\(\s*(['"])(.*?)\1\s*\)''');
  final keyPattern2 = RegExp(r'''(['"])(.*?)\1\s*\.tr''');
  final keys = <String>{};

  for (final file in files) {
    final content = file.readAsStringSync();

    for (final match in keyPattern1.allMatches(content)) {
      final value = match.group(2);
      if (_isValidTranslationKey(value)) {
        keys.add(value!);
      }
    }

    for (final match in keyPattern2.allMatches(content)) {
      final value = match.group(2);
      if (_isValidTranslationKey(value)) {
        keys.add(value!);
      }
    }
  }

  return keys;
}

bool _isValidTranslationKey(String? value) {
  if (value == null || value.isEmpty) return false;
  if (value.contains(r'${') || value.contains(r'$')) return false;
  return true;
}

Map<String, dynamic> loadJsonMap(File file) {
  try {
    final decoded = jsonDecode(file.readAsStringSync());
    if (decoded is Map<String, dynamic>) {
      return Map<String, dynamic>.from(decoded);
    }
    stderr.writeln(
        'Translation file ${file.path} does not contain a JSON object.');
    exit(1);
  } catch (e) {
    stderr.writeln('Failed to parse JSON from ${file.path}: $e');
    exit(1);
  }
}

void writeJsonMap(File file, Map<String, dynamic> map) {
  final encoder = JsonEncoder.withIndent('  ');
  final encoded = encoder.convert(map);
  file.writeAsStringSync('$encoded\n');
}
