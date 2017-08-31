// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

/// Information Entity Level
class IELevel {
  final int level;
  final String name;

  const IELevel(this.level, this.name);

  static const subject = const IELevel(0, 'Subject');
  static const study = const IELevel(0, 'Study');
  static const series = const IELevel(0, 'Series');
  static const instance = const IELevel(0, 'Instance');
  static const dataset = const IELevel(0, 'Dataset');
}

