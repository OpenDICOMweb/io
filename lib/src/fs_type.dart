// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

class FSType {
  final String type;
  final String ext;

  const FSType(this.type, this.ext);

  static const sopTree = const FSType("SOP", ".dcm");
  static const sopFlat = const FSType("SOP",  ".dcm");
  static const msd = const FSType("MSD", "msd");
  static const mint = const FSType("Mint", "mint");
}
