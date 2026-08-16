// =====================================================================================================================
// *** TurboControls LCL Library ***
//
// Copyright (c) 2025-2026 Turborium
// License: Turborium Modified MIT License or GPL v3.
// See LICENSE.txt for the full license text of the Turborium Modified MIT License.
// SPDX-License-Identifier: LicenseRef-Turborium-Modified-MIT OR GPL-3.0-or-later
//
// Note:
//   Users may obtain a commercial version of this software without the requirement
//   to display the "About" notice in their application. Such commercial license is
//   available directly from Turborium under separate terms and conditions.
//
// github.com/turborium/TurboControls
// Telegram: @turborium
// =====================================================================================================================

unit TurboCommonControls;

{$MODE DELPHIUNICODE}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$OVERFLOWCHECKS ON}
{$OPTIMIZATION ON}
{$SCOPEDENUMS ON}

interface

uses
  Classes, SysUtils, Forms, LCLIntf, LMessages;

type

  { TTurboScrollEvent }

  TTurboScrollEvent = procedure(Sender: TObject; ScrollPosition: TPoint) of object;

  { TTurboScrollBox }

  TTurboScrollBox = class(TScrollBox)
  private
    FImmediateScrollUpdate: Boolean;
    FScrollEvent: TTurboScrollEvent;
  protected
    procedure WMHScroll(var Message: TLMHScroll); message LM_HSCROLL;
    procedure WMVScroll(var Message: TLMVScroll); message LM_VSCROLL;
  public
    constructor Create(Owner: TComponent); override;

    procedure ScrollBy(DeltaX, DeltaY: Integer); override;

  published
    property ImmediateScrollUpdate: Boolean read FImmediateScrollUpdate write FImmediateScrollUpdate default True;
    property OnScroll: TTurboScrollEvent read FScrollEvent write FScrollEvent;
  end;

implementation

{ TTurboScrollBox }

constructor TTurboScrollBox.Create(Owner: TComponent);
begin
  inherited Create(Owner);

  FImmediateScrollUpdate := True;
end;

procedure TTurboScrollBox.WMHScroll(var Message: TLMHScroll);
begin
  inherited;

  if Assigned(FScrollEvent) then
  begin
    FScrollEvent(Self, TPoint.Create(HorzScrollBar.Position, VertScrollBar.Position));
  end;
end;

procedure TTurboScrollBox.WMVScroll(var Message: TLMVScroll);
begin
  inherited;

  if Assigned(FScrollEvent) then
  begin
    FScrollEvent(Self, TPoint.Create(HorzScrollBar.Position, VertScrollBar.Position));
  end;
end;

procedure TTurboScrollBox.ScrollBy(DeltaX, DeltaY: Integer);
begin
  inherited ScrollBy(DeltaX, DeltaY);

  {$IFDEF WINDOWS}
  if FImmediateScrollUpdate then
  begin
    UpdateWindow(Handle);
  end;
  {$ENDIF}
end;

end.

