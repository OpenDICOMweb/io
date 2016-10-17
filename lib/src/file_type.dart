// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

class FileType {
  final int index;
  final String name;
  final String extension;

  const FileType(this.index, this.name, this.extension);

  static const instance = const FileType(0, "SOP Instance", ".dcm");
  static const metadata = const FileType(1, "Metadata",  ".md");
  static const bulkdata = const FileType(2, "Bulkdata", ".bd");

  static const jsonInstance = const FileType(3, "JSON SOP Instance", ".dcm.json");
  static const jsonMetadata = const FileType(4, "JSON Metadata",  ".md.json");
  static const jsonBulkdata = const FileType(5, "JSON Bulkdata", ".bd");

  static const xmlInstance = const FileType(6, "XML SOP Instance", ".dicom+xml");
  static const xmlMetadata = const FileType(7, "XML Metadata",  ".dicom+xml.md");
  static const xmlBulkdata = const FileType(8, "XML Bulkdata", ".dicom+xml.bd");
}