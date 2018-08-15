// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.
//
import 'dart:io';

import 'package:path/path.dart' as _p;

abstract class PathBase {
  String get path;
  FileSystemEntity get fse;

  bool exists();
  bool get isDirectory => false;
  bool get isFile => false;
  bool get isLink => false;

}

abstract class Path {
  String path;

  factory Path(String path) {
    if (FileSystemEntity.isFileSync(path))
      return FilePath(path);
    if (FileSystemEntity.isDirectorySync(path))
      return DirectoryPath(path);
    if (FileSystemEntity.isLinkSync(path))
      return LinkPath(path);
    return null;

  }

  Path._(this.path);
}

class DirectoryPath extends Path {
  Directory dir;

  DirectoryPath(String p)
      : dir = Directory(p),
        super._(p);

  bool get isDirectory => true;

}

class FilePath extends Path {
  File file;

  FilePath(String p)
      : file = File(p),
        super._(p);

  bool get isFile => true;

}

class LinkPath extends Path {
  Link link;

  LinkPath(String p)
      : link = Link(p),
        super._(p);

  bool get isLink => true;

}
