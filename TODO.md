# TODO

1, Create an I/O interface to convert
    a. read(String path, String defaultFileType)
    b. write(Dataset ds, DicomMediaType mt)
    
1. Create a program that reads a directory and creates:
    a. A Database of all patients, studies, series, and instances
    b. Organizes each Study as a directory in the form
       studyUid/SeriesUid/instanceUid.dcm
    c. Build a test that finds all the SOP Instance files
       under a directory, places them in a random order and then
       stores them in a VNA in the appropriate place.
       
       
       
1. Create a global object that knows about all file systems.

2. Examples
    - read a file
    - write a file
    - read a study
    - write a study

2. Tools
    - Walk a directory tree and store results in a File System
