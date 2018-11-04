// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the   AUTHORS file for other contributors.
//
import 'dart:async';
import 'dart:typed_data';

import 'package:core/server.dart';
import 'package:converter/converter.dart';
import 'package:io_extended/io_extended.dart';
import 'package:io_extended/src/tools/compare_files.dart';

// ignore_for_file: only_throw_errors, avoid_catches_without_on_clauses

String inputDir = 'C:/acr/odw/sdk/io/example/input';
String inputDir2 = 'C:/acr/odw/test_data/sfd/CT';

String outputDir = 'C:/acr/odw/sdk/io/example/output';

class FileTestError {
  FileTestError(this.inFile, this.outFile);

  Filename inFile;
  Filename outFile;
  String read;
  String reRead;
  String dsCompare;
  FileCompareResult result;

  @override
  String toString() => '''
File Text Error:
     in: $inFile
    out: $outFile
     ds: $dsCompare
  bytes: $result
  ''';
}

Future<Null> main(List<String> args) async {
  Server.initialize(name: 'readFile_test.dart', level: Level.info0);
  final watch = new Stopwatch();
  var filesTotal = 0;
  var filesRead = 0;

  // Get the files in the directory
  final files = Filename.listFromDirectory(inputDir2);
  filesTotal = files.length;
  log.config('Total File count: $filesTotal');
  watch.start();
  var begin = watch.elapsed;
  List<FileTestError> errors;

  // Read, parse, and log.debug a summary of each file.
  for (var i = 0; i < files.length; i++) {
    final inFN = files[i];
    FileTestError error;

    if (!inFN.isDicom) {
      log.info0('Skipping File $i Non-Dicom File:$inFN');
      continue;
    } else if (inFN.isDicom) {
      // Read at least the FMI to get the Transfer Syntax
      final Uint8List bytes0 = inFN.file.readAsBytesSync();
      final rds0 = TagReader(bytes0).readRootDataset();
      if (rds0 == null) {
        log.info0('Skipping File $i Bad TS: $inFN');
        continue;
      }

      if ((i % 1000) == 0) {
        final end = watch.elapsed;
        final time = end - begin;
        print('$time $i files ok');
        begin = end;
      }
      filesRead++;

      log
        ..info0('*** ($filesRead) File $i of $filesTotal: ${inFN.path}')
        ..info0('*** ($filesRead) File $i of $filesTotal: ${inFN.path}', 1)
        ..debug('Reading $i: $inFN', 1)
        ..debug1('Read ${bytes0.length} bytes', 1)
        ..debug1('rds0: $rds0', -2);

      // Write a File
      final outFN = new Filename.withType('$outputDir/${inFN.base}', FileSubtype.part10);
      log
        ..debug('Writing file $i: $outFN')
        ..down;

      final bytes1 = TagWriter(rds0).writeRootDataset();
      log.debug1('Wrote ${bytes1.length} bytes');
      activeStudies.remove(rds0.studyUid);
      log
        ..up

        // Now read the file we just wrote.
        ..debug('Reading Result file $i: $outFN')
        ..down;
      final bytes2 = outFN.readAsBytesSync();
      final length0 = bytes0.lengthInBytes;
      final length2 = bytes2.lengthInBytes;
      log.debug1('Read $length2 bytes');
      if (length0 == length2) {
        log.debug('Both files have length($length0)');
      } else {
        log.error('Files have different lengths: original($length0), result ($length2)');
      }
      final Uint8List bytes3 = inFN.file.readAsBytesSync();
      final rds1 = TagReader(bytes3).readRootDataset();
      log
        ..debug1('rds: 1 ${rds1.info}')
        ..debug2(rds1.format(new Formatter(maxDepth: -1)))
        ..up

      // Compare [Dataset]s
      //log.watermark = Level.info;
      ..debug('Comparing Datasets: 0: $rds0, 1: $rds1', 1);
      final comparitor = new DatasetComparitor(rds0, rds1)
      ..run;
      log.down;
      if (comparitor.hasDifference) {
        log..config('*** ($filesRead) File $i of $filesTotal: ${inFN.path}')
        ..config('Result: ${comparitor.info}')
        ..debug(comparitor.toString());
        error = new FileTestError(inFN, outFN)
        ..dsCompare = comparitor.info;
        throw 'stop';
      } else {
        log.debug('Dataset are identical');
      }
      log
        ..up
        ..up
        // log.watermark = Level.debug;
        // Compare input and output
        ..debug('Comparing Files by Bytes:')
        ..down
        ..debug1('Original: ${inFN.path}')
        ..debug1('Result: ${outFN.path}');
      final result = compareFiles(inFN.path, outFN.path);
      if (result == null) {
        log.debug('Files are identical');
      } else {
        log
          ..config('*** ($filesRead) File $i of $filesTotal: ${inFN.path}')
          ..debug('Files have differences at : $result');
        error = error ??= new FileTestError(inFN, outFN)..result = result;
      }
      log.up;
    } else {
      throw 'Fall-through error';
    }
    if (error != null) {
      errors.add(error);
      print(error);
      error = null;
    }
    log.up;
  }
}
