// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.



import 'package:path/path.dart' as p;

enum DcmType {descriptor, metadata, bulkdata}


int _firstDot(String s) => p.basename(s).indexOf('.');

String _extension(String path) => p.basename(path).substring(_firstDot(path));

class FileType {
  final String name;
  final String type;
  final String ext;

  const FileType(this.name, this.type, this.ext);

  bool get isDicom => true;
  bool get isDescriptor => type == "decriptor";
  bool get isMetadata => type == "metadata";
  bool get isBulkdata => type == "bulkdata";

  String get mediaType => 'application/$name';

  static const dicom = const FileType("dicom", "descriptor", ".dcm");
  static const mdDicom = const FileType("dicom", "metadata", ".md.dcm");
  static const bdDicom = const FileType("dicom", "bulkdata", ".bd.dcm");
  static const dicomJson = const FileType("dicom+json", "descriptor", ".dcm.json");
  static const mdDicomJson = const FileType("dicom+json", "metadata", ".md.dcm.json");
  static const dicomXml = const FileType("dicom+xml", "descriptor", ".dcm.json");
  static const mdDicomXml = const FileType("dicom+xml", "metadata", ".md.dcm.json");

  static parseExt(String ext) => types[ext];
  static parse(String _path) => types[_extension(_path)];

  static const Map<String, FileType> types = const {
    ".dcm":  dicom,
    ".md.dcm": mdDicom,
    ".bd.dcm": bdDicom,
    ".dcm.json": dicomJson,
    ".md.dcm.json": mdDicomJson,
    ".dcm.xml": dicomXml,
    ".md.dcm.xml": mdDicomXml
  };

  String toString() => '$runtimeType: name($name), type($type), ext("$ext")';
}

/// path = root / dir / base
///                   / name /ext
class Filename {
  final String _path;
  FileType _type;

  Filename(this._path);

  bool get isDicom => _type.isDicom;
  bool get isDescriptor => _type.isDescriptor;
  bool get isMetadata => _type.isMetadata;
  bool get isBulkdata => _type.isBulkdata;

  String get path => _path;
  String get root => p.rootPrefix(_path);
  String get dir => p.dirname(_path);
  String get base => p.basename(_path);
  String get name => base.substring(0, _firstDot(base));
  String get ext => base.substring(_firstDot(base));


  FileType get type => _type ??= FileType.parse(_path);
  String get mType => type.mediaType;
  String get oType => type.type;
  String get ext1 => type.ext;

  String toString() => _path;

}

String ext(String s) {
  var base = p.basename(s);
  var i = base.indexOf('.');
  var ext = base.substring(i);
  return ext;
}

main() {
  String jsonName = 'bas/bar/foo.md.dcm.json';
  String dcmName = 'bas/bar/foo.md.dcm';
  String bdName = 'bas/bar/foo.bd.dcm';

  Filename fname = new Filename(dcmName);
  print('fname: $fname');
  print('type: ${fname.type}');
  FileType type1 = FileType.parse(dcmName);
  print(type1);

  Filename f = new Filename(bdName);
  print('p: ${f.name}\n  base: ${f.base}\n  basename: ${f.base}\n  ext: ${f.ext}');
  print('  mType: ${f.mType}');
  print('  oType: ${f.oType}');
}

