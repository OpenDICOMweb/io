//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:io';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:path/path.dart';
import 'package:io_extended/src/utils/base.dart';

/// Returns a [List] of [Uint8List]s containing all the SOP Instances
/// of the [Study] specified by the [Directory].
String getFilename(File f) => basenameWithoutExtension(f.path);
String getFileExt(File f) => extension(f.path);

String getTempFile(String infile, String extension) {
  final name = basenameWithoutExtension(infile);
  final dir = Directory.systemTemp.path;
  return '$dir/$name.$extension';
}

/// Checks that [file] is not empty.
// Urgent: rename isEmptyFile
void checkFile(File file, {bool overWrite = false}) {
  if (file == null) throw new ArgumentError('null File');
  if (file.existsSync() && (file.lengthSync() == 0))
    throw new ArgumentError('$file has zero length');
}


/// Returns _true_ if the [path] has [ext] as it's file extension.
bool hasExtension(String path, String ext) => extension(path) == ext;

String testExtension(String path, String ext) => (hasExtension(path, ext)) ? ext : null;
/*
/// Returns _true_ if [f] has the [sopInstance] file extension.
File isDcmFile(File f) =>
    (hasExtension(f.path, '.dcm')) ? f : null;

/// Returns _true_ if [f] has the [metadata] file extension.
bool isMetadataFile(File f) => hasExtension(f.path, FileSubtype.ext);

/// Returns _true_ if [f] has the [bulkdate] file extension.
bool isBulkdataFile(File f) => hasExtension(f.path, FileSubtype.ext);
*/
/// Returns the [File] if the [Filter] is _true_; otherwise, null.
File filter(File f, Filter p) => (p(f) != null) ? f : null;

//
File isFile(Object f) => (f is File) ? f : null;


