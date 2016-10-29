// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

/// An enumerated set of the types of File Systems supported by the IO package.
class FSType {
  final String name;
  /// The file extension for this type.
  final String ext;

  const FSType(this.name, this.ext);

  static const sop = const FSType("SOP Instance DICOM", ".dcm");
  static const msd = const FSType("Multi-Series DICOM", ".msd");
  static const mint = const FSType("Mint Normalized FS", ".mint");

  toString() => '$runtimeType($name)';
}
