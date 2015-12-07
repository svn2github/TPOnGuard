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
 *
 * Boguslaw Brandys      brandys@o2.pl
 *                       conversion to Free Pascal
 *                       June 04, 2006
 *
 * Andrew Haines         andrew@haines.name                        {AH.02}
 *                       64 bit support added                      {AH.02}
 *                       December 6, 2015                          {AH.02}
 *
 *
 * ***** END LICENSE BLOCK ***** *)
{*********************************************************}
{*                  OGPROEXE.PAS 1.15                    *}
{*     Copyright (c) 1996-02 TurboPower Software Co      *}
{*                 All rights reserved.                  *}
{*********************************************************}
(*
   2015-Mar-10:
   All types, functions, and procedures were moved to ogproexeutil.pas
   to facilitate the separation of the visual component and the library code.
   This should make the component conversion much simpler.
*)

{$I onguard.inc}


{$IFDEF FPC}
{$mode delphi}{$H+}
{$ASMMODE INTEL}
{$ENDIF}
unit ogproexe;

interface

{$IFDEF KYLIX}{$MESSAGE WARN 'Kylix not supported.'}{$ENDIF}
{$IFDEF LINUX}{$MESSAGE WARN 'Linux not supported.'}{$ENDIF}
{$IFDEF FREESBD}{$MESSAGE WARN 'FreeBSD not supported.'}{$ENDIF}
{$IFDEF ANDROID}{$MESSAGE WARN 'Android not supported.'}{$ENDIF}
{$IFDEF IOS}{$MESSAGE WARN 'IOS not supported.'}{$ENDIF}
{$IFDEF MACOS}{$MESSAGE WARN 'Mac OSX not supported.'}{$ENDIF}

uses
  {$IFDEF Win16} WinTypes, WinProcs, {$ENDIF}
  {$IFDEF Win32} Windows, {$ENDIF}
  {$IFDEF Win64} Windows, {$ENDIF}                                 {AH.02}
  {$IFDEF LINUX} Libc, {$ENDIF}                                    {AH.01}
  {$IFDEF UsingCLX} Types, {$ENDIF}                                {AH.01}
  Classes, {$IFDEF MSWINDOWS}MMSystem, {$ENDIF} SysUtils,
  ogconst, ogutil, ogstamp, ogproexeutil;

type
  TCheckedExeEvent =
    procedure(Sender : TObject; Status : TExeStatus)
    of object;

  TOgProtectExe = class(TComponent)
  protected {private}
    {property variables}
    FAutoCheck  : Boolean;
    FCheckSize  : Boolean;

    {event variables}
    FOnChecked  : TCheckedExeEvent;

    {property methods}
    function GetAbout : string;                                      {!!.08}
    procedure SetAbout(const AValue : string);                        {!!.08}

  protected
    procedure DoOnChecked(Status : TExeStatus);
      dynamic;
    procedure Loaded;
      override;

  public
    constructor Create(AOwner : TComponent);
      override;
    function CheckExe(Report : Boolean) : TExeStatus;
      {-test the exe file for tampering}
    function StampExe(const FileName : string ;  EraseMarker : Boolean) : Boolean;
      {-stamp exe with crc and file size. optionally erase search markers}
    function UnStampExe(const FileName : string) : Boolean;
      {-writes uninitialized signature record. marker must not have been erased}

  published
    {properties}
    property AutoCheck : Boolean
      read FAutoCheck
      write FAutoCheck
      default DefAutoCheck;

    property CheckSize : Boolean
      read FCheckSize
      write FCheckSize
      default DefCheckSize;

    property About : string                                          {!!.08}
      read GetAbout                                                  {!!.08}
      write SetAbout                                                 {!!.08}
      stored False;

    {events}
    property OnChecked : TCheckedExeEvent
      read FOnChecked
      write FOnChecked;
  end;


implementation

{*** TOgProtectExe ***}

constructor TOgProtectExe.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FAutoCheck := DefAutoCheck;
  FCheckSize := DefCheckSize;
end;

function TOgProtectExe.CheckExe(Report : Boolean) : TExeStatus;
begin
  Result := IsExeTampered(FCheckSize);

  if Report then DoOnChecked(Result);
end;

procedure TOgProtectExe.DoOnChecked(Status : TExeStatus);
begin
  if Assigned(FOnChecked) then FOnChecked(Self, Status);
end;

function TOgProtectExe.GetAbout : string;                            {!!.08}
begin
  Result := OgVersionStr;
end;

procedure TOgProtectExe.Loaded;
begin
  inherited Loaded;

  if FAutoCheck then CheckExe(True);
end;

procedure TOgProtectExe.SetAbout(const AValue : string);              {!!.08}
begin
  // do nothing
end;

function TOgProtectExe.StampExe(const FileName : string ;  EraseMarker : Boolean) : Boolean;
begin
  Result := ProtectExe(FileName,  EraseMarker);
end;

function TOgProtectExe.UnStampExe(const FileName : string) : Boolean;
begin
  Result := UnprotectExe(FileName);
end;


end.
