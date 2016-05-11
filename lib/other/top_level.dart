// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.
library odw.sdk.dicom.io.top_level;

/// This module contains the entry point for parsing a DICOM P10 byte stream
///
/// This module exports itself as both an AMD module for use with AMD loaders as well
/// as a global browser variable when AMD modules are not being used.  See the following:
///
/// https://github.com/umdjs/umd/blob/master/amdWeb.js

import 'dart:typed_data';

import 'package:base/base.dart';
import 'package:base/src/io/byte_array/dcm_byte_array.dart';


class RootDataset extends Dataset {
  Uint8List prefix;
  FileMetaInfo fmi;
  int length;

  RootDataset(this.prefix, this.fmi, Map<int, Attribute> attributes,
      [bool hadUndefinedLengt = false, int length = -1)
      : super(null, attributes, hadUndefinedLength, length);

  String readPrefix(DcmByteArray buf) {
    Uint8List prefix = buf.readBytes(0, 128);
    String dicm = buf.readString(4);
    if (prefix != "DICM") {
      throw "parseDicom: DICM prefix not found at location 132";
    }
    return prefix;
  }

  readFileMetaInfo(DcmByteArray buf) {
    Dataset fmi = new Dataset.fromByteArray(buf);
    readPrefix(fmi);
    //save and restore later
    int limit = buf.limit;

    // Read the group length element so we know how many bytes needed
    // to read the entire meta header
    //TODO shouldn't we check that it's in fact the fmi group length element = 0x00020000
    var groupLengthElement = fmi.readElementExplicit();
    var fmiLength = fmi.buf.getUint32(groupLengthElement.offset);
    var readFileMetaInfo = fmi.buf.limit = fmi.buf.position + fmiLength;
    fmi[groupLengthElement.tag] = groupLengthElement;
    while (fmi.buf.isNotEmpty) {
      var element = fmi.readElementExplicit();
      fmi[element.tag] = element;
    }
    // Restore limit saved above
    buf.limit = limit;
    return fmi;
  }

  isExplicit(Dataset fmi) {
    if (fmi.attributes[0x00020010] == null)
      throw 'parseDicom: missing required meta header attribute 0002,0010';

    var transferSyntaxElement = fmi.attributes[$transferSyntaxTag];
    //print(transferSyntaxElement);
    String transferSyntax =
    fmi.buf.getString(
        transferSyntaxElement.offset, transferSyntaxElement.length);
    //print('TransferSyntax="$transferSyntax", len=${transferSyntax.length}');
    if (transferSyntax == '1.2.840.10008.1.2') {
      // implicit little endian
      return false;
    } else if (transferSyntax == '1.2.840.10008.1.2.2') {
      throw 'parseDicom: explicit big endian transfer syntax not supported';
    }
    // all other transfer syntaxes should be explicit
    return true;
  }

  mergeDatasets(Dataset fmiDataset, Dataset instanceDataset) {
    fmiDataset.attributes.forEach((int tag, Element element) {
      instanceDataset.attributes[tag] = element;
    });
    return instanceDataset;
  }

  /// This is the main entry point for the [Dataset].
  /// It parses the array of bytes into a DICOM Part 3.10 object.
  readDataset(Uint8List bytes) {
    var buf = new ByteArray.fromUint8List(bytes);
    var fmiDataset = readFileMetaInfo(buf);
    //print(fmiDataset);
    Formatter fmt = new Formatter();
    fmiDataset.regexpString(fmt);
    fmt.flush();
    //print('isExplicit=${isExplicit(fmiDataset)}');
    //print('buf=$buf');
    bool explicit = isExplicit(fmiDataset);
    var ds = Dataset.read(buf, isExplicit: explicit);
    mergeDatasets(fmiDataset, ds);
    //print(ds);
    return ds;
  }

  static RootDataset decode(Uint8List bytes) {
    DcmByteArray dcmBytes = new DcmByteArray(bytes);
    Uint8List prefix = readPrefix(dcmBytes);
    FileMetaInfo fmi = readFileMetaInfo(dcmBytes);
    Map<int, Attribute> attributes = dcmBytes.readDataset();
    return new RootDataset(prefix, fmi, attributes);
  }
}


