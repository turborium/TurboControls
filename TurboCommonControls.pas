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
  Classes, SysUtils, Forms, LCLIntf, LMessages, StdCtrls, Menus, Controls;

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
    property ImmediateScrollUpdate: Boolean read FImmediateScrollUpdate write FImmediateScrollUpdate default False;
    property OnScroll: TTurboScrollEvent read FScrollEvent write FScrollEvent;
  end;

  { TTurboDropDownButton }

  TTurboDropDownButton = class(TButton)
  private
    FDropDownMenu: TPopupMenu;
    FLastDropDownTick: QWord;
    procedure SetDropDownMenu(Value: TPopupMenu);
  protected
    procedure Notification(Component: TComponent; Operation: TOperation); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    procedure Click(); override;
  published
    property DropDownMenu: TPopupMenu read FDropDownMenu write SetDropDownMenu;
  end;

implementation

{ TTurboScrollBox }

constructor TTurboScrollBox.Create(Owner: TComponent);
begin
  inherited Create(Owner);

  FImmediateScrollUpdate := False;
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

{ TTurboDropDownButton }

procedure TTurboDropDownButton.SetDropDownMenu(Value: TPopupMenu);
begin
  if FDropDownMenu <> Value then
  begin
    if FDropDownMenu <> nil then
    begin
      FDropDownMenu.RemoveFreeNotification(Self);
    end;

    FDropDownMenu := Value;

    if FDropDownMenu <> nil then
    begin
      FDropDownMenu.FreeNotification(Self);
    end;
  end;
end;

procedure TTurboDropDownButton.Notification(Component: TComponent; Operation: TOperation);
begin
  inherited Notification(Component, Operation);

  if Operation = opRemove then
  begin
    if Component = FDropDownMenu then
    begin
      FDropDownMenu := nil
    end;
  end;
end;

procedure TTurboDropDownButton.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if GetTickCount64() >= FLastDropDownTick then
  begin
    FLastDropDownTick := 0;
  end;

  inherited KeyDown(Key, Shift);
end;

procedure TTurboDropDownButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if GetTickCount64() >= FLastDropDownTick then
  begin
    FLastDropDownTick := 0;
  end;

  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TTurboDropDownButton.Click();
var
  Point: TPoint;
begin
  // ignore too early click
  if FLastDropDownTick <> 0 then
  begin
    FLastDropDownTick := 0;
    inherited Click();
    exit;
  end;

  // show PopUp
  if FDropDownMenu <> nil then
  begin
    FDropDownMenu.PopupComponent := Self;
    Point := ClientToScreen(TPoint.Create(0, Height));
    FDropDownMenu.PopUp(Point.X, Point.Y);
  end;

  // MUSTDIE HACK:
  // TrackPopupMenuEx uses its own modal menu tracking.
  // After it returns, the next Click on the button may be either the click that closed the popup
  // or a new click. These cases are indistinguishable, so ignore Click briefly.
  FLastDropDownTick := GetTickCount64() + 100;

  inherited Click();
end;

end.

