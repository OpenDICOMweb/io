// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

//TODO: document this file


//TODO: implement later
//Stream<Uint8List> readDirectory(String path) {}

Future<Uint8List> readFile(String path) async {
  File f = new File(path);
  return await f.readAsBytes();
}


List<Uint8List> readDirectorySync(String path) {
  Directory d = new Directory(path);
  return _readDirectorySync(d, []);
}

List<Uint8List> _readDirectorySync(Directory d, List<Uint8List> bytesList) {
  List<FileSystemEntity> entities = d.listSync(recursive: true, followLinks: false);
  try {
    for(FileSystemEntity e in entities) {
      if (e is Directory) {
        _readDirectorySync(e, bytesList);
      } else if (e is File) {
        bytesList.add(e.readAsBytesSync());
      } else {
        throw 'Invalid FileSystem Entity: $e';
      }
    }
  } catch (e) {

  }
  return bytesList;
}

Uint8List readFileSync(String path)  {
  File f = new File(path);
  Uint8List bytes;
  try {
    bytes = f.readAsBytesSync();
  } catch (e) {
    //TODO: finish
  }
  return bytes;
}

//TODO: implement later
//Stream<Uint8List> writeDirectory(String path) {}

Future<Null> writeFile(String path, Uint8List bytes) async {
  File f = new File(path);
  try {
    await f.writeAsBytes(bytes);
  } catch (e) {
    //TODO: add code
  }
}

//TODO: implement later
//TODO: add try block
void writeDirectorySync(String path, Map<String, Uint8List> entries) {
  entries.forEach((String path, Uint8List bytes) {
    File f = new File(path);
    try {
      f.writeAsBytesSync(bytes);
    } catch (e) {
      //TODO: finish
    }
  });
}

void writeFileSync(String path, Uint8List bytes) {
  File f = new File(path);
  try {
    f.writeAsBytes(bytes);
  } catch (e) {
    //TODO: finish
  }
}

