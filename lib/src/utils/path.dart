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

//String cleanPath(String path) => path.replaceAll('\\', '/');

/// Checks that [path] is not empty.
String checkPath(String path) {
  if (path == null || path == '') throw ArgumentError('Empty path: $path');
  return path;
}

final path.Context pathContext = path.Context(style: path.Style.posix);
final String separator = pathContext.separator;

/*
String getOutputPath(String inPath, {String dir, String base, String ext}) {
  dir ??= path.dirname(path.current);
  base ??= path.basenameWithoutExtension(inPath);
  ext ??= path.extension(inPath);
  return path.absolute(dir, '$base.$ext');
}

String getOutPath(String base, String ext, {String dir}) {
  dir ??= path.dirname(path.current);
  return cleanPath(path.absolute(dir, '$base.$ext'));
}
*/

String getVNAPath(RootDataset rds, String rootDir, String ext) {
  final study = rds.getUid(kStudyInstanceUID);
  final series = rds.getUid(kSeriesInstanceUID);
  final instance = rds.getUid(kSOPInstanceUID);
  final dirPath = '$rootDir/$study/$series';
  final dir = Directory(dirPath);
  if (!dir.existsSync()) dir.createSync(recursive: true);
  return '$dirPath/$instance.$ext';
}

Directory pathToDirectory(String path, {bool mustExist = true}) {
  final dir = Directory(path);
  return (mustExist && !dir.existsSync()) ? null : dir;
}

File pathToFile(String path, {bool mustExist = true}) {
  final file = File(path);
  final exists = file.existsSync();
  if (mustExist && !exists) {
    if (throwOnError) throw FileSystemException('Non-Existant File', path);
    return null;
  } else {
    return file;
  }
}

/*
// TODO: debug - allows asynchronous creation of the FS root.
/// Returns the [root] [Directory] of the MintFileSystem,
/// creating it if it doesn't exist.
Future<Directory> createRoot(String path) async {
  final root = Directory(path);
  if (!await root.exists()) await root.create(recursive: true);
  return root;
}
*/

//TODO move to utilities
/// Returns a [List] of [File]s with extension [ext] from
/// the specified [Directory].
List<File> getFilesFromDirectory(String path, [String ext = '.dcm']) {
  final dir = Directory(path);
  final entities = dir.listSync(recursive: true, followLinks: false);
  final files = <File>[];
  for (var e in entities) {
    if (e is File) files.add(e);
  }
  return files;
}

//**** Binary Utility Functions
//TODO: implement later
Future<FileSystemEntity> readDirectory(String path) => unimplementedError();

//TODO: debug, doc, and Test
Entity readBinaryDirectorySync(String path) {
  final d = Directory(path);
  return _readBinaryDirectorySync(d, []);
}

Entity _readBinaryDirectorySync(Directory d, List<Uint8List> bytesList) {
  final entities = d.listSync(recursive: true, followLinks: false);
  try {
    for (var e in entities) {
      if (e is Directory) {
        _readBinaryDirectorySync(e, bytesList);
      } else if (e is File) {
        bytesList.add(e.readAsBytesSync());
      } else {
        // ignore: only_throw_errors
        throw 'Invalid FileSystem Entity: $e';
      }
    }
  }
  // ignore: avoid_catches_without_on_clauses
  catch (e) {
    // ignore: avoid_empty_catch_blocks
  }
  // ignore: only_throw_errors
  throw 'Unimplemented';
}

//**** [String] based [File] utilities
//TODO: implement later
Stream<String> readStringDirectory(String path) {}

List<String> readStringDirectorySync(String path) =>
    _readStringDirectorySync( Directory(path), []);

List<String> _readStringDirectorySync(Directory d, List<String> bytesList) {
  final entities = d.listSync(recursive: true, followLinks: false);
  try {
    for (var e in entities) {
      if (e is Directory) {
        _readStringDirectorySync(e, bytesList);
      } else if (e is File) {
        bytesList.add(e.readAsStringSync());
      } else {
        // ignore: only_throw_errors
        throw 'Invalid FileSystem Entity: $e';
      }
    }
  }
  // ignore: avoid_catches_without_on_clauses,
  catch (e) {
    // ignore: avoid_empty_catch_blocks
  }
  return bytesList;
}

Future<Entity> readBinaryFile(String path) async {
  // ignore: only_throw_errors
  throw 'Unimplemented';
}

Uint8List readBinaryFileSync(String path) {
  final f = File(path);
  try {
    return f.readAsBytesSync();
  }
  // ignore: avoid_catches_without_on_clauses
  catch (e) {
    //TODO: finish
    return kEmptyUint8List;
  }
}

//TODO: implement later
//Stream<Uint8List> writeDirectory(String path) {}

Future<void> writeBinaryFile(String path, Uint8List bytes) async {
  final f = File(path);
  try {
    await f.writeAsBytes(bytes);
  }
  // ignore: avoid_catches_without_on_clauses
  catch (e) {
    //TODO: add code
  }
}

//TODO: implement later
//TODO: add try block
void writeDirectorySync(String path, Map<String, Uint8List> entries) {
  entries.forEach((path, bytes) {
    final f = File(path);
    try {
      f.writeAsBytesSync(bytes);
    }
    // ignore: avoid_catches_without_on_clauses
    catch (e) {
      //TODO: finish
    }
  });
}

void writeBinaryFileSync(String path, Uint8List bytes) {
  final f = File(path);
  try {
    f.writeAsBytes(bytes);
  }
  // ignore: avoid_catches_without_on_clauses
  catch (e) {
    //TODO: finish
  }
}

// TODO:test
bool isBinaryDicom(String path) {
  final bytes = readBinaryFileSync(path);
  if (bytes.lengthInBytes < 132) return false;
  final s = bytes.sublist(128, 132).toString();
  return s == 'DICM';
}

//TODO: implement later
//Stream<String> writeDirectory(String path) {}

//TODO: debug and test
void writeStringDirectorySync(String path, Map<String, String> entries) {
  entries.forEach((path, s) {
    final f = File(path);
    try {
      f.writeAsStringSync(s);
    }
    // ignore: avoid_catches_without_on_clauses
    catch (e) {
      //TODO: finish
    }
  });
}

Future<String> readStringFile(String path) async {
  final f = File(path);
  return await f.readAsString();
}

String readStringFileSync(String path) {
  final f = File(path);
  String s;
  try {
    s = f.readAsStringSync();
  }
  // ignore: avoid_catches_without_on_clauses
  catch (e) {
    //TODO: finish
  }
  return s;
}

Future<void> writeStringFile(String path, String s) async {
  final f = File(path);
  try {
    await f.writeAsString(s);
  }
  // ignore: avoid_catches_without_on_clauses
  catch (e) {
    //TODO: add code
  }
}

void writeStringFileSync(String path, String s) {
  final f = File(path);
  try {
    f.writeAsString(s);
  }
  // ignore: avoid_catches_without_on_clauses
  catch (e) {
    //TODO: finish
  }
}
