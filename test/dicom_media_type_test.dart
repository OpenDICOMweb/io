// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.
//
import 'package:io_extended/io_extended.dart';
import 'package:test/test.dart';

void main() {

  group('DicomMediaTypeTest', (){

    test('DicomMediaType.part10', (){
      expect(DicomMediaType.dicom.type, equals('application'));
      expect(DicomMediaType.dicom.isBinary, true);
      expect(DicomMediaType.dicom.isAscii, false);
      expect(DicomMediaType.dicom.isUtf8, false);
      expect(DicomMediaType.dicom.isPart10, true);
      expect(DicomMediaType.dicom.isJson, false);
      expect(DicomMediaType.dicom.isXml, false);



    });
  });

}

