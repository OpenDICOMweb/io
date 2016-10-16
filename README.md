# DICOM I/O Library

A library for reading and writing DICOM objects.

## Usage

A simple usage example:

    import 'package:io3/io3.dart';

    main() {
      var awesome = new Awesome();
    }

## Examples

### Types of files by extensoin

    Extension   Type
    .dcm        SOP Instance
    .md         Metadata
    .bd         Bulkdata


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
naming a file. The studyUid and instancUid are strings containing UIDs.

### Utility Files

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

Write a Directory

    Sink directory.write(path)
    void directory.writeSync(path, List<UintList>)
   
    
## Design

The libary is designed to support different file organizations:

- SOP_Flat: All the files are in one directory specified by the 
[_StudyInstanceUID].  Each file contains a single SOP Instance

- Structured: All the files are


## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[StudyInstanceUID]
[tracker]: http://example.com/issues/replaceme
