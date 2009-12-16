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
{*                  ONGUARD.INC 1.13                     *}
{*     Copyright (c) 1996-02 TurboPower Software Co      *}
{*                 All rights reserved.                  *}
{*********************************************************}

{Conditional defines that affect compilation}

{General define indicating use under C++ Builder}
{$IFDEF VER93}
  {$DEFINE CBuilder}
{$ENDIF}
{$IFDEF VER110}
  {$DEFINE CBuilder}
  {For BCB 3.0 package support.}
  {$ObjExportAll On}
{$ENDIF}
{$IFDEF VER125}                                                        {!!.10}
  {$DEFINE CBuilder}
  {$ObjExportAll On}
{$ENDIF}
{$IFDEF VER130}                                                        {!!.10}
  {$IFDEF BCB}
    {$DEFINE CBuilder}
    {$ObjExportAll On}
  {$ENDIF}
{$ENDIF}

{$IFNDEF VER80}
 {$IFNDEF VER90}
  {$IFNDEF VER93}
    {$DEFINE VERSION3} { Delphi 3.0 or BCB 3.0 or higher }             {!!.06}
  {$ENDIF}
 {$ENDIF}
{$ENDIF}

{$IFDEF VERSION3}
 {$IFNDEF VER100}     {Delphi 3}
  {$IFNDEF VER110}    {BCB 3}
   {$DEFINE VERSION4} {Delphi 4.0 or higher}                           {!!.07}
  {$ENDIF}
 {$ENDIF}
{$ENDIF}

{$IFDEF VER130}               { Delphi 5 & C++ Builder 5 }
  {$DEFINE VERSION5}
 {$IFDEF BCB}                 { C++ Builder 5 }
  {$DEFINE CBuilder}
  {$ObjExportAll On}
 {$ENDIF}
{$ENDIF}

{$IFDEF VER140}               { Delphi 6 & Bcb 6 }
  {$DEFINE VERSION6}
 {$IFDEF BCB}
  {$DEFINE CBuilder}
  {$ObjExportAll On}
 {$ENDIF}
{$ENDIF}

{$IFDEF VER150}               { Delphi 7 }
  {$DEFINE VERSION6}          { Version 6 or greater }
  {$DEFINE VERSION7}
 {$IFDEF BCB}
  {$DEFINE CBuilder}
  {$ObjExportAll On}
 {$ENDIF}
{$ENDIF}

{$IFDEF CBuilder)
  {$A+} {Word Align Data}
{$ELSE}
  {$IFDEF Win32}
    {$A+} {Word Align Data}
  {$ELSE}
    {$A-} {Byte Align Data}
  {$ENDIF}
{$ENDIF}

{$Q-} {Overflow Checking}
{$R-} {Range-Checking}
{$S-} {Stack-Overflow Checking}
{$V-} {Var-String Checking}

{$IFNDEF Win32}
  {$F-} {Force Far Calls}
  {$K-} {Smart Callbacks}
{$ENDIF}


{====General defines=================================================}

{!!.10}
{Activate the following define to prevent the TOgMakeCodes Form being
 compiled into the exe. }

{.$DEFINE NoMakeCodesSupport}


{!!.10}
{Activate the following define to prevent the TOgMakeKeys Form being
 compiled into the exe. }

{.$DEFINE NoMakeKeysSupport}


