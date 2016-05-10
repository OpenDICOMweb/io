// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.
library odw.sdk.base.io.byte_array.explicit_dcm_byte_array;

import 'dart:core' hide DateTime;
import 'dart:typed_data';

import 'package:base/type.dart';
import 'package:base/src/io/byte_array/byte_array.dart';

/// A library for parsing [Uint8List], aka [ByteArray]
///
/// Supports parsing both BIG_ENDIAN and LITTLE_ENDIAN byte arrays. The default
/// Endianness is the endianness of the host [this] is running on, aka HOST_ENDIAN.
/// All read* methods advance the [position] by the number of bytes read.
class ImplicitDcmByteArray extends ByteArray {
  static const bool isExplicit = false;
  final List<String> warnings = [];

  ImplicitDcmByteArray(Uint8List bytes, [int start = 0, int length])
      : super(bytes, start, length);

  ImplicitDcmByteArray.ofLength(int length)
      : super(new Uint8List(length), start, length);

  ImplicitDcmByteArray.fromBuffer(ByteBuffer buffer,
      [int start = 0, int length])
      : super(buffer.asUint8List(), start, length);

  ImplicitDcmByteArray.fromUint8List(Uint8List bytes,
      [int start = 0, int length])
      : super(bytes, start, length);

  ImplicitDcmByteArray.view(ByteArray buf, [int start = 0, int length])
      : super(buf.bytes, start, length);

  /// Read the Value Field Length.
  ///
  /// The implicit Value Field Length is always a 32-bit positive integer.
  /// Note: This is always an even number, but last byte might be padding.
  int _readVFLength(int vr) => readUint32();


  /// Read the [List] of values.
  //TODO: later
  List readValues() {
    //TODO implement this method
  }

  /// Read an [Attribute] with an *Implicit* VR from [buf].
  Attribute readAttribute([int limit]) {
    // [tag], [length], and [offset] must be read in this order.
    int tag = _readTag();
    int length = _readVFImplicitLength();
    int offset = position;

    if (_peekTag() == kItem) {
      // Peek at the next tag to see if it is an item tag.  If so, this is a sequence.
      // This is not 100% safe because a non sequence item could have type that has
      // these bytes, but this is how to do it without a type dictionary.
      // Parse the sequence.
      if (hasUndefinedLength(length)) {
        return _readSequenceUndefinedLength(tag, offset);
      } else {
        int limit = getLimit(length);
        return _readSequence(tag, offset, length, limit);
      }
    } else {
      if (hasUndefinedLength(length)) {
        // vr = OB, OD, OF, OW, UN, UR, or UT (Not SQ or Item)
        length = _getUndefinedItemLength(offset, tag);
      }
      seek(length);
      var attribute = new Attribute(tag, -1, offset, length);
      //print(attribute);
      return attribute;
    }
  }
}

