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
 *                       February 17 2015
 *
 *
 *
 * ***** END LICENSE BLOCK ***** *)
{*********************************************************}
{*                  OGPROEXE.PAS 1.15                    *}
{*     Copyright (c) 1996-02 TurboPower Software Co      *}
{*                 All rights reserved.                  *}
{*********************************************************}

{$I onguard.inc}


{$IFDEF FPC}
{$mode delphi}{$H+}
{$ASMMODE INTEL}
{$ENDIF}
unit ogstamp;

interface

{$IFNDEF OgProExeUsed}
type
  {exe signature record}
  PSignatureRec = ^TSignatureRec;
  TSignatureRec = packed record
    Sig1   : DWord;                                                  {!!.07}
    Sig2   : DWord;                                                  {!!.07}
    Sig3   : DWord;                                                  {!!.07}
    Offset : DWord;                                                  {!!.07}
    Size   : DWord;                                                  {!!.07}
    CRC    : DWord;                                                  {!!.07}
    Sig4   : DWord;                                                  {!!.07}
    Sig5   : DWord;                                                  {!!.07}
    Sig6   : DWord;                                                  {!!.07}
  end;

{signature = '!~~@CRC32@~~' used before and after}
const
  StoredSignature : TSignatureRec = (
    Sig1:$407E7E21;  Sig2:$33435243;  Sig3:$7E7E4032;
    Offset:1;  Size:2;  CRC:3;
    Sig4:$407E7E21;  Sig5:$33435243;  Sig6:$7E7E4032);

{$DEFINE OgProExeStampUsed}
{$ENDIF}

implementation

end.
