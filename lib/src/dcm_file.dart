// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'dart:io';
import 'dart:typed_data';

import 'package:dictionary/uid.dart';
import 'package:path/path.dart' as path;

import 'file_system.dart';
import 'file_type.dart';

int _firstDot(String s) => path.basename(s).indexOf('.');

String _extension(String fname) => path.basename(fname).substring(_firstDot(fname));

class DcmFile {
  final FileSystem fs;
  final FileType fType;
  final Uid study;
  final Uid series;
  final Uid instance;

  DcmFile(this.fs, this.fType, this.study, [this.series, this.instance]);

  factory DcmFile.fromPath(FileSystem fs, String path) => fs.toFile(path);

  Directory get directory => fs.directory(study, series);
  DcmFile get file => fs.file(fType, study, series, instance);

  /// Returns the [File] corresponding to the specified arguments.
  String get path {
    var s = (series == null) ? "" : '/$series';
    var i = (instance == null) ? "" : '/$instance';
    return '${fs.path}/$study/$s/$i.${fType.extension}';
  }
  Uint8List get bytes {
    if (fType.charset == "octet") {
      File f = new File(path);
      return f.readAsBytesSync();
    } else {
      throw "Not a binary file type $this";
    }
  }

  String get json {

  }

  String get xml {

  }

  String toString() => 'DcmFile($path)';

  static void writeBytesSync(Uint8List bytes) {

  }

  static void writeStringSync(String s) {

  }

}