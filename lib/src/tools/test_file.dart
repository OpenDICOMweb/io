// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
//
import 'dart:io';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:converter/converter.dart';

import 'package:io_extended/src/filename.dart';
import 'package:io_extended/src/tools/compare_files.dart';
import 'package:io_extended/src/tools/file_test_error.dart';

// ignore_for_file: only_throw_errors,
// ignore_for_file: avoid_catches_without_on_clauses
// ignore_for_file: empty_catches
// ignore_for_file: public_member_api_docs

/// Test of
FileTestError dicomFileTest(Object inFile, Object outFile) {
  Filename sourceFN;
  TagRootDataset rds0;
  Filename resultFN;
  TagRootDataset rds1;
  FileTestError error;
  Bytes bytes0;

  // Open input file
  sourceFN = Filename.toFilename(inFile);

  if (sourceFN.isNotDicom) return null;

  //Read source file.
  try {
    log
      ..down
      // Read at least the FMI to get the Transfer Syntax
      ..debug('Reading $sourceFN');
    final reader0 = ByteReader.fromFile(sourceFN.file);
    bytes0 = reader0.bytes;
    log
      ..down
      ..debug1('Read ${bytes0.length} bytes');
    final sourceRDS = reader0.readRootDataset();

    //TODO: instance should have StatusReport
    if (sourceRDS != null) {
      log
        ..debug1('source: $sourceRDS')
        ..debug2(sourceRDS.format(Formatter(maxDepth: -1)))
        ..up;
    } else {
      return error;
    }
  } catch (e) {}

  // Write result file
  try {
    // Open output file.
    resultFN = (outFile == null)
        ? Filename.withExt(inFile)
        : Filename.toFilename(outFile);

    log
      ..debug('Writing file $resultFN')
      ..down;
    final bytes1 = TagWriter.writeBytes(rds0);

    if (bytes0 == bytes1) log.debug1('Wrote ${bytes1.length} bytes');
    activeStudies.remove(rds0.studyUid);
    log.up;
  } catch (e) {}

  // Now read the result file.
  try {
    log
      ..debug('Reading Result file $resultFN')
      ..down;
    final bytes = File(sourceFN.path).readAsBytesSync();
    final reader1 = TagReader(bytes);
    final bytes1 = reader1.bytes;
    log.debug1('Read ${bytes1.length} bytes');
    rds1 = reader1.readRootDataset();
    log
      ..debug1('Instance: 1 ${rds1.info}')
      ..debug2(rds1.format(Formatter(maxDepth: -1)))
      ..up;
  } catch (e) {}

  // Compare [Dataset]s
  //log.watermark = Level.info;
  try {
    log
      ..debug('.Comparing Datasets: 0: $rds0, 1: $rds1')
      ..down;
    final comparitor = DatasetComparitor(rds0, rds1)..run;
    if (comparitor.hasDifference) {
      log
        ..config('Comparing Datasets: $rds0, $rds1')
        ..config('Result: ${comparitor.info}')
        ..debug(comparitor.toString());
      error = FileTestError(sourceFN, resultFN)..dsCompare = comparitor.info;
    } else {
      log.debug('Dataset are identical');
    }
    log.up;
  } catch (e) {}

  // log.watermark = Level.debug;
  // Compare input and output
  try {
    log
      ..debug('Comparing Files by Bytes:')
      ..down
      ..debug1('Original: ${sourceFN.path}')
      ..debug1('Result: ${resultFN.path}');
    final result = compareFiles(sourceFN.path, resultFN.path);
    if (result.hasProblems) {
      log
        ..config('***  Input File: ${sourceFN.path}')
        ..config('*** Output File: ${sourceFN.path}')
        ..debug('*** Files have differences at : $result');
      error = error ??= FileTestError(sourceFN, resultFN)..result = result;
    } else {
      log.debug('Files are identical');
    }
  } catch (e) {
    if (e != null) {
      error.add(e.msg);
      print(error);
      return error;
    }
  }
  log.up;
  return error;
}

bool haveEqualLengths(Uint8List sourceBytes, Uint8List resultBytes) {
  if (sourceBytes.length == resultBytes.length) {
    log.debug('Both files have length(${sourceBytes.lengthInBytes})');
    return true;
  }
  log.error('Files have different lengths: '
      'original(${sourceBytes.lengthInBytes}), result '
      '(${resultBytes.lengthInBytes})');
  return false;
}
