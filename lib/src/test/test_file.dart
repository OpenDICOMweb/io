// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:convertX/convert.dart';
import 'package:core/core.dart';
import 'package:io/src/filename.dart';
import 'package:io/src/test/compare_files.dart';
import 'package:io/src/test/file_test_error.dart';

Logger log = new Logger("DicomFileTest");
/// Test of
FileTestError dicomFileTest(inFile, outFile, [Logger log]) {
  Filename sourceFN;
  Uint8List sourceBytes;
  Instance sourceInstance;
  Filename resultFN;
  Uint8List resultBytes;
  Instance result;
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
    sourceInstance = DcmDecoder.decode(new DSSource(sourceBytes, sourceFN.path));

    //TODO: instance should have StatusReport
    if (sourceInstance != null) {
      log.debug1('source: $sourceInstance');
      log.debug2(sourceInstance.format(new Formatter(maxDepth: -1)));
      log.up;
    } else {
      return error;
    }
  } catch (e) {}

  // Write result file
  try {
    // Open output file.
    resultFN =
        (outFile == null) ? new Filename.withExt(inFile) : Filename.toFilename(outFile);

    log.debug('Writing file $resultFN');
    log.down;
    resultBytes = DcmEncoder.encode(sourceInstance);
    resultFN.writeAsBytesSync(resultBytes);
    if (haveEqualLengths(sourceBytes, resultBytes))
    log.debug1('Wrote ${resultBytes.length} bytes');
    ActiveStudies.removeStudyIfPresent(sourceInstance.study.uid);
    log.up;
  } catch (e) {}

  // Now read the result file.
  try {
    log.debug('Reading Result file $resultFN');
    log.down;
    resultBytes = resultFN.readAsBytesSync();
    log.debug1('Read ${resultBytes.length} bytes');
    result = DcmDecoder.decode(new DSSource(resultBytes, sourceFN.path));
    log.debug1('Instance: 1 ${result.info}');
    log.debug2(result.format(new Formatter(maxDepth: -1)));
    log.up;
  } catch (e) {}

  // Compare [Dataset]s
  //log.watermark = Level.info;
  try {
    log.debug("Comparing Datasets: 0: ${sourceInstance.dataset}, 1: ${result.dataset}");
    log.down;
    var comparitor = new DatasetComparitor(sourceInstance.dataset, result.dataset);
    comparitor.run;
    if (comparitor.hasDifference) {
      log.config('Comparing Datasets: ${sourceInstance.dataset}, ${result.dataset}');
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
