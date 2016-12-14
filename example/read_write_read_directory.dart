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
  final log = new Logger('read_write_read_directory', logLevel: Level.debug);

  // Get the files in the directory
  List<Filename> files = Filename.listFromDirectory(inputDir);
  log.info('Total File count: ${files.length}');

  // Read, parse, and log.debug a summary of each file.
  for (var i = 0; i < files.length; i++) {
    var input = files[i];
    if (input.isDicom) {
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
      bytes0 = resultFn.readAsBytesSync();
      int resultLength = bytes0.lengthInBytes;
      log.info('read ${bytes0.length} bytes');
      if (originalLength == resultLength) {
        log.info('Both files have length($originalLength)');
      } else {
        log.error('Files have different lengths: '
            'original($originalLength), result ($resultLength)');
      }
      Instance instance1 = DcmDecoder.decode(new DSSource(bytes0, input.path));
      log.debug1('Instance: 1 ${instance1.info}');
      log.debug2(instance1.format(new Formatter(maxDepth: -1)));
      log.up;

      // Compare Datasets
      log.logLevel = Level.info;
      var comparitor = new DatasetComparitor(instance0.dataset, instance1.dataset);
      comparitor.result;
      if (comparitor.hasDifference) {
        log.info('Result: ${comparitor.bad}');
        throw "stop";
      }
      log.up2;

      log.logLevel = Level.debug;
      // Compare input and output
      log.info('Comparing Bytes:');
      log.down;
      log.info('Original: ${input.path}');
      log.info('Result: ${output.path}');
      List result = compareFiles(input.path, output.path);
      log.info('$result');
      log.up;
    } else {
      log.info('Skipping ... $input');
    }
  }
}
