// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
import 'package:core/core.dart';


/// A path database for a VNA.
class PathDB {
  /// The path of the root directory for a VNA.
  final String rootPath;

  /// A [Map] from [Uid]s to relative path from the [rootPath];
  final Map<Uid, String> pathMap;

  /// Creates a [PathDB].
  PathDB.empty(String rootPath)
      : rootPath = _normalizeDirPath(rootPath),
        pathMap = <Uid, String>{};

  /// Add a new entry into _this_.
  void add(Uid uid, String path) {}

  static String _normalizeDirPath(String path) {
    final p = path.replaceAll(r'\', r'/');
    return (path[p.length - 1] == r'/') ? p : '$p/';
  }
}
