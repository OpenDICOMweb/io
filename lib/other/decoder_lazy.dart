// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.
library odw.sdk.base.io.decoder_lazy;

import 'dart:collection';
import 'dart:core' hide DateTime;
import 'dart:typed_data';


typedef AttrReader([int limit]);

/// A DICOM Part 10 File Format Decoder
/// A Decoder takes a [ByteBuffer] and returns a DICOM Dataset
class  Decoder implements Maps {
  final bool isExplicit;
  AttrReader reader;
  ByteArray buf;
  Map<int, AttributeBase> attributes = {};
  List<String> warnings = [];

//****  Constructors  ****
//TODO determine which are really neaded
  Decoder(Uint8List bytes, [this.isExplicit = true]) {
    _init(bytes, isExplicit, 0, bytes.length);
  }

  Decoder.fromByteArray(this.buf,
      [bool this.isExplicit = true]) {
    _init(buf.bytes, isExplicit, buf.start, buf.limit);
  }

  Decoder.fromBuffer(ByteBuffer buffer,
      [this.isExplicit = true, int start = 0, int length]) {
    _init(buffer.asUint8List(), isExplicit, start, length);
  }

  Decoder.fromUint8List(Uint8List bytes,
      [this.isExplicit = true, int start = 0, int length]) {
    _init(bytes, isExplicit, start, length);
  }

  Decoder.view(Uint8List bytes,
      [this.isExplicit = true, int start = 0, int length]) {
    _init(bytes, isExplicit, start, length);
  }

  void _init(Uint8List bytes, bool isExplicit, int start, int length) {
    if(start == null) start = 0;
    if(length == null) length = bytes.lengthInBytes;
    reader = (isExplicit) ? readExplicit : readImplicit;
    buf = new ByteArray.fromUint8List(bytes, start, length);
  }

//****  Maps primitives  ****
  AttributeBase operator [](int tag) => attributes[tag];

  void operator []=(int tag, AttributeBase value) {
    attributes[tag] = value;
  }

  Iterable<int> get keys => attributes.keys;

  void clear() => attributes.clear();

  AttributeBase remove(int key) => attributes.remove(key);

  //****  Static Entry Point  ****
  /// Reads an explicit type set.
  static Decoder read(ByteArray buf, [bool isExplicit = true]) {
    var ds = new Decoder.fromByteArray(buf, isExplicit);
    while(buf.isNotEmpty) {
      //print('buf remaining = ${buf.limit - buf.position}');
      var attribute = ds.reader(buf.limit);
      ds[attribute.tag] = attribute;
    }
    return ds;
  }

  //****  Core Decoder methods  ****
  /// Peek at next tag - doesn't move the [ByteArray.position]
  int _peekTag() {
    int group = buf.getUint16(buf.position);
    int attribute = buf.getUint16(buf.position + 2);
    //print('grp=$group, elt=$attribute');
    return (group << 16) + attribute;
  }

  /// Read the DICOM Attribute Tag
  int _readTag() {
    int group = buf.readUint16();
    int attribute = buf.readUint16();
    return (group << 16) + attribute;
  }

  //****  Explicit VR Attribute Reader  ****
  //****  Decoder for Attributes with Explicit Value Representations  ****
  /// Read an [Attribute] from the [ByteArray] containing a model with Explicit VRs.
  /// Read an [Attribute] with an *Explicit* VR from [buf] [ByteArray].
  AttributeBase readExplicit([int limit]) {

    /// Read a Value Representation Code (VR). See PS3.10.
    int _readVR() {
      int c1 = buf.readUint8();
      int c2 = buf.readUint8();
      int vrCode = c2 + (c1 << 8);
      return vrCode;
    }

    /// Read Value Field length
    /// Note: This is always an even number, but the last byte might be
    /// padding.  See DICOM PS3.5.
    int _readVFLength(int vr) {
      int sizeInBytes = getExplicitVFSize(vr);
      //print('vrSizeInBytes= $sizeInBytes');
      if(sizeInBytes == 4) {
        buf.seek(2);
        return buf.readUint32();
      } else {
        return buf.readUint16();
      }
    }

//print('rEE: limit=$limit');
// [tag], [vr], [length], and [offset] must be read in this order.
    int tag = _readTag();
    int vr = _readVR();
    int length = _readVFLength(vr);
    int offset = buf.position;
//print('tag=${tagToDicom(tag)}, vr= ${vrToString[vr]}, len=$length, off=$offset');
    if(vr == VR.kSQ) {
      if(hasUndefinedLength(length)) {
        return _readSQUndefinedLength(tag, offset);
      } else {
        int limit = buf.getLimit(length);
        return _readSQ(tag, offset, length, limit);
      }
    } else {
      if(hasUndefinedLength(length)) {
//TODO verify that this list is correct.
// vr = OB, OD, OF, OW, UN, UR, or UT (Not SQ or Item)
        print('rEE.UndefinedLength: tag=${tagToDcmFmt(tag)}, vrAsciiToString[vr], len=$length ');
        length = _findItemDelimitationItemAndReturnLength(offset, tag);
      } else {
        buf.seek(length);
      }
      var attribute = new AttributeBase(tag, vr, offset, length);
      print('readAttributeExplicit: $attribute');
      return attribute;
    }
  }

//****  Explicit VR Attribute Reader  ****
//****  Decoder for Datasets with Explicit Value Representations  ****
  /// Read an [Attribute] with an *Implicit* VR from [buf].
  AttributeBase readImplicit([int limit]) {
    int _readVFImplicitLength() => buf.readUint32();

//print('rEI: limit=$limit');
// [tag], [length], and [offset] must be read in this order.
    int tag = _readTag();
    int length = _readVFImplicitLength();
    int offset = buf.position;

    if(_peekTag() == kItem) {
// Peek at the next tag to see if it is an item tag.  If so, this is a sequence.
// This is not 100% safe because a non sequence item could have type that has
// these bytes, but this is how to do it without a type dictionary.
// Parse the sequence.
      if(hasUndefinedLength(length)) {
        return _readSQUndefinedLength(tag, offset);
      } else {
        int limit = buf.getLimit(length);
        return _readSQ(tag, offset, length, limit);
      }
    } else {
      if(hasUndefinedLength(length)) {
// vr = OB, OD, OF, OW, UN, UR, or UT (Not SQ or Item)
        length = _findItemDelimitationItemAndReturnLength(offset, tag);
      }
      buf.seek(length);
      var attribute = new Attribute(tag, -1, offset, length);
//print(attribute);
      return attribute;
    }
  }

//****  Helper Methods for Reader  ****
  /// Read a [Sequence] with *Known Length*.
  SQ _readSQ(int tag, int offset, int length, int limit) {
    print('rSQ: ${tagToDcmFmt(tag)}, off=$offset, len=$length, limit=$limit');
    List<Item> items = [];
    while(buf.position < limit) {
      Item item = _readItem();
      items.add(item);
    }
    SQ sq = new SQ(tag, VR.kSQ, offset, length, false, items);
    sq.debug();
    return sq;
  }

  /// Read a [Sequence] with *Undefined Length*, i.e. [SQ.length] == -1.
  SQ _readSQUndefinedLength(int tag, int offset) {
    print('rSQUL: ${tagToDcmFmt(tag)}, off=$offset');
    var length;
    List<Item> items = [];
    while(buf.isNotEmpty) {
      Item item = _readItem();
      if(item.tag == $sequenceDelimitationItem) {
// This is the *Sequence Delimitation Item*, get the [sequence] length
// and return the [Sequence].
        length = buf.checkLength(item.offset);
        return new SQ(tag, VR.kSQ, offset, length, true, items);
      } else {
        items.add(item);
      }
    }
// eof encountered - log a warning and return a [SQ]
// with [length] based on the [buf.limit].
    warning(
        'eof encountered before finding "SequenceDelimitationItem" '
            'in [SQ] of "Undefined Length" with tag=$tag');
    buf.position = buf.limit;
    length = buf.checkLength(offset);
    var sq = new SQ(tag, VRk.SQ, offset, length, true, items);
    sq.debug();
    return sq;
  }

//TODO this can be moved to Dataset_base if we abstract
// DatasetExplicit & readAttributeExplicit
  Item _readItem() {
    var item = _readItemHeader();
//print('rItem: $item');
    if(item.length == 0) return item;
    item.dataset = new Dataset();
    while(buf.position < item.limit) {
//print('pos=${buf.position}, limit=${item.limit}');
      var attribute = attributeReader(item.limit);
      item.dataset[attribute.tag] = attribute;
      if(attribute.tag == kItemDelimitationItem) {
        if(item.hadUndefinedLength) {
// The item delimiter tag marks the end of this [Item].  Set the length and return.
          item.length = buf.checkLength(item.offset - 8);
//print('rIE2:$item');
          return item;
        } else {
          throw "Encountered item delimiter in Item with explicit length";
        }
      }
      if(item.hadUndefinedLength) {
        warning('eof encountered before finding item delimeter in item of undefined length');
      }
    }
    print('readItem: $item');
    return item;
  }

  /// [Item]s have a Uint32 length field.
  int _readItemLength() => buf.readUint32();

  /// Reads the tag and length of a sequence item and returns them as an object
  ///  with the following properties:
  ///     1. The item tag,
  ///     2. The length: the number of bytes in this item or 4294967295 if undefined,
  ///     3. The offset into the byteStream of the type for this item
  Item _readItemHeader() {
    int tag = _readTag();
//print('tag=${tagToDicom(tag)}');
    if(tag != $item) readError('Expected Item, but received tag =$tag instead');
    int length = _readItemLength();
    int offset = buf.position;
    bool hadUndefinedLength = (hasUndefinedLength(length)) ? true : false;
    var item = new Item(tag, offset, length, hadUndefinedLength);
    print('readItemHeader: $item');
    return item;
  }

  static const $itemDelimitationFirst16Bits = 0xfffe;
  static const $itemDelimitationSecond16Bits = 0xe00d;

  /// Returns the [Attribute.length] of an [Attribute] or [Item] with undefined length.
  /// The [Attribute.length] does not including the [$itemDelimitationItem] or the
  /// [$itemDelimitationItem] length field, which should be zero.
  int _findItemDelimitationItemAndReturnLength(int offset, int tag) {
    var maxPosition = buf.limit - $itemDelimitationItemLength;
    print('findItemDelimitationItem: pos=${buf.position}, max=$maxPosition');
    while(buf.position < maxPosition) {
      int groupNumber = buf.readUint16();
      if(groupNumber == $itemDelimitationFirst16Bits) {
//print('group=${groupNumber.toRadixString(16)}');
        int attributeNumber = buf.readUint16();
        if(attributeNumber == $itemDelimitationSecond16Bits) {
//print('attribute=${attributeNumber.toRadixString(16)}');
          int length = (buf.position - 4) - offset;
          int itemDelimiterLength = buf.readUint32(); // the length
          if(itemDelimiterLength != 0) {
            warning('encountered non zero length following item delimeter at position'
                ' ${buf.position} while reading attribute of undefined length with tag = $tag');
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
    buf.position = buf.limit;
    return buf.limit - offset;
  }

//TODO this method has not been tested
  readEncapsulatedPixelData(Dataset dataset, frame) {
//print('Read Pixel Data $model, frame=$frame');
    if(dataset == null) {
      throw "dicomParser.readEncapsulatedPixelData: missing required parameter 'dataSet'";
    }
    if(frame == null) {
      throw "dicomParser.readEncapsulatedPixelData: missing required parameter 'frame'";
    }
    var pixelAttribute = dataset.attributes[0x7fe00010];
    if(pixelAttribute == null) {
      throw "readEncapsulatedPixelData: pixel type attribute x7fe00010 not present";
    }
// seek to the beginning of the encapsulated pixel type and read the basic offset table
    var ds = new Dataset.fromByteArray(buf);
    buf.seek(pixelAttribute.offset);
    var basicOffsetTable = _readItemHeader();
    if(basicOffsetTable.tag != 'xfffee000') {
      throw "readEncapsulatedPixelData: missing basic offset table xfffee000";
    }
// now that we know how many frames we have validate the frame parameter
    var numFrames = basicOffsetTable.length / 4;
    if(frame > numFrames - 1) {
      throw
      "readEncapsulatedPixelData: parameter frame exceeds number of frames in basic offset table";
    }
// read all the frame offsets
    var frameOffsets = [];
    for(var frameOffsetNum = 0; frameOffsetNum < numFrames; frameOffsetNum++) {
      var frameOffset = buf.readUint32();
      frameOffsets.add(frameOffset);
    }
// now read the frame
    var baseOffset = buf.position;
    var pixelData = readFrame(baseOffset, frameOffsets, frame);
    return pixelData;
  }

//TODO this method has not been tested
  readFrame(int baseOffset, List<int> frameOffsets, frame) {
    if(frame >= frameOffsets.length) {
      throw 'readFrame: parameter frame refers to frame not in frameOffsets';
    }

// position the byteStream at the beginning of this frame
    var frameOffset = frameOffsets[frame];
    buf.position = baseOffset + frameOffset;

// calculate the next frame offset so we know when to stop reading this frame
    var nextFrameOffset = buf.limit;
    if(frame < frameOffsets.length - 1) nextFrameOffset = frameOffsets[frame + 1];

// read all fragments for this frame
    var fragments = [];
    var frameSize = 0;
    while(buf.position < nextFrameOffset) {
      var fragment = _readItemHeader();
      if(fragment.tag == 'xfffee0dd') break;
      fragments.add(fragment);
      frameSize += fragment.length;
      buf.seek(fragment.length);
    }

// if there is only one fragment, return a view on this array to avoid copying
    if(fragments.length == 1) {
      return new Uint8List.view(fragments[0].offset, fragments[0].length);
    }

// copy all of the type from the fragments into the pixelData
    var pixelData = new Uint8List(frameSize);
    var pixelDataIndex = 0;
    for(var i = 0; i < fragments.length; i++) {
      var fragmentOffset = fragments[i].offset;
      for(var j = 0; j < fragments[i].length; j++) {
        pixelData[pixelDataIndex++] = buf.bytes[fragmentOffset++];
      }
    }

//console.log('read frame #' + frame + " with " + fragments.length + " fragments and " + pixelData.length + " bytes");
    return pixelData;
  }

//****  Parser for [Attribute] values  ****
  /// Finds the attribute associated with [tag], where [tag] is an int and returns
  /// an unsigned int 16 if it exists and has type.  [index] is the index of a
  /// multi-valued attribute.  The default index 0 if not supplied.  Returns the 16 bit
  /// unsigned integer value as an [int] or null if the attribute is not present or
  /// has type of length 0.
  int uint16(int tag, [int index = 0]) {
    var attribute = attributes[tag];
    if((attribute != null) && (attribute.length != 0)) {
      return buf.getUint16(attribute.offset + (index * 2));
    }
    return null;
  }

  /// Finds the attribute for tag and returns the signed 16 bit integer if it exists
  /// and has a value. Returns null if the tag is not contained in [this] or if its
  /// length is 0.
  int int16(tag, [index = 0]) {
    var attribute = attributes[tag];
//index = (index != null) ? index : 0;
    if(attribute && attribute.length != 0) {
      return buf.getInt16(attribute.offset + (index * 2));
    }
    return null;
  }

  /// Finds the [attribute] associated with [tag].  Returns a 32 bit unsigned integer,
  /// if it exists and has a value; otherwise, returns [null]
  int uint32(tag, [index = 0]) {
    var attribute = this.attributes[tag];
    if((attribute != null) && (attribute.length != 0)) {
      int offset = attribute.offset + (index * 4);
//print('offset=$offset');
      return buf.getUint32(offset);
    }
    return null;
  }

  /// Finds the attribute for tag and returns a 32 bit signed integer if it exists
  /// and has type [index] defaults to 0 if not supplied. Returns an [int] with
  /// th value of the [int32] or null if the attribute is not present or has
  /// value of length 0.
  int int32(int tag, [int index = 0]) {
    var attribute = this.attributes[tag];
    if((attribute != null) && (attribute.length != 0)) {
      return buf.getInt32(attribute.offset + (index * 4));
    }
    return null;
  }

  /// Finds the attribute for tag and returns a 32 bit floating point number (VR=FL)
  /// if it exists and has a value.  [index] defaults to 0 if not supplied. Returns
  /// a [double] with the value of the [float32] or null if the attribute is not
  /// present or has value of length 0.
  double float32(int tag, [int index = 0]) {
    var attribute = attributes[tag];
    if((attribute != null) && (attribute.length != 0)) {
      return buf.getFloat32(attribute.offset + (index * 4));
    }
    return null;
  }

  /// A synonm for [float32].
  double float(int tag, [int index = 0]) => float32(tag, index);

  /// Finds the [attribute] with [tag] and returns a 64 bit floating point number
  /// (VR=FD) if it exists and has a value; otherwise, returns null if the attribute
  /// is not present or has a length of 0.  [index] defaults to 0 if not supplied.
  double float64(int tag, [int index = 0]) {
    var attribute = attributes[tag];
    if((attribute != null) && (attribute.length != 0)) {
      return buf.getFloat64(attribute.offset + (index * 8));
    }
    return null;
  }

  /// Returns the [int] number of string values contained in the attribute
  /// or null if the attribute is not present or has zero length value.
  int numStringValues(tag) {
//final backslash = new RegExp(r'\\');
    var attribute = this.attributes[tag];
    if((attribute != null) && (attribute.length > 0)) {
//print('NumStringValues: attribute=$attribute');
      var charCodes = buf.bytes.buffer.asUint8List(attribute.offset, attribute.length);
      var s = new String.fromCharCodes(charCodes);
      List<String> list = s.split(r'\');
//print('NumStringValues=$list');
      return list.length;
    }
    return null;
  }

  /// Returns the [attribute]'s value as a [String].  If [index] is provided,
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
  string(int tag, [int index = 0]) {
    var attribute = attributes[tag];
    if(attribute != null) {
      if(attribute.length == 0) return "";
//print('string: attribute=$attribute');
      var bytes = buf.bytes.buffer.asUint8List(attribute.offset, attribute.length);
      int char = bytes[bytes.length - 1];
//print('string: char="$char"');
      if(char == kNul)
        bytes = buf.bytes.buffer.asUint8List(attribute.offset, attribute.length - 1);
      var s = new String.fromCharCodes(bytes);

//print('fixedString="$s"');
      if(index >= 0) {
        List<String> values = s.split(r'\');
        for(String s in values) {
//TODO sometimes this should only be TrimRight.
          var y = s.trim();
//print('val="$s", trim="$y"');
        }
// trim leading and trailing spaces
//TODO verify that this returns [null] if index is too big
        var value = values[index];
//var v = value[1].codeUnitAt(0);
//print('trailing="$v"');
        var x = value.trim();
        return x;
      } else {
//print('fixedString="$s"');
// trim leading and trailing spaces
        return s.trim();
      }
    }
    return null;
  }

  /// Returns a [String] with the leading spaces preserved and trailing spaces removed.
  /// Use this function to access the value for attributes with VRs of type UT, ST and LT
  String text(tag, [index = 0]) {
    var attribute = this.attributes[tag];
    if((attribute != null) && (attribute.length != 0)) {
      var charCodes = new Uint8List.view(buf.bytes.buffer, attribute.offset, attribute.length);
      var fixedString = new String.fromCharCodes(charCodes);
      var s = (index >= 0) ? fixedString.split(r'\')[index] : fixedString;
      return s.trimRight();
    }
    return null;
  }

  /// Parses a string to a float for the specified index in a multi-valued attribute.
  /// If index is not specified, the first value in a multi-valued VR will be parsed
  /// if present. Returns a floating point number or null if not present or if index
  /// exceeds the number of values in the attribute.
  double floatString(int tag, [int index = 0]) {
    var attribute = attributes[tag];
//print('floatString: $attribute');
    if((attribute != null) && (attribute.length != 0)) {
      var value = string(tag, index);
//print('floatString:value=$value');
      if(value != null) {
        double d = double.parse(value);
//print('Double=$d');
        return d;
      }
    }
    return null;
  }

  /// Parses a [String] to an [int] for the specified [index] in a multi-valued
  /// attribute. If [index] is not specified, it defaults to 0, and the first value
  /// in a multi-valued VR will be returned if present.  Returns [null] if not
  ///  present or if the [index] exceeds the number of values in the attribute.
  int intString(int tag, [int index = 0]) {
    var attribute = attributes[tag];
    if((attribute != null) && (attribute.length != 0)) {
//index = (index != null) ? index : 0;
      var value = string(tag, index);
      if(value != null) return int.parse(value);
    }
    return null;
  }

  /// Reads and parses a [Date] formatted string (VR = DA).
  /// Returns a [Date] or [null] if not present or not 8 bytes long.
//TODO verify that date MUST be 8 bytes long?
  Date date(tag) {
    var value = string(tag);
    if((value != null) && (value.length == 8)) {
      int yyyy = int.parse(value.substring(0, 4));
      int mm = int.parse(value.substring(4, 6));
      int dd = int.parse(value.substring(6, 8));
      return new Date(yyyy, mm, dd);
    }
    warning('bad Date format "$value" for tag=$tag');
    return null;
  }

  /// Reads and parses a [Date] formatted string (VR = DA).
  /// Returns a [Date] or [null] if not present or not 8 bytes long.
//TODO This needs to be tested
  DateTime dateTime(tag) {
    var value = string(tag);
    if((value != null) && (value.length == 8)) {
      var yyyy = int.parse(value.substring(0, 4));
      var MM = int.parse(value.substring(4, 6));
      var dd = int.parse(value.substring(6, 8));
      var hh = int.parse(value.substring(8, 10));
      var mm = (value.length >= 12) ? int.parse(value.substring(10, 12)) : 0;
      var ss = (value.length >= 14) ? int.parse(value.substring(12, 14)) : 0;
//TODO should read the ".", but we just skip over it for now
      var ffffff = (value.length >= 16) ? int.parse(value.substring(15, 21)) : 0;
      return new DateTime(new Date(yyyy, MM, dd), new Time(hh, mm, ss, ffffff));
    }
    warning('bad DateTime format "$value" for tag=$tag');
    return null;
  }

  /// Parses a [String] with format (VR = TM) HHMMSS.FFFFFF into a [Time].
  /// Returns a [Time] with hours, minutes, seconds and fractionalSeconds
  /// or [null] if not present or does not have a length of 2.
  Time time(tag) {
    var value = string(tag);
    if((value != null) && (value.length >= 2)) {
      // must at least have HH
      var hh = int.parse(value.substring(0, 2));
      var mm = value.length >= 4 ? int.parse(value.substring(2, 4)) : 0;
      var ss = value.length >= 6 ? int.parse(value.substring(4, 6)) : 0;
//TODO should read the ".", but we just skip over it for now
      var ffffff = value.length >= 8 ? int.parse(value.substring(7, 13)) : 0;
      return new Time(hh, mm, ss, ffffff);
    }
    warning('bad Time format "$value" for tag=$tag');
    return null;
  }

  /// Parses a [String formatted as a Person Name (VR = PN) into a [PersonName].
  /// Returns a [PersonName] or [null] if the attribute is not present or has a
  /// value length of 0.
  PersonName personName(int tag, [int index = 0]) {
    var stringValue = string(tag, index);
    if(stringValue != null) {
      var stringValues = stringValue.split('^');
      var familyName = stringValues[0];
      var givenName = stringValues[1];
      var middleName = stringValues[2];
      var prefix = stringValues[3];
      var suffix = stringValues[4];
      return new PersonName(familyName, givenName, middleName, prefix, suffix);
    }
    return null;
  }

  /// Add a warning string to the [List<String>] of [warnings] associated with the [Dataset].
  void warning(String s) {
    print(s);
    warnings.add(s);
  }

  /// Formats the [Dataset] into a nested structure for [SQs] and [Items].
  void format(Formatter fmt) {
    fmt.writeLn('Dataset:[');
    fmt.indent();
    attributes.forEach((int tag, Attribute a) {
      a.format(fmt);
    });
    fmt.outdent();
    fmt.writeLn(']');
  }

}
