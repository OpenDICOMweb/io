// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

class DcmMediaType {
  final String subType;
  final String charset;

  const DcmMediaType(this.subType, this.charset);

  String get type => "application";

  bool get isDicom => true;

  static const dcm = const DcmMediaType("dicom", "octet");
  static const json = const DcmMediaType("dicom+json", "UTF-8");
  static const fastJson = const DcmMediaType("dicom+json", "UTF-8");
  static const pureJson = const DcmMediaType("json", "UTF-8");
  static const xml = const DcmMediaType("dicom+xml", "UTF-8");
  static const bytes = const DcmMediaType("octet-stream", "octet");

  String toString() => "$type/$subType";
}