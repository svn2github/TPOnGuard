TurboPower OnGuard


Table of contents

1.  Introduction
2.  Package names
3.  Installation
4.  Version history

==============================================


1. Introduction


OnGuard is a library to create demo versions of your Borland Delphi &
C++Builder applications. Ccreate demo versions that are time-limited,
feature-limited, limited to a certain number of uses, or limited to a
certain # of concurrent network users.

This is a source-only release of TurboPower OnGuard. It includes
designtime and runtime packages for Delphi 3 and up and C++Builder
3 through 6.

==============================================

2. Package names


TurboPower OnGuard package names have the following form:

  GNNN_KVV.*
   |  |||
   |  ||+------ VV  VCL version (30=Delphi 3, 40=Delphi 4, 70=Delphi 7)
   |  |+------- K   Kind of package (R=runtime, D=designtime)
   |  +-------- P   Platform (_=VCL, C=CLX, F=FMX, L=Lazarus)
   +----------- NNN Product version number (e.g., 113=version 1.13)


For example, the OnGuard designtime package files for Delphi 7 have
the filename G115_D70.*.

==============================================

3. Installation


To install TurboPower OnGuard into your IDE, take the following steps:

  1. Unzip the release files into a directory (e.g., d:\onguard).

  2. Start Delphi or C++Builder.

  3. Add the source subdirectory (e.g., d:\onguard\source) to the
     IDE's library path.

  4. Open & install the designtime package specific to the IDE being
     used. The IDE should notify you the components have been
     installed.

  5. Make sure the PATH environmental variable contains the directory
     in which the compiled packages (i.e., BPL or DPL files) were
     placed.

==============================================

4. Version history


4.1 Release 1.13

    Enhancements
    -------------------------------------------------------------
    Added support for Delphi 7

4.2 Release 1.14

    Enhancements
    -------------------------------------------------------------
    Added support for Unicode (Delphi 2009 and Delphi 2010)

4.3 Release 1.15

    Enhancements
    -------------------------------------------------------------
    Added packages for Delphi XE, XE2, XE3, XE4, XE5.
    merged changes from SongBeamer.
    merged changes from CLX port.
    merged changes from FPC/Lazarus port.
    added SourceForge feature request 5.
    added SourceForge bug reports 6, 7, 8, and 10.
    added CHM help file
    added HxS help file
    added HTML help files
    added Unit Tests

4.3.1 Release 1.15 r16

    Enhancements
    -------------------------------------------------------------
    added packages for XE6 and XE7
    added XE6 & XE7 in onguard.inc
    confirmed SourceForge bug report 12 is already in place

4.3.2 Github

    Roman Kassebaum forks on GitHub.
    Removed support for all but most current Delphi products.
    No unit tests were kept.
    

4.3.3 Release 1.15 r17

    Enhancements
    -------------------------------------------------------------
    removed code folding "{$REGION}" for Delphi 3-7 support
    confirmed {$IF } ... {$IFEND} usage

4.3.4 Release 1.15 r18

    Enhancements
    -------------------------------------------------------------
    added ogstamp.pas

4.3.5 Release 1.15 r19

    Enhancements
    -------------------------------------------------------------
    added ogcodesign.pas

4.3.6 Release 1.15 r20

    Enhancements
    -------------------------------------------------------------
    split ognetwrk.pas to separate visual/non-visual code, adding ognetwrkutil.pas
    added XE8 in onguard.inc
    added Delphi 10 Seattle in onguard.inc
    added Delphi 10 Seattle packages and group project
    added 64 bit support
    added "bin" folder for storing compiler output
    added UseOgVCL define to enable VCL usage (enabled by default for Delphi)
    added DUnit tests for Delphi 10 Seattle (32 and 64 bit, Windows only)
    fixed XE5 group project and package files
    fixed XE6 group project and package files
    added DUnit tests for Delphi XE6 (32 and 64 bit, Windows only)
    fixed DPK files for Delphi 3-7, 2005-2010, XE-XE4 for new files and structure.
    fixed XE7 group project and package files
    added DUnit tests for Delphi XE7 (32 and 64 bit, Windows only)
    added XE8 group project and package files
    added DUnit tests for Delphi XE8 (32 and 64 bit, Windows only)
    various documentation updates


    Known Issues
    -------------------------------------------------------------
    BCB package files do not have changes for new files and structure.
    Kylix package files do not have changes for new files and structure.
    Lazarus package files do not have changes for new files and structure.
    ogcodesign.pas is not in any package.
    IsFileTampered function does not use the file's stamp.


4.3.7 Release 1.15 r21

    Enhancements
    -------------------------------------------------------------
    added ComponentPlatformsAttribute to define Win32 and Win64 availability for XE2 and up.
    fixed IsExeTampered function
    fixed IsFileTampered function
    removed LibSuffix from Delphi 10 Seattle packages


4.3.8 Release 1.15 r22

    Enhancements
    -------------------------------------------------------------
    fixed Delphi package files, moving ognetwrk and ogproexe back into runtime packages.


4.3.9 Release 1.15 r23

    Enhancements
    -------------------------------------------------------------
    Initial FMX release for Delphi 10 Seattle.
    stole part of FMX Register procedure from Github version (turn about is fair play).
    added G115FR230.bpl
    added G115FD230.bpl
    added G115Common_R230.bpl
    source/fmx folder contains FMX specific files

4.3.10 Release 1.15 r24

    Enhancements
    -------------------------------------------------------------
    clean up extraneous FMX files in source folder

4.3.11 Release 1.15 r25

    Enhancements
    -------------------------------------------------------------
    clean up VCL examples:
    create a project group "Demos"
    set demo projects for 32 bit and 64 bit Windows platform targets
    set demo project output and search paths

4.3.11 Release 1.15 r26

    Enhancements
    -------------------------------------------------------------
    Initial FMX release for Delphi XE8.
    added G115FR220.bpl
    added G115FD220.bpl
    added G115Common_R220.bpl

4.3.12 Release 1.15 r27

    Enhancements
    -------------------------------------------------------------
    missing packages for Delphi 2005, 2006, and 2007
    missing files for XE8

4.3.13 Release 1.15 r28

    Enhancements
    -------------------------------------------------------------
    Initial FMX release for Delphi XE7.
    added G115FR210.bpl
    added G115FD210.bpl
    added G115Common_R210.bpl

4.3.14 Release 1.15 r29

    Enhancements
    -------------------------------------------------------------
    removed fpGUI files
    removed Lazarus packages from Github import
    removed LCL files from Github import
    fixed base files to compile with Lazarus
    added g115commonlr140.lpk
    added g115lr140.lpk
    added g115ld140.lpk
    recreated LCL files from current VCL files
    compiles with Lazarus 1.4.0 on Ubuntu 15.10 64bit.

