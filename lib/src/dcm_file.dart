// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:core/core.dart';

import 'file_system.dart';
import 'file_type.dart';

// ignore_for_file: public_member_api_docs
// ignore_for_file: only_throw_errors, avoid_catches_without_on_clauses

class DcmFile {
  DcmFile(this.fs, this.fType, this.entity);
  factory DcmFile.fromPath(FileSystem fs, String path) => fs.toFile(path);

  final FileSystem fs;
  final FileType fType;
  final Entity entity;

  Directory get directory => fs.directory(entity);

  File get file => File(path);

  /// Returns the [File] corresponding to the specified arguments.
  String get path => '${fs.rootPath}$entity${fType.extension}';

  Uint8List get bytes {
    if (fType.subtype.isBinary) {
      final f = File(path);
      return f.readAsBytesSync();
    } else {
      throw 'Not a binary file type $this';
    }
  }

  String get json {
    throw 'Unimplemented';
  }

  String get xml {
    throw 'Unimplemented';
  }

  @override
  String toString() => 'DcmFile($path)';

  Future<bool> write(Uint8List bytes) async {
    final f = File(path);
    await f.writeAsBytes(bytes);
    return true;
  }

  void writeSync(Uint8List bytes) {
    //  print('writeSync: path:$path');
    final f = File(path);
    if (f.existsSync()) {
      throw 'File $f already exists';
    } else {
      //    print('Creating: $f');
      f.createSync(recursive: true);
    }

    try {
      f.writeAsBytesSync(
        bytes,
      );
    } catch (e) {
      throw 'caught $e';
    }
  }

  void writeStringSync(String s) {}
}
