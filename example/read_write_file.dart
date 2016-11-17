// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the   AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:encode/encoder.dart';
import 'package:io/io.dart';

//String inPath = 'C:/odw/test_data/IM-0001-0001.dcm';
String inPath = 'C:/odw/sdk/io/example/input/1.2.840.113696.596650.500.5347264.20120723195848/'
    '2.16.840.1.114255.1870665029.949635505.39523.169/2.16.840.1.114255.1870665029.949635505.10220.175.dcm';
String outPath = 'C:/odw/sdk/io/example/input/1.2.840.113696.596650.500.5347264.20120723195848/'
    '2.16.840.1.114255.1870665029.949635505.39523.169/output.dcm';

String in1 = "C:/odw/sdk/io/example/input/1.2.840.113696.596650.500.5347264.20120723195848/"
    "2.16.840.1.114255.1870665029.949635505.39523.169/"
    "2.16.840.1.114255.1870665029.949635505.25169.170.dcm";
String out1 = "C:/odw/sdk/io/example/input/1.2.840.113696.596650.500.5347264.20120723195848/"
    "2.16.840.1.114255.1870665029.949635505.39523.169/"
    "output.dcm";
void main(List<String> args) {


    Filename fn = new Filename(in1);
    print('reading: $fn');
    Uint8List bytes = fn.file.readAsBytesSync();
    print('read ${bytes.length} bytes');
    Instance instance = DcmDecoder.decode(bytes);
    print(instance.format(new Formatter(maxDepth: -1)));

    print('0070 0010 ${instance.dataset.lookup(0x00700010)}');
    // Write a File
    Filename fnOut = new Filename.withType(out1, FileSubtype.part10);
    fnOut.writeSync(instance);

    // Now read the file we just wrote.
    Filename result = new Filename(out1);

    print('Re-reading: $result');
    bytes = result.file.readAsBytesSync();
    print('read ${bytes.length} bytes');
    instance = DcmDecoder.decode(bytes);
    print(instance.format(new Formatter(maxDepth: -1)));

}



