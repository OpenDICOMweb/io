//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:io';

class VNA {
  Directory root;

  VNA(String path) : root = _createRoot(path);


  String get dbPath => '$root/db';



  static Directory _createRoot(String path) {
    final root = Directory(path);
    return root;
  }
}

class VnaDB {
  Directory root;

  VnaDB(String path) : root = _checkRoot(path);

  static Directory _checkRoot(String path) {
    final root = Directory(path);
    return root;
  }
}