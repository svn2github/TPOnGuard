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

{$IFDEF Win32} {$R ogreg.r32} {$ENDIF}

interface

procedure Register;

implementation

uses
  Classes, {Forms,} ogabout0,
  ogconst, ogfile, ognetwrk, ogproexe, ogfirst,
  onguard,
  onguard2,
  onguard3,
  onguard5,
  onguard6,
  onguard7,
  ogutil,                                                            {!!.12}
{$IFDEF DELPHI6UP}                                                      {!!.13}
  DesignIntf,
  DesignEditors;
{$ELSE}
  dsgnintf;
{$ENDIF}

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
    with TCodeGenerateFrm.Create(Application) do
      try
        ShowHint := True;
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
    with TKeyMaintFrm.Create(Application) do
      try
        ShowHint := True;
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
  RegisterComponentEditor(TOgFMXCodeBase, TOgFMXCodeGenEditor);

  RegisterPropertyEditor(
    TypeInfo(string), TOgFMXMakeKeys, 'KeyFileName', TOgFileNameProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOgFMXMakeCodes, 'KeyFileName', TOgFileNameProperty);
{  RegisterPropertyEditor( }                                          {!!.09}
{    TypeInfo(string), TOgCodeBase, 'Expires', TOgExpiresProperty);}  {!!.09}
  RegisterPropertyEditor(
    TypeInfo(string), TOgFMXCodeBase, 'Code', TOgCodeProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOgFMXCodeBase, 'Modifier', TOgModifierProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOgFMXCodeBase, 'About', TOgAboutProperty);       {!!.08}
  RegisterPropertyEditor(
    TypeInfo(string), TOgFMXProtectExe, 'About', TOgAboutProperty);     {!!.08}
  RegisterPropertyEditor(
    TypeInfo(string), TOgFMXMakeCodes, 'About', TOgAboutProperty);      {!!.08}
  RegisterPropertyEditor(
    TypeInfo(string), TOgFMXMakeKeys, 'About', TOgAboutProperty);       {!!.08}

  RegisterComponents('OnGuard FMX', [
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