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
{*                  ONGUARD6.PAS 1.15                    *}
{*     Copyright (c) 1996-02 TurboPower Software Co      *}
{*                 All rights reserved.                  *}
{*********************************************************}

{$I ..\onguard.inc}

unit FMX.onguard6;
  {-Code generation dialog}

interface

uses
  {$IFDEF MSWINDOWS} Windows, {$ENDIF}
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.ExtCtrls,
  FMX.Layouts, FMX.Edit, FMX.Platform, Fmx.StdCtrls, FMX.Header, FMX.Graphics,
  FMX.DateTimeCtrls, FMX.ComboEdit, FMX.CalendarEdit, FMX.Controls.Presentation,
  OgConst, OgUtil, FMX.OnGuard,
  DesignIntf,
  DesignEditors;


type
  TFMXModifierFrm = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    GroupBox1: TGroupBox;
    UniqueModifierCb: TCheckBox;
    MachineModifierCb: TCheckBox;
    DateModifierCb: TCheckBox;
    NoModifierCb: TCheckBox;
    ModifierEd: TEdit;
    ModDateCalendarEdit: TCalendarEdit;
    procedure FormCreate(Sender: TObject);
    procedure ModifierClick(Sender: TObject);
    procedure InfoChanged(Sender: TObject);
  private
  public
    Modifier : LongInt;
  end;


type
  {property editor for ranges}
  TOgFMXModifierProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes;
      override;
    function GetValue : string;
      override;
    procedure Edit;
      override;
  end;


implementation

{$R *.fmx}

procedure TFMXModifierFrm.FormCreate(Sender: TObject);
begin
  NoModifierCb.IsChecked := True;
  ModDateCalendarEdit.Date := Date();
  InfoChanged(nil);
end;

procedure TFMXModifierFrm.ModifierClick(Sender: TObject);
const
  Busy : Boolean = False;
var
  L : LongInt;
  D : TDateTime;
begin
  if Busy then
    Exit;

  {set busy flag so that setting "Checked" won't recurse}
  Busy := True;
  try
    L := 0;

    if (Sender = NoModifierCb) and NoModifierCb.IsChecked then begin
      UniqueModifierCb.IsChecked := False;
      MachineModifierCb.IsChecked := False;
      DateModifierCb.IsChecked := False;
    end else
      NoModifierCb.IsChecked := False;

    if not UniqueModifierCb.IsChecked and
       not MachineModifierCb.IsChecked and
       not DateModifierCb.IsChecked then
      NoModifierCb.IsChecked := True;

    if MachineModifierCb.IsChecked then begin
      if L = 0 then
        L := GenerateMachineModifierPrim
      else
        L := L xor GenerateMachineModifierPrim;
    end;

    {set status of date field}
    ModDateCalendarEdit.Enabled := DateModifierCb.IsChecked;

    if DateModifierCb.IsChecked then begin
      try
        D := ModDateCalendarEdit.Date;
      except
        {ignore errors and don't generate modifier}
        D := 0;
      end;

      if Trunc(D) > 0 then begin
        if L = 0 then
          L := GenerateDateModifierPrim(D)
        else
          L := L xor GenerateDateModifierPrim(D);
      end;
    end;

    if UniqueModifierCb.IsChecked then begin
      if L = 0 then
        L := GenerateUniqueModifierPrim
      else
        L := L xor GenerateUniqueModifierPrim;
    end;

    if L = 0 then
      ModifierEd.Text := ''
    else
      ModifierEd.Text := '$' + BufferToHex(L, 4);

    InfoChanged(nil);
  finally
    Busy := False;
  end;
end;

procedure TFMXModifierFrm.InfoChanged(Sender: TObject);
begin
  OKBtn.Enabled := (Length(ModifierEd.Text) > 0) and
    HexToBuffer(ModifierEd.Text, Modifier, SizeOf(Modifier));
end;

{*** TOgFMXModifierProperty ***}

function TOgFMXModifierProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

function TOgFMXModifierProperty.GetValue : string;
begin
  Result := inherited GetValue;
end;

procedure TOgFMXModifierProperty.Edit;
begin
  with TFMXModifierFrm.Create(Application) do
    try
      if ShowModal = mrOK then
        Value := BufferToHex(Modifier, SizeOf(Modifier));
    finally
      Free;
    end;
end;

end.
