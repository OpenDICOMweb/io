// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:encode/encoder.dart';
import 'package:io/io.dart';
import 'package:io/src/compare_files.dart';


class FileTestResult {
  Filename inFN;
  Filename outFN;

  FileTestResult(this.inFN, this.outFN);


}

FileTestResult dicomFileTest(inFile, outFile, {Logger log, }) {
  var error;
  try {
    Filename inFN = Filename.toFilename(inFile);
    Filename outFN = (outFile == null)
                     ? new Filename.withExt(inFile)
                     : Filename.toFilename(outFile);
    if (log == null) log = new Logger("DicomFileTest");
    if (inFN.isNotDicom) return null;

    log.down;
    // Read at least the FMI to get the Transfer Syntax
    log.debug('Reading $inFN');
    Uint8List bytes0 = inFN.file.readAsBytesSync();
    log.down;
    log.debug1('Read ${bytes0.length} bytes');
    Instance instance0 = DcmDecoder.decode(new DSSource(bytes0, inFN.path));

    //TODO: instance should have StatusReport
    if (instance0 != null) {
      log.debug1('Instance0: $instance0');
      log.debug2(instance0.format(new Formatter(maxDepth: -1)));
      log.up;

      // Write a File
      log.debug('Writing file $outFN');
      log.down;
      Uint8List bytes1 = DcmEncoder.encode(instance0);
      outFN.writeAsBytesSync(bytes1);
      log.debug1('Wrote ${bytes1.length} bytes');
      ActiveStudies.removeStudyIfPresent(instance0.study.uid);
      log.up;

      // Now read the file we just wrote.
      log.debug('Reading Result file $outFN');
      log.down;
      Uint8List bytes2 = outFN.readAsBytesSync();
      int length0 = bytes0.lengthInBytes;
      int length2 = bytes2.lengthInBytes;
      log.debug1('Read $length2 bytes');
      if (length0 == length2) {
        log.debug('Both files have length($length0)');
      } else {
        log.error('Files have different lengths: original($length0), result ($length2)');
      }
      Instance instance1 = DcmDecoder.decode(new DSSource(bytes2, inFN.path));
      log.debug1('Instance: 1 ${instance1.info}');
      log.debug2(instance1.format(new Formatter(maxDepth: -1)));
      log.up;

      // Compare [Dataset]s
      //log.logLevel = Level.info;
      log.debug("Comparing Datasets: 0: ${instance0.dataset}, 1: ${instance1.dataset}");
      log.down;
      var comparitor = new DatasetComparitor(instance0.dataset, instance1.dataset);
      comparitor.run;
      if (comparitor.hasDifference) {
        log.config('Comparing Datasets: ${instance0.dataset}, ${instance1.dataset}');
        log.config('Result: ${comparitor.info}');
        log.debug(comparitor.toString());
        error = new FileTestResult(inFN, outFN);
        error.dsCompare = comparitor.info;
      } else {
        log.debug("Dataset are identical");
      }
      log.up;

      // log.logLevel = Level.debug;
      // Compare input and output
      log.debug('Comparing Files by Bytes:');
      log.down;
      log.debug1('Original: ${inFN.path}');
      log.debug1('Result: ${outFN.path}');
      FileCompareResult result = compareFiles(inFN.path, outFN.path);
      if (result.length == 0) {
        log.debug('Files are identical');
      } else {
        log.config('*** ($filesRead) File $i of $filesTotal: ${inFN.path}');
        log.debug('Files have differences at : $result');
        error = error ??= new FileTestError(inFN, outFN);
        error.result = result;
      }
    }
  } catch (e) {}
    if (error != null) {
      errors.add(error);
      print(error);
      error = null;
    }
    log.up;
  }
}


