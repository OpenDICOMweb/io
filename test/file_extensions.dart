// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

/// path = root / dir / base
///                   / name /ext
class Filename {
  final String _path;
  FileType _type;

  Filename(this._path);

  bool get isDicom => _type.isDicom;
  bool get isDescriptor => _type.isEntity;
  bool get isMetadata => _type.isMetadata;
  bool get isBulkdata => _type.isBulkdata;

  String get path => _path;
  String get root => p.rootPrefix(_path);
  String get dir => p.dirname(_path);
  String get base => p.basename(_path);
  String get name => base.substring(0, _firstDot(base));
  String get ext => base.substring(_firstDot(base));
  String get charset => _type.charset;

  FileType get type => _type ??= FileType.parse(_path);
  DcmMediaType get mType => type.mediaType;
  OType get oType => type.eType;
  String get ext1 => type.ext;

  String toString() => _path;
}

String ext(String s) {
  var base = p.basename(s);
  var i = base.indexOf('.');
  var ext = base.substring(i);
  return ext;
}

String dcmEntity = 'bas/bar/file.dcm';
String dcmMetadata = 'bas/bar/file.md.dcm';
String jsonEntity = 'bas/bar/file.dcm.json';
String jsonMetadata = 'bas/json/file.md.dcm.json';
String xmlEntity = 'bas/bar/file.dcm.xml';
String xmlMetadata = 'bas/bar/file.md.dcm.xml';
String bulkdata = 'bas/bar/file.bd.dcm';
var pathList = [
  dcmEntity, dcmMetadata, jsonEntity, jsonMetadata, xmlEntity, xmlMetadata, bulkdata
];

main() {

  for (String s in pathList) {
    Filename f = new Filename(s);
    print('Path: $s');
    print('  fname: $f');
    print('  type: ${f.type}');
    print('  components:\n    root:${f.root}\n    dir: ${f.dir}\n    base: ${f.base}\n'
              '    name: ${f.name}\n    ext: ${f.ext}');
    print('  mType: ${f.mType}');
    print('  oType: ${f.oType}');
    print('  charset: ${f.charset}');
  }


}
