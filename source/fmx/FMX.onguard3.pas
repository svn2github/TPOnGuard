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
 * ***** END LICENSE BLOCK ***** *)
{*********************************************************}
{*                  ONGUARD3.PAS 1.15                    *}
{*     Copyright (c) 1996-02 TurboPower Software Co      *}
{*                 All rights reserved.                  *}
{*********************************************************}

{$I ..\onguard.inc}

unit FMX.onguard3;
  {-Key selection and maintenance}

interface

uses

  System.SysUtils, System.Types, System.UITypes, System.Classes, System.IniFiles,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Objects,
  FMX.ExtCtrls, FMX.ListBox, FMX.Layouts, FMX.Edit, FMX.Platform,
  Fmx.StdCtrls, FMX.Header, FMX.Graphics,
  ogconst,
  ogutil,
  FMX.onguard,
  FMX.onguard1,
  FMX.onguard4, FMX.Controls.Presentation;

type
  TFMXKeyMaintFrm = class(TForm)
    ProductsGb: TGroupBox;
    ProductsLb: TListBox;
    AddBtn: TButton;
    DeleteBtn: TButton;
    EditBtn: TButton;
    OKBtn: TButton;
    CancelBtn: TButton;
    OpenBtn: TButton;
    OpenDialog1: TOpenDialog;
    FileNameGb: TGroupBox;
    FileNameEd: TEdit;
    OpenFileSb: TSpeedButton;
    GroupBox1: TGroupBox;
    BlockKeyEd: TEdit;
    BytesKeyEd: TEdit;
    CopyBlockKeySb: TSpeedButton;
    CopyByteKeySb: TSpeedButton;
    KeyPasteSb: TSpeedButton;
    SpeedButton1: TSpeedButton;
    procedure AddBtnClick(Sender: TObject);
    procedure EditBtnClick(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure InfoChanged(Sender: TObject);
    procedure KeyCopySbClick(Sender: TObject);
    procedure OpenFileSbClick(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
    procedure ProductsLbDblClick(Sender: TObject);
    procedure CopyByteKeySbClick(Sender: TObject);
    procedure KeyPasteSbClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    function GetListBoxItemIndex : integer;                          {!!.07}
  private
    { Private declarations }
    FKey         : TKey;
    FKeyType     : TKeyType;

    function GetKeyFileName : string;
    procedure SetKeyFileName(Value : string);

  public
    { Public declarations }
    procedure SetKey(Value : TKey);                                  {!!.08}
    procedure GetKey(var Value : TKey);                              {!!.08}

    property KeyFileName : string
      read GetKeyFileName
      write SetKeyFileName;

    property KeyType : TKeyType
      read FKeyType
      write FKeyType;

  end;

implementation

{$R *.fmx}

{!! This function is required to get round a bug in Delphi 4}        {!!.07}
function TFMXKeyMaintFrm.GetListBoxItemIndex : integer;                 {!!.07}
begin                                                                {!!.07}
  if (ProductsLB.Items.Count = 0) then                               {!!.07}
    Result := -1                                                     {!!.07}
  else                                                               {!!.07}
    {Result := SendMessage(ProductsLB.Handle, LB_GETCURSEL, 0, 0);}  {!!.07}
    {Note: The above doesn't work - cannot delete item 0}            {!!.07}
    {      This works but looks odd in D4 so still a bug}            {!!.07}
    Result := ProductsLB.ItemIndex;                                  {!!.07}
end;                                                                 {!!.07}

procedure TFMXKeyMaintFrm.FormCreate(Sender: TObject);
begin
  InfoChanged(Sender);
end;

procedure TFMXKeyMaintFrm.InfoChanged(Sender: TObject);
var
  I       : Integer;
  IniFile : TIniFile;
begin
  OpenBtn.Enabled := Length(FileNameEd.Text) > 0;
  FillChar(FKey, SizeOf(FKey), 0);

  if Length(KeyFileName) > 0 then begin
    IniFile := TIniFile.Create(KeyFileName);
    try
      I := GetListBoxItemIndex;                                      {!!.07}
      ProductsLb.Items.BeginUpdate;
      try
        ProductsLb.Items.Clear;
        IniFile.ReadSection(OgKeySection, ProductsLb.Items);
        if I < ProductsLb.Items.Count then
          ProductsLb.ItemIndex := I                                  {!!.07}
        else begin                                                   {!!.07}
          ProductsLb.ItemIndex := pred(ProductsLb.Items.Count);      {!!.07}
          I := GetListBoxItemIndex;                                  {!!.07}
        end;                                                         {!!.07}

        if (I > -1) then begin                                       {!!.07}
          EditBtn.Enabled := True;                                   {!!.07}
          DeleteBtn.Enabled := True;                                 {!!.07}
          BlockKeyEd.Text := IniFile.ReadString(OgKeySection,
            ProductsLb.Items[I], '');                                {!!.07}

          HexToBuffer(BlockKeyEd.Text, FKey, SizeOf(FKey));

          BlockKeyEd.Text := BufferToHex(FKey, SizeOf(FKey));
          BytesKeyEd.Text := BufferToHexBytes(FKey, SizeOf(FKey));

          if HexStringIsZero(BlockKeyEd.Text)then
            BlockKeyEd.Text := '';
          if HexStringIsZero(BytesKeyEd.Text)then
            BytesKeyEd.Text := '';
        end else begin                                               {!!.07}
          EditBtn.Enabled := False;                                  {!!.07}
          DeleteBtn.Enabled := False;                                {!!.07}
        end;                                                         {!!.07}
      finally
        ProductsLb.Items.EndUpdate;
      end;
    finally
      IniFile.Free;
    end;
  end else
    ProductsLb.Items.Clear;

  OKBtn.Enabled := HexToBuffer(BlockKeyEd.Text, FKey, SizeOf(FKey));
end;

procedure TFMXKeyMaintFrm.AddBtnClick(Sender: TObject);
var
  F       : TFMXEditProductFrm;
  IniFile : TIniFile;
begin
  F := TFMXEditProductFrm.Create(Self);
  try
    F.SetKey(FKey);
    F.KeyType := FKeyType;
    {$IFDEF MSWINDOWS}
    //F.ShowHint := ShowHint;
    {$ENDIF}
    if F.ShowModal = mrOK then begin
      IniFile := TIniFile.Create(KeyFileName);
      try
        IniFile.WriteString(OgKeySection, F.ProductEd.Text, F.KeyEd.Text);
      finally
        IniFile.Free;
      end;
      F.GetKey(FKey);
      FKeyType := F.KeyType;
    end;
  finally
    F.Free;
  end;

  InfoChanged(Self);
end;

procedure TFMXKeyMaintFrm.EditBtnClick(Sender: TObject);
var
  F       : TFMXEditProductFrm;
  IniFile : TIniFile;
begin
  F := TFMXEditProductFrm.Create(Self);
  try
    F.SetKey(FKey);
    F.KeyType := FKeyType;
    {$IFDEF MSWINDOWS}
    //F.ShowHint := ShowHint;
    {$ENDIF}
    IniFile := TIniFile.Create(KeyFileName);
    try
      F.ProductEd.Text := ProductsLb.Items[GetListBoxItemIndex];     {!!.07}
      F.KeyEd.Text := BufferToHex(FKey, SizeOf(FKey));
      if F.ShowModal = mrOK then
        IniFile.WriteString(OgKeySection, F.ProductEd.Text, F.KeyEd.Text);
    finally
      IniFile.Free;
    end;
  finally
    F.Free;
  end;

  InfoChanged(Self);
end;

procedure TFMXKeyMaintFrm.DeleteBtnClick(Sender: TObject);
var
  IniFile : TIniFile;
  I       : Integer;
begin
  I := GetListBoxItemIndex;                                          {!!.07}
  if (I > -1) then                                                   {!!.07}
    if MessageDlg(SCDeleteQuery,
                  TMsgDlgType.mtConfirmation,
                  mbYesNo, 0) = mrYes then begin
      {$IFDEF MSWINDOWS}
      IniFile := TIniFile.Create(KeyFileName);
      try
        IniFile.DeleteKey(OgKeySection, ProductsLb.Items[I]);        {!!.07}
      finally
        IniFile.Free;
      end;
      {$ENDIF}
      BlockKeyEd.Text := '';
      BytesKeyEd.Text := '';

      InfoChanged(Self);
    end;
end;

procedure TFMXKeyMaintFrm.KeyCopySbClick(Sender: TObject);
var
  OldSelStart: Integer;
begin
  OldSelStart := BlockKeyEd.SelStart;
  BlockKeyEd.SelStart := 0;
  BlockKeyEd.SelLength := MaxInt;
  BlockKeyEd.CopyToClipboard;
  BlockKeyEd.SelStart := OldSelStart;
  BlockKeyEd.SelLength := 0;
end;

procedure TFMXKeyMaintFrm.CopyByteKeySbClick(Sender: TObject);
var
  OldSelStart: Integer;
begin
  OldSelStart := BytesKeyEd.SelStart;
  BytesKeyEd.SelStart := 0;
  BytesKeyEd.SelLength := MaxInt;
  BytesKeyEd.CopyToClipboard;
  BytesKeyEd.SelStart := OldSelStart;
  BytesKeyEd.SelLength := 0;
end;

procedure TFMXKeyMaintFrm.OpenFileSbClick(Sender: TObject);begin
  OpenDialog1.FileName := FileNameEd.Text;
  if OpenDialog1.Execute then begin
    FileNameEd.Text := OpenDialog1.FileName;
    InfoChanged(Sender);
  end;
end;

function TFMXKeyMaintFrm.GetKeyFileName : string;
begin
  Result := FileNameEd.Text;
end;

procedure TFMXKeyMaintFrm.SetKeyFileName(Value : string);
begin
  FileNameEd.Text := Value;
  InfoChanged(Self);
end;

procedure TFMXKeyMaintFrm.OpenBtnClick(Sender: TObject);
begin
  OpenDialog1.FileName := FileNameEd.Text;
  FileNameEd.Text := OpenDialog1.FileName;
  InfoChanged(Sender);
end;

procedure TFMXKeyMaintFrm.ProductsLbDblClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TFMXKeyMaintFrm.KeyPasteSbClick(Sender: TObject);
begin
  BlockKeyEd.PasteFromClipboard;
  HexToBuffer(BlockKeyEd.Text, FKey, SizeOf(FKey));
  BlockKeyEd.Text := BufferToHex(FKey, SizeOf(FKey));
  BytesKeyEd.Text := BufferToHexBytes(FKey, SizeOf(FKey));
end;

procedure TFMXKeyMaintFrm.SpeedButton1Click(Sender: TObject);
begin
  BytesKeyEd.PasteFromClipboard;
  HexToBuffer(BytesKeyEd.Text, FKey, SizeOf(FKey));
  BytesKeyEd.Text := BufferToHexBytes(FKey, SizeOf(FKey));
  BlockKeyEd.Text := BufferToHex(FKey, SizeOf(FKey));
end;

procedure TFMXKeyMaintFrm.GetKey(var Value : TKey);                     {!!.08}
begin
  Value := FKey;
end;

procedure TFMXKeyMaintFrm.SetKey(Value : TKey);                         {!!.08}
begin
  FKey := Value;
end;


end.

