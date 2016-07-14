// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.
library odw.sdk.reference.io.byte_array.dcm_byte_array;

import 'dart:core' hide DateTime;
import 'dart:typed_data';

import 'byte_array.dart';

typedef List VFReader(int tag, int length);
enum Trim {left, right, both}

//TODO: fix comment
/// A library for parsing [Uint8List], aka [DcmByteArray]
///
/// Supports parsing both BIG_ENDIAN and LITTLE_ENDIAN byte arrays. The default
/// Endianness is the endianness of the host [this] is running on, aka HOST_ENDIAN.
/// All read* methods advance the [position] by the number of bytes read.
class DcmByteArray extends ByteArray {
  final List<String> warnings = [];

  DcmByteArray(Uint8List bytes, [int start = 0, int length])
      : super(bytes, start, length);

  DcmByteArray.ofLength(int length)
      : super(new Uint8List(length), 0, length);

  DcmByteArray.fromBuffer(ByteBuffer buffer, [int start = 0, int length])
      : super(buffer.asUint8List(), start, length);

  DcmByteArray.fromUint8List(Uint8List bytes, [int start = 0, int length])
      : super(bytes, start, length);

  DcmByteArray.view(DcmByteArray buf, [int start = 0, int length])
      : super(buf.bytes, start, length);

  Attribute get readAttribute => readAttributeExplicit();

  //****  Core Dataset methods  ****
  /// Peek at next tag - doesn't move the [DcmByteArray.position]
  int peekTag() {
    int group = getUint16(position);
    int attribute = getUint16(position + 2);
    //print('grp=$group, elt=$attribute');
    return (group << 16) + attribute;
  }

  /// Read the DICOM Attribute Tag
  int readTag() {
    int group = readUint16();
    int attribute = readUint16();
    return (group << 16) + attribute;
  }

  const Map<int, VFReader> vrReaders = const {
    0x4145: readAEValues,
    0x4153: readASValues,
    0x4154: readATValues,
    0x4252: readBRValues,
    0x4353: readCSValues,
    0x4441: readDAValues,
    0x4453: readDSValues,
    0x4454: readDTValues,
    0x4644: readFDValues,
    0x464c: readFLValues,
    0x4953: readISValues,
    0x4c4f: readLOValues,
    0x4c54: readLTValues,
    0x4f42: readOBValues,
    0x4f44: readODValues,
    0x4f46: readOFValues,
    0x4f57: readOWValues,
    0x504e: readPNValues,
    0x5348: readSHValues,
    0x534c: readSLValues,
    0x5351: readSQValues,
    0x5353: readSSValues,
    0x5354: readSTValues,
    0x544d: readTMValues,
    0x5543: readUCValues,
    0x5549: readUIValues,
    0x554c: readULValues,
    0x554e: readUNValues,
    0x5552: readURValues,
    0x5553: readUSValues,
    0x5554: readUTValues
  };

  List readValues(tag, vr, length) => vrReaders[vr](tag, length);

  //TODO: Is there a cleaner way to abstract the next three methods?
  //TODO: Could tearoffs be used.
  List<String> readStringListTrimRight(int length, int min, int max) {
    var list = readStringList(length);
    for (int i = 0; i < list.length; i++) {
      var s = list[i].trimRight();
      _checkStringLength(s, min, max);
      list[i] = list[i].trimLeft();
    }
    return list;
  }

  List<String> readStringListTrim(int length, int min, int max) {
    var list = readStringList(length);
    for (int i = 0; i < list.length; i++) {
      var s = list[i].trim();
      _checkStringLength(s, min, max);
      list[i] = list[i].trimLeft();
    }
    return list;
  }

  List<String> readStringListTrimLeft(int bLength, int min, int max) {
    var list = readStringList(length);
    for (int i = 0; i < list.length; i++) {
      var s = list[i].trimLeft();
      _checkStringLength(s, min, max);
      list[i] = list[i].trimLeft();
    }
    return list;
  }

  int _checkStringLength(String s, int min, int max) {
    var length = s.length;
    if ((length < min) || (length > max))
      throw 'Invalid length: min= $min, max=$max, "$s" has length ${s.length}';
    return length;
  }

  List<String> readAEValues(int tag, int length) => readStringListTrim(length, 0, 16);
  List<String> readASValues(int tag, int length) => readStringListTrim(length, 4, 4);


  /// Read a [Sequence] with *Known Length*.
  SQ _readSequence(Dataset parent, int tag, int length) {
    print('rSQ: ${tagToDcmFmt(tag)}, off=$offset, len=$length, limit=$limit');
    List<Item> items = <Item>[];
    while (position < limit)
      items.add(_readItem(tag, parent););

    SQ sq = new SQ(tag, items, false);
    //sq.debug();
    return sq;
  }

  /// Read a [Sequence] with *Undefined Length*, i.e. [Sequence.length] == -1.
  Sequence _readSequenceUndefinedLength(int tag, int offset) {
    print('rSQUL: ${tagToDcmFmt(tag)}, off=$offset');
    int length;
    List<Item> items = [];
    while (isNotEmpty) {
      Item item = _readItem();
      if (item.tag == sequenceDelimitationItem) {
        // This is the *Sequence Delimitation Item*, get the [sequence] length
        // and return the [Sequence].
        length = checkLength(item.offset);
        return new Sequence(tag, vrSQ, offset, length, true, items);
      } else {
        items.add(item);
      }
    }
    // eof encountered - log a warning and return a [Sequence]
    // with [length] based on the [limit].
    warning(
        'eof encountered before finding "SequenceDelimitationItem" '
            'in [Sequence] of "Undefined Length" with tag=$tag');
    position = limit;
    length = checkLength(offset);
    var sq = new Sequence(tag, VR_SQ, offset, length, true, items);
    sq.debug();
    return sq;
  }

  //TODO this can be moved to Dataset_base if we abstract DatasetExplicit & readAttributeExplicit
  Item _readItem(int tag) {
    bool hadUndefinedLength = false;
    int length = _readItemLength();
    if (length == kUndefinedLength) {
      length = _getUndefinedItemLength();
      hadUndefinedLength = true;
    }
    int limit = position + length;
    Map<int, Attribute> attributes = {};
    while (position < limit) {
      Attribute attribute = reader();
      attributes[attribute.tag] = attribute;
    }
    Item item = new Item(tag, attributes, hadUndefinedLength);
    print('readItem: $item($tag, $attributes, $hadUndefinedLength)');
    return item;
  }

  /// Returns the [length] of an [Item].
  /// Reads the [tag] and [length] fields.  If [kUndefinedLength]
  /// calls [_getUndefinedItemLength] to determine the [length].
  int _readItemLength() {
    int tag = readTag();
    if (tag != kItemDelimitationItem)
      readError("Bad Item tag=${tagToDcmFmt(tag)} at $position");
    //print('tag=${tagToDicom(tag)}');
    // [Item]s have a [Uint32] length field.
    int length = readUint32();

    int offset = position;
    print('readItemLength: $length');
    return length;
  }

  static const kItemDelimitationFirst16Bits = 0xfffe;
  static const kItemDelimitationSecond16Bits = 0xe00d;

  /// Returns the [length] of an [Item] with undefined length.
  /// The [length] does not include the [kItemDelimitationItem] or the
  /// [kItemDelimitationItem] [length] field, which should be zero.
  int _getUndefinedItemLength() {
    int start = position;
    //var maxPosition = limit - kItemDelimitationItemLength;
    print('findItemDelimitationItem: pos=${position}, max=$limit');
    while (position < limit) {
      int groupNumber = readUint16();
      if (groupNumber == kItemDelimitationFirst16Bits) {
        //print('group=${groupNumber.toRadixString(16)}');
        int elementNumber = readUint16();
        if (elementNumber == kItemDelimitationSecond16Bits) {
          //print('attribute=${attributeNumber.toRadixString(16)}');
          int length = (position - 4) - start;
          int itemDelimiterLength = readUint32(); // the length
          if (itemDelimiterLength != 0) {
            warning('encountered non zero length following item delimeter'
                'at position ${position} in [_readUndefinedItemLength]');
          }
          // Return the Item length
          print('foundLength: len=$length');
          return length;
        }
      }
    }
    //TODO should this throw an Error?
    // No item delimitation item found - issue a warning, silently set the position
    // to the buffer limit and return the length from the offset to the end of the buffer.
    warning('encountered end of buffer while looking for ItemDelimiterItem');
    position = limit;
    return limit - start;
  }

  //TODO this method has not been tested
  encapsulatedPixelDataFromBytes(int offset, int length, frame) {
    //print('Read Pixel Data $model, frame=$frame');
    seek(offset);
    var basicOffsetTable = _readItemHeader();
    if (basicOffsetTable.tag != 'xfffee000') {
      throw "readEncapsulatedPixelData: missing basic offset table xfffee000";
    }
    // now that we know how many frames we have to validate the frame parameter
    var numFrames = basicOffsetTable.length / 4;
    if (frame > numFrames - 1) {
      throw
      "readEncapsulatedPixelData: parameter frame exceeds number of frames in basic offset table";
    }
    // read all the frame offsets
    var frameOffsets = [];
    for (var frameOffsetNum = 0; frameOffsetNum < numFrames; frameOffsetNum++) {
      var frameOffset = readUint32();
      frameOffsets.add(frameOffset);
    }
    // now read the frame
    var baseOffset = position;
    var pixelData = readFrame(baseOffset, frameOffsets, frame);
    return pixelData;
  }


  //TODO this method has not been tested
  readFrame(int baseOffset, List<int> frameOffsets, frame) {
    if (frame >= frameOffsets.length) {
      throw 'readFrame: parameter frame refers to frame not in frameOffsets';
    }

    // position the byteStream at the beginning of this frame
    int frameOffset = frameOffsets[frame];
    position = baseOffset + frameOffset;

    // calculate the next frame offset so we know when to stop reading this frame
    int nextFrameOffset = end;
    if (frame < frameOffsets.length - 1)
      nextFrameOffset = frameOffsets[frame + 1];

    // read all fragments for this frame
    var fragments = [];
    var frameSize = 0;
    while (position < nextFrameOffset) {
      var fragment = _readItemHeader();
      if (fragment.tag == 'xfffee0dd') break;
      fragments.add(fragment);
      frameSize += fragment.length;
      seek(fragment.length);
    }
    // if there is only one fragment, return a view on this array to avoid copying
    if (fragments.length == 1) {
      return new Uint8List.view(fragments[0].offset, fragments[0].length);
    }
    // copy all of the type from the fragments into the pixelData
    var pixelData = new Uint8List(frameSize);
    var pixelDataIndex = 0;
    for (var i = 0; i < fragments.length; i++) {
      var fragmentOffset = fragments[i].offset;
      for (var j = 0; j < fragments[i].length; j++) {
        pixelData[pixelDataIndex++] = bytes[fragmentOffset++];
      }
    }
    //console.log('read frame #' + frame + " with " + fragments.length + " fragments and " + pixelData.length + " bytes");
    return pixelData;
  }


  /// Returns the [attribute]'s value as a [String].  If [_index] is provided,
  /// the attribute is assumed to be multi-valued and will return the value
  /// specified by index.  [null] is returned if
  ///     1. the attribute does not exist,
  ///     2. there is no component with the specified [index], or
  ///     3. it is zero length.
  ///
  /// Use this function for VRs of type AE, CS, SH and LO
  /// The returned [String] has leading and trailing spaces removed.
  //TODO make the comment correspond to the method
  // VRs AE, CS, DS, IS, LO, PN, SH, UR remove leading and training
  // VRs DT, LT,  ST, TM, UT training only
  String getStringTrimBoth(int offset, int length) =>
      getString(offset, length, 'both');

  String getStringTrimLeft(int offset, int length) =>
      getString(offset, length, 'left');

  String getStringTrimRight(int offset, int length) =>
      getString(offset, length, 'right');


  /// Returns a [String] with the leading spaces preserved and trailing spaces removed.
  /// Use this function to access the value for attributes with VRs of type UT, ST and LT

  /// Returns a [String] with the leading spaces preserved and trailing spaces removed.
  /// Use this function to access the value for attributes with VRs of type UT, ST and LT
  String getDcmText(int offset, int length) {
    var s = getString(offset, length, 'right');
    return ((s != null) && (s != "")) ? s : null;
  }

  String readDcmText(int length) {
    var s = getDcmText(position, length);
    position += length;
    return s;
  }

  /// Reads and parses a [Date] formatted string (VR = DA).
  /// Returns a [Date] or [null] if not present or not 8 bytes long.
  //TODO verify that date MUST be 8 bytes long?
  Date dcmDateFromString(String s) {
    if ((s != null) && (s.length == 8)) {
      var yyyy = int.parse(s.substring(0, 4));
      var mm = int.parse(s.substring(4, 6));
      var dd = int.parse(s.substring(6, 8));
      return new Date(yyyy, mm, dd);
    }
    warning('bad Date format "$s"');
    return null;
  }

  /// Get a DICOM Time value from [bytes] at [offset] with [length]
  Date getDcmDate(int offset, int length) {
    //TODO what should trim be?
    var s = getString(offset, length, 'right');
    return (s != null) ? dcmDateFromString(s) : null;
  }

  Date readDate(int length) {
    var s = getDcmDate(position, length);
    position += length;
    return s;
  }

  /// Reads and parses a [Date] formatted string (VR = DA).
  /// Returns a [Date] or [null] if not present or not 8 bytes long.
  //TODO This needs to be tested
  DateTime dcmDateTimeFromString(String s) {
    if ((s != null) && (s.length == 8)) {
      var yyyy = int.parse(s.substring(0, 4));
      var MM = int.parse(s.substring(4, 6));
      var dd = int.parse(s.substring(6, 8));
      var hh = int.parse(s.substring(8, 10));
      var mm = (s.length >= 12) ? int.parse(s.substring(10, 12)) : 0;
      var ss = (s.length >= 14) ? int.parse(s.substring(12, 14)) : 0;
      //TODO should read the ".", but we just skip over it for now
      var ffffff = (s.length >= 16) ? int.parse(s.substring(15, 21)) : 0;
      return new DateTime(
          yyyy,
          MM,
          dd,
          hh,
          mm,
          ss,
          ffffff);
    } else {
      warning('bad DateTime format "$s"');
      return null;
    }
  }

  /// Get a DICOM Time value from [bytes] at [offset] with [length]
  DateTime getDcmDateTime(int offset, int length) {
    //TODO what should trim be?
    var s = getString(offset, length, 'right');
    return (s != null) ? dcmDateTimeFromString(s) : null;
  }

  DateTime readDcmDateTime(int length) {
    var s = getDcmDateTime(position, length);
    position += length;
    return s;
  }

  /// Parses a [String] with format (VR = TM) HHMMSS.FFFFFF into a [Time].
  /// Returns a [Time] with hours, minutes, seconds and fractionalSeconds
  /// or [null] if not present or does not have a length of 2.
  Time dcmTimeFromString(String s) {
    if (s.length >= 2) {
      // must at least have HH
      //TODO what is trim
      s = s.trimRight();
      var hh = int.parse(s.substring(0, 2));
      var mm = s.length >= 4 ? int.parse(s.substring(2, 4)) : 0;
      var ss = s.length >= 6 ? int.parse(s.substring(4, 6)) : 0;
      //TODO should read the ".", but we just skip over it for now
      var ffffff = s.length >= 8 ? int.parse(s.substring(7, 13)) : 0;
      return new Time(hh, mm, ss, ffffff);
    } else {
      warning('bad Time format "$s"');
      return null;
    }
  }

  /// Get a DICOM Time value from [bytes] at [offset] with [length]
  Time getTime(int offset, int length) {
    //TODO what should trim be?
    var s = getString(offset, length, 'right');
    return (s != null) ? dcmTimeFromString(s) : null;
  }

  Time readTime(int length) {
    var s = getTime(position, length);
    position += length;
    return s;
  }

  /// Parses a [String formatted as a Person Name (VR = PN) into a [PersonName].
  /// Returns a [PersonName] or [null] if the attribute is not present or has a
  /// value length of 0.
  PersonName personNameFromString(String s) {
    //TODO what happens when you read beyond the end of the list
    var pName = s.split('^');
    var familyName = pName[0];
    var givenName = pName[1];
    var middleName = pName[2];
    var prefix = pName[3];
    var suffix = pName[4];
    return new PersonName(familyName, givenName, middleName, prefix, suffix);
  }

  /// Get a DICOM Time value from [bytes] at [offset] with [length]
  PersonName getPersonName(int offset, int length) {
    //TODO what should trim be?
    var s = getString(offset, length, 'right');
    return (s != null) ? personNameFromString(s) : null;
  }

  PersonName readPersonName(int length) {
    var s = getPersonName(position, length);
    position += length;
    return s;
  }

  /// Parses a [String formatted as a Person Name (VR = PN) into a [PersonName].
  /// Returns a [PersonName] or [null] if the attribute is not present or has a
  /// value length of 0.
  List<PersonName> getPersonNameList(int offset, int length) {
    //TODO how should space be trimmed
    var strings = getStringList(offset, length, 'both');
    if (strings != null) {
      var pnList = [];
      for (var s in strings) {
        //TODO is the next line needed?
        if (s == "") continue;
        pnList.add(personNameFromString(s));
      }
      return (pnList.length == 1) ? pnList[0] : pnList;
    }
    return null;
  }

  List<PersonName> readPersonNameList(int length) {
    var list = getPersonNameList(position, length);
    position += length;
    return list;
  }

  /// Add a warning string to the [List<String>] of [warnings] associated with the [Dataset].
  void warning(String s) {
    print(s);
    warnings.add(s);
  }

}

