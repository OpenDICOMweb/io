// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the   AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:encode/encoder.dart';
import 'package:io/io.dart';

String inPath = 'C:/odw/test_data/IM-0001-0001.dcm';

String outPath = 'C:/odw/sdk/io/example/output/IM-0001-0001.dcm';

void main(List<String> args) {

    Filename fn = new Filename(inPath);
    Uint8List bytes = fn.file.readAsBytesSync();
    Instance instance = DcmDecoder.decode(bytes);
    print(instance.format(new Formatter()));

    // Write a File
    Filename fnOut = new Filename.withType(outPath, FileSubtype.part10);
    fnOut.writeSync(instance);

    Filename result = new Filename(outPath);

    bytes = fn.file.readAsBytesSync();
    instance = DcmDecoder.decode(bytes);
    print(instance.format(new Formatter()));

}



