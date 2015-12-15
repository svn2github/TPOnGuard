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
 * Andrew Haines         andrew@haines.name                        {AH.02}
 *                       64 bit support added                      {AH.02}
 *                       December 6, 2015                          {AH.02}
 *
 * ***** END LICENSE BLOCK ***** *)
{*********************************************************}
{*                  ONGUARD2.PAS 1.15                    *}
{*     Copyright (c) 1996-02 TurboPower Software Co      *}
{*                 All rights reserved.                  *}
{*********************************************************}

{$I ../onguard.inc}


unit lcl_onguard2;
  {-Code generation dialog}

interface

uses
  {$IFDEF Win16} WinTypes, WinProcs, {$ENDIF}
  {$IFDEF Win32} Windows, ComCtrls, {$ENDIF}
  {$IFDEF Win64} Windows, ComCtrls, {$ENDIF}                       {AH.02}
  SysUtils, Classes,
  Graphics, Controls, Forms, Dialogs, MaskEdit,
  ExtCtrls, StdCtrls, Buttons, ComCtrls, Messages,

  ogconst,
  ognetwrkutil,
  ogutil,
  lcl_onguard,
  lcl_onguard3;

{$IFDEF MSWINDOWS}
const
  OGM_CHECK = WM_USER + 100;
  OGM_QUIT  = WM_USER + 101;
{$ENDIF}
type

  { TLCLCodeGenerateFrm }

  TLCLCodeGenerateFrm = class(TForm)
    UsageUnlimitedCb: TCheckBox;
    GroupBox1: TGroupBox;
    GenerateGb: TGroupBox;
    RegCodeCopySb: TSpeedButton;
    RegStrCopySb: TSpeedButton;
    GenerateKeySb: TSpeedButton;
    GenerateBtn: TButton;
    RegRandomBtn: TButton;
    SerRandomBtn: TButton;
    StringModifierCb: TCheckBox;                                     {!!.11}
    ts1: TTabSheet;
    ts2: TTabSheet;
    ts3: TTabSheet;
    ts4: TTabSheet;
    ts5: TTabSheet;
    ts6: TTabSheet;
    ts7: TTabSheet;
    UniqueModifierCb: TCheckBox;
    MachineModifierCb: TCheckBox;
    DateModifierCb: TCheckBox;
    NoModifierCb: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label17: TLabel;
    Label19: TLabel;
    CodesNbk: TPageControl;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    UsageExpiresEd: TEdit;
    SpecialExpiresEd: TEdit;
    SerialExpiresEd: TEdit;
    RegExpiresEd: TEdit;
    DaysExpiresEd: TEdit;
    ModDateEd: TEdit;
    StartDateEd: TEdit;
    EndDateEd: TEdit;
    DaysCountEd: TEdit;
    SerialNumberEd: TEdit;
    UsageCountEd: TEdit;
    NetworkSlotsEd: TEdit;
    SpecialDataEd: TEdit;
    RegCodeEd: TEdit;
    RegStrEd: TEdit;
    ModifierEd: TEdit;
    BlockKeyEd: TEdit;
    ModStringEd: TEdit;                                              {!!.11}

    procedure FormCreate(Sender: TObject);
    procedure ModifierClick(Sender: TObject);
    procedure RegRandomBtnClick(Sender: TObject);
    procedure GenerateBtnClick(Sender: TObject);
    procedure SerRandomBtnClick(Sender: TObject);
    procedure ParametersChanged(Sender: TObject);
    procedure ModifierEdKeyPress(Sender: TObject; var Key: Char);
    procedure RegStrCopySbClick(Sender: TObject);
    procedure RegCodeCopySbClick(Sender: TObject);
    procedure DateEdKeyPress(Sender: TObject; var Key: Char);
    procedure NumberEdKeyPress(Sender: TObject; var Key: Char);
    procedure TabbedNotebook1Change(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure GenerateKeySbClick(Sender: TObject);
    procedure InfoChanged(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FCode        : TCode;
    FCodeType    : TCodeType;
    FKey         : TKey;
    FKeyType     : TKeyType;
    FKeyFileName : string;

    {$IFDEF MSWINDOWS}
    procedure OGMCheck(var Msg : TMessage);
      message OGM_CHECK;
    procedure OGMQuit(var Msg : TMessage);
      message OGM_QUIT;
    {$ENDIF}
    procedure SetCodeType(Value : TCodeType);

  public
    procedure SetKey(Value : TKey);                                  {!!.08}
    procedure GetKey(var Value : TKey);                              {!!.08}

    property Code : TCode
      read FCode;

    property CodeType : TCodeType
      read FCodeType
      write SetCodeType;

    property KeyFileName : string
      read FKeyFileName
      write FKeyFileName;

    property KeyType : TKeyType
      read FKeyType
      write FKeyType;
  end;


implementation

{$R *.lfm}

procedure TLCLCodeGenerateFrm.FormCreate(Sender: TObject);
var
  D : TDateTime;
begin
  NoModifierCb.Checked := True;
  CodesNbk.PageIndex := Ord(FCodeType);
  BlockKeyEd.Text := BufferToHex(FKey, SizeOf(FKey));
  if HexStringIsZero(BlockKeyEd.Text)then
    BlockKeyEd.Text := '';

  {initialize date edits}
  D := EncodeDate(9999,12,31);
  StartDateEd.Text      := OgFormatDate(Date);                       {!!.09}
  EndDateEd.Text        := OgFormatDate(Date);                       {!!.09}
  ModDateEd.Text        := OgFormatDate(Date);                       {!!.09}
  UsageExpiresEd.Text   := OgFormatDate(D);                          {!!.09}
  SpecialExpiresEd.Text := OgFormatDate(D);                          {!!.09}
  SerialExpiresEd.Text  := OgFormatDate(D);                          {!!.09}
  RegExpiresEd.Text     := OgFormatDate(D);                          {!!.09}
  DaysExpiresEd.Text    := OgFormatDate(D);                          {!!.09}
  NoModifierCb.Checked  := True;                                      {!!.11}
  InfoChanged(Self);
end;

procedure TLCLCodeGenerateFrm.ModifierClick(Sender: TObject);
const
  Busy : Boolean = False;
var
  L : ogLongInt;
  D : TDateTime;
  S : AnsiString;                                                        {!!.11}
  i : Integer;                                                       {!!.12}
begin
  if Busy then
    Exit;

  {set busy flag so that setting "Checked" won't recurse}
  Busy := True;
  try
    L := 0;

    if (Sender = NoModifierCb) and NoModifierCb.Checked then begin
      UniqueModifierCb.Checked := False;
      MachineModifierCb.Checked := False;
      DateModifierCb.Checked := False;
      StringModifierCb.Checked := False;                             {!!.11}
      ModifierEd.Color := clBtnFace;                                 {!!.11}
      ModifierEd.ReadOnly := True;                                   {!!.11}
    end else begin
      NoModifierCb.Checked := False;
      ModifierEd.Color := clWindow;                                  {!!.11}
      ModifierEd.ReadOnly := False;                                  {!!.11}
    end;

    if MachineModifierCb.Checked then begin
      if L = 0 then
        L := GenerateMachineModifierPrim
      else
        L := L xor GenerateMachineModifierPrim;
    end;

    {set status of string field}                                     {!!.11}
    ModStringEd.Enabled := StringModifierCb.Checked;                 {!!.11}
    if ModStringEd.Enabled then                                      {!!.11}
      ModStringEd.Color := clWindow                                  {!!.11}
    else                                                             {!!.11}
      ModStringEd.Color := clBtnFace;                                {!!.11}
                                                                     {!!.11}
    if StringModifierCb.Checked then begin                           {!!.11}
      S := AnsiString(ModStringEd.Text);                                         {!!.11}
      {strip accented characters from the string}                    {!!.12}
      for i := Length(S) downto 1 do                                 {!!.12}
        if Ord(S[i]) > 127 then                                      {!!.12}
          Delete(S, i, 1);                                           {!!.12}
      L := StringHashELF(S);                                         {!!.11}
    end;                                                             {!!.11}

    {set status of date field}
    ModDateEd.Enabled := DateModifierCb.Checked;
    if ModDateEd.Enabled then
      ModDateEd.Color := clWindow
    else
      ModDateEd.Color := clBtnFace;

    if DateModifierCb.Checked then begin
      try
        D := StrToDate(ModDateEd.Text);
      except
        {ignore errors and don't generate modifier}
        D := 0;
      end;

      if Trunc(D) <> 0 then begin
        if L = 0 then
          L := GenerateDateModifierPrim(D)
        else
          L := L xor GenerateDateModifierPrim(D);
      end;
    end;

    if UniqueModifierCb.Checked then begin
      if L = 0 then
        L := GenerateUniqueModifierPrim
      else
        L := L xor GenerateUniqueModifierPrim;
    end;

    if L = 0 then
      ModifierEd.Text := ''
    else
      ModifierEd.Text := '$' + BufferToHex(L, 4);
  finally
    Busy := False;
  end;
end;

procedure TLCLCodeGenerateFrm.RegRandomBtnClick(Sender: TObject);
var
  I     : Integer;
  L     : ogLongInt;
  Bytes : array[0..3] of Byte absolute L;
begin
  Randomize;
  for I := 0 to 3 do
    Bytes[I] := Random(256);
  RegStrEd.Text := IntToHex(L, 8);
end;

procedure TLCLCodeGenerateFrm.GenerateBtnClick(Sender: TObject);
var
  I        : ogLongInt;
  Work     : TCode;
  K        : TKey;
  Modifier : ogLongInt;
  D1, D2   : TDateTime;
begin
  Modifier := 0;
  if ((ModifierEd.Text = '') or HexToBuffer(ModifierEd.Text, Modifier, SizeOf(ogLongInt))) then begin
    K := FKey;
    ApplyModifierToKeyPrim(Modifier, K, SizeOf(K));

    case CodesNbk.PageIndex of
      0 : begin
            try
              D1 := StrToDate(StartDateEd.Text);
            except
              on EConvertError do begin
                ShowMessage(SCInvalidStartDate);
                StartDateEd.SetFocus;
                Exit;
              end else
                raise;
            end;

            try
              D2 := StrToDate(EndDateEd.Text);
            except
              on EConvertError do begin
                ShowMessage(SCInvalidStartDate);
                EndDateEd.SetFocus;
                Exit;
              end else
                raise;
            end;

            InitDateCode(K, Trunc(D1), Trunc(D2), FCode);
            Work := FCode;
            MixBlock(T128bit(K), Work, False);

            {sanity check}
            StartDateEd.Text := OgFormatDate(Work.FirstDate+BaseDate);  {!!.09}
            EndDateEd.Text := OgFormatDate(Work.EndDate+BaseDate);      {!!.09}
          end;
      1 : begin
            try
              D1 := StrToDate(DaysExpiresEd.Text);
            except
              on EConvertError do begin
                ShowMessage(SCInvalidExDate);
                DaysExpiresEd.SetFocus;
                Exit;
              end else
                raise;
            end;
            InitDaysCode(K, StrToIntDef(DaysCountEd.Text, 0), D1, FCode);
          end;
      2 : begin
            try
              D1 := StrToDate(RegExpiresEd.Text);
            except
              on EConvertError do begin
                ShowMessage(SCInvalidExDate);
                RegExpiresEd.SetFocus;
                Exit;
              end else
                raise;
            end;
            InitRegCode(K, AnsiString(RegStrEd.Text), D1, FCode);
          end;
      3 : begin
            try
              D1 := StrToDate(SerialExpiresEd.Text);
            except
              on EConvertError do begin
                ShowMessage(SCInvalidExDate);
                SerialExpiresEd.SetFocus;
                Exit;
              end else
                raise;
            end;
            InitSerialNumberCode(K, StrToIntDef(SerialNumberEd.Text, 0), D1, FCode);
          end;
      4 : begin
            try
              D1 := StrToDate(UsageExpiresEd.Text);
            except
              on EConvertError do begin
                ShowMessage(SCInvalidExDate);
                UsageExpiresEd.SetFocus;
                Exit;
              end else
                raise;
            end;
            InitUsageCode(K, StrToIntDef(UsageCountEd.Text, 0), D1, FCode);
          end;
      5 : begin
            I := StrToIntDef(NetworkSlotsEd.Text, 2);
            if I < 1 then                                            {!!.08}
              I := 1;                                                {!!.08}
            NetworkSlotsEd.Text := IntToStr(I);
            EncodeNAFCountCode(K, I, FCode);
          end;
      6 : begin
            try
              D1 := StrToDate(SpecialExpiresEd.Text);
            except
              on EConvertError do begin
                ShowMessage(SCInvalidExDate);
                SpecialExpiresEd.SetFocus;
                Exit;
              end else
                raise;
            end;
            InitSpecialCode(K, StrToIntDef(SpecialDataEd.Text, 0), D1, FCode);
          end;
    end;

    RegCodeEd.Text := BufferToHex(FCode, SizeOf(FCode));
  end else
    MessageDlg(SCInvalidKeyOrModifier, mtError, [TMsgDlgBtn.mbOK], 0);
end;

procedure TLCLCodeGenerateFrm.SerRandomBtnClick(Sender: TObject);
var
  I     : Integer;
  L     : ogLongInt;
  Bytes : array[0..3] of Byte absolute L;
begin
  Randomize;
  for I := 0 to 3 do
    Bytes[I] := Random(256);
  SerialNumberEd.Text := IntToStr(Abs(L));
end;

procedure TLCLCodeGenerateFrm.ParametersChanged(Sender: TObject);
begin
  RegCodeEd.Text := '';
end;

procedure TLCLCodeGenerateFrm.RegStrCopySbClick(Sender: TObject);
var
  OldSelStart: Integer;
begin
  if (RegStrEd.SelLength > 0) then
    RegStrEd.CopyToClipboard
  else begin
    OldSelStart := RegStrEd.SelStart;
    RegStrEd.SelStart := 0;
    RegStrEd.SelLength := MaxInt;
    RegStrEd.CopyToClipboard;
    RegStrEd.SelStart := OldSelStart;
    RegStrEd.SelLength := 0;
  end;
end;

{!!.04}
procedure TLCLCodeGenerateFrm.DateEdKeyPress(Sender: TObject; var Key: Char);
begin
  if (not (Key in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', DateSeparator])) and (not (Key < #32)) then begin
    {$IFDEF MSWINDOWS}MessageBeep(0);{$ENDIF}
    Key := #0;
  end;
end;

procedure TLCLCodeGenerateFrm.NumberEdKeyPress(Sender: TObject; var Key: Char);
const
  CIntChars = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
begin
  if (not (Key in CIntChars)) and (not (Key < #32)) then begin
    {$IFDEF MSWINDOWS}MessageBeep(0);{$ENDIF}
    Key := #0;
  end;
end;

procedure TLCLCodeGenerateFrm.ModifierEdKeyPress(Sender: TObject; var Key: Char);
const
  CHexChars = ['$', 'A', 'B', 'C', 'D', 'E', 'F', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
begin
  if (not (Key in CHexChars)) and (not (Key < #32)) then begin
    {$IFDEF MSWINDOWS}MessageBeep(0);{$ENDIF}
    Key := #0;
  end;
end;

procedure TLCLCodeGenerateFrm.RegCodeCopySbClick(Sender: TObject);
var
  OldSelStart: Integer;
begin
  if (RegCodeEd.SelLength > 0) then
    RegCodeEd.CopyToClipboard
  else begin
    OldSelStart := RegCodeEd.SelStart;
    RegCodeEd.SelStart := 0;
    RegCodeEd.SelLength := MaxInt;
    RegCodeEd.CopyToClipboard;
    RegCodeEd.SelStart := OldSelStart;
    RegCodeEd.SelLength := 0;
  end;
end;

procedure TLCLCodeGenerateFrm.TabbedNotebook1Change(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
  AllowChange := True;

  RegCodeEd.Text := '';
  NoModifierCb.Checked := True;
  ModifierEd.Text := '';
end;

procedure TLCLCodeGenerateFrm.GenerateKeySbClick(Sender: TObject);
var
  F    : TLCLKeyMaintFrm;
begin
  F := TLCLKeyMaintFrm.Create(Self);
  try
    F.SetKey(FKey);
    F.KeyType := FKeyType;
    F.KeyFileName := FKeyFileName;
    F.ShowHint := ShowHint;
    if F.ShowModal = mrOK then begin
      F.GetKey(FKey);
      BlockKeyEd.Text := BufferToHex(FKey, SizeOf(FKey));
      if HexStringIsZero(BlockKeyEd.Text)then
        BlockKeyEd.Text := '';
      FKeyType := F.KeyType;
      FKeyFileName := F.KeyFileName;
      InfoChanged(Self);
    end;
  finally
    F.Free;
  end;
end;

procedure TLCLCodeGenerateFrm.SetCodeType(Value : TCodeType);
begin
  if Value <> TCodeType(CodesNbk.PageIndex) then begin
    FCodeType := Value;
    CodesNbk.PageIndex := Ord(FCodeType);
  end;
end;

procedure TLCLCodeGenerateFrm.SetKey(Value : TKey);
begin
  FKey := Value;
  BlockKeyEd.Text := BufferToHex(FKey, SizeOf(FKey));
  if HexStringIsZero(BlockKeyEd.Text)then
    BlockKeyEd.Text := '';
end;

procedure TLCLCodeGenerateFrm.InfoChanged(Sender: TObject);
begin
  GenerateBtn.Enabled := HexToBuffer(BlockKeyEd.Text, FKey, SizeOf(FKey));
  OKBtn.Enabled := Length(RegCodeEd.Text) > 0;
end;

{$IFDEF MSWINDOWS}
procedure TLCLCodeGenerateFrm.OGMCheck(var Msg : TMessage);
var
  F    : TLCLKeyMaintFrm;
begin
  if not HexToBuffer(BlockKeyEd.Text, FKey, SizeOf(FKey)) then begin
    {get a key}
    F := TLCLKeyMaintFrm.Create(Self);
    try
      F.SetKey(FKey);
      F.KeyType := ktRandom;
      F.KeyFileName := FKeyFileName;
      F.ShowHint := ShowHint;
      if F.ShowModal = mrOK then begin
        F.GetKey(FKey);
        BlockKeyEd.Text := BufferToHex(FKey, SizeOf(FKey));
        if HexStringIsZero(BlockKeyEd.Text)then
          BlockKeyEd.Text := '';
        FKeyFileName := F.KeyFileName;
        InfoChanged(Self);
      end else
        PostMessage(Handle, OGM_QUIT, 0, 0);
    finally
      F.Free;
    end;
  end;
end;

procedure TLCLCodeGenerateFrm.OGMQuit(var Msg : TMessage);
begin
  ModalResult := mrCancel;
end;
{$ENDIF}

procedure TLCLCodeGenerateFrm.FormShow(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  PostMessage(Handle, OGM_CHECK, 0, 0);
  {$ENDIF}
end;

procedure TLCLCodeGenerateFrm.GetKey(var Value : TKey);
begin
  Value := FKey;
end;

end.
