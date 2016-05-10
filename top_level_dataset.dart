
library top_level_dataset;

import 'dart:typed_data';

import 'package:base/base.dart';


class TopLevelDataset extends Dataset {
 // MintHeader header;
  Dataset    fileMetaInfo;
  String     transferSyntax = "";

  TopLevelDataset(Uint8List bytes) : super.fromUint8List(bytes);

  /// Read the Mint Header if any

  /// Read the DICOM Part 10 (PS 3.10) Prefix
  bool _readPrefix() {
    buf.seek(128);
    var prefix = buf.readString(4);
    if (prefix != "DICM") {
      warning("readPrefix: DICM prefix not found at location 132");
      // Move buf.position back to beginning of file
      buf.seek(-132);
      return false;
    } else
      return true;
  }

  static const fmiGroupLength = 0x00020000;
  /// Read the [FileMetaInfo].
  /// Note: The FileMetaInfo elements always have an explicit VR.
  bool readFileMetaInfo() {
    if(! _readPrefix()) return false;

    do {
      var element = readElementExplicit();
      if (tagGroup(element.tag) != 0x0002) {
        attributes[element.tag] = element;
        break;
      }
      fileMetaInfo[element.tag] = element;
      if (element.tag == kTransferSyntaxTag) {
        transferSyntax = buf.getString(element.offset, element.length);
      }
    } while(true);

    if (transferSyntax == '1.2.840.10008.1.2') { // implicit little endian
      super.isExplicit = false;
    } else if (transferSyntax == '1.2.840.10008.1.2.2') {
      throw 'TopLevelDataset: explicit big endian transfer syntax not supported';
      return false;
    }
    return true;
  }

  static read(Uint8List bytes) {
    TopLevelDataset topDataset = new TopLevelDataset(bytes);
    topDataset.readFileMetaInfo();

    ByteArray buf = topDataset.buf;
    while (buf.isNotEmpty) {
      //print('buf remaining = ${buf.limit - buf.position}');
      var element = topDataset.attributeReader(buf.limit);
      topDataset[element.tag] = element;
    }
    return topDataset;
  }

}
