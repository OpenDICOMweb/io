// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

/// The various Encodings of DICOM objects
///
/// The file extensions are structured from most specific to least specific.
/// The are three types of objects that can be stored:
///     - Entity: contains all data (Metadata & Bulkdata) for the object.
///     - Metadata: contains all Data Elements, but some large values have
///       been moved to a Bulkdata object.
///     - Bulkdata: A set of large values that are referred to by a Metadata object.
///
/// An Entity might be a Study, Series, or Instance.

///
/// The object type, encoding, media type, and file extension for a File.
class Encoding {
  static const ssType = "dicom";
  static const type = "application";

  final int index;

  final String oType;  // Object Type
  final String sType;  // SubType
  final String ext;    // File Extension
  final String bType;  // Base Encoding Type

  //TODO: jfp document this
  const Encoding(this.index, this.oType, this.sType,  this.ext, this.bType);

  String get subType => '$ssType+$sType';
  String get mediaType => 'application/$subType';
  String get objectType => oType;
  String get extension => ext;
  String get charset => bType;



  static const entity = const Encoding(1, "Entity",   "", "dcm", "octet");
  static const metadata = const Encoding(2, "Metadata", "", "desc.dcm", "octet");
  static const bulkdata = const Encoding(3, "Bulkdata",   "", "bd.dcm", "octet");

  static const jsonEntity = const Encoding(4, "Entity",   "json", ".dcm.json",  "utf8");
  static const jsonMetadata = const Encoding(5, "Metadata", "json", ".desc.dcm.json", "utf8");
  static const jsonBulkdata = const Encoding(6, "Bulkdata",   "json", ".bd.dcm.json", "utf8");

  static const xmlEntity = const Encoding(7, "Entity", "xml", ".dcm.xml", "utf8");
  static const xmlMetadata = const Encoding(8, "Metadata", "xml", "desc.dcm.xml", "utf8");
  static const xmlBulkdata = const Encoding(9, "Bulkdata", "xml", "md.dcm.json", "utf8");

  static const pureJsonEntity = const Encoding(10, "Entity", "json", ".json",  "utf8");
  static const pureJsonMetadata = const Encoding(11, "Metadata", "json", "desc.json", "utf8");
  static const pureJsonBulkdata = const Encoding(12, "Bulkdata", "json", "bd.json", "utf8");

  String toString() => '$oType encoded as $mediaType';
}
