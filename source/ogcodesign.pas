(* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is Andrew Haines
 *
 * The Initial Developer of the Original Code is
 * Andrew Haines
 *
 * Portions created by the Initial Developer are Copyright (C) 2015
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * Andrew Haines         andrew@haines.name                        {AH.01}
 *                       February 22 2015
 *                       based on snippets from stackoverflow by
 *                         Craig Peterson
 *                         TOndrej
 *
 *
 *
 * ***** END LICENSE BLOCK ***** *)
{*********************************************************}
{*                  OGPROEXE.PAS 1.15                    *}
{*     Copyright (c) 1996-02 TurboPower Software Co      *}
{*                 All rights reserved.                  *}
{*********************************************************}

{$I onguard.inc}


{$IFDEF FPC}
{$mode delphi}{$H+}
{$ASMMODE INTEL}
{$ENDIF}
unit ogcodesign;

{$IFDEF Win16}{$MESSAGE WARN 'Win16 not supported.'}{$ENDIF}
{$IFDEF KYLIX}{$MESSAGE WARN 'Kylix not supported.'}{$ENDIF}
{$IFDEF LINUX}{$MESSAGE WARN 'Linux not supported.'}{$ENDIF}
{$IFDEF FREESBD}{$MESSAGE WARN 'FreeBSD not supported.'}{$ENDIF}
{$IFDEF ANDROID}{$MESSAGE WARN 'Android not supported.'}{$ENDIF}
{$IFDEF IOS}{$MESSAGE WARN 'IOS not supported.'}{$ENDIF}
{$IFDEF MACOS}{$MESSAGE WARN 'Mac OSX not supported.'}{$ENDIF}

interface

{$IFDEF MSWINDOWS}

uses Windows;

// Imagehlp.dll
const
  CERT_SECTION_TYPE_ANY = $FF;      // Any Certificate type

function ImageEnumerateCertificates(FileHandle: THandle; TypeFilter: WORD; out CertificateCount: DWORD; Indicies: PDWORD; IndexCount: Integer): BOOL; stdcall; external 'Imagehlp.dll';
function ImageGetCertificateHeader(FileHandle: THandle; CertificateIndex: Integer; var CertificateHeader: TWinCertificate): BOOL; stdcall; external 'Imagehlp.dll';
function ImageGetCertificateData(FileHandle: THandle; CertificateIndex: Integer; Certificate: PWinCertificate; var RequiredLength: DWORD): BOOL; stdcall; external 'Imagehlp.dll';

// Crypt32.dll
const
  CERT_NAME_SIMPLE_DISPLAY_TYPE = 4;
  PKCS_7_ASN_ENCODING = $00010000;
  X509_ASN_ENCODING = $00000001;

type
  PCCERT_CONTEXT = type Pointer;
  HCRYPTPROV_LEGACY = type Pointer;
  PFN_CRYPT_GET_SIGNER_CERTIFICATE = type Pointer;

  CRYPT_VERIFY_MESSAGE_PARA = record
    cbSize: DWORD;
    dwMsgAndCertEncodingType: DWORD;
    hCryptProv: HCRYPTPROV_LEGACY;
    pfnGetSignerCertificate: PFN_CRYPT_GET_SIGNER_CERTIFICATE;
    pvGetArg: Pointer;
  end;

function CryptVerifyMessageSignature(const pVerifyPara: CRYPT_VERIFY_MESSAGE_PARA; dwSignerIndex: DWORD; pbSignedBlob: PByte; cbSignedBlob: DWORD; pbDecoded: PBYTE; pcbDecoded: PDWORD; ppSignerCert: PCCERT_CONTEXT): BOOL; stdcall; external 'Crypt32.dll';
function CertGetNameStringA(pCertContext: PCCERT_CONTEXT; dwType: DWORD; dwFlags: DWORD; pvTypePara: Pointer; pszNameString: PAnsiChar; cchNameString: DWORD): DWORD; stdcall; external 'Crypt32.dll';
function CertFreeCertificateContext(pCertContext: PCCERT_CONTEXT): BOOL; stdcall; external 'Crypt32.dll';
function CertCreateCertificateContext(dwCertEncodingType: DWORD; pbCertEncoded: PBYTE; cbCertEncoded: DWORD): PCCERT_CONTEXT; stdcall; external 'Crypt32.dll';

// WinTrust.dll
const
  WINTRUST_ACTION_GENERIC_VERIFY_V2: TGUID = '{00AAC56B-CD44-11d0-8CC2-00C04FC295EE}';

  WTD_UI_ALL    = 1;
  WTD_UI_NONE   = 2;
  WTD_UI_NOBAD  = 3;
  WTD_UI_NOGOOD = 4;

  WTD_REVOKE_NONE       = $00000000;
  WTD_REVOKE_WHOLECHAIN = $00000001;

  WTD_CHOICE_FILE    = 1;
  WTD_CHOICE_CATALOG = 2;
  WTD_CHOICE_BLOB    = 3;
  WTD_CHOICE_SIGNER  = 4;
  WTD_CHOICE_CERT    = 5;

  WTD_STATEACTION_IGNORE           = $00000000;
  WTD_STATEACTION_VERIFY           = $00000001;
  WTD_STATEACTION_CLOSE            = $00000002;
  WTD_STATEACTION_AUTO_CACHE       = $00000003;
  WTD_STATEACTION_AUTO_CACHE_FLUSH = $00000004;

type
  PWinTrustFileInfo = ^TWinTrustFileInfo;
  TWinTrustFileInfo = record
    cbStruct: DWORD;                    // = sizeof(WINTRUST_FILE_INFO)
    pcwszFilePath: PWideChar;           // required, file name to be verified
    hFile: THandle;                     // optional, open handle to pcwszFilePath
    pgKnownSubject: PGUID;              // optional: fill if the subject type is known
  end;

  PWinTrustData = ^TWinTrustData;
  TWinTrustData = record
    cbStruct: DWORD;
    pPolicyCallbackData: Pointer;
    pSIPClientData: Pointer;
    dwUIChoice: DWORD;
    fdwRevocationChecks: DWORD;
    dwUnionChoice: DWORD;
    pFile: PWinTrustFileInfo;
    dwStateAction: DWORD;
    hWVTStateData: THandle;
    pwszURLReference: PWideChar;
    dwProvFlags: DWORD;
    dwUIContext: DWORD;
  end;

function WinVerifyTrust(hwnd: HWND; const ActionID: TGUID; ActionData: Pointer): Longint; stdcall; external wintrust;

{$ENDIF}

//--------------------------------
/// <summary>
///   Returns TRUE if the current application is code signed and the checksum
///   matches
/// </summary>
function IsExeCodeSigned: Boolean;
/// <summary>
///   Returns TRUE if the application is code signed, the checksum matches, and
///   the certificate's SubjectName matches.
/// </summary>
/// <param name="SignName">
///   compared to the certificate's SubjectName
/// </param>
function IsExeSignedbyName(const SignName :string): Boolean;
/// <summary>
///   Returns TRUE if the file is code signed and the checksum<br />matches
/// </summary>
/// <param name="Filename">
///   path of file to be checked
/// </param>
function IsFileCodeSigned(const Filename: string): Boolean;
/// <summary>
///   Returns TRUE if the file is code signed, the checksum matches, and
///   <br />the certificate's SubjectName matches.
/// </summary>
/// <param name="Filename">
///   path of file to be checked
/// </param>
/// <param name="SignName">
///   compared to certificate's SubjectName
/// </param>
function IsFileSignedbyName(const Filename, SignName :string): Boolean;

implementation

{$IFDEF MSWINDOWS}
function IsExeCodeSigned: Boolean;
begin
  Result := IsFileCodeSigned(ParamStr(0));
end;

function IsExeSignedbyName(const SignName :string): Boolean;
begin
  Result := IsFileSignedbyName(ParamStr(0), SignName);
end;

function IsFileCodeSigned(const Filename: string): Boolean;
var
  file_info: TWinTrustFileInfo;
  trust_data: TWinTrustData;
begin
  // Verify that the file is signed and the checksum matches
  FillChar(file_info, SizeOf(file_info), 0);
  file_info.cbStruct := sizeof(file_info);
  file_info.pcwszFilePath := PWideChar(WideString(Filename));
  FillChar(trust_data, SizeOf(trust_data), 0);
  trust_data.cbStruct := sizeof(trust_data);
  trust_data.dwUIChoice := WTD_UI_NONE;
  trust_data.fdwRevocationChecks := WTD_REVOKE_NONE;
  trust_data.dwUnionChoice := WTD_CHOICE_FILE;
  trust_data.pFile := @file_info;
  Result := WinVerifyTrust(INVALID_HANDLE_VALUE, WINTRUST_ACTION_GENERIC_VERIFY_V2, @trust_data) = ERROR_SUCCESS
end;

function IsFileSignedbyName(const Filename, SignName :string): Boolean;
var
  hExe: HMODULE;
  Cert: PWinCertificate;
  CertContext: PCCERT_CONTEXT;
  CertCount: DWORD;
  CertName: AnsiString;
  CertNameLen: DWORD;
  VerifyParams: CRYPT_VERIFY_MESSAGE_PARA;
begin
  // Returns TRUE if the SubjectName on the certificate used to sign the file is "Sign Name".
  Result := False;
  // Verify that the exe was signed by our private key
  hExe := CreateFile(PChar(Filename), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL or FILE_FLAG_RANDOM_ACCESS, 0);
  if hExe = INVALID_HANDLE_VALUE then Exit;
  try
    // There should only be one certificate associated with the exe
    if (not ImageEnumerateCertificates(hExe, CERT_SECTION_TYPE_ANY, CertCount, nil, 0)) or (CertCount <> 1) then Exit;
    // Read the certificate header so we can get the size needed for the full cert
    GetMem(Cert, SizeOf(TWinCertificate) + 3); // ImageGetCertificateHeader writes an DWORD at bCertificate for some reason
    try
      Cert.dwLength := 0;
      Cert.wRevision := WIN_CERT_REVISION_1_0;
      if not ImageGetCertificateHeader(hExe, 0, Cert^) then Exit;
      // Read the full certificate
      ReallocMem(Cert, SizeOf(TWinCertificate) + Cert.dwLength);
      if not ImageGetCertificateData(hExe, 0, Cert, Cert.dwLength) then Exit;
      // Get the certificate context.  CryptVerifyMessageSignature has the
      // side effect of creating a context for the signing certificate.
      FillChar(VerifyParams, SizeOf(VerifyParams), 0);
      VerifyParams.cbSize := SizeOf(VerifyParams);
      VerifyParams.dwMsgAndCertEncodingType := X509_ASN_ENCODING or PKCS_7_ASN_ENCODING;
      if not CryptVerifyMessageSignature(VerifyParams, 0, @Cert.bCertificate, Cert.dwLength, nil, nil, @CertContext) then Exit;
      try
        // Extract and compare the certificate's subject names.  Don't
        // compare the entire certificate or the public key as those will
        // change when the certificate is renewed.
        CertNameLen := CertGetNameStringA(CertContext, CERT_NAME_SIMPLE_DISPLAY_TYPE, 0, nil, nil, 0);
        SetLength(CertName, CertNameLen - 1);
        CertGetNameStringA(CertContext, CERT_NAME_SIMPLE_DISPLAY_TYPE, 0, nil, PAnsiChar(CertName), CertNameLen);
        if CertName <> SignName then Exit;
      finally
        CertFreeCertificateContext(CertContext)
      end;
    finally
      FreeMem(Cert);
    end;
  finally
    CloseHandle(hExe);
  end;
  Result := True;
end;

{$ELSE}
// all other platforms besides Windows are not supported yet

function IsExeCodeSigned: Boolean;
begin
  Result := False;
end;

function IsExeSignedbyName(const SignName :string): Boolean;
begin
  Result := False;
end;

function IsFileCodeSigned(const Filename: string): Boolean;
begin
  Result := False;
end;

function IsFileSignedbyName(const Filename, SignName :string): Boolean;
begin
  Result := False;
end;

{$ENDIF}

end.
