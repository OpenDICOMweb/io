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
String outputDir = 'C:/odw/sdk/io/example/output';

void main(List<String> args) {
  final log = new Logger('read_write_read_directory', logLevel: Level.info);

  //FLush begin
  int i0 = 0x0a8b1844; // 0000 1010 1000 1011
  int i1 = 0x2fc43c44; // 0010 1111 1100 0100
  double d0 = i0.toDouble();
  double d1 = i1.toDouble();
  print('i0($i0), d0($d0)');
  print('i1($i1), d0($d1)');
  //Flush end

  // Get the files in the directory
  List<Filename> files = Filename.listFromDirectory(inputDir);
  log.info('Total File count: ${files.length}');

  // Read, parse, and log.debug a summary of each file.
  for (var i = 0; i < files.length; i++) {
    var input = files[i];
    if (input.isDicom) {
      log.info('*** File $i');
      log.down;
      log.info('Reading file $i: $input');
      log.down;
      Uint8List bytes0 = input.file.readAsBytesSync();
      int originalLength = bytes0.lengthInBytes;
      log.debug('Read ${bytes0.length} bytes');
      Instance instance0 = DcmDecoder.decode(new DSSource(bytes0, input.path));
      log.down;
      log.debug('Instance0: $instance0');
      log.debug1(instance0.format(new Formatter(maxDepth: -1)));
      log.up2;

      // Write a File
      var outPath = '$outputDir/${input.base}';
      log.info('writing file $i: $outPath');
      log.down;
      Filename output = new Filename.withType(outPath, FileSubtype.part10);
      Uint8List bytes1 = DcmEncoder.encode(instance0);
      output.writeAsBytesSync(bytes1);
      log.debug('Wrote ${bytes1.length} bytes');
      ActiveStudies.removeStudyIfPresent(instance0.study.uid);
      log.up;

      // Now read the file we just wrote.
      Filename resultFn = new Filename(outPath);
      log.info('Reading Result file $i: $resultFn');
      log.down;
      Uint8List bytes2 = resultFn.readAsBytesSync();
      int resultLength = bytes2.lengthInBytes;
      log.info('read ${bytes2.length} bytes');
      if (originalLength == resultLength) {
        log.info('Both files have length($originalLength)');
      } else {
        log.error('Files have different lengths: '
                      'original($originalLength), result ($resultLength)');
      }
      Instance instance1 = DcmDecoder.decode(new DSSource(bytes2, input.path));
      log.debug1('Instance: 1 ${instance1.info}');
      log.debug2(instance1.format(new Formatter(maxDepth: -1)));
      log.up;

      // Compare Datasets
      log.logLevel = Level.info;
      log.info("Comparing Datasets: 0: ${instance0.dataset}, 1: ${instance1.dataset}");
      log.down;
      var comparitor = new DatasetComparitor(instance0.dataset, instance1.dataset);
      comparitor.run;
      log.down;
      if (comparitor.hasDifference) {
        log.info('Result: ${comparitor.bad}');
        throw "stop";
      } else {
        log.info("Dataset are identical");
      }
      log.up2;

      log.logLevel = Level.debug;
      // Compare input and output
      log.info('Comparing Files by Bytes:');
      log.down;
      log.debug('Original: ${input.path}');
      log.debug('Result: ${output.path}');
      List result = compareFiles(input.path, output.path);
      if (result.length == 0) {
          log.info('Files are identical');
        } else {
        log.info('Files have differences at: $result');
      }
      log.up;
    } else {
      log.info('Skipping ... $input');
    }
    log.up;
  }
}
