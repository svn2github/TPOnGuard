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
{*                   OGREG.PAS 1.15                      *}
{*     Copyright (c) 1996-02 TurboPower Software Co      *}
{*                 All rights reserved.                  *}
{*********************************************************}

{$I ../onguard.inc}

unit FMX.ogreg;

{$IFDEF MSWINDOWS} {$R ..\ogreg.r32} {$ENDIF}

interface

procedure Register;

implementation

uses
  Classes,
  FMX.Types, FMX.Forms, FMX.Controls,
  ogutil, ogconst, ogfile,
  FMX.ogfirst,
  FMX.ogabout0,
  FMX.ognetwrk,
  FMX.ogproexe,
  FMX.onguard,
  FMX.onguard2,
  FMX.onguard3,
  FMX.onguard5,
  FMX.onguard6,
  FMX.onguard7,
  DesignIntf,
  DesignEditors;

type
  {component editor for TogCodeBase components}
  TOgFMXCodeGenEditor = class(TDefaultEditor)
  public
    procedure ExecuteVerb(Index : Integer);
      override;
    function GetVerb(Index : Integer) : string;
      override;
    function GetVerbCount : Integer;
      override;
  end;


{*** TOgCodeGenEditor ***}

procedure TOgFMXCodeGenEditor.ExecuteVerb(Index : Integer);
begin
  if Index = 0 then begin
    with TFMXCodeGenerateFrm.Create(Application) do
      try
        //ShowHint := True;
        KeyFileName := OgKeyFile;
        if Component is TOgFMXDateCode then
          CodeType := ctDate
        else if Component is TOgFMXDaysCode then
          CodeType := ctDays
        else if Component is TOgFMXNetCode then
          CodeType := ctNetwork
        else if Component is TOgFMXRegistrationCode then
          CodeType := ctRegistration
        else if Component is TOgFMXSerialNumberCode then
          CodeType := ctSerialNumber
        else if Component is TOgFMXSpecialCode then
          CodeType := ctSpecial
        else if Component is TOgFMXUsageCode then
          CodeType := ctUsage;
        ShowModal;
      finally
        Free;
      end;
  end else if Index = 1 then begin
    with TFMXKeyMaintFrm.Create(Application) do
      try
        //ShowHint := True;
        KeyFileName := 'ONGUARD.INI';
        KeyType := ktRandom;
        ShowModal;
      finally
        Free;
      end;
  end;
end;

function TOgFMXCodeGenEditor.GetVerb(Index : Integer) : string;
begin
  case Index of
    0 : Result := 'Generate Code';
    1 : Result := 'Generate Key';
  else
    Result := '?';
  end;
end;

function TOgFMXCodeGenEditor.GetVerbCount : Integer;
begin
  Result := 2;
end;


{component registration}
procedure Register;
begin
  GroupDescendentsWith(TOgFMXCodeBase, FMX.Controls.TControl);
  GroupDescendentsWith(TOgFMXMakeKeys, FMX.Controls.TControl);
  GroupDescendentsWith(TOgFMXMakeCodes, FMX.Controls.TControl);
  GroupDescendentsWith(TOgFMXDateCode, FMX.Controls.TControl);
  GroupDescendentsWith(TOgFMXDaysCode, FMX.Controls.TControl);
  GroupDescendentsWith(TOgFMXNetCode, FMX.Controls.TControl);
  GroupDescendentsWith(TOgFMXRegistrationCode, FMX.Controls.TControl);
  GroupDescendentsWith(TOgFMXSerialNumberCode, FMX.Controls.TControl);
  GroupDescendentsWith(TOgFMXSpecialCode, FMX.Controls.TControl);
  GroupDescendentsWith(TOgFMXUsageCode, FMX.Controls.TControl);
  GroupDescendentsWith(TOgFMXProtectExe, FMX.Controls.TControl);

  RegisterFMXClasses([TOgFMXCodeBase, TOgFMXMakeKeys, TOgFMXMakeCodes,
                      TOgFMXDateCode, TOgFMXDaysCode, TOgFMXNetCode,
                      TOgFMXRegistrationCode, TOgFMXSerialNumberCode,
                      TOgFMXSpecialCode, TOgFMXUsageCode, TOgFMXProtectExe]);

  RegisterComponentEditor(TOgFMXCodeBase, TOgFMXCodeGenEditor);

  RegisterPropertyEditor(
    TypeInfo(string), TOgFMXMakeKeys, 'KeyFileName', TOgFMXFileNameProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOgFMXMakeCodes, 'KeyFileName', TOgFMXFileNameProperty);
{  RegisterPropertyEditor( }                                          {!!.09}
{    TypeInfo(string), TOgCodeBase, 'Expires', TOgExpiresProperty);}  {!!.09}
  RegisterPropertyEditor(
    TypeInfo(string), TOgFMXCodeBase, 'Code', TOgFMXCodeProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOgFMXCodeBase, 'Modifier', TOgFMXModifierProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOgFMXCodeBase, 'About', TOgFMXAboutProperty);       {!!.08}
  RegisterPropertyEditor(
    TypeInfo(string), TOgFMXProtectExe, 'About', TOgFMXAboutProperty);     {!!.08}
  RegisterPropertyEditor(
    TypeInfo(string), TOgFMXMakeCodes, 'About', TOgFMXAboutProperty);      {!!.08}
  RegisterPropertyEditor(
    TypeInfo(string), TOgFMXMakeKeys, 'About', TOgFMXAboutProperty);       {!!.08}

  RegisterComponents('OnGuard FMX (sf.net)', [
    TOgFMXMakeKeys,
    TOgFMXMakeCodes,
    TOgFMXDateCode,
    TOgFMXDaysCode,
    TOgFMXNetCode,
    TOgFMXRegistrationCode,
    TOgFMXSerialNumberCode,
    TOgFMXSpecialCode,
    TOgFMXUsageCode,
    TOgFMXProtectExe]);

end;

end.