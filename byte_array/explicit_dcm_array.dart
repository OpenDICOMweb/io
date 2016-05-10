// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.
library odw.sdk.reference.io.explict_dcm_byte_array;

import 'dart:core' hide DateTime;
import 'dart:typed_data';

import 'package:base/type.dart';
import 'package:base/src/io/byte_array/dcm_byte_array.dart';

/// A library for parsing [Uint8List], aka [ExplicitDcmByteArray]
///
/// Supports parsing both BIG_ENDIAN and LITTLE_ENDIAN byte arrays. The default
/// Endianness is the endianness of the host [this] is running on, aka HOST_ENDIAN.
/// All read* methods advance the [position] by the number of bytes read.
class ExplicitDcmByteArray extends DcmByteArray {
  static const bool isExplicit =  true;

  ExplicitDcmByteArray(Uint8List bytes, [int start = 0, int length])
      : super(bytes, start, length);

  ExplicitDcmByteArray.ofLength(int length)
      : super(new Uint8List(length), 0, length);

  ExplicitDcmByteArray.fromBuffer(ByteBuffer buffer, [int start = 0, int length])
      : super(buffer.asUint8List(), start, length);

  ExplicitDcmByteArray.fromUint8List(
      Uint8List bytes,
      [int start = 0, int length])
      : super(bytes, start, length);

  ExplicitDcmByteArray.view(DcmByteArray buf, [int start = 0, int length])
      : super(buf.bytes, start, length);


  /// Read a Value Representation Code (VR). See PS3.10.
  int _readVR() {
    int c1 = readUint8();
    int c2 = readUint8();
    int vrCode = c2 + (c1 << 8);
    return vrCode;
  }

  /// Read the Value Field Length
  /// Note: Always an even number, but the last byte might be padding.
  int _readVFLength(int vr) {
    int sizeInBytes = vrVFLength(vr);
    //print('vrSizeInBytes= $sizeInBytes');
    if (sizeInBytes == 4) {
      seek(2);
      return readUint32();
    } else {
      return readUint16();
    }
  }

  /// An Attribute Reader for [Dataset]s with Explicit Value Representations.
  /// Read an [Attribute] with an Explicit [VR] from [buf].
  Attribute readAttribute([int limit]) {
    //print('rEE: limit=$end');
    // [tag], [vr], [length], and [offset] must be read in this order.
    int tag = _readTag();
    int vr = _readVR();
    int length = _readVFLength(vr);
    int offset = position;
    //print('tag=${tagToDicom(tag)}, vr= ${vrToString[vr]}, len=$length, off=$offset');
    if (vr == vrSQ) {
      if (hasUndefinedLength(length)) {
        return _readSequenceUndefinedLength(tag, offset);
      } else {
        int limit = getLimit(length);
        return _readSequence(tag, offset, length, limit);
      }
    } else {
      if (hasUndefinedLength(length)) {
        //TODO verify that this list is correct.
        // vr = OB, OD, OF, OW, UN, UR, or UT (Not SQ or Item)
        print('rEE.UndefinedLength: tag=${tagToDcmFmt(tag)},'
        '$vrToString[vr], len=$length ');
        length = _getUndefinedItemLength(offset, tag);
      } else {
        seek(length);
      }
      var attribute = new Attribute(tag, vr, offset, length);
      print('readAttributeExplicit: $attribute');
      return attribute;
    }
  }
}
