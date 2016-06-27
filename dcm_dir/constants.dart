//TODO: copyright
library odw.sdk.dicom.io.dcm_dir.constants;

import 'package:attribute/attribute.dart';

/// A library of compile time constants for handling DICOM Directory data


/// A [Map<int, String>] of [tag]:[keyword] pairs.
const Map<int, String> dcmDirTagToKeywordMap = const {
  0x00041130: "FileSetID",
  0x00041141: "FileSetDescriptorFileID",
  0x00041142: "SpecificCharacterSetOfFileSetDescriptorFile",
  0x00041200: "OffsetOfTheFirstDirectoryRecordOfTheRootDirectoryEntity",
  0x00041202: "OffsetOfTheLastDirectoryRecordOfTheRootDirectoryEntity",
  0x00041212: "FileSetConsistencyFlag",
  0x00041220: "DirectoryRecordSequence",
  0x00041400: "OffsetOfTheNextDirectoryRecord",
  0x00041410: "RecordInUseFlag",
  0x00041420: "OffsetOfReferencedLowerLevelDirectoryEntity",
  0x00041430: "DirectoryRecordType",
  0x00041432: "PrivateRecordUID",
  0x00041500: "ReferencedFileID",
  0x00041504: "MRDRDirectoryRecordOffset",
  0x00041510: "ReferencedSOPClassUIDInFile",
  0x00041511: "ReferencedSOPInstanceUIDInFile",
  0x00041512: "ReferencedTransferSyntaxUIDInFile",
  0x0004151A: "ReferencedRelatedGeneralSOPClassUIDInFile",
  0x00041600: "NumberOfReferences",
};

const Map<String, int> dcmDirKeywordToTag = const {
  "FileSetID": 0x00041130,
  "FileSetDescriptorFileID": 0x00041141,
  "SpecificCharacterSetOfFileSetDescriptorFile": 0x00041142,
  "OffsetOfTheFirstDirectoryRecordOfTheRootDirectoryEntity": 0x00041200,
  "OffsetOfTheLastDirectoryRecordOfTheRootDirectoryEntity": 0x00041202,
  "FileSetConsistencyFlag": 0x00041212,
  "DirectoryRecordSequence": 0x00041220,
  "OffsetOfTheNextDirectoryRecord": 0x00041400,
  "RecordInUseFlag": 0x00041410,
  "OffsetOfReferencedLowerLevelDirectoryEntity": 0x00041420,
  "DirectoryRecordType": 0x00041430,
  "PrivateRecordUID": 0x00041432,
  "ReferencedFileID": 0x00041500,
  "MRDRDirectoryRecordOffset": 0x00041504,
  "ReferencedSOPClassUIDInFile": 0x00041510,
  "ReferencedSOPInstanceUIDInFile": 0x00041511,
  "ReferencedTransferSyntaxUIDInFile": 0x00041512,
  "ReferencedRelatedGeneralSOPClassUIDInFile": 0x0004151A,
  "NumberOfReferences": 0x00041600,
};

const Map<String, String> dcmDirKeywordToTagString = const {
  "FileSetID": "0x00041130",
  "FileSetDescriptorFileID": "0x00041141",
  "SpecificCharacterSetOfFileSetDescriptorFile": "0x00041142",
  "OffsetOfTheFirstDirectoryRecordOfTheRootDirectoryEntity": "0x00041200",
  "OffsetOfTheLastDirectoryRecordOfTheRootDirectoryEntity": "0x00041202",
  "FileSetConsistencyFlag": "0x00041212",
  "DirectoryRecordSequence": "0x00041220",
  "OffsetOfTheNextDirectoryRecord": "0x00041400",
  "RecordInUseFlag": "0x00041410",
  "OffsetOfReferencedLowerLevelDirectoryEntity": "0x00041420",
  "DirectoryRecordType": "0x00041430",
  "PrivateRecordUID": "0x00041432",
  "ReferencedFileID": "0x00041500",
  "MRDRDirectoryRecordOffset": "0x00041504",
  "ReferencedSOPClassUIDInFile": "0x00041510",
  "ReferencedSOPInstanceUIDInFile": "0x00041511",
  "ReferencedTransferSyntaxUIDInFile": "0x00041512",
  "ReferencedRelatedGeneralSOPClassUIDInFile": "0x0004151A",
  "NumberOfReferences": "0x00041600",
};

const List<int> dcmDirTagList = const [
  kFileSetID, // (0004,1130)
  kFileSetDescriptorFileID, // (0004,1141)
  kSpecificCharacterSetOfFileSetDescriptorFile, // (0004,1142)
  kOffsetOfTheFirstDirectoryRecordOfTheRootDirectoryEntity, // (0004,1200)
  kOffsetOfTheLastDirectoryRecordOfTheRootDirectoryEntity, // (0004,1202)
  kFileSetConsistencyFlag, // (0004,1212)
  kDirectoryRecordSequence, // (0004,1220)
  kOffsetOfTheNextDirectoryRecord, // (0004,1400)
  kRecordInUseFlag, // (0004,1410)
  kOffsetOfReferencedLowerLevelDirectoryEntity, // (0004,1420)
  kDirectoryRecordType, // (0004,1430)
  kPrivateRecordUID, // (0004,1432)
  kReferencedFileID, // (0004,1500)
  kMRDRDirectoryRecordOffset, // (0004,1504)
  kReferencedSOPClassUIDInFile, // (0004,1510)
  kReferencedSOPInstanceUIDInFile, // (0004,1511)
  kReferencedTransferSyntaxUIDInFile, // (0004,1512)
  kReferencedRelatedGeneralSOPClassUIDInFile, // (0004,151A)
  kNumberOfReferences, // (0004,1600)
];

/// Returns true if [dcmDirTagList] contains [tag].
bool isValidDcmDirTag(int tag) => dcmDirTagList.contains(tag);

/// A [tag] ordered list of DICOM Directory Keywords.
const List<String> dcmDirKeywordList = const [
    "FileSetID",
    "FileSetDescriptorFileID",
    "SpecificCharacterSetOfFileSetDescriptorFile",
    "OffsetOfTheFirstDirectoryRecordOfTheRootDirectoryEntity",
    "OffsetOfTheLastDirectoryRecordOfTheRootDirectoryEntity",
    "FileSetConsistencyFlag",
    "DirectoryRecordSequence",
    "OffsetOfTheNextDirectoryRecord",
    "RecordInUseFlag",
    "OffsetOfReferencedLowerLevelDirectoryEntity",
    "DirectoryRecordType",
    "PrivateRecordUID",
    "ReferencedFileID",
    "MRDRDirectoryRecordOffset",
    "ReferencedSOPClassUIDInFile",
    "ReferencedSOPInstanceUIDInFile",
    "ReferencedTransferSyntaxUIDInFile",
    "ReferencedRelatedGeneralSOPClassUIDInFile",
    "NumberOfReferences"];

/// Returns true if [dcmDirKeywordList] contains [keyword].
bool isValidDcmDirKeyword(String keyword ) => dcmDirTagList.contains(keyword);
