//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as path;

const List<String> stdDcmJsonExtensions = const <String>[
  '.json',
  '.dcmjson',
  '.JSON'
];

//TODO: what should default be?
const int kSmallDcmJsonFileLimit = 376;

Future<String> readDcmJsonPath(String fPath,
    [List<String> extensions = stdDcmJsonExtensions,
    int sizeLimit = kSmallDcmJsonFileLimit]) async {
  final ext = path.extension(fPath);
  if (!extensions.contains(ext)) return null;
  final f = new File(fPath);
  return readDcmJsonFile(f, sizeLimit);
}

Future<String> readDcmJsonFile(File f,
    [int sizeLimit = kSmallDcmJsonFileLimit]) async {
  String json;
  int length;
  if (f.existsSync()) {
    length = await f.length();
    if (length > kSmallDcmJsonFileLimit) {
      try {
        json = await f.readAsString();
      } on FileSystemException {
        return null;
      }
      return (json.length > kSmallDcmJsonFileLimit) ? json : null;
    }
  }
  return null;
}

Uint8List readJsonPathSync(String fPath,
    [List<String> extensions = stdDcmJsonExtensions,
    int sizeLimit = kSmallDcmJsonFileLimit]) {
  final ext = path.extension(fPath);
  if (!extensions.contains(ext)) return null;
  final f = new File(fPath);
  return readJsonFileSync(f, sizeLimit);
}

Uint8List readJsonFileSync(File f, [int sizeLimit = kSmallDcmJsonFileLimit]) {
  Uint8List bytes;
  if (!f.existsSync() && (f.lengthSync() <= kSmallDcmJsonFileLimit))
    return null;
  try {
    bytes = f.readAsBytesSync();
  } on FileSystemException {
    return null;
  }
  return (bytes.length > kSmallDcmJsonFileLimit) ? bytes : null;
}
