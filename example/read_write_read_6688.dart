// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the   AUTHORS file for other contributors.


import 'package:common/format.dart';
import 'package:common/logger.dart';
import 'package:common/timestamp.dart';
import 'package:core/core.dart';
import 'package:dcm_convert/dcm.dart';
import 'package:io/io.dart';
import 'package:io/src/test/compare_files.dart';

String inputDir = 'C:/odw/sdk/io/example/input';
String inputDir2 = 'C:/odw/test_data/sfd/CT';
String inputDir3 = 'C:/dicom/6688';

String outputDir = 'C:/odw/sdk/io/example/output';

void main(List<String> args) {
  final log = new Logger('read_write_read_directory', watermark: Severity.config);
  int filesTotal = 0;
  int filesRead = 0;

  // Get the files in the directory
  List<Filename> files = Filename.listFromDirectory(inputDir3);
  filesTotal = files.length;
  log.config('Total File count: $filesTotal');
  Timestamp startTime = new Timestamp("Start Time:");
  log.config('Starting tests at $startTime ...');

  // Read, parse, and log a summary of each file.
  for (int i = 0; i < files.length; i++) {
    Filename inFN = files[i];

    log.config('*** ($filesRead) File $i of $filesTotal: ${inFN.path}');
    // Read at least the FMI to get the Transfer Syntax

    log.down;
    RootTagDataset rds0 = TagReader.readFile(inFN.file);
    if (rds0 == null) {
      log.info('Skipping File $i Bad TS: $inFN');
      continue;
    }
    filesRead++;
    log.down;
    log.debug('rds0: $rds0');
    //log.debug1(instance0.format(new Formatter(maxDepth: -1)));
    log.up;

    // Write a File
    Filename outFN = new Filename.withType('$outputDir/${inFN.base}', FileSubtype.part10);
    log.info('Writing file $i: $outFN');
    log.down;
//    outFN.writeAsBytesSync(bytes1);
//   log.info('Wrote ${bytes1.length} bytes');
//    activeStudies.remove(rds0.study);
    log.up;

    // Now read the file we just wrote.
    log.info('Reading Result file $i: $outFN');
    log.down;
/*    int length0 = rds0.LengthInBytes;
    int length2 = rds1.lengthInBytes;
    if (length0 == length2) {
      log.info('Files have equal length.');
    } else {
      log.error('Files have different lengths: original($length0), result ($length2).');
    }*/
    RootTagDataset rds1 = TagReader.readFile(inFN.file);
    log.debug('Instance: 1 ${rds1.info}');
    log.debug1(rds1.format(new Formatter(maxDepth: -1)));
    log.up;

    // Compare [Dataset]s
    //log.watermark = Level.info;
    log.info("Comparing Datasets: 0: ${rds0}, 1: ${rds1}");
    log.down;
    var comparitor = new DatasetComparitor(rds0, rds1);
    comparitor.run;
    if (comparitor.hasDifference) {
      log.info('Result: ${comparitor.bad}');
      throw "stop";
    } else {
      log.info("Dataset are identical");
    }
    log.up;

    // log.watermark = Level.debug;
    // Compare input and output
    log.info('Comparing Files by Bytes:');
    log.down;
    log.debug('Original: ${inFN.path}');
    log.debug('Result: ${outFN.path}');
    FileCompareResult result = compareFiles(inFN.path, outFN.path, log);
    if (result == null) {
      log.info('Files are identical');
    } else {
      log.info('Files have differences at: $result');
    }
    log.up2;
  }
  Timestamp endTime = new Timestamp("End Time:");
  log.config('Completed tests at $endTime ...');
  Duration elapsed = endTime.dt.difference(startTime.dt);
  log.config('ElapsedTime: $elapsed');
}

