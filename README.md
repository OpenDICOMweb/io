# DICOM I/O Library

A library for reading and writing DICOM objects encoded in a
DICOM Media Type. See PS3.18, Section 6.1.1.8.

## Usage

A simple usage example:

    import 'package:io/io.dart';

    main() {
      var awesome = new Awesome();
    }

## Examples

### Types of files by extensoin

    Extension   Type
    .dcm        SOP Instance
    .md         Metadata
    .bd         Bulkdata
    .dcm.json
    .md.json


### SOP Instance Tree

    path format = root / studyUid / seriesUid / instanceUid.dcm ; Sop Instance
                / root / studyUid / seriesUid / instanceUid.md ; instance Metadata
                / root / studyUid / seriesUid / bulkdataUid.bd ; instance Bulkdata

Where, root, studyUid, and SeriesUid are strings naming directories, and instanceUid is a string
naming a file. The studyUid, seriesUid and instancUid are strings containing UIDs.

### SOP Instance Flat

path format = root / studyUid / instanceUid.dcm

Where, root, and studyUid are strings naming directories, and instanceUid is a string
naming a file. The studyUid and instancUid are strings containing UIDs.



### Mint

    path format = root / studyUid / metadataUid.md ; constains study Metadata
                / root / studyUid / bulkdataUid.bd ; contain study Bulkdata
                / root / studyUid / series / metadataUid.md ; constain study & series Metadata
                / root / studyUid / series / bulkdataUid.md ; contains series Bulkdata
                / root / studyUid / seriesUid / instanceUid.dcm ; Sop Instance
                / root / studyUid / seriesUid / instanceUid.md ; instance Metadata
                / root / studyUid / seriesUid / bulkdataUid.bd ; instance Bulkdata

Where, root, and studyUid are strings naming directories, and instanceUid is a string
naming a file. The studyUid and instanceUid are strings containing UIDs.

### Utility Files
TODO: update
    Media Type  Source Code
    dicom       dicomUtils.dart
    dicom+json  dicom_json_utils.dart
    dicom+xml   dicom_xml_utils.dart
    json        json.utils

#### Interface

Create a Path

    String toPath(root, study, [series, instance, extension])

Read a File

    bytes = file.read()
    bytes = file.readSync()

Read a Directory

    stream = directory.read()
    List<Uint8List> = directory.readSync()

Write a File

    void file.write(path, bytes)
    void file writeSync(path, bytes)

Update a File

    void file.update(path, bytes)
    void file updateSync(path, bytes)

Write a Directory

    Sink directory.write(path)
    void directory.writeSync(path, List<UintList>)


## Design

This library implements different file systems:

- SOP File System
- MINT File System

### SOP File System

The SOP File System is designed to be contained within other
file systems. It has a four level structure:

- Root Directory
- Study Directory
- Series Directory
- Instance File

All of the files contain either an Instance, Metadata, or
Bulkdata.

The path to an Instance looks like:

        root/study/series/instance.ext

#### Root Directory

The Root Directory is the path to the root of the File
System.

#### Study Directory

A directory that contains one or more Series Directories,
where each Series belongs to the Study.

The directory name is the Study Instance UID of the Study it
contains.

#### Series Directory

A directory that contains one or more Instance files, where
each file contains an instance that belongs to the Series.
The directory name is the Series Instance UID of the Series it
contains.

#### Instance File

A file that contains a single Instance, Metadata, or
Bulkdata object, encoded in the [media type][MediaType] specified by
the file extension. The file name is the SOP Instance UID of
the Instance it contains.

#### File Extension

A file extension of the Instance File is used to identify
the media type contained in the file.



## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[MediaType]:
    http://dicom.nema.org/medical/dicom/current/output/html/part18.html#sect_6.1.1
[tracker]: http://example.com/issues/replaceme
