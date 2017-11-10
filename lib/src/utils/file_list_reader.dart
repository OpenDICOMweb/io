// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:collection';

import 'file_utils.dart';

typedef bool PathPredicate(String path);

/// Reads a Map<directory, List<file>>, where directory and file are [String]s.
class FileMapReader extends IterableBase<String> {
  final Map<String, List<String>> fileMap;
  final PathPredicate filter;

  FileMapReader(this.fileMap, [this.filter = isReadableDcmPathSync]);

  @override
  FileMapIterator get iterator => new FileMapIterator(fileMap, filter);

  @override
  int get length => fileMap.values.length;
}

class FileMapIterator implements Iterator<String> {
  Map<String, List<String>> fileMap;
  final PathPredicate filter;
  final Iterable<String> _dirList;
  int _dirIndex;
  int _fileIndex;
  String _currentDir;
  Iterable<String> _fileList;

  FileMapIterator(this.fileMap, [this.filter])
      : _dirList = fileMap.keys,
        _dirIndex = 0,
        _fileIndex = -1 {
    _currentDir = _dirList.elementAt(_dirIndex);
    _fileList = fileMap[_currentDir];
  }

  int get reset {
    _dirIndex = 0;
    return _fileIndex = -1;
  }

  @override
  String get current {
    String path;
    do {
      final dir = _currentDir;
      final leaf = _fileList.elementAt(_fileIndex);
      path = '$dir$leaf';
    } while (!filter(path));
    return path;
  }

  @override
  bool moveNext() {
    _fileIndex++;
    if (_fileIndex >= _fileList.length) {
      _dirIndex++;
      if (_dirIndex >= _dirList.length) return false;
      _fileIndex = 0;
      if (_dirIndex >= _dirList.length) return false;
      _currentDir = _dirList.elementAt(_dirIndex);
      _fileIndex = 0;
      return true;
    }
    return true;
  }
}


