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
 *                       January 1, 2004                           {AH.01}
 * Boguslaw Brandys      conversion to FPC
 *                       June 14, 2006
 *
 * Andrew Haines         andrew@haines.name                        {AH.02}
 *                       64 bit support added                      {AH.02}
 *                       December 6, 2015                          {AH.02}
 *
 *
 * ***** END LICENSE BLOCK ***** *)
{*********************************************************}
{*                  OGFIRST.PAS 1.15                     *}
{*     Copyright (c) 1996-02 TurboPower Software Co      *}
{*                 All rights reserved.                  *}
{*********************************************************}

{$I ..\onguard.inc}

unit FMX.ogfirst;
  {-limit instance routines}

interface

uses
  {$IFDEF MSWINDOWS} Windows, {$ENDIF}
  FMX.Forms,
  SysUtils;

{detect/Activate instance routines}
function IsFirstInstance: Boolean;
procedure ActivateFirstInstance;
{!!.04} {revised Win16 version}


implementation


{$IFDEF MSWINDOWS}
var
  FirstInstance : Boolean;
  InstanceMutex : THandle;
{$ENDIF}

{limit instances routines}
function IsFirstInstance : Boolean;
begin
  Result := True; // true so unsupported platforms should still work
  {$IFDEF Win32} Result := FirstInstance; {$ENDIF}
  {$IFDEF Win64} Result := FirstInstance; {$ENDIF}
  {$IFDEF LINUX} Result := FirstInstance; {$ENDIF}
end;

{$IFDEF Win32}
procedure ActivateFirstInstance;
(*
var
  ClassBuf,
  WindowBuf : array [0..255] of Char;
  Wnd,
  TopWnd    : hWnd;
  ThreadID  : DWord;                                                 {!!.07}
*)
begin
(*
  if IsFirstInstance then begin
    if IsIconic(Application.Handle) then
      Application.Restore
    else
      Application.BringToFront;
  end else begin
    GetClassName(Application.Handle, ClassBuf, Length(ClassBuf));
    GetWindowText(Application.Handle, WindowBuf, Length(WindowBuf));
    Wnd := FindWindow(ClassBuf, WindowBuf);
    if (Wnd <> 0) then begin
      GetWindowThreadProcessId(Wnd, @ThreadID);
      if (ThreadID = GetCurrentProcessId) then begin
        Wnd := FindWindowEx(0, Wnd, ClassBuf, WindowBuf);
        if (Wnd <> 0) then
          if IsIconic(Wnd) then
            ShowWindow(Wnd, SW_RESTORE)
          else begin
            SetForegroundWindow(Wnd);                                {!!.09}
            TopWnd := GetLastActivePopup(Wnd);
            if (TopWnd <> 0) and (TopWnd <> Wnd) and
                IsWindowVisible(TopWnd) and IsWindowEnabled(TopWnd) then
              BringWindowToTop(TopWnd)
            else
              BringWindowToTop(Wnd);
          end;
      end;
    end;
  end;
*)
end;
{$ENDIF}

{$IFDEF Win64}
procedure ActivateFirstInstance;
(*
var
  ClassBuf,
  WindowBuf : array [0..255] of Char;
  Wnd,
  TopWnd    : hWnd;
  ThreadID  : DWord;                                                 {!!.07}
*)
begin
(*
  if IsFirstInstance then begin
    if IsIconic(Application.Handle) then
      Application.Restore
    else
      Application.BringToFront;
  end else begin
    GetClassName(Application.Handle, ClassBuf, Length(ClassBuf));
    GetWindowText(Application.Handle, WindowBuf, Length(WindowBuf));
    Wnd := FindWindow(ClassBuf, WindowBuf);
    if (Wnd <> 0) then begin
      GetWindowThreadProcessId(Wnd, @ThreadID);
      if (ThreadID = GetCurrentProcessId) then begin
        Wnd := FindWindowEx(0, Wnd, ClassBuf, WindowBuf);
        if (Wnd <> 0) then
          if IsIconic(Wnd) then
            ShowWindow(Wnd, SW_RESTORE)
          else begin
            SetForegroundWindow(Wnd);                                {!!.09}
            TopWnd := GetLastActivePopup(Wnd);
            if (TopWnd <> 0) and (TopWnd <> Wnd) and
                IsWindowVisible(TopWnd) and IsWindowEnabled(TopWnd) then
              BringWindowToTop(TopWnd)
            else
              BringWindowToTop(Wnd);
          end;
      end;
    end;
  end;
*)
end;
{$ENDIF}

{$IFDEF MACOS}
procedure ActivateFirstInstance;
begin
 //[to do] Find and Activate the first instance of the application

 //look at the owner of the socket
 //look at the running processes
end;
{$ENDIF}

{$IFDEF IOS}
procedure ActivateFirstInstance;
begin
 //[to do] Find and Activate the first instance of the application

 //look at the owner of the socket
 //look at the running processes
end;
{$ENDIF}

{$IFDEF ANDROID}
procedure ActivateFirstInstance;
begin
 //[to do] Find and Activate the first instance of the application

 //look at the owner of the socket
 //look at the running processes
end;
{$ENDIF}


{$IFDEF MSWINDOWS}
function GetMutexName : string;
//var
//  WindowBuf : array [0..512] of Char;
begin
  //GetWindowText(Application.Handle, WindowBuf, Length(WindowBuf));
  //Result := 'PREVINST:' + WindowBuf;
  Result := 'PREVINST:' + ExtractFileName(ParamStr(0)) + Application.Title;
end;

initialization
  InstanceMutex := CreateMutex(nil, True, PChar(GetMutexName));
  if (InstanceMutex <> 0) and (GetLastError = 0) then
    FirstInstance := True
  else
    FirstInstance := False;

finalization
  if (InstanceMutex <> 0) then
    CloseHandle(InstanceMutex);
{$ENDIF}

end.
