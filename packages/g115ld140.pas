{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit g115ld140;

interface

uses
  lcl_onguard5, lcl_onguard7, lcl_onguard6, lcl_ogabout0, lcl_ogreg, 
  LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('lcl_ogreg', @lcl_ogreg.Register);
end;

initialization
  RegisterPackage('g115ld140', @Register);
end.
