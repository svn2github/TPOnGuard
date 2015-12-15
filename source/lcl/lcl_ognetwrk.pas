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
 * The Original Code is TurboPower OnGuard
 *
 * The Initial Developer of the Original Code is
 * TurboPower Software
 *
 * Portions created by the Initial Developer are Copyright (C) 1996-2002
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * Andrew Haines         andrew@haines.name                        {AH.01}
 *                       conversion to CLX                         {AH.01}
 *                       December 30, 2003                         {AH.01}
 *
 * Andrew Haines         andrew@haines.name                        {AH.02}
 *                       64 bit support added                      {AH.02}
 *                       December 6, 2015                          {AH.02}
 *
 * ***** END LICENSE BLOCK ***** *)
{*********************************************************}
{*                  OGNETWRK.PAS 1.15                    *}
{*     Copyright (c) 1996-02 TurboPower Software Co      *}
{*                 All rights reserved.                  *}
{*********************************************************}
(*
   2015-Mar-12:
   All types, functions, and procedures were moved to ognetwrkutil.pas
   to facilitate the separation of the visual component and the library code.
   This should make the component conversion much simpler.
*)

{$I ../onguard.inc}

unit lcl_ognetwrk;
  {-network file routines}

interface

uses
  {$IFDEF Win16} WinTypes, WinProcs, OLE2, {$ENDIF}
  {$IFDEF Win32} Windows, {$ENDIF}
  {$IFDEF Win64} Windows, {$ENDIF}                                     {AH.02}
  {$IFDEF KYLIX} Libc, {$ENDIF}
  {$IFDEF UsingCLX} Types, {$ENDIF}
  {$IFDEF MACOS}Posix.Unistd, {$ENDIF}
  Classes, SysUtils,
  ogconst,
  ogutil,
  lcl_onguard, ognetwrkutil;


type
  TGetFileNameEvent =                                                  {!!.02}
    procedure(Sender : TObject; var Value : string)                    {!!.02}
    of object;                                                         {!!.02}

  TOgNetCode = class(TOgCodeBase)
  protected {private}
    {property variables}
    FFileName        : string;

    {event variables}                                                  {!!.02}
    FOnGetFileName   : TGetFileNameEvent;                              {!!.02}

    {internal variables}
    nacNetAccess     : TNetAccess;
    nacNetAccessInfo : TNetAccessInfo;

    {property methods}
    function GetActiveUsers : ogLongInt;
    function GetInvalidUsers : ogLongInt;
    function GetMaxUsers : ogLongInt;

  protected
    procedure Loaded;
      override;

    function DoOnGetFileName : string;                                 {!!.02}
      dynamic;                                                         {!!.02}

  public
    constructor Create(AOwner : TComponent);                           {!!.01}
      override;
    destructor Destroy;
      override;

    function CheckCode(Report : Boolean) : TCodeStatus;
      override;
    function CreateAccessFile : Boolean;
      {-creates the net access file}
    function IsRemoteDrive(const ExePath : string) : Boolean;
      {-returns True if the application is running on a remote drive}
    function ResetAccessFile : Boolean;
      {-rewrites the net access file, returning True if successful}

    property ActiveUsers : ogLongInt
      read GetActiveUsers;

    property InvalidUsers : ogLongInt
      read GetInvalidUsers;

    property MaxUsers : ogLongInt
      read GetMaxUsers;

  published
    {properties}
    property Code
      stored FStoreCode;

    property FileName : string
      read FFileName
      write FFileName;

    property StoreCode
      default DefStoreCode;

    {events}
    property OnGetFileName :  TGetFileNameEvent                        {!!.02}
      read FOnGetFileName                                              {!!.02}
      write FOnGetFileName;                                            {!!.02}
  end;


implementation

uses
  ogfile;


{*** TOgNetCode ***}

function TOgNetCode.CheckCode(Report : Boolean) : TCodeStatus;
var
  Key      : TKey;
begin
  Result := ogValidCode;

  DoOnGetKey(Key);
  ApplyModifierToKeyPrim(DoOnGetModifier, Key, SizeOf(Key));         {!!.09}
  if DecodeNAFCountCode(Key, DoOnGetCode) > 0 then begin             {!!.09}
    if (nacNetAccess.Fh = -1) then begin                             {!!.09}
      if (FFileName = '') then                                       {!!.09}
        FFileName := DoOnGetFileName;                                {!!.09}
      // attempt to fix ticket #7
      if not FAutoCheck then begin
        if not GetNetAccessFileInfo(FFileName, Key, nacNetAccessInfo) then
          CreateAccessFile; {wasn't there, try to create it}
      end;
      LockNetAccessFile(FFileName, Key, nacNetAccess);               {!!.09}
    end;                                                             {!!.09}
    if not CheckNetAccessFile(nacNetAccess) then
      Result := ogNetCountUsed;
  end else
    Result := ogInvalidCode;

  if Report then
    DoOnChecked(Result);
end;

{!!.01}
constructor TOgNetCode.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  nacNetAccess.Fh := -1;
end;

function TOgNetCode.CreateAccessFile : Boolean;
var
  ACode     : TCode;
  Key      : TKey;
  AModifier : ogLongInt;
begin
  DoOnGetKey(Key);
  ACode := DoOnGetCode;
  AModifier := DoOnGetModifier;
  ApplyModifierToKeyPrim(AModifier, Key, SizeOf(Key));
  Result := CreateNetAccessFileEx(FFileName, Key, ACode);
end;

destructor TOgNetCode.Destroy;
begin
  UnlockNetAccessFile(nacNetAccess);

  inherited Destroy;
end;

{!!.02}
function TOgNetCode.DoOnGetFileName : string;
begin
  Result := '';
  if not Assigned(FOnGetFileName) then
    raise EOnGuardException.Create({$IFNDEF NoOgSrMgr}StrRes[SCNoOnGetFileName]{$ELSE}SCNoOnGetFileName{$ENDIF});

  FOnGetFileName(Self, Result);
end;

function TOgNetCode.GetActiveUsers : ogLongInt;
var
  Key           : TKey;
  AModifier      : ogLongInt;
  NetAccessInfo : TNetAccessInfo;
begin
  DoOnGetKey(Key);
  AModifier := DoOnGetModifier;
  ApplyModifierToKeyPrim(AModifier, Key, SizeOf(Key));
  if GetNetAccessFileInfo(FileName, Key, NetAccessInfo) then
    Result := NetAccessInfo.Locked
  else
    Result := -1;
end;

function TOgNetCode.GetInvalidUsers : ogLongInt;
var
  Key           : TKey;
  AModifier      : ogLongInt;
  {NetAccessInfo : TNetAccessInfo;}                                  {!!.08}
begin
  DoOnGetKey(Key);
  AModifier := DoOnGetModifier;
  ApplyModifierToKeyPrim(AModifier, Key, SizeOf(Key));
  if GetNetAccessFileInfo(FFileName, Key, nacNetAccessInfo) then
    Result := nacNetAccessInfo.Invalid                               {!!.08}
  else
    Result := -1;
end;

function TOgNetCode.GetMaxUsers : ogLongInt;
var
  Key      : TKey;
  AModifier : ogLongInt;
begin
  DoOnGetKey(Key);
  AModifier := DoOnGetModifier;
  ApplyModifierToKeyPrim(AModifier, Key, SizeOf(Key));
  if GetNetAccessFileInfo(FFileName, Key, nacNetAccessInfo) then
    Result := nacNetAccessInfo.Total
  else
    Result := -1;
end;

function TOgNetCode.IsRemoteDrive(const ExePath : string) : Boolean;
begin
  Result := IsAppOnNetwork(ExePath);
end;

procedure TOgNetCode.Loaded;
var
  Key      : TKey;
  ACode     : TCode;
  AModifier : ogLongInt;
begin
  if FAutoCheck and not (csDesigning in ComponentState) then begin   {!!.08}
    ACode := DoOnGetCode;
    DoOnGetKey(Key);
    AModifier := DoOnGetModifier;

    {if no file name, fire event to get one}                           {!!.02}
    if FFileName = '' then                                            {!!.02}
      FFilename := DoOnGetFileName;                                    {!!.02}

    ApplyModifierToKeyPrim(AModifier, Key, SizeOf(Key));
    if DecodeNAFCountCode(Key, ACode) > 0 then begin
      try
        if not GetNetAccessFileInfo(FFileName, Key, nacNetAccessInfo) then
          CreateAccessFile; {wasn't there, try to create it}
        LockNetAccessFile(FFileName, Key, nacNetAccess);
      except
        {ignore errors - CheckCode will report that record is not locked}
      end;
    end;
  end;

  inherited Loaded;
end;

function TOgNetCode.ResetAccessFile : Boolean;
var
  Key      : TKey;
  AModifier : ogLongInt;
begin
  DoOnGetKey(Key);
  AModifier := DoOnGetModifier;
  ApplyModifierToKeyPrim(AModifier, Key, SizeOf(Key));
  Result := ResetNetAccessFile(FFileName, Key);
end;


end.
