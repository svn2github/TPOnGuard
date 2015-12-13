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
 * ***** END LICENSE BLOCK ***** *)
{*********************************************************}
{*                  ONGUARD.PAS 1.15                     *}
{*     Copyright (c) 1996-02 TurboPower Software Co      *}
{*                 All rights reserved.                  *}
{*********************************************************}

{$I ../onguard.inc}

unit FMX.onguard;
  {-code and key classes and routines}

interface

uses
  {$IFDEF Win32} Windows, {$ENDIF}
  {$IFDEF Win64} Windows, {$ENDIF}
  {$IFDEF DELPHI15UP} System.AnsiStrings, {$ENDIF}
  Classes, SysUtils,
  {$IFDEF UsingZLib} ZLib, {$ENDIF}
  System.UITypes,
  ogconst,
  ogutil;



type
  TChangeCodeEvent =
    procedure(Sender : TObject; Code : TCode)
    of object;
  TCheckedCodeEvent =
    procedure(Sender : TObject; Status : TCodeStatus)
    of object;
  TGetCodeEvent =
    procedure(Sender : TObject; var Code : TCode)
    of object;
  TGetKeyEvent =
    procedure(Sender : TObject; var Key : TKey)
    of object;
  TGetModifierEvent =
    procedure(Sender : TObject; var Value : LongInt)
    of object;
  TGetRegStringEvent =
    procedure(Sender : TObject; var Value : string)
    of object;

  {base regisration code component}
{$IFDEF DELPHI16UP}[ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32 or pidiOSSimulator or pidiOSDevice{$IFDEF DELPHI22UP} or pidiOSDevice32 or pidiOSDevice64{$ENDIF} or pidAndroid or pidLinux32)]{$ENDIF}
  TOgFMXCodeBase = class(TComponent)
  protected {private}
    {property variables}
    FAutoCheck     : Boolean;          {true to test code when loaded}
    FCode          : TCode;            {release code}
    FModifier      : LongInt;          {key modifier}
    FStoreCode     : Boolean;          {true to store release code on stream}
    FStoreModifier : Boolean;          {true to store key modifier on stream}

    {event variables}
    FOnChecked     : TCheckedCodeEvent;{called after auto check is made}
    FOnGetCode     : TGetCodeEvent;    {called to retrieve release code}
    FOnGetKey      : TGetKeyEvent;     {called to retrieve key}
    FOnGetModifier : TGetModifierEvent;{called to retrieve key modifier}

    {property methods}
    function GetCode : string;
    function GetModifier : string;
    function GetAbout : string;                                      {!!.08}
    procedure SetCode(const Value : string);
    procedure SetModifier(const Value : string);
    procedure SetAbout(const Value : string);                        {!!.08}

  protected
    procedure Loaded;
      override;

    procedure DoOnChecked(Value : TCodeStatus);
      dynamic;
    function DoOnGetCode : TCode;
      dynamic;
    procedure DoOnGetKey(var Key : TKey);
      dynamic;
    function DoOnGetModifier : LongInt;
      dynamic;

    {protected properties}
    property Code : string
      read GetCode
      write SetCode;

    property StoreCode : Boolean
      read FStoreCode
      write FStoreCode;

  public
    constructor Create(AOwner : TComponent);
      override;

    function CheckCode(Report : Boolean) : TCodeStatus;
      virtual; abstract;
    function IsCodeValid : Boolean;
      {-return true if code is valid}

  published
    {properties}
    property AutoCheck : Boolean
      read FAutoCheck
      write FAutoCheck
      default DefAutoCheck;

    property Modifier : string
      read GetModifier
      write SetModifier
      stored FStoreModifier;

    property StoreModifier : Boolean
      read FStoreModifier
      write FStoreModifier
      default DefStoreModifier;

    property About : string                                          {!!.08}
      read GetAbout                                                  {!!.08}
      write SetAbout                                                 {!!.08}
      stored False;

    {events}
    property OnChecked : TCheckedCodeEvent
      read FOnChecked
      write FOnChecked;

    property OnGetKey : TGetKeyEvent
      read FOnGetKey
      write FOnGetKey;

    property OnGetCode : TGetCodeEvent
      read FOnGetCode
      write FOnGetCode;

    property OnGetModifier : TGetModifierEvent
      read FOnGetModifier
      write FOnGetModifier;
  end;

{$IFDEF DELPHI16UP}[ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32 or pidiOSSimulator or pidiOSDevice{$IFDEF DELPHI22UP} or pidiOSDevice32 or pidiOSDevice64{$ENDIF} or pidAndroid or pidLinux32)]{$ENDIF}
  TOgFMXMakeCodes = class(TComponent)
  protected {private}
    {property variables}
    FCode        : TCode;
    FCodeType    : TCodeType;
    FKey         : TKey;
    FKeyFileName : string;
    FKeyType     : TKeyType;
    FShowHints   : Boolean;

    {property methods}
    function GetAbout : string;                                      {!!.08}
    procedure SetAbout(const Value : string);                        {!!.08}

  public
    constructor Create(AOwner : TComponent);
      override;
    function Execute : Boolean;
    procedure GetCode(var Value : TCode);                            {!!.08}
    procedure SetCode(Value : TCode);                                {!!.08}
    procedure GetKey(var Value : TKey);                              {!!.08}
    procedure SetKey(Value : TKey);                                  {!!.08}

    property KeyType : TKeyType
      read FKeyType
      write FKeyType;

  published

    {properties}
    property CodeType : TCodeType
      read FCodeType
      write FCodeType
      default DefCodeType;

     property KeyFileName : string
      read FKeyFileName
      write FKeyFileName;

    property ShowHints : Boolean
      read FShowHints
      write FShowHints
      default False;

    property About : string                                          {!!.08}
      read GetAbout                                                  {!!.08}
      write SetAbout                                                 {!!.08}
      stored False;
  end;

type
{$IFDEF DELPHI16UP}[ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32 or pidiOSSimulator or pidiOSDevice{$IFDEF DELPHI22UP} or pidiOSDevice32 or pidiOSDevice64{$ENDIF} or pidAndroid or pidLinux32)]{$ENDIF}
  TOgFMXMakeKeys = class(TComponent)
  protected {private}
    {property variables}
    FKeyFileName : string;
    FKey         : TKey;
    FKeyType     : TKeyType;
    FShowHints   : Boolean;

    {property methods}
    function GetAbout : string;                                      {!!.08}
    procedure SetAbout(const Value : string);                        {!!.08}

  public
    constructor Create(AOwner : TComponent);
      override;
    function Execute : Boolean;

    procedure ApplyModifierToKey(Modifier : LongInt; var Key; KeySize : Cardinal);
      {-signs the key with the modifier}
    function GenerateDateModifier(D : TDateTime) : LongInt;
      {-returns a modifier based on the current date}
    function GenerateMachineModifier : LongInt;
      {-returns a modifier based on hardware information}
    procedure GenerateMDKey(var Key; KeySize : Cardinal; const Str : AnsiString);
      {-generate a key based on the message digest of Str}
    procedure GenerateRandomKey(var Key; KeySize : Cardinal);
      {-generate a random key}
    function GenerateStringModifier(const S : AnsiString) : LongInt;
      {-returns a modifier based on S}
    function GenerateUniqueModifier : LongInt;
      {-returns a unique/random modifier}
    procedure SetKey(Value : TKey);                                  {!!.08}
    procedure GetKey(var Value : TKey);                              {!!.08}

  published

    {properties}
    property About : string                                          {!!.08}
      read GetAbout                                                  {!!.08}
      write SetAbout                                                 {!!.08}
      stored False;

    property KeyFileName : string
      read FKeyFileName
      write FKeyFileName;

    property KeyType : TKeyType
      read FKeyType
      write FKeyType
      default DefKeyType;

    property ShowHints : Boolean
      read FShowHints
      write FShowHints
      default False;
  end;

{$IFDEF DELPHI16UP}[ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32 or pidiOSSimulator or pidiOSDevice{$IFDEF DELPHI22UP} or pidiOSDevice32 or pidiOSDevice64{$ENDIF} or pidAndroid or pidLinux32)]{$ENDIF}
  TOgFMXDateCode = class(TOgFMXCodeBase)
  public
    function CheckCode(Report : Boolean) : TCodeStatus;
      override;
    function GetValue : TDateTime;
      {-return expiration date (0 for error)}

  published
    {properties}
    property Code
      stored FStoreCode;

    property StoreCode
      default DefStoreCode;
  end;

{$IFDEF DELPHI16UP}[ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32 or pidiOSSimulator or pidiOSDevice{$IFDEF DELPHI22UP} or pidiOSDevice32 or pidiOSDevice64{$ENDIF} or pidAndroid or pidLinux32)]{$ENDIF}
  TOgFMXDaysCode = class(TOgFMXCodeBase)
  protected {private}
    {property variables}
    FAutoDecrease : Boolean;

    {event variables}
    FOnChangeCode : TChangeCodeEvent;

  protected
    procedure Loaded;
      override;

    procedure DoOnChangeCode(Value : TCode);
      dynamic;

  public
    constructor Create(AOwner : TComponent);
      override;
    function CheckCode(Report : Boolean) : TCodeStatus;
      override;
    procedure Decrease;
      {-reduce days and generate modified code}
    function GetValue : LongInt;
      {-return number of days remaining}

  published
    {properties}
    property AutoDecrease : Boolean
      read FAutoDecrease
      write FAutoDecrease
      default DefAutoDecrease;

    {events}
    property OnChangeCode : TChangeCodeEvent
      read FOnChangeCode
      write FOnChangeCode;
  end;

{$IFDEF DELPHI16UP}[ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32 or pidiOSSimulator or pidiOSDevice{$IFDEF DELPHI22UP} or pidiOSDevice32 or pidiOSDevice64{$ENDIF} or pidAndroid or pidLinux32)]{$ENDIF}
  TOgFMXRegistrationCode = class(TOgFMXCodeBase)
  protected {private}
    {property variables}
    FRegString      : string;
    FStoreRegString : Boolean;

    {event variables}
    FOnGetRegString : TGetRegStringEvent;

  protected
    function DoOnGetRegString : string;
      dynamic;

  public
    constructor Create(AOwner : TComponent);
      override;

    function CheckCode(Report : Boolean) : TCodeStatus;
      override;

  published
    {properties}
    property Code
      stored FStoreCode;

    property StoreCode
      default DefStoreCode;

    property RegString : string
      read FRegString
      write FRegString
      stored FStoreRegString;

    property StoreRegString : Boolean
      read FStoreRegString
      write FStoreRegString
      default DefStoreRegString;

    {events}
    property OnGetRegString : TGetRegStringEvent
      read FOnGetRegString
      write FOnGetRegString;
  end;

{$IFDEF DELPHI16UP}[ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32 or pidiOSSimulator or pidiOSDevice{$IFDEF DELPHI22UP} or pidiOSDevice32 or pidiOSDevice64{$ENDIF} or pidAndroid or pidLinux32)]{$ENDIF}
  TOgFMXSerialNumberCode = class(TOgFMXCodeBase)
  public
    function CheckCode(Report : Boolean) : TCodeStatus;
      override;
    function GetValue : LongInt;
      {-return serial number (0 for error)}

  published
    {properties}
    property Code
      stored FStoreCode;

    property StoreCode
      default DefStoreCode;

  end;

{$IFDEF DELPHI16UP}[ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32 or pidiOSSimulator or pidiOSDevice{$IFDEF DELPHI22UP} or pidiOSDevice32 or pidiOSDevice64{$ENDIF} or pidAndroid or pidLinux32)]{$ENDIF}
  TOgFMXSpecialCode = class(TOgFMXCodeBase)
    function CheckCode(Report : Boolean) : TCodeStatus;
      override;
    function GetValue : LongInt;
      {-return serial number (0 for error)}

  published
    {properties}
    property Code
      stored FStoreCode;

    property StoreCode
      default DefStoreCode;
  end;

{$IFDEF DELPHI16UP}[ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32 or pidiOSSimulator or pidiOSDevice{$IFDEF DELPHI22UP} or pidiOSDevice32 or pidiOSDevice64{$ENDIF} or pidAndroid or pidLinux32)]{$ENDIF}
  TOgFMXUsageCode = class(TOgFMXCodeBase)
  protected {private}
    {property variables}
    FAutoDecrease : Boolean;

    {event variables}
    FOnChangeCode : TChangeCodeEvent;

  protected
    procedure Loaded;
      override;

    procedure DoOnChangeCode(Value : TCode);
      dynamic;

  public
    constructor Create(AOwner : TComponent);
      override;
    function CheckCode(Report : Boolean) : TCodeStatus;
      override;
    procedure Decrease;
      {-reduce number of uses and generate code}
    function GetValue : LongInt;
      {-return number of uses remaining}

  published
    {properties}
    property AutoDecrease : Boolean
      read FAutoDecrease
      write FAutoDecrease
      default DefAutoDecrease;

    {events}
    property OnChangeCode : TChangeCodeEvent
      read FOnChangeCode
      write FOnChangeCode;
  end;




implementation

{$IF not defined(NoMakeCodesSupport) or  not defined(NoMakeKeysSupport)}
uses
  {$IFNDEF NoMakeCodesSupport}FMX.onguard2{$IFNDEF NoMakeKeysSupport},FMX.onguard3{$ENDIF}{$ENDIF}
  ;
{$ENDIF}


{*** TogCodeBase ***}

constructor TOgFMXCodeBase.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FAutoCheck := DefAutoCheck;
  FStoreCode := DefStoreCode;
  FStoreModifier := DefStoreModifier;

end;

procedure TOgFMXCodeBase.DoOnChecked(Value : TCodeStatus);
begin
  if Assigned(FOnChecked) then
    FOnChecked(Self, Value)
  else if FAutoCheck then
    raise EOnGuardException.CreateFmt(SCNoOnCheck, [Self.ClassName]);
end;

function TOgFMXCodeBase.DoOnGetCode : TCode;
begin
  FillChar(Result, SizeOf(Result), 0);
  if FStoreCode then
    Result := FCode
  else begin
    if Assigned(FOnGetCode) then
      FOnGetCode(Self, Result)
    else
      raise EOnGuardException.CreateFmt(SCNoOnGetCode, [Self.ClassName]);
  end;

  {store code for easy access using the Code property}                 {!!.02}
  FCode := Result;                                                     {!!.02}
end;

procedure TOgFMXCodeBase.DoOnGetKey(var Key : TKey);
begin
  FillChar(Key, SizeOf(TKey), 0);
  if Assigned(FOnGetKey) then
    FOnGetKey(Self, Key)
  else
    raise EOnGuardException.CreateFmt(SCNoOnGetKey, [Self.ClassName]);
end;

{!!.02} {revised}
function TOgFMXCodeBase.DoOnGetModifier : LongInt;
var
  L : LongInt;
begin
  Result := 0;
  if FStoreModifier then
    Result := FModifier
  else if Assigned(FOnGetModifier) then begin
    FOnGetModifier(Self, L);
    if FStoreModifier then begin
      {byte and word swap the modifier}
      TLongIntRec(Result).HiHi := TLongIntRec(L).LoLo;
      TLongIntRec(Result).HiLo := TLongIntRec(L).LoHi;
      TLongIntRec(Result).LoHi := TLongIntRec(L).HiLo;
      TLongIntRec(Result).LoLo := TLongIntRec(L).HiHi;
    end else
      Result := L;
  end;

  {store modifier for easy access using the Modifier property}         {!!.02}
  FModifier := Result;                                                 {!!.02}
end;

function TOgFMXCodeBase.GetCode : string;
var
  Work : TCode;
begin
  Result := '$' + BufferToHex(FCode, SizeOf(FCode));
  if not HexToBuffer(Result, Work, SizeOf(Work)) then
    Result := '';

  if HexStringIsZero(Result) then
    Result := '';
end;

function TOgFMXCodeBase.GetModifier : string;
var
  Work : LongInt;
begin
  Result := '$' + BufferToHex(FModifier, SizeOf(FModifier));
  if not HexToBuffer(Result, Work, SizeOf(Work)) then
    Result := '';

  if HexStringIsZero(Result) then
    Result := '';
end;

function TOgFMXCodeBase.GetAbout : string;                              {!!.08}
begin
  Result := OgVersionStr;
end;

function TOgFMXCodeBase.IsCodeValid : Boolean;
begin
  Result := (CheckCode(False) = ogValidCode);
end;

procedure TOgFMXCodeBase.Loaded;
begin
  inherited Loaded;

  if FAutoCheck and not (csDesigning in ComponentState) then
    CheckCode(True);
end;

procedure TOgFMXCodeBase.SetCode(const Value : string);
begin
  if not HexToBuffer(Value, FCode, SizeOf(FCode)) then
    FillChar(FCode, SizeOf(FCode), 0);
end;

procedure TOgFMXCodeBase.SetModifier(const Value : string);
begin
  if not HexToBuffer(Value, FModifier, SizeOf(FModifier)) then
    FModifier := 0;
end;

procedure TOgFMXCodeBase.SetAbout(const Value : string);                {!!.08}
begin
end;


{*** TOgDateCode ***}

function TOgFMXDateCode.CheckCode(Report : Boolean) : TCodeStatus;
var
  Code     : TCode;
  Key      : TKey;
  Modifier : LongInt;
begin
  Result := ogValidCode;

  DoOnGetKey(Key);
  Code := DoOnGetCode;
  Modifier := DoOnGetModifier;

  ApplyModifierToKeyPrim(Modifier, Key, SizeOf(Key));
  if IsDateCodeValid(Key, Code) then begin
    if IsDateCodeExpired(Key, Code) then
      Result := ogPastEndDate;
  end else
    Result := ogInvalidCode;

  if Report then
    DoOnChecked(Result);
end;

function TOgFMXDateCode.GetValue : TDateTime;
var
  Code     : TCode;
  Key      : TKey;
  Modifier : LongInt;
begin
  DoOnGetKey(Key);
  Code := DoOnGetCode;
  Modifier := DoOnGetModifier;

  ApplyModifierToKeyPrim(Modifier, Key, SizeOf(Key));
  Result := GetDateCodeValue(Key, Code);
end;

{*** TOgDaysCode ***}

function TOgFMXDaysCode.CheckCode(Report : Boolean) : TCodeStatus;
var
  Code     : TCode;
  Key      : TKey;
  Modifier : LongInt;
begin
  Result := ogValidCode;

  DoOnGetKey(Key);
  Code := DoOnGetCode;
  Modifier := DoOnGetModifier;

  ApplyModifierToKeyPrim(Modifier, Key, SizeOf(Key));
  if IsDaysCodeValid(Key, Code) then begin
    if IsDaysCodeExpired(Key, Code) then begin
      Result := ogDayCountUsed;
      if GetExpirationDate(Key, Code) < Date then
        Result := ogCodeExpired;
    end;
  end else
    Result := ogInvalidCode;

  if Report then
    DoOnChecked(Result);
end;

constructor TOgFMXDaysCode.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FAutoDecrease := DefAutoDecrease;
end;

procedure TOgFMXDaysCode.Decrease;
var
  Code     : TCode;
  Work     : TCode;
  Key      : TKey;
  Modifier : LongInt;
begin
  DoOnGetKey(Key);
  Code := DoOnGetCode;
  Work := Code;
  Modifier := DoOnGetModifier;
  ApplyModifierToKeyPrim(Modifier, Key, SizeOf(Key));

  {code is only decreased once per day - no matter how many times called}
  DecDaysCode(Key, Work);

  {save code if it was changed}
  if (Work.CheckValue <> Code.CheckValue) or (Work.Days <> Code.Days) then
    DoOnChangeCode(Work);
end;

procedure TOgFMXDaysCode.DoOnChangeCode(Value : TCode);
begin
  if Assigned(FOnChangeCode) then
    FOnChangeCode(Self, Value)
  else
    raise EOnGuardException.CreateFmt(SCNoOnChangeCode, [Self.ClassName]);
end;

function TOgFMXDaysCode.GetValue : LongInt;
var
  Code     : TCode;
  Key      : TKey;
  Modifier : LongInt;
begin
  DoOnGetKey(Key);
  Code := DoOnGetCode;
  Modifier := DoOnGetModifier;

  ApplyModifierToKeyPrim(Modifier, Key, SizeOf(Key));
  Result := GetDaysCodeValue(Key, Code);
end;

procedure TOgFMXDaysCode.Loaded;
begin
  inherited Loaded;

  if FAutoDecrease and not (csDesigning in ComponentState) then
    Decrease;
end;

{*** TOgMakeCodes ***}

constructor TOgFMXMakeCodes.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FCodeType := DefCodeType;
  FShowHints := False;
end;

function TOgFMXMakeCodes.Execute : Boolean;
{$IFNDEF NoMakeCodesSupport}                                         {!!.10}
var
  F : TFMXCodeGenerateFrm;
{$ENDIF}                                                             {!!.10}
begin
{$IFNDEF NoMakeCodesSupport}                                         {!!.10}
  F := TFMXCodeGenerateFrm.Create(Owner);
  try
    F.CodeType := FCodeType;
    F.SetKey(FKey);                                                  {!!.08}
    F.KeyType := FKeyType;
    F.KeyFileName := FKeyFileName;
    {$IFNDEF UseOgFMX}
    F.ShowHint := FShowHints;
    {$ENDIF}
    Result := F.ShowModal = mrOK;// was mrOK but that pulls in a GUI framework
    if Result then begin
      FCode := F.Code;
      F.GetKey(FKey);                                                {!!.08}
      FKeyType := F.KeyType;
      FKeyFileName := F.KeyFileName;
    end;
  finally
    F.Free;
  end;
{$ELSE}                                                              {!!.10}
  Result := False;                                                   {!!.10}
{$ENDIF}                                                             {!!.10}
end;

function TOgFMXMakeCodes.GetAbout : string;                             {!!.08}
begin
  Result := OgVersionStr;
end;

procedure TOgFMXMakeCodes.SetAbout(const Value : string);               {!!.08}
begin
end;

procedure TOgFMXMakeCodes.GetCode(var Value : TCode);                   {!!.08}
begin
  Value := FCode;
end;

procedure TOgFMXMakeCodes.SetCode(Value : TCode);                       {!!.08}
begin
  FCode := Value;
end;

procedure TOgFMXMakeCodes.GetKey(var Value : TKey);                     {!!.08}
begin
  Value := FKey;
end;

procedure TOgFMXMakeCodes.SetKey(Value : TKey);                         {!!.08}
begin
  FKey := Value;
end;

{*** TOgMakeKeys ***}

constructor TOgFMXMakeKeys.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FKeyType := DefKeyType;
  FShowHints := False;
end;

function TOgFMXMakeKeys.Execute : Boolean;
{$IFNDEF NoMakeCodesSupport}                                         {!!.10}
var
  F : TFMXKeyMaintFrm;
{$ENDIF}                                                             {!!.10}
begin
{$IFNDEF NoMakeCodesSupport}                                         {!!.10}
  F := TFMXKeyMaintFrm.Create(Owner);
  try
    F.SetKey(FKey);                                                  {!!.08}
    F.KeyType := FKeyType;
    F.KeyFileName := FKeyFileName;
    {$IFNDEF UseOgFMX}
    F.ShowHint := FShowHints;
    {$ENDIF}
    Result := F.ShowModal = mrOK;
    if Result then begin
      F.GetKey(FKey);                                                {!!.08}
      FKeyType := F.KeyType;
      FKeyFileName := F.KeyFileName;
    end;
  finally
    F.Free;
  end;
{$ELSE}                                                              {!!.10}
  Result := False;                                                   {!!.10}
{$ENDIF}                                                             {!!.10}
end;

procedure TOgFMXMakeKeys.ApplyModifierToKey(Modifier : LongInt; var Key; KeySize : Cardinal);
begin
  ApplyModifierToKeyPrim(Modifier, Key, KeySize);
end;

function TOgFMXMakeKeys.GenerateDateModifier(D : TDateTime) : LongInt;
begin
  Result := GenerateDateModifierPrim(D);
end;

function TOgFMXMakeKeys.GenerateMachineModifier : LongInt;
begin
  Result := GenerateMachineModifierPrim;
end;

procedure TOgFMXMakeKeys.GenerateMDKey(var Key; KeySize : Cardinal; const Str : AnsiString);
begin
  GenerateTMDKeyPrim(Key, KeySize, Str);
end;

procedure TOgFMXMakeKeys.GenerateRandomKey(var Key; KeySize : Cardinal);
begin
  GenerateRandomKeyPrim(Key, KeySize);
end;

function TOgFMXMakeKeys.GenerateUniqueModifier : LongInt;
begin
  Result := GenerateUniqueModifierPrim;
end;

function TOgFMXMakeKeys.GenerateStringModifier(const S : AnsiString) : LongInt;
begin
  Result := GenerateStringModifierPrim(S);
end;

function TOgFMXMakeKeys.GetAbout : string;                              {!!.08}
begin
  Result := OgVersionStr;
end;

procedure TOgFMXMakeKeys.SetAbout(const Value : string);                {!!.08}
begin
end;

procedure TOgFMXMakeKeys.GetKey(var Value : TKey);                      {!!.08}
begin
  Value := FKey;
end;

procedure TOgFMXMakeKeys.SetKey(Value : TKey);                          {!!.08}
begin
  FKey := Value;
end;

{*** TOgRegistrationCode ***}

function TOgFMXRegistrationCode.CheckCode(Report : Boolean) : TCodeStatus;
var
  ACode     : TCode;
  Key      : TKey;
  AModifier : LongInt;
  {RegStr   : string;}                                                 {!!.02}
begin
  Result := ogValidCode;

  FRegString := DoOnGetRegString;                                      {!!.02}
  DoOnGetKey(Key);
  ACode       := DoOnGetCode;
  AModifier   := DoOnGetModifier;

  ApplyModifierToKeyPrim(AModifier, Key, SizeOf(Key));
  if not IsRegCodeValid(Key, ACode) then
    Result := ogInvalidCode
  else if GetExpirationDate(Key, ACode) < Date then
    Result := ogCodeExpired;

  if Report then
    DoOnChecked(Result);
end;

constructor TOgFMXRegistrationCode.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FRegString := '';
  FStoreRegString := DefStoreRegString;
end;

function TOgFMXRegistrationCode.DoOnGetRegString : string;
begin
  Result := '';
  if FStoreRegString then
    Result := FRegString
  else if Assigned(FOnGetRegString) then
    FOnGetRegString(Self, Result)
end;

{*** TOgSerialNumberCode ***}

function TOgFMXSerialNumberCode.CheckCode(Report : Boolean) : TCodeStatus;
var
  ACode     : TCode;
  Key      : TKey;
  AModifier : LongInt;
begin
  Result := ogValidCode;

  DoOnGetKey(Key);
  ACode := DoOnGetCode;
  AModifier := DoOnGetModifier;

  ApplyModifierToKeyPrim(AModifier, Key, SizeOf(Key));
  if not IsSerialNumberCodeValid(Key, ACode) then
    Result := ogInvalidCode
  else if GetExpirationDate(Key, ACode) < Date then
    Result := ogCodeExpired;

  if Report then
    DoOnChecked(Result);
end;

function TOgFMXSerialNumberCode.GetValue : LongInt;
var
  ACode     : TCode;
  Key      : TKey;
  AModifier : LongInt;
begin
  DoOnGetKey(Key);
  ACode := DoOnGetCode;
  AModifier := DoOnGetModifier;

  ApplyModifierToKeyPrim(AModifier, Key, SizeOf(Key));
  Result := GetSerialNumberCodeValue(Key, ACode);
end;

{*** TOgSpecialCode ***}

function TOgFMXSpecialCode.CheckCode(Report : Boolean) : TCodeStatus;
var
  ACode     : TCode;
  Key      : TKey;
  AModifier : LongInt;
begin
  Result := ogValidCode;

  DoOnGetKey(Key);
  ACode := DoOnGetCode;
  AModifier := DoOnGetModifier;

  ApplyModifierToKeyPrim(AModifier, Key, SizeOf(Key));
  if not IsSpecialCodeValid(Key, ACode) then
    Result := ogInvalidCode
  else if GetExpirationDate(Key, ACode) < Date then
    Result := ogCodeExpired;

  if Report then
    DoOnChecked(Result);
end;

function TOgFMXSpecialCode.GetValue : LongInt;
var
  ACode     : TCode;
  Key      : TKey;
  AModifier : LongInt;
begin
  DoOnGetKey(Key);
  ACode := DoOnGetCode;
  AModifier := DoOnGetModifier;

  ApplyModifierToKeyPrim(AModifier, Key, SizeOf(Key));
  Result := GetSpecialCodeValue(Key, ACode);
end;

{*** TOgUsageCode ***}

function TOgFMXUsageCode.CheckCode(Report : Boolean) : TCodeStatus;
var
  ACode     : TCode;
  Key      : TKey;
  AModifier : LongInt;
begin
  Result := ogValidCode;

  DoOnGetKey(Key);
  ACode := DoOnGetCode;
  AModifier := DoOnGetModifier;
  ApplyModifierToKeyPrim(AModifier, Key, SizeOf(Key));

  if IsUsageCodeValid(Key, ACode) then begin
    if IsUsageCodeExpired(Key, ACode) then begin
      Result := ogRunCountUsed;
      if GetExpirationDate(Key, ACode) < Date then
        Result := ogCodeExpired;
    end;
  end else
    Result := ogInvalidCode;

  if Report then
    DoOnChecked(Result);
end;

constructor TOgFMXUsageCode.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FAutoDecrease := DefAutoDecrease;
end;

procedure TOgFMXUsageCode.Decrease;
var
  ACode     : TCode;
  Work     : TCode;
  Key      : TKey;
  AModifier : LongInt;
begin
  DoOnGetKey(Key);
  ACode := DoOnGetCode;
  Work := ACode;
  AModifier := DoOnGetModifier;
  ApplyModifierToKeyPrim(AModifier, Key, SizeOf(Key));

  {code is decreased each time this routine is called}
  DecUsageCode(Key, Work);
  {save the changed code}
  DoOnChangeCode(Work);
end;

procedure TOgFMXUsageCode.DoOnChangeCode(Value : TCode);
begin
  if Assigned(FOnChangeCode) then
    FOnChangeCode(Self, Value)
  else
    raise EOnGuardException.CreateFmt({$IFNDEF NoOgSrMgr}StrRes[SCNoOnChangeCode]{$ELSE}SCNoOnChangeCode{$ENDIF}, [Self.ClassName]);
end;

function TOgFMXUsageCode.GetValue : LongInt;
var
  ACode     : TCode;
  Key      : TKey;
  AModifier : LongInt;
begin
  DoOnGetKey(Key);
  ACode := DoOnGetCode;
  AModifier := DoOnGetModifier;

  ApplyModifierToKeyPrim(AModifier, Key, SizeOf(Key));
  Result := GetUsageCodeValue(Key, ACode);
end;

procedure TOgFMXUsageCode.Loaded;
begin
  inherited Loaded;

  // added (not FAutoCheck) to fix ticket #6
  if FAutoDecrease and (not FAutoCheck) and (not (csDesigning in ComponentState)) then
    Decrease;
end;


end.



