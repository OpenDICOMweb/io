// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the   AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:encode/encoder.dart';
import 'package:io/io.dart';
import 'package:io/src/compare_files.dart';

String inputDir = 'C:/odw/sdk/io/example/input';
String inputDir2 = 'C:/odw/test_data/sfd/CT';

String outputDir = 'C:/odw/sdk/io/example/output';

void main(List<String> args) {
  final log = new Logger('read_write_read_directory',  logLevel: Level.info);
  int filesTotal = 0;
  int filesRead = 0;

  // Get the files in the directory
  List<Filename> files = Filename.listFromDirectory(inputDir2);
  filesTotal = files.length;
  log.info('Total File count: $filesTotal');

  // Read, parse, and log.debug a summary of each file.
  for (var i = 0; i < files.length; i++) {
    Filename inFN = files[i];
    if (!inFN.isDicom) {
      log.debug('Skipping File $i Non-Dicom File:$inFN');
      continue;
    } else if (inFN.isDicom) {
      // Read at least the FMI to get the Transfer Syntax
      Uint8List bytes0 = inFN.file.readAsBytesSync();
      Instance instance0 = DcmDecoder.decode(new DSSource(bytes0, inFN.path));
      if (instance0 == null) {
        log.debug('Skipping File $i Bad TS: $inFN');
        continue;
      }
      filesRead++;
      log.info('*** ($filesRead) File $i of $filesTotal: ${inFN.path}');
      log.down;
      log.debug('Reading $i: $inFN');
      log.down;
      log.debug1('Read ${bytes0.length} bytes');
      log.down;
      log.debug1('Instance0: $instance0');
      //log.debug1(instance0.format(new Formatter(maxDepth: -1)));
      log.up2;

      // Write a File
      Filename outFN = new Filename.withType('$outputDir/${inFN.base}', FileSubtype.part10);
      log.debug('Writing file $i: $outFN');
      log.down;

      Uint8List bytes1 = DcmEncoder.encode(instance0);
      outFN.writeAsBytesSync(bytes1);
      log.debug1('Wrote ${bytes1.length} bytes');
      ActiveStudies.removeStudyIfPresent(instance0.study.uid);
      log.up;

      // Now read the file we just wrote.
      log.debug('Reading Result file $i: $outFN');
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
      log.down;
      if (comparitor.hasDifference) {
        log.debug('Result: ${comparitor.bad}');
        throw "stop";
      } else {
        log.debug("Dataset are identical");
      }
      log.up2;

     // log.logLevel = Level.debug;
      // Compare input and output
      log.debug('Comparing Files by Bytes:');
      log.down;
      log.debug1('Original: ${inFN.path}');
      log.debug1('Result: ${outFN.path}');
      List result = compareFiles(inFN.path, outFN.path);
      if (result.length == 0) {
          log.debug('Files are identical');
        } else {
        log.debug('Files have differences at: $result');
      }
      log.up;
    } else {
      throw "Fall-through error";
    }
    log.up;
  }
}
