// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the   AUTHORS file for other contributors.

import 'package:core/server.dart';
import 'package:convert/convert.dart';
import 'package:io/io.dart';
import 'package:io/src/tools/compare_files.dart';

// ignore_for_file: only_throw_errors, avoid_catches_without_on_clauses

String inputDir = 'C:/acr/odw/sdk/io/example/input';
String inputDir2 = 'C:/acr/odw/test_data/sfd/CT';
String inputDir3 = 'C:/dicom/6688';

String outputDir = 'C:/acr/odw/sdk/io/example/output';

void main(List<String> args) {
  Server.initialize(name: 'readFile_test.dart', level: Level.info0);
  var filesTotal = 0;
  var filesRead = 0;

  // Get the files in the directory
  final files = Filename.listFromDirectory(inputDir3);
  filesTotal = files.length;
  log.config('Total File count: $filesTotal');
  final startTime = new Timestamp('Start Time:');
  log.config('Starting tests at $startTime ...');

  // Read, parse, and log a summary of each file.
  for (var i = 0; i < files.length; i++) {
    final inFN = files[i];

    log..config('*** ($filesRead) File $i of $filesTotal: ${inFN.path}')..down;

    // Read at least the FMI to get the Transfer Syntax
    final rds0 = TagReader.readFile(inFN.file);
    if (rds0 == null) {
      log.info0('Skipping File $i Bad TS: $inFN');
      continue;
    }
    filesRead++;
    log
      ..down
      ..debug('rds0: $rds0')
      //log.debug1(instance0.format(new Formatter(maxDepth: -1)));
      ..up;

    // Write a File
    final outFN = new Filename.withType('$outputDir/${inFN.base}', FileSubtype.part10);
    log..info0('Writing file $i: $outFN')..info0('Reading Result file $i: $outFN', 1);

    // Now read the file we just wrote.
    final rds1 = TagReader.readFile(inFN.file);

    // Compare [Dataset]s
    //log.watermark = Level.info;
    log
      ..debug('Instance: 1 ${rds1.info}')
      ..debug1(rds1.format(new Formatter(maxDepth: -1)), -1)
      ..info0('Comparing Datasets: 0: $rds0, 1: $rds1', 1);

    final comparitor = new DatasetComparitor(rds0, rds1)..run;
    if (comparitor.hasDifference) {
      log.info0('Result: ${comparitor.bad}');
      throw 'stop';
    } else {
      log.info0('Dataset are identical');
    }
    // log.watermark = Level.debug;
    // Compare input and output
    log
      ..up
      ..info0('Comparing Files by Bytes:')
      ..down
      ..debug('Original: ${inFN.path}', 1)
      ..debug('Result: ${outFN.path}');
    final result = compareFiles(inFN.path, outFN.path);
    if (result == null) {
      log.info0('Files are identical', -2);
    } else {
      log.info0('Files have differences at: $result', -2);
    }
  }
  final endTime = new Timestamp('End Time:');
  log.config('Completed tests at $endTime ...');
  final elapsed = endTime.dt.difference(startTime.dt);
  log.config('ElapsedTime: $elapsed');
}
