
import 'dart:io';
import 'dart:typed_data';

//import 'package:common/format.dart';
import 'package:common/logger.dart';
import 'package:convertX/convert.dart';
import 'package:core/core.dart';
import 'package:dictionary/dictionary.dart';
import 'package:io/io.dart';
//import 'package:io/src/test/compare_files.dart';

String inputDir = 'C:/odw/sdk/io/example/input';
String inputDir2 = 'C:/odw/test_data/sfd/CT';
String inputDir3 = 'C:/odw/test_data/TransferUIDs';
String inputDir4 = 'C:/odw/test_data/Localizers';
String inputDir5 = 'C:/odw/test_data/Different_SOP_Class_UIDs';
String inputDir6 = 'C:/odw/test_data/COMUNIX_1';
String inputDir7 = 'C:/odw/test_data';
String inputDir8 = 'C:/odw/test_data/ASPERA/Clean_Pixel_test_data/Sop';
String inputDir9 = 'C:/odw/test_data/500+';

const String testDataDir = 'C:/odw/test_data';

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

void readFile() {
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
    Filename inFile = files[i];
    if (!inFile.isDicom) {
      log.info('Skipping File $i Non-Dicom File:$inFile');
      continue;
    } else if (inFile.isDicom) {
      // Read at least the FMI to get the Transfer Syntax
      Uint8List bytes0 = inFile.file.readAsBytesSync();
      DcmDecoder decoder = new DcmDecoder(new DSSource(bytes0, inFile.path));
      TransferSyntax ts = decoder.xReadFmi();
      log.info('${inFile.path} -- $ts');
      pathToTS[inFile.path] = ts.asString;
      List<String> paths = tsToPath[ts.asString];
      if (paths == null) {
        tsToPath[ts.asString] = <String>[inFile.path];
      } else {
        paths.add(inFile.path);
        tsToPath[ts.asString] = paths;
      }
      filesRead++;
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

void readTS([String inputDir = testDataDir]) {
  int filesTotal = 0;
  int filesRead = 0;

  // Get the files in the directory
  List<Filename> files = Filename.listFromDirectory(inputDir);
  filesTotal = files.length;
  log.config('Total File count: $filesTotal');

  List<FileReadError> errorList = new List<FileReadError>();
  Map<String, String> pathToTS = new Map<String, String>();
  Map<String, List<String>> tsToPath = new Map<String, List<String>>();

  // Read, parse, and log.debug a summary of each file.
  for (var i = 0; i < files.length; i++) {
    Filename inFile = files[i];
    try {
      if (!inFile.isDicom) {
        log.info('Skipping File $i Non-Dicom File:$inFile');
        continue;
      } else if (inFile.isDicom) {
        // Read at least the FMI to get the Transfer Syntax
        Uint8List bytes0 = inFile.file.readAsBytesSync();
        DcmDecoder decoder = new DcmDecoder(new DSSource(bytes0, inFile.path));
        TransferSyntax ts = decoder.xReadFmi();
        log.debug('${inFile.path}: $ts');
        pathToTS[inFile.path] = ts.asString;
        List<String> paths = tsToPath[ts.asString];
        if (paths == null) {
          tsToPath[ts.asString] = <String>[inFile.path];
        } else {
          paths.add(inFile.path);
          tsToPath[ts.asString] = paths;
        }
      }
    } catch (e) {
      errorList.add(new FileReadError(inFile, e));
    }
  }
  var tsMap = writeTSToPaths(tsToPath, inputDir);
  print('tsMap:\n$tsMap');
  var pathMap = writePathToTS(pathToTS, inputDir);
  print('pathMap:\n$tsMap');
  var errors = writeErrorFiles(errorList, inputDir);
  print('pathMap:\n$tsMap');

  print('-----------------------Error count: ${errorList.length}');
  for (var s in errorList) {
    print(s.inFile);
    print(s.error);
  }
}

String writeTSToPaths(Map<String, List<String>> tsToPaths, String directory) {
  var out = "const var tsToPaths = const <String, List<String>>{\n    ";
  tsToPaths.forEach((String ts, List<String> paths) {
    out += '"$ts": [${paths.join(',\n    ')}];';
  });
  out += '};\n';
  File outFile = new File('$directory/transfer_syntax_to_paths.dart');
  outFile.writeAsStringSync(out);
  return out += '};\n';
}

String writePathToTS(Map<String, String> pathToTS, String directory) {
  var out = "const var pathToTS = const <String, String>{\n    ";
  pathToTS.forEach((String path, String ts) {
    out += '"$ts": "$path",\n';
  });
  out += '};\n';
  File outFile = new File('$directory/path_to_transfer_syntax.dart');
  outFile.writeAsStringSync(out);
  return out += '};\n';
}

String writeErrorFiles(List<FileReadError> errorFiles, String directory) {
  var out = "const var errorFiles = const <String>[\n    ";
  errorFiles.forEach((FileReadError error) {
    out += '"$error",\n';
  });
  out += '};\n';
  File outFile = new File('$directory/error_files.dart');
  outFile.writeAsStringSync(out);
  return out += '};\n';
}
