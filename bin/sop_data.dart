// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.

// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.
library sop_data;

class SopFiles {
  final String dir;
  final List<String> files;

  const SopFiles(this.dir, this.files);

  List<String> get list {
    List<String> l = [];
    for(String f in files)
        l.add('$dir$f');
    return l;
  }

  static const cr1 = const SopFiles(
      "D:/M2sata/mint_test_data/sfd/cr/PID_MINT10/1_DICOM_Original/",
      const ["CR.2.16.840.1.114255.393386351.1568457295.17895.5.dcm",
      "CR.2.16.840.1.114255.393386351.1568457295.48879.7.dcm"
      ]);

  static const cr2 = const SopFiles(
      "D:/M2sata/mint_test_data/sfd/cr/PID_MINT10/Group2_dcm4che/",
      const ["2.16.840.1.114255.393386351.1568457295.17895.5",
      "2.16.840.1.114255.393386351.1568457295.48879.7"
      ]);
}
