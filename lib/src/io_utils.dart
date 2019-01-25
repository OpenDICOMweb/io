//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:path/path.dart' as path;

// ignore_for_file: public_member_api_docs

//TODO: move to io_utils
/// Checks that [dataset] is not empty.
void checkRootDataset(Dataset dataset) {
  if (dataset == null || dataset.isEmpty)
    throw ArgumentError('Empty ' 'Empty Dataset: $dataset');
}

final path.Context pathContext = path.Context(style: path.Style.posix);
final String separator = pathContext.separator;

typedef FSERunner = void Function(FileSystemEntity f, [int level]);

/// Walks a [Directory] recursively and applies [Runner] [f] to each [File].
Future<int> walkDirectory(Directory dir, FSERunner f, [int level = 0]) async {
  final eList = dir.list(recursive: false, followLinks: true);

  var count = 0;
  var _level = level;
  await for (FileSystemEntity e in eList) {
    if (e is Directory) {
      count += await walkDirectory(e, f, _level++);
    } else if (e is File) {
      await Future(() => f(e, level));
      count++;
    } else {
      stderr.write('Warning: $e is not a File or Directory');
    }
  }
  return count;
}

typedef FileRunner = void Function(File f, [int level]);

/// Walks a [Directory] recursively and applies [Runner] [f] to each [File].
Future<int> walkDirectoryFiles(Directory dir, FileRunner f,
    [int level = 0]) async {
  final eList = dir.list(recursive: false, followLinks: true);

  var count = 0;
  var _level = level;
  await for (FileSystemEntity fse in eList) {
    if (fse is Directory) {
      count += await walkDirectory(fse, f, _level++);
    } else if (fse is File) {
      await Future(() => f(fse, level));
      count++;
    } else {
      stderr.write('Warning: $fse is not a File or Directory');
    }
  }
  return count;
}

/// Walks a [Directory] recursively and applies [Runner] [f] to each [File].
int walkDirectorySync(Directory dir, FSERunner f, [int level = 0]) {
  var _level = level;
  f(dir, _level);
  final eList = dir.listSync(recursive: false, followLinks: true);

  _level++;
  var count = 0;
  for (var e in eList) {
    if (e is Directory) {
      count += walkDirectorySync(e, f, _level);
    } else if (e is File) {
      f(e, _level);
      count++;
    } else {
      stderr.write('Warning: $e is not a File or Directory');
    }
  }
  _level--;
  return count;
}

/// Walks a [Directory] recursively and applies [Runner] [f] to each [File].
int walkDirectoryFilesSync(Directory dir, FileRunner f, [int level = 0]) {
  var _level = level;
  // f(dir, _level);
  final eList = dir.listSync(recursive: false, followLinks: true);

  _level++;
  var count = 0;
  for (var e in eList) {
    if (e is Directory) {
      count += walkDirectorySync(e, f, _level);
    } else if (e is File) {
      f(e, _level);
      count++;
    } else {
      stderr.write('Warning: $e is not a File or Directory');
    }
  }
  _level--;
  return count;
}

typedef RunFile = Null Function(File f, [int count]);

/// Walks a [List] of [String], [File], List<String>, or List<File>, and
/// applies [runner] to each one asynchronously.
Future<int> walkPathList(Iterable paths, RunFile runner,
    [int level = 0]) async {
  var count = 0;
  var _level = level;
  for (var entry in paths) {
    if (entry is List) {
      count += await walkPathList(entry, runner, _level++);
    } else if (entry is String) {
      final f = File(entry);
      await runFile(f, runner);
    } else if (entry is File) {
      await runFile(entry, runner);
      count++;
    } else {
      stderr.write('Warning: $entry is not a File or Directory');
    }
  }
  return count;
}

Future<void> runFile(File file, RunFile runner, [int level = 0]) async =>
    await Future<void>(() => runner(file, level));

Future<void> runPath(String path, RunFile runner, [int level = 0]) async =>
    await Future<void>(() => runner(File(path), level));

/// Returns the number of [File]s in a [Directory]
int fileCount(Directory d, {List<String> extensions, bool recursive = true}) {
  final eList = d.listSync(recursive: recursive);
  var count = 0;
  for (var fse in eList) if (fse is File) count++;
  return count;
}

const List<String> stdDcmExtensions = <String>['.dcm', '', '.DCM'];

//TODO: what should default be?
const int kSmallDcmFileLimit = 376;

Bytes readPath(String fPath,
    { // TODO: change to true when async works
    bool doAsync = false,
    List<String> extensions = stdDcmExtensions,
    int minLength = kSmallDcmFileLimit,
    int maxLength}) {
  final ext = path.extension(fPath);
  if (!extensions.contains(ext)) return null;
  final f = File(fPath);
  return readFile(f,
      doAsync: doAsync, minLength: minLength, maxLength: maxLength);
}

Bytes readFile(File f,
    { // TODO: change to true when async works
    bool doAsync = false,
    List<String> extensions = stdDcmExtensions,
    int minLength = kSmallDcmFileLimit,
    int maxLength}) {
  if (!f.existsSync() || !_checkLength(f, doAsync, minLength, maxLength))
    return null;
  try {
    final bytes = doAsync ? _readAsync(f) : _readSync(f);
    return Bytes.from(bytes);
  } on FileSystemException {
    return null;
  }
}

bool _checkLength(File f, bool doAsync, int min, int max) =>
    doAsync ? _checkLenAsync(f, min, max) : _checkLenSync(f, min, max);

Future<bool> _checkLenAsync(File f, int min, int max) async {
  assert(min >= 0 && max > min);
  final len = await f.length();
  final max0 = max ?? len;
  assert(min >= 0 && max0 > min);
  return len >= min && len <= max0;
}

bool _checkLenSync(File f, int min, int max) {
  final len = f.lengthSync();
  final max0 = max ?? len;
  assert(min >= 0 && max0 > min);
  final v = len >= min && len <= max0;
  return v;
}

Future<Uint8List> _readAsync(File f) async => await f.readAsBytes();
Uint8List _readSync(File f) => f.readAsBytesSync();

List<String> fileListFromDirectory(String dirPath) {
  final dir = Directory(dirPath);
  final fList = dir.listSync(recursive: true);
  final fsEntityCount = fList.length;
  log
    ..debug('List length: $fsEntityCount')
    ..debug('FSEntity count: $fsEntityCount');

  final files = <String>[];
  for (var fse in fList) {
    if (fse is! File) continue;
    final ext = path.extension(fse.path);
    if (ext == '.dcm' || ext == '') {
      log.debug1('$fse');
      files.add(fse.path);
    }
  }
  return files;
}
