// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:dcm_convert/dcm.dart';
import 'package:io/src/filename.dart';
import 'package:io/src/test/compare_files.dart';
import 'package:io/src/test/file_test_error.dart';
import 'package:system/server.dart';

/// Test of
FileTestError dicomFileTest(inFile, outFile) {
  Server.initialize(name: 'file_test.dart', level: Level.info0);

  Filename sourceFN;
  Uint8List sourceBytes;
  RootTagDataset rds0;
  Filename resultFN;
  Uint8List resultBytes;
  RootTagDataset rds1;
  FileTestError error;

  // Open input file
  sourceFN = Filename.toFilename(inFile);

  if (sourceFN.isNotDicom) return null;

  //Read source file.
  try {
    log.down;
    // Read at least the FMI to get the Transfer Syntax
    log.debug('Reading $sourceFN');
    sourceBytes = sourceFN.readAsBytesSync();

    //TODO: put up/down functionality in logger
    //      e.g. log.debug.down('...')
    //           log.debug.up('...')
    log.down;
    log.debug1('Read ${sourceBytes.length} bytes');
    var sourceRDS = ByteReader.readFile(sourceFN.file);

    //TODO: instance should have StatusReport
    if (sourceRDS != null) {
      log.debug1('source: $sourceRDS');
      log.debug2(sourceRDS.format(new Formatter(maxDepth: -1)));
      log.up;
    } else {
      return error;
    }
  } catch (e) {}

  // Write result file
  try {
    // Open output file.
    resultFN = (outFile == null)
        ? new Filename.withExt(inFile)
        : Filename.toFilename(outFile);

    log.debug('Writing file $resultFN');
    log.down;
    resultBytes = TagWriter.writeBytes(rds0);
    resultFN.writeAsBytesSync(resultBytes);
    if (haveEqualLengths(sourceBytes, resultBytes))
      log.debug1('Wrote ${resultBytes.length} bytes');
    activeStudies.remove(rds0.studyUid);
    log.up;
  } catch (e) {}

  // Now read the result file.
  try {
    log.debug('Reading Result file $resultFN');
    log.down;
    resultBytes = resultFN.readAsBytesSync();
    log.debug1('Read ${resultBytes.length} bytes');
    rds1 = TagReader.readPath(sourceFN.path);
    log.debug1('Instance: 1 ${rds1.info}');
    log.debug2(rds1.format(new Formatter(maxDepth: -1)));
    log.up;
  } catch (e) {}

  // Compare [Dataset]s
  //log.watermark = Level.info;
  try {
    log.debug(
        "Comparing Datasets: 0: ${rds0}, 1: ${rds1}");
    log.down;
    var comparitor = new DatasetComparitor(rds0, rds1);
    comparitor.run;
    if (comparitor.hasDifference) {
      log.config('Comparing Datasets: ${rds0}, ${rds1}');
      log.config('Result: ${comparitor.info}');
      log.debug(comparitor.toString());
      error = new FileTestError(sourceFN, resultFN);
      error.dsCompare = comparitor.info;
    } else {
      log.debug("Dataset are identical");
    }
    log.up;
  } catch (e) {}

  // log.watermark = Level.debug;
  // Compare input and output
  try {
    log.debug('Comparing Files by Bytes:');
    log.down;
    log.debug1('Original: ${sourceFN.path}');
    log.debug1('Result: ${resultFN.path}');
    FileCompareResult result = compareFiles(sourceFN.path, resultFN.path);
    if (result.hasProblems) {
      log.config('***  Input File: ${sourceFN.path}');
      log.config('*** Output File: ${sourceFN.path}');
      log.debug('*** Files have differences at : $result');
      error = error ??= new FileTestError(sourceFN, resultFN);
      error.result = result;
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
  log.error(
      'Files have different lengths: original(${sourceBytes.lengthInBytes}), result '
      '(${resultBytes.lengthInBytes})');
  return false;
}
