// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.
library odw.sdk.dicom.io.byte_array.dcm_byte_array;

import 'dart:typed_data';

import 'package:ascii/ascii.dart';
import 'package:attribute/attribute.dart';
import 'package:dataset/dataset.dart';
import 'package:date_time/date_time.dart';
import 'package:uid/uid.dart';

import 'byte_array.dart';

typedef Attribute AReader(tag, vr);
typedef List VFReader(int tag, int length);
enum Trim {left, right, both}

//TODO: fix comment
/// A library for parsing [Uint8List], aka [DcmByteArray]
///
/// Supports parsing both BIG_ENDIAN and LITTLE_ENDIAN byte arrays. The default
/// Endianness is the endianness of the host [this] is running on, aka HOST_ENDIAN.
/// All read* methods advance the [position] by the number of bytes read.
class DcmByteArray extends ByteArray {
  AReader reader;
  final List<String> warnings = [];

  DcmByteArray(this.reader, Uint8List bytes, [int start = 0, int length])
      : super(bytes, start, length);

  DcmByteArray.ofLength(this.reader, [start = 0, int length])
      : super(new Uint8List(length), start, length);

  DcmByteArray.fromBuffer(this.reader, ByteBuffer buffer, [int start = 0, int length])
      : super(buffer.asUint8List(), start, length);

  DcmByteArray.fromUint8List(this.reader, Uint8List bytes, [int start = 0, int length])
      : super(bytes, start, length);

  DcmByteArray.view(this.reader, DcmByteArray buf, [int start = 0, int length])
      : super(buf.bytes, start, length);

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


  List readValues(tag, vr, length) {
    Map<int, VFReader> vrReaders = {
      0x4145: readAE,
      0x4153: readAS,
      0x4154: readAT,
      // 0x4252: readBR,
      0x4353: readCS,
      0x4441: readDA,
      0x4453: readDS,
      0x4454: readDT,
      0x4644: readFD,
      0x464c: readFL,
      0x4953: readIS,
      0x4c4f: readLO,
      0x4c54: readLT,
      0x4f42: readOB,
      0x4f44: readOD,
      0x4f46: readOF,
      0x4f57: readOW,
      0x504e: readPN,
      0x5348: readSH,
      0x534c: readSL,
      0x5351: readSQ,
      0x5353: readSS,
      0x5354: readST,
      0x544d: readTM,
      0x5543: readUC,
      0x5549: readUI,
      0x554c: readUL,
      0x554e: readUN,
      0x5552: readUR,
      0x5553: readUS,
      0x5554: readUT
    };
    return vrReaders[vr](tag, length);
  }

  List<String> readAE(int length) => readStringListTrim(0, 16, length);

  List<String> readAS(int length) {
    if (length != 4) throw "Invalid Length: $length";
    var list = [];
    //TODO: create an age object
    return list.add(readString(length));
  }

  List<int> readAT(int length) {
    if ((length % 4) != 0) throw "Invalid length error: $length";
    int len = length ~/ 4;
    Uint32List list = new Uint32List(len);
    for (int i = 0; i < len; i++)
      list[i] = readTag();
    return list;
  }

  // List<String> readBR(int tag, int length) => readStringListTrim(4, 4,length);
  List<String> readCS(int length) => readStringListTrim(1, 16, length);

  List<Date> readDA(int length) {
    List<String> slist = readStringList(length);
    List<Date> dates = new List(slist.length);
    for (int i = 0; i < slist.length; i++)
        dates[i] = Date.parse(slist[i]);
    return dates;
  }

  List<double> readDS(int length) {
    List<String> strings = readStringListTrimRight(length, 1, 16);
    List<double> doubles = [];
    for (String s in strings) {
      if ((s.length < 1) || (s.length > 16))
        throw "Invalid DS Length: ${s.length}";
      doubles.add(double.parse(s));
    }
    return doubles;
  }

  List<DcmDateTime> readDT(int length) {
    List<String> slist = readStringListTrim(length, 0, 16);
    List<DcmDateTime> dts = new List<DcmDateTime>(slist.length);
    for (int i = 0; i < slist.length; i++)
      dts[i] = DcmDateTime.parse(slist[i]);
    return dts;
  }

  List<double> readFD(int length) => readFloat64List(length);

  List<double> readFL(int length) => readFloat32List(length);

  List<String> readIS(int length) => readStringListTrim(1, 12, length);

  List<String> readLO(int length) => readStringListTrim(length, 1, 64);

  List<String> readLT(int length) => _readText(length, 1, 10240);

  Uint8List readOB(int length) => readUint8List(length);

  Float64List readOD(int length) => readFloat64List(length);

  Float32List readOF(int length) => readFloat32List(length);

  Uint32List readOL(int length) => readUint32List(length);

  // depends on Transfer Syntax
  Uint16List readOW(int length) => readUint16List(length);

  // depends on Transfer Syntax
  List<PersonName> readPN(int length) => readPersonNameList(length);

  List<String> readSH(int length) => readStringListTrim(1, 16, length);

  Int32List readSL(int length) => readInt32List(length);

  SQ readSQ(int length) => _readSequence(length);

  Int16List readSS(int length) => readInt16List(length);

  List<String> readST(int length) => _readText(length, 1, 1024);

  List<Time> readTM(int length) {
    var slist = readStringListTrimRight(length, 2, 14);
    var times = new List<Time>(slist.length);
    for (int i = 0; i < slist.length; i++)
        times[i] = Time.parse(slist[i]);
    return times;
  }

  List<String> readUC(int length) => readStringListTrimRight(1, Dicom.kMaxLongLength, length);

  List<Uid> readUI(int length) {
    var list = readStringList(length);
    List<Uid> uids = [];
    for (String s in list) {
      if ((s.length < 6) || (s.length > 64))
        throw "Invalid Length for UID: ${s.length}";
      uids.add(Uid.parse(s));
    }
    return uids;
  }

  Uint32List readUL(int length) => readUint32List(length);

  Uint8List readUN(int length) => readUint8List(length);

  Uri readUR(int length) {
    var s = readString(length);
    if (s[s.length - 1] == 0) s = s.substring(0, length - 1);
    return Uri.parse(s);
  }

  List<int> readUS(int length) => readUint16List(length);

  List<String> readUT(int length) => _readText(length, 1, Dicom.kMaxLongLength);

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


  String getStringTrim(int offset, int length) =>
      getString(offset, length).trim();

  String readStringTrim(int length) {
    var s = getStringTrim(position, length);
    position += length;
    return s;
  }

  /// Returns a [List] of {String]s with [length] between [min]
  /// and [max] inclusive.  All [String]s have leading and trailing
  /// spaces trimmed (T = .trim()).
  List<String> getStringListTrim(int offset, int length, int min, int max) {
    var list = getStringList(offset, length);
    for (int i = 0; i < list.length; i++) {
      var s = list[i];
      // Check length before trimming!
      _checkStringLength(s, min, max);
      list[i] = s.trim();
    }
    return list;
  }

  /// Returns a [List] of {String]s with [length] between [min]
  /// and [max] inclusive.  All [String]s have leading and trailing
  /// spaces trimmed (T = .trim()).
  List<String> readStringListTrim(int length, int min, int max) {
    var list = getStringListTrim(position, length, min, max);
    position += length;
    return list;
  }

  String getStringTrimRight(int offset, int length) =>
      getString(offset, length).trimRight();

  String readStringTrimRight(int length) {
    var s = getStringTrimRight(position, length);
    position += length;
    return s;
  }

  //TODO: Is there a cleaner way to abstract the next three methods?
  //TODO: Could tearoffs be used.
  List<String> getStringListTrimRight(int offset, int length, int min, int max) {
    var slist = getStringList(offset, length);
    for (int i = 0; i < slist.length; i++) {
      _checkStringLength(slist[i], min, max);
      slist[i] = slist[i].trimRight();;
    }
    return slist;
  }

  //TODO: Is there a cleaner way to abstract the next three methods?
  //TODO: Could tearoffs be used.
  List<String> readStringListTrimRight(int length, int min, int max) {
    var slist = getStringListTrim(position, length, min, max);
    position += length;
    return slist;
  }

  /// Returns a List<String> containing a single String
  List<String> _readText(int bLength, int min, int max) {
    var s = readString(length);
    _checkStringLength(s, min, max);
    return [s];
  }

  int _checkStringLength(String s, int min, int max) {
    var length = s.length;
    if ((length < min) || (length > max))
      throw 'Invalid length: min= $min, max=$max, "$s" has length ${s.length}';
    return length;
  }


  int getSequenceLength(int endTag) {
    int length = readUint32();
    if (length == Dicom.kMinusOneAsUint32) {
      length = _getUndefinedLength(kSequenceDelimitationItemLast16Bits);
    }
    return length;
  }

  //TODO: decide on the recursive structure:
  //    1) should we create the parent then set the object, or
  //    2) should we create and return the object without
  //       the parent and have the parent set it them self
  // lets add the parent after we create the object, i.e. on the
  // way back up from the recursion.
  /// Read a [Sequence] with *Known Length*.
  SQ _readSequence(int tag) {
    bool hadUndefinedLength = false;
    int length = readUint32();
    if (length == Dicom.kUndefinedLength) {
      length = _getUndefinedLength(kSequenceDelimitationItemLast16Bits);
      hadUndefinedLength = true;
    }
    List<Item> items = <Item>[];
    while (position < (position + length))
      items.add(_readItem(tag));
    var sq = new SQ(tag, items, hadUndefinedLength);
    //Fix or remove
    // for (Item item in items)
    //   item.sequence = sq;
    return sq;
  }

  //TODO this can be moved to Dataset_base if we abstract DatasetExplicit & readAttributeExplicit
  Item _readItem(int seqTag) {
    bool hadUndefinedLength = false;
    int length = readUint32();
    if (length == Dicom.kUndefinedLength) {
      length = _getUndefinedLength(kItemDelimitationItemLast16Bits);
      hadUndefinedLength = true;
    }
    Map<int, Attribute> attributes = {};
    while (position < (position + length)) {
      var attribute = reader(seqTag, null);
      attributes[attribute.tag] = attribute;
    }
    Item item = new Item(attributes, seqTag, hadUndefinedLength);
    print('readItem: $item($seqTag, $attributes, $hadUndefinedLength)');
    return item;
  }

  //TODO: Document
  static const kDelimitationItemFirst16Bits = 0xFFFE;
  static const kSequenceDelimitationItemLast16Bits = 0xE0DD;
  static const kItemDelimitationItemLast16Bits = 0xE00D;

  /// Returns the [length] of an [Item] with undefined length.
  /// The [length] does not include the [kItemDelimitationItem] or the
  /// [kItemDelimitationItem] [length] field, which should be zero.
  int _getUndefinedLength(int delimiter) {
    int start = position;
    while (position < end) {
      int groupNumber = readUint16();
      if (groupNumber == kDelimitationItemFirst16Bits) {
        int elementNumber = readUint16();
        if (elementNumber == delimiter) {
          int length = (position - 4) - start;
          int itemDelimiterLength = readUint32();
          // Should be 0
          if (itemDelimiterLength != 0) {
            warning('encountered non zero length following item delimeter'
                        'at position ${position} in [_readUndefinedItemLength]');
          }
          print('foundLength: len=$length');
          return length;
        }
      }
    }
    // This code should not be executed - if we're here there's a problem
    //TODO should this throw an Error?
    // No item delimitation item found - issue a warning, silently set the position
    // to the buffer limit and return the length from the offset to the end of the buffer.
    warning('encountered end of buffer while looking for ItemDelimiterItem');
    position = limit;
    return limit - start;
  }

  //TODO this method has not been tested
  FrameTable readEncapsulatedPixelDataFromBytes(int offset, int length, int frame) {
    //print('Read Pixel Data $model, frame=$frame');
    //seek(offset);
    int tag = readUint32();
    if (tag != kItem)
      throw "Invalid Encapsulated Pixel Data Item";
    int length = readUint32();
    if (length != Dicom.kMinusOneAsUint32)
      throw "Invalid Item Length Field=$length, in Encapsulted Pixel Data";
    Uint32List basicOffsetTable = readBasicOffsetTable();

    // now that we know how many frames we have to validate the frame parameter
    if (frame > basicOffsetTable.length)
      throw "parameter frame exceeds number of frames in basic offset table";
    return readFragments(basicOffsetTable);
  }

  List<int> readBasicOffsetTable() {
    int tag = readUint32();
    if (tag != kItem)
      throw "readEncapsulatedPixelData: missing basic offset table xfffee000";
    int length = readUint32();
    if (length == 0) {
      return null;
    } else if (length > 0) {
      return bytes.buffer.asUint32List(position, position + length);
    } else {
      throw "Negative length field in Basic Offset table";
    }
  }

  readFragments(List<int> basicOffsetTable) {
    for (int i = 0; i < basicOffsetTable.length; i++) {
      
    }

  }
  //TODO this method has not been tested
  readFragment(List<int> basicOffsetTable, int frame) {
    if (frame >= basicOffsetTable.length) {
      throw 'readFrame: parameter frame refers to frame not in frameOffsets';
    }

    // position the byteStream at the beginning of this frame
    int frameOffset = basicOffsetTable[frame];
    position = baseOffset + frameOffset;

    // calculate the next frame offset so we know when to stop reading this frame
    int nextFrameOffset = end;
    if (frame < basicOffsetTable.length - 1)
      nextFrameOffset = basicOffsetTable[frame + 1];

    // read all fragments for this frame
    var fragments = [];
    var frameSize = 0;
    while (position < nextFrameOffset) {
      Map<int, List> attributes = {};
      var fragment = _readItem(kPixelData);
      // move this check to readItem
      //if (fragment.tag == 'xfffee0dd') break;
      fragments.add(fragment);
      frameSize += fragment.length;
      //Flush:?
      //seek(fragment.length);
    }
    //TODO: if there is only one fragment, return a view on this array to avoid copying
    //if (fragments.length == 1)
    //  return new Uint8List.view(fragments[0].offset, fragments[0].length);

    // copy all of the type from the fragments into the pixelData
    var pixelData = new Uint8List(frameSize);
    var pixelDataIndex = 0;
    for (var i = 0; i < fragments.length; i++) {
      var fragmentOffset = fragments[i].offset;
      for (var j = 0; j < fragments[i].length; j++) {
        pixelData[pixelDataIndex++] = bytes[fragmentOffset++];
      }
    }
    //log('read frame #' + frame + " with " + fragments.length + " fragments and " + pixelData.length + " bytes");
    return pixelData;
  }

  /// Returns a [String] with the leading spaces preserved and trailing spaces removed.
  /// Use this function to access the value for attributes with VRs of type UT, ST and LT

  /// Returns a [String] with the leading spaces preserved and trailing spaces removed.
  /// Use this function to access the value for attributes with VRs of type UT, ST and LT
  String getDcmText(int offset, int length) {
    var s = readStringTrimRight(length);
    return ((s != null) && (s != "")) ? s : null;
  }

  String readDcmText(int length) {
    var s = getDcmText(position, length);
    position += length;
    return s;
  }

  /// Get a DICOM Date value from [bytes] at [offset] with [length]
  Date getDate(int offset, int length) {
    var s = getString(offset, length);
    return Date.dcmParse(s);
  }

  Date readDate(int length) {
    var s = getDate(position, length);
    position += length;
    return s;
  }

  /// Get a [List] of DICOM [Date]s from [bytes] at [offset] with [length].
  List<Date> getDateList(int offset, int length) {
    var slist = getStringListTrimRight(offset, length, 2, 14);
    List<Date> dates = new List<Date>(slist.length);
    for (int i = 0; i < slist.length; i++)
      dates[i] = Date.parse(slist[i]);
    return dates;
  }

  /// Read  a [List] of DICOM [Date]s from [bytes] at [offset] with [length].
  List<Date> readDateList(int length) {
    var dates = getDateList(position, length);
    position += length;
    return dates;
  }



  /// Reads and parses a [Date] formatted string (VR = DA).
  /// Returns a [Date] or [null] if not present or not 8 bytes long.
  //TODO This needs to be tested
  DcmDateTime dcmDcmDateTimeFromString(String s) {
    if ((s != null) && (s.length == 8)) {
      var yyyy = int.parse(s.substring(0, 4));
      var MM = int.parse(s.substring(4, 6));
      var dd = int.parse(s.substring(6, 8));
      var hh = int.parse(s.substring(8, 10));
      var mm = (s.length >= 12) ? int.parse(s.substring(10, 12)) : 0;
      var ss = (s.length >= 14) ? int.parse(s.substring(12, 14)) : 0;
      //TODO should read the ".", but we just skip over it for now
      var ffffff = (s.length >= 16) ? int.parse(s.substring(15, 21)) : 0;
      return new DcmDateTime(
          yyyy,
          MM,
          dd,
          hh,
          mm,
          ss,
          ffffff);
    } else {
      warning('bad DcmDateTime format "$s"');
      return null;
    }
  }

  /// Get a DICOM Time value from [bytes] at [offset] with [length]
  DcmDateTime getDcmDcmDateTime(int offset, int length) {
    //TODO what should trim be?
    var s = getStringTrimRight(offset, length);
    return (s != null) ? dcmDcmDateTimeFromString(s) : null;
  }

  DcmDateTime readDcmDcmDateTime(int length) {
    var s = getDcmDcmDateTime(position, length);
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
    var s = getStringTrimRight(offset, length);
    return (s != null) ? dcmTimeFromString(s) : null;
  }

  Time readTime(int length) {
    var s = getTime(position, length);
    position += length;
    return s;
  }

  /// Get a DICOM Time value from [bytes] at [offset] with [length]
  List<Time> getTimeList(int offset, int length) {
    var slist = getStringListTrimRight(offset, length, 2, 14);
    List<Time> times = new List<Time>(slist.length);
    for (int i = 0; i < slist.length; i++)
        times[i] = Time.parse(slist[i]);
    return times;
  }

  Time readTimeList(int length) {
    var times = getTimeList(position, length);
    position += length;
    return times;
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
    var s = getStringTrimRight(offset, length);
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
    var strings = getStringList(offset, length);
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




