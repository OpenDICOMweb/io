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

  static const sopInstance = const FileType(1, "SOP Instance", ".dcm");
  static const metadata = const FileType(2, "Metadata",  ".md");
  static const bulkdata = const FileType(3, "Bulkdata", ".bd");
}