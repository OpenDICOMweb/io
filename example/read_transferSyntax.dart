import 'dart:typed_data';

import 'package:common/format.dart';
import 'package:common/logger.dart';
import 'package:convertX/convert.dart';
import 'package:core/core.dart';
import 'package:dictionary/dictionary.dart';
import 'package:io/io.dart';
import 'package:io/src/test/compare_files.dart';

String inputDir = 'C:/odw/sdk/io/example/input';
String inputDir2 = 'C:/odw/test_data/sfd/CT';
String inputDir3 = 'C:/odw/test_data/TransferUIDs';
String inputDir4 = 'C:/odw/test_data/Localizers';
String inputDir5 = 'C:/odw/test_data/Different_SOP_Class_UIDs';
String inputDir6 = 'C:/odw/test_data/COMUNIX_1';
String inputDir7 = 'C:/odw/test_data';
String inputDir8 = 'C:/odw/test_data/ASPERA/Clean_Pixel_test_data/Sop';
String inputDir9 = 'C:/odw/test_data/500+';

class FileReadError {
  Filename inFile;
  Object error;

  FileReadError(this.inFile, this.error);
}

void main(List<String> args) {
  //readTS();
  readFile();
}

final log = new Logger('read_write_read_directory', watermark: Severity.debug);

readFile() {
  int filesTotal = 0;

  // Get the files in the directory
  List<Filename> files = Filename.listFromDirectory(inputDir8);
  filesTotal = files.length;
  log.config('Total File count: $filesTotal');

  List<FileReadError> errorList = new List<FileReadError>();
  Map<String, String> pathToTS = new Map<String, String>();
  Map<String, List<String>> tsToPath = new Map<String, List<String>>();

  // Read, parse, and log.debug a summary of each file.
  for (var i = 0; i < files.length; i++) {
    Filename inFN = files[i];
    if (!inFN.isDicom) {
      log.info('Skipping File $i Non-Dicom File:$inFN');
      continue;
    } else if (inFN.isDicom) {
      // Read at least the FMI to get the Transfer Syntax
      Uint8List bytes0 = inFN.file.readAsBytesSync();
      DcmDecoder decoder = new DcmDecoder(new DSSource(bytes0, inFN.path));
      TransferSyntax ts = decoder.readFmi();
      log.info('${inFN.path} -- ${ts}');
      pathToTS[inFN.path] = ts.asString;
      List<String> paths = tsToPath[ts.asString];
      if (paths == null) {
        tsToPath[ts.asString] = <String>[inFN.path];
      } else {
        paths.add(inFN.path);
        tsToPath[ts.asString] = paths;
      }
    }
  }
  for (var s in pathToTS.keys) {
    print('Path to Ts: ${pathToTS[s]} -- $s');
  }
  for (var s in tsToPath.keys) {
    print('Ts to Path: ${tsToPath[s]} -- $s');
  }
  /*print('-----------------------Error count: ${errorList.length}');
  for (var s in errorList) {
    print(s.inFile);
    print(s.error);
  }*/
}

readTS() {
  int filesTotal = 0;
  int filesRead = 0;

  // Get the files in the directory
  List<Filename> files = Filename.listFromDirectory(inputDir7);
  filesTotal = files.length;
  log.config('Total File count: $filesTotal');

  List<FileReadError> errorList = new List<FileReadError>();
  Map<String, String> pathToTS = new Map<String, String>();
  Map<String, List<String>> tsToPath = new Map<String, List<String>>();

  // Read, parse, and log.debug a summary of each file.
  for (var i = 0; i < files.length; i++) {
    Filename inFN = files[i];
    try {
      if (!inFN.isDicom) {
        log.info('Skipping File $i Non-Dicom File:$inFN');
        continue;
      } else if (inFN.isDicom) {
        // Read at least the FMI to get the Transfer Syntax
        Uint8List bytes0 = inFN.file.readAsBytesSync();
        DcmDecoder decoder = new DcmDecoder(new DSSource(bytes0, inFN.path));
        TransferSyntax ts = decoder.readFmi();
        log.info('${inFN.path} -- ${ts}');
        pathToTS[inFN.path] = ts.asString;
        List<String> paths = tsToPath[ts.asString];
        if (paths == null) {
          tsToPath[ts.asString] = <String>[inFN.path];
        } else {
          paths.add(inFN.path);
          tsToPath[ts.asString] = paths;
        }
      }
    } catch (e) {
      errorList.add(new FileReadError(inFN, e));
    }
  }
  for (var s in pathToTS.keys) {
    print('Path to Ts: ${pathToTS[s]} -- $s');
  }
  for (var s in tsToPath.keys) {
    print('Ts to Path: ${tsToPath[s]} -- $s');
  }
  print('-----------------------Error count: ${errorList.length}');
  for (var s in errorList) {
    print(s.inFile);
    print(s.error);
  }
}
