// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.


import 'dart:typed_data';

import 'package:ascii/ascii.dart';

//TODO: edit comment
/// A library for parsing [Uint8List], aka [ByteArray]
///
/// Supports parsing both BIG_ENDIAN and LITTLE_ENDIAN byte arrays. The default
/// Endianness is the endianness of the host [this] is running on, aka HOST_ENDIAN.
/// All read* methods advance the [position] by the number of bytes read.

//TODO: edit all doc comments below.
class ByteArray {
  /// The Endianness can be set before using
  Endianness endianness = Endianness.LITTLE_ENDIAN;
  final Uint8List bytes;
  final ByteData bd;
  final int start;
  final int length;
  final int end;
  int position;
  int limit;

  /// Constructor
  ByteArray(Uint8List bytes, [start = 0, length])
      : length = (length == null) ? bytes.length : length,
        start = start,
        position = start,
        end = start + length,
        limit = start + length,
        bytes = bytes,
        bd = bytes.buffer.asByteData() {
    if ((start + length) > bytes.lengthInBytes)
      throw "Invalid length ($length)"
          "- ByteArray is only ${bytes.lengthInBytes} long.";
  }

  /// Returns a [new] [ByteArray] [length] bytes long.
  factory ByteArray.ofLength(int length) {
    Uint8List bytes = new Uint8List(length);
    return new ByteArray(bytes,  0, length);
  }

  /// Returns a [new] [ByteArray] with [length = end created from a [ByteBuffer][length] bytes long.
  factory ByteArray.fromBuffer(ByteBuffer buffer, [start = 0, int length]) {
    Uint8List bytes = buffer.asUint8List(start, length);
    return new ByteArray(bytes,  0, bytes.length);
  }

  factory ByteArray.fromBytes(Uint8List bytes, [start = 0, int length]) {
    return new ByteArray(bytes,  0, bytes.length);
  }

  factory ByteArray.view(ByteArray buf, [start = 0, int length]) {
    Uint8List bytes = buf.bytes;
    return new ByteArray(bytes,  0, bytes.length);
  }

  int operator [](int i) => bytes[i];

  void operator []=(int i, int val) {
    bytes[i] = val;
  }

  int get remaining => end - position;

  bool get isEmpty => position >= end;

  bool get isNotEmpty => !isEmpty;

  int seek(int n) {
    checkRange(position, n, 1, "seek");
    return position += n;
  }

  int getLimit(int lengthInBytes) {
    int localLimit = position + lengthInBytes;
    if(localLimit > end) throw "length $lengthInBytes too long";
    return localLimit;
  }

  int checkLength(int offsetInBytes) {
    if (offsetInBytes > end) throw "Offset $offsetInBytes too long";
    return position - offsetInBytes;
  }

  //Flush:? not used
  //TODO add to Warnings
  int checkLimit(int index) => (index >= end) ? end : index;

  void checkRange(int offset, int unitLength, int lengthInBytes, String caller) {
    if ((lengthInBytes ~/ unitLength) != 0)
      throw '$caller: Invalid Length=$lengthInBytes for UnitLength=$unitLength';
    int index = offset + (unitLength * lengthInBytes);
    if(index < start) {
      throw '$caller: position cannot be less than 0';
    }
    if(index > end) {
      throw '$caller: attempt to read past end of buffer';
    }
  }

  /// Returns an unsigned 8-bit [int]. [offset] is an absolute offset
  /// in [bytes].
  int getUint8(int offset) {
    checkRange(offset, 1, 1, "getUint8");
    return bd.getUint8(offset);
  }

  /// Returns an unsigned 8-bit [int] from the current [position]
  /// in [bytes] and increments the [position]  by 1.
  /// Throws an error if [position] is out of range.
  int readUint8() {
    int value = getUint8(position);
    position ++;
    return value;
  }

  /// Returns a [Uint8List] of length [lengthInBytes]. [offset] i
  /// s an absolute offset in [bytes].
  List<int> getUint8List(int offset, int lengthInBytes) {
    checkRange(offset, 1, lengthInBytes, "getUint8List");
    return bytes.buffer.asUint8List(offset, offset + lengthInBytes);
  }

  /// Reads a [Uint8List] of length [lengthInBytes] from the current
  /// [position] in [bytes] and increments the [position] by [lengthInBytes].
  /// Throws an error if [position] is out of range.
  List<int> readUint8List(int lengthInBytes) {
    List<int> value = getUint8List(position, lengthInBytes);
    position += lengthInBytes;
    return value;
  }

  /// [offset] is an absolute offset in the [bytes]. Returns an unsigned 8 bit integer.
  /// Throws an error if [position] is out of reange.
  int getInt8(int offset) {
    checkRange(offset, 1, 1, "Int8");
    return bd.getInt8(offset);
  }

  /// Returns an unsigned 16 bit integer from [this] or throws and error.
  int readInt8() {
    int value = getInt8(position);
    position += 1;
    return value;
  }

  /// Returns an [Int8List] of length [lengthInBytes]. [offset]
  /// is an absolute offset in [bytes].
  List<int> getInt8List(int offset, int lengthInBytes) {
    checkRange(offset, 1, lengthInBytes, "getInt8List");
    return bytes.buffer.asInt8List(offset, offset + lengthInBytes);
  }

  /// Returns an [Int8List] of length [lengthInBytes] from the current
  /// [position] in [bytes] and increments the [position] by [lengthInBytes].
  /// Throws an error if [position] is out of range.
  List<int> readInt8List(int lengthInBytes) {
    List<int> value = getInt8List(position, lengthInBytes);
    position += lengthInBytes;
    return value;
  }

  /// Gets 16 bits at the absolute [offset] in the [bytes]. Returns the unsigned 16
  ///  bit value as an [int].  Throws an error if [position] is out of reange.
  int getUint16(int offset) {
    checkRange(offset, 1, 2, "getUint16");
    return bd.getUint16(offset, endianness);
  }

  /// Reads the 16 bits at the current [position] as an unsigned integer, increments
  /// the position by 2, and returns an [int].  Throws an error if [position] is out
  /// of range.
  int readUint16() {
    int value = getUint16(position);
    position += 2;
    return value;
  }

  /// Returns an [Uint8List] of length [lengthInBytes]. [offset]
  /// is an absolute offset in [bytes].
  List<int> getUint16List(int offset, int lengthInBytes) {
    checkRange(offset, 2, lengthInBytes, "getUint16List");
    return bytes.buffer.asUint16List(offset, offset + lengthInBytes);
  }

  /// Returns an [Uint8List] of length [lengthInBytes] from the current
  /// [position] in [bytes] and increments the [position] by [lengthInBytes].
  /// Throws an error if [position] is out of range.
  List<int> readUint16List(int lengthInBytes) {
    List<int> value = getUint16List(position, lengthInBytes);
    position += lengthInBytes;
    return value;
  }

  /// Returns an signed 16-bit [int] at the absolute [offset] in
  /// [bytes].  Throws an error if [position] is out of range.
  int getInt16(int offset) {
    checkRange(offset, 2, 2, "getInt16");
    return bd.getInt16(offset, endianness);
  }

  /// Returns an signed 16-bit [int] at [position] and increments
  /// the [position] by 2.
  int readInt16() {
    int value = getInt16(position);
    position += 2;
    return value;
  }

  /// Returns an [Int16List] of length [lengthInBytes]. [offset]
  /// is an absolute offset in [bytes].
  List<int> getInt16List(int offset, int lengthInBytes) {
    checkRange(offset, 2, lengthInBytes, "getInt16List");
    return bytes.buffer.asInt16List(offset, offset + lengthInBytes);
  }

  /// Returns an [Int16List] of length [lengthInBytes] from the current
  /// [position] in [bytes] and increments the [position] by [lengthInBytes].
  /// Throws an error if [position] is out of range.
  List<int> readInt16List(int lengthInBytes) {
    List<int> value = getInt16List(position, lengthInBytes);
    position += lengthInBytes;
    return value;
  }

  int getUint32(int offset) {
    checkRange(offset, 1, 4, "Uint32");
    return bd.getUint32(offset, endianness);
  }

  /// Reads a 32 bit unsigned integer from the byte array.
  int readUint32() {
    int value = getUint32(position);
    position += 4;
    return value;
  }

  /// Returns an [Uint32List] of length [lengthInBytes]. [offset]
  /// is an absolute offset in [bytes].
  List<int> getUint32List(int offset, int lengthInBytes) {
    checkRange(offset, 4, lengthInBytes, "getUint32List");
    return bytes.buffer.asUint32List(offset, offset + lengthInBytes);
  }

  /// Returns an [Uint32List] of length [lengthInBytes] from the current
  /// [position] in [bytes] and increments the [position] by [lengthInBytes].
  /// Throws an error if [position] is out of range.
  List<int> readUint32List(int lengthInBytes) {
    List<int> value = getUint32List(position, lengthInBytes);
    position += lengthInBytes;
    return value;
  }

  int getInt32(int offset) {
    checkRange(offset, 4, 4, "Int32");
    return bd.getInt32(offset, endianness);
  }

  /// Reads a 32 bit signed integer from the byte array.
  int readInt32() {
    int value = getInt32(position);
    position += 4;
    return value;
  }

  /// Returns an [Int32List] of length [lengthInBytes]. [offset]
  /// is an absolute offset in [bytes].
  List<int> getInt32List(int offset, int lengthInBytes) {
    checkRange(offset, 4, lengthInBytes, "getInt32List");
    return bytes.buffer.asInt32List(offset, offset + lengthInBytes);
  }

  /// Returns an [Int32List] of length [lengthInBytes] from the current
  /// [position] in [bytes] and increments the [position] by [lengthInBytes].
  /// Throws an error if [position] is out of range.
  List<int> readInt32List(int lengthInBytes) {
    List<int> value = getUint32List(position, lengthInBytes);
    position += lengthInBytes;
    return value;
  }

  int getUint64(int offset) {
    checkRange(offset, 8, 8, "Uint64");
    return bd.getUint64(offset, endianness);
  }

  /// Reads a 32 bit unsigned integer from the byte array.
  int readUint64() {
    int value = getUint64(position);
    position += 8;
    return value;
  }

  /// Returns an [Uint64List] of length [lengthInBytes]. [offset]
  /// is an absolute offset in [bytes].
  List<int> getUint64List(int offset, int lengthInBytes) {
    checkRange(offset, 8, lengthInBytes, "getUint64List");
    return bytes.buffer.asUint64List(offset, offset + lengthInBytes);
  }

  /// Returns an [Uint64List] of length [lengthInBytes] from the current
  /// [position] in [bytes] and increments the [position] by [lengthInBytes].
  /// Throws an error if [position] is out of range.
  List<int> readUint64List(int lengthInBytes) {
    List<int> value = getUint64List(position, lengthInBytes);
    position += lengthInBytes;
    return value;
  }

  int getInt64(int offset) {
    checkRange(offset, 8, 8, "Int64");
    return bd.getInt64(offset, endianness);
  }

  /// Reads a 32 bit signed integer from the byte array.
  int readInt64() {
    int value = getInt64(position);
    position += 8;
    return value;
  }

  /// Returns an [Int64List] of length [lengthInBytes]. [offset]
  /// is an absolute offset in [bytes].
  List<int> getInt64List(int offset, int lengthInBytes) {
    checkRange(offset, 8, lengthInBytes, "getInt64List");
    return bytes.buffer.asInt64List(offset, offset + lengthInBytes);
  }

  /// Returns an [Int64List] of length [lengthInBytes] from the current
  /// [position] in [bytes] and increments the [position] by [lengthInBytes].
  /// Throws an error if [position] is out of range.
  List<int> readInt64List(int lengthInBytes) {
    List<int> value = getInt64List(position, lengthInBytes);
    position += lengthInBytes;
    return value;
  }

  double getFloat32(int offset) {
    checkRange(offset, 4, 4, "Float32");
    return bd.getFloat32(offset, endianness);
  }

  /// Synonym for getFloat32
  double getFLoat(int offset) => getFloat32(offset);

  /// Reads a 32 bit floating point number from the byte array.
  double readFloat32() {
    double value = getFloat32(position);
    position += 4;
    return value;
  }

  /// Synonym for readFloat32
  double readFloat() => readFloat32();

  /// Returns an [Float32List] of length [lengthInBytes]. [offset]
  /// is an absolute offset in [bytes].
  List<double> getFloat32List(int offset, int lengthInBytes) {
    checkRange(offset, 4, lengthInBytes, "getFloat32List");
    return bytes.buffer.asFloat32List(offset, offset + lengthInBytes);
  }

  /// Returns an [Float32List] of length [lengthInBytes] from the current
  /// [position] in [bytes] and increments the [position] by [lengthInBytes].
  /// Throws an error if [position] is out of range.
  List<double> readFloat32List(int lengthInBytes) {
    List<double> value = getFloat32List(position, lengthInBytes);
    position += lengthInBytes;
    return value;
  }

  /// Synonym for readFloat32List
  List<double> readFloatList(int lengthInBytes) =>
      readFloat32List(lengthInBytes);

  double getFloat64(int offset) {
    checkRange(offset, 8, 8, "Float64");
    return bd.getFloat64(offset, endianness);
  }

  /// Reads a 64 bit floating point number from the byte array.
  double readFloat64() {
    double value = getFloat64(position);
    position += 8;
    return value;
  }

  /// Synonym for readFloat64
  double readDouble() => readFloat64();

  /// Returns an [Float64List] of length [lengthInBytes]. [offset]
  /// is an absolute offset in [bytes].
  List<double> getFloat64List(int offset, int lengthInBytes) {
    checkRange(offset, 8, lengthInBytes, "getFloat64List");
    return bytes.buffer.asFloat64List(offset, offset + lengthInBytes);
  }

  /// Returns an [Float64List] of length [lengthInBytes] from the current
  /// [position] in [bytes] and increments the [position] by [lengthInBytes].
  /// Throws an error if [position] is out of range.
  List<double> readFloat64List(int lengthInBytes) {
    List<double> value = getFloat64List(position, lengthInBytes);
    position += lengthInBytes;
    return value;
  }

  /// Synonym for readFloat32List
  List<double> readDoubleList(int lengthInBytes) =>
      readFloat64List(lengthInBytes);

  //TODO: Isn't there a faster way to do this? Should string trimming be done here?
  /*
  String getFixedString(int offset, int length) {
    checkRange(offset, length, 1, "FixedString");
    //var result = "";
    for(int i = offset; i < offset + length; i++) {
      int byte = bytes[i];
      if((byte == 0) || (byte == kBackslash)) {
        Uint8List charCodes = bytes.buffer.asUint8List(offset, i - offset);
        String s = new String.fromCharCodes(charCodes);
        //print('getFixedString1:"$s"');
        return s.trimRight();
      }
    }
    Uint8List charCodes = bytes.buffer.asUint8List(offset, length);
    String s = new String.fromCharCodes(charCodes);
    //print('getFixedString2:"$s"');
    return s.trimRight();
  }
  */
  //Enhancement: Which is better [getFixedString] or [getFixedString1]?  Does it matter?
  String getString(int offset, int length) {
    checkRange(offset, length, 1, "getString");
    Uint8List charCodes = bytes.buffer.asUint8List(offset, length);
    var s = new String.fromCharCodes(charCodes);
    if ((s.codeUnitAt(length - 1) == kSpace) || (s.codeUnitAt(length - 1) == kNull))
      return s.substring(0, length - 1);
    return s;
  }

  /// Reads a string of 8 bit characters from the byte array.
  String readString(int length) {
    String s = getString(position, length);
    position += length;
    return s;
  }

  List<String> getStringList(int offset, int length) {
    var s = getString(offset, length);
    return s.split(r'\');
  }

  /// Reads a [List] of [String]s from the byte array.
  /// The backslash (reverse solidus) characters separates
  /// the [String]s.
  List<String> readStringList(int length) {
    var list = getStringList(position, length);
    position += length;
    return list;
  }
}




