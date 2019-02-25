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

import 'package:io_extended/src/utils/base.dart';
import 'package:io_extended/src/utils/file.dart';

// ignore_for_file: public_member_api_docs

// TODO: debug - allows asynchronous creation of the FS root.
/// Returns the [root] [Directory] of the MintFileSystem,
/// creating it if it doesn't exist.
Future<Directory> createRoot(String path) async {
  final root = Directory(path);
  if (!await root.exists()) await root.create(recursive: true);
  return root;
}

typedef FSERunner = void Function(FileSystemEntity f, [int level]);

/// Walks a [Directory] recursively and applies [Runner] [f] to each [File].
Future<int> walkDirectory(Directory dir, FSERunner f, [int level = 0]) async {
  final eList = dir.list(recursive: false, followLinks: true);

  var count = 0;
  var _level = level;
  await for (final e in eList) {
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
  await for (final fse in eList) {
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
  for (final e in eList) {
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
  for (final e in eList) {
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

/// Returns a [List] of [File] from the [Directory] specified by rootPath.
List getFilesSync(Object directory, [Filter filter = isFile]) {
  Directory dir;
  if (directory is String) dir = Directory(directory);
  if (directory is Directory) dir = directory;
  if (dir == null) throw ArgumentError('must be String or Directory');
  return walkSync(dir, filter);
}

//TODO: debug and create unit test
/// Returns a [List] of values that result from walking the
/// [Directory] tree, and applying [filter] to each [File] in the tree.
Stream walk(Directory d, Filter filter) => _walk(d, filter);

Stream _walk(Directory d, Filter filter) async* {
  final stream = d.list(followLinks: false);
  // print('Length: ${entries.length}');
  try {
    await for (final e in stream) {
      if (e is File) {
        // print('Found file ${e.path}');
        final v = filter(e);
        if (v == null) continue;
        yield v;
      } else if (e is Directory) {
        //   print('Found dir ${e.path}');
        walk(e, filter);
      }
    }
  }
  // ignore: avoid_catches_without_on_clauses
  catch (e) {
    print(e.toString());
  }
}

//TODO: debug and create unit test
/// Returns a [List] of values that result from walking the
/// [Directory] tree, and applying [func] to each [File] in the tree.
List walkSync(Directory d, Function func) => _walkSync(d, func, <Object>[]);

// TODO: replace Function with true type
List _walkSync(Directory d, Function func, List<Object> list) {
  final entries = d.listSync(followLinks: false);
  try {
    for (final e in entries) {
      if (e is File) {
        // print('Found file ${e.path}');
        final Object v = func(e);
        if (v == null) continue;
        list.add(v);
      } else if (e is Directory) {
        list.add(_walkSync(e, func, list));
      }
    }
  }
  // ignore: avoid_catches_without_on_clauses
  catch (e) {
    print(e.toString());
  }
  return list;
}

Stream getFiles(String root, [Filter filter]) =>
    walk(Directory(root), filter);
