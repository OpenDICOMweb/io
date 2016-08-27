// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.
library odw.sdk.io.simple ;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:convert/dicom.dart';
import 'package:core/dicom.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;

//TODO: doc
/// Read an Instance from a File
Instance readInstance(String inPath) {
  final Logger log = new Logger("readInstance");
  log.level = Level.info;
  File file = new File(inPath);
  var bytes = file.readAsBytesSync();
  var filePath = path.normalize(file.path);
  log.debug('file length: ${bytes.length}, File: $filePath');
  DcmDecoder decoder = new DcmDecoder(bytes, 0, bytes.length, bytes.length);
  return decoder.readSopInstance();
}

//TODO: record input length in instance
const int defaultLength = 1024 * 1024;

//TODO: doc
/// Write an Instance to a File
void writeInstance(String outPath, Instance instance) {
  final Logger log = new Logger("writeInstance");
  log.level = Level.info;

  File outFile = new File(outPath);
  log.info('Writing file: $outFile');

  DcmEncoder writer = new DcmEncoder(defaultLength);
  writer.writeSopInstance(instance);
  log.info('writeIndex: ${writer.writeIndex}');

  var outBytes = writer.bytes.buffer.asUint8List(0, writer.writeIndex);
  log.info('out length: ${outBytes.length}');
  outFile.writeAsBytesSync(outBytes);

  // Format study for output;
  String fmtOutput = instance.study.format(new Prefixer());
  print(fmtOutput);
}




class DcmData {
  final File file;
  final Uint8List data;

  DcmData(this.file, this.data);

  DcmData.fromFile(File file)
      : file = file,
        data = file.readAsBytesSync();

  static Future<DcmData> retrieve(var path) async {
    File file = toFile(path);
    Uint8List data = await file.readAsBytes();
    return new DcmData(file, data);
  }
}

/// Returns a [File] if possible.
File toFile(path) {
  if (path is File) return path;
  if (path is String) return new File(path);
  if (path is Uri) new File.fromUri(path);
  return null;
}

Future<Uint8List> readDicomFile(String path) async {
  File file = toFile(path);
  return await file.readAsBytes();
}

Uint8List readDicomFileSync(var path) {
  File file = toFile(path);
  return file.readAsBytesSync();
}

/* Fix:
Future<Uint8List> readDcmFileList(List pathList) async {
  for (var path in pathList) {
    File file = toFile(path);
    return await file.readAsBytes();
  }
}
*/

Uint8List readDcmFileListSync(List pathList) {
  File file = toFile(pathList);
  return file.readAsBytesSync();
}
