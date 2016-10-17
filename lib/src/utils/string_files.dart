// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:async';
import 'dart:io';

//TODO: document this file

///


//TODO: implement later
//Stream<String> readDirectory(String path) {}

Future<String> readFile(String path) async {
  File f = new File(path);
  return await f.readAsString();
}


List<String> readDirectorySync(String path) => _readDirectorySync(new Directory(path), []);

List<String> _readDirectorySync(Directory d, List<String> bytesList) {
  List<FileSystemEntity> entities = d.listSync(recursive: true, followLinks: false);
  try {
    for(FileSystemEntity e in entities) {
      if (e is Directory) {
        _readDirectorySync(e, bytesList);
      } else if (e is File) {
        bytesList.add(e.readAsStringSync());
      } else {
        throw 'Invalid FileSystem Entity: $e';
      }
    }
  } catch (e) {

  }
  return bytesList;
}

String readFileSync(String path)  {
  File f = new File(path);
  String s;
  try {
    s = f.readAsStringSync();
  } catch (e) {
    //TODO: finish
  }
  return s;
}

//TODO: implement later
//Stream<String> writeDirectory(String path) {}

Future<Null> writeStringFile(String path, String s) async {
  File f = new File(path);
  try {
    await f.writeAsString(s);
  } catch (e) {
    //TODO: add code
  }
}

//TODO: implement later
//TODO: add try block
void writeDirectorySync(String path, Map<String, String> entries) {
  entries.forEach((String path, String s) {
    File f = new File(path);
    try {
      f.writeAsStringSync(s);
    } catch (e) {
      //TODO: finish
    }
  });
}

void writeFileSync(String path, String s) {
  File f = new File(path);
  try {
    f.writeAsString(s);
  } catch (e) {
    //TODO: finish
  }
}

