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
  Classes, SysUtils, Forms, LCLIntf, LMessages, StdCtrls, Menus, Controls, ComCtrls, ExtendedNotebook;

type

  { TTurboScrollEvent }

  TTurboScrollEvent = procedure(Sender: TObject; ScrollPosition: TPoint) of object;

  { TTurboScrollBox }

  TTurboScrollBox = class(TScrollBox)
  private
    FImmediateRepaint: Boolean;
    FScrollEvent: TTurboScrollEvent;
  protected
    procedure WMHScroll(var Message: TLMHScroll); message LM_HSCROLL;
    procedure WMVScroll(var Message: TLMVScroll); message LM_VSCROLL;
  public
    constructor Create(Owner: TComponent); override;
    procedure ScrollBy(DeltaX, DeltaY: Integer); override;
  published
    property ImmediateRepaint: Boolean read FImmediateRepaint write FImmediateRepaint default True;
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

  { TTurboTabSheet }

  TTurboTabSheet = class(TTabSheet)
  private
    FActiveContent: TControl;
    FContent: TControl;
    procedure AttachContent(Content: TControl);
    procedure DeattachContent();
    procedure AlignContent();
    procedure SetContent(Value: TControl);
  protected
    procedure DoShow(); override;
    procedure DoHide(); override;
    procedure Resize(); override;
  public
    property Content: TControl read FContent write SetContent;
    property ActiveContent: TControl read FActiveContent;
  end;

  { TTurboNotebookPrepareContentEvent }

  TTurboNotebookPrepareContentEvent = procedure(Sender: TObject; TabSheet: TTurboTabSheet; var Content: TControl) of object;

  { TTurboNotebookVisiblePageEvent }

  TTurboNotebookVisiblePageEvent = procedure(Sender: TObject; TabSheet: TTurboTabSheet; Content: TControl) of object;

  { TTurboNotebook }

  TTurboNotebook = class(TExtendedNotebook)
  private
    FAutoAlignContent: Boolean;
    FContent: TControl;
    FOnPrepareContent: TTurboNotebookPrepareContentEvent;
    FOnShowPage: TTurboNotebookVisiblePageEvent;
    FOnHidePage: TTurboNotebookVisiblePageEvent;
    procedure SetAutoAlignContent(Value: Boolean);
    procedure SetContent(Value: TControl);
    function GetActiveContent(): TControl;
  protected
    function GetPageClass(): TCustomPageClass; override;
  public
    constructor Create(Owner: TComponent); override;
    property Content: TControl read FContent write SetContent;
    property ActiveContent: TControl read GetActiveContent;
  published
    property AutoAlignContent: Boolean read FAutoAlignContent write SetAutoAlignContent default True;
    property OnPrepareContent: TTurboNotebookPrepareContentEvent read FOnPrepareContent write FOnPrepareContent;
    property OnShowPage: TTurboNotebookVisiblePageEvent read FOnShowPage write FOnShowPage;
    property OnHidePage: TTurboNotebookVisiblePageEvent read FOnHidePage write FOnHidePage;
  end;

implementation

{ TTurboScrollBox }

constructor TTurboScrollBox.Create(Owner: TComponent);
begin
  inherited Create(Owner);

  FImmediateRepaint := True;
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
  if FImmediateRepaint then
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

{ TTurboTabSheet }

procedure TTurboTabSheet.AttachContent(Content: TControl);
begin
  DeattachContent();

  if Content <> nil then
  begin
    FActiveContent := Content;
    FActiveContent.Parent := Self;
  end;

  AlignContent();
end;

procedure TTurboTabSheet.DeattachContent();
begin
  if (FActiveContent <> nil) then
  begin
    FActiveContent.Parent := nil;
    FActiveContent := nil;
  end;
end;

procedure TTurboTabSheet.AlignContent();
begin
  if (FActiveContent <> nil) and (FActiveContent.Align = alNone) and (PageControl is TTurboNotebook) and (TTurboNotebook(PageControl).FAutoAlignContent) then
  begin
    FActiveContent.SetBounds(
      FActiveContent.BorderSpacing.AroundLeft,
      FActiveContent.BorderSpacing.AroundTop,
      ClientWidth - FActiveContent.BorderSpacing.AroundLeft - FActiveContent.BorderSpacing.AroundRight,
      ClientHeight - FActiveContent.BorderSpacing.AroundTop - FActiveContent.BorderSpacing.AroundBottom
    );
  end;
end;

procedure TTurboTabSheet.SetContent(Value: TControl);
begin
  if FContent <> Value then
  begin
    FContent := Value;

    if Self.Visible then
    begin
      AttachContent(FContent);
    end;
  end;
end;

procedure TTurboTabSheet.DoShow();
var
  NewContent: TControl;
begin
  if PageControl is TTurboNotebook then
  begin
    NewContent := nil;
    if Assigned(TTurboNotebook(PageControl).FOnPrepareContent) then
    begin
      TTurboNotebook(PageControl).FOnPrepareContent(TTurboNotebook(PageControl), Self, NewContent);
    end;

    if NewContent <> nil then
    begin
      AttachContent(NewContent);
    end else
    if (FContent <> nil) then
    begin
      AttachContent(FContent);
    end else
    begin
      AttachContent(TTurboNotebook(PageControl).FContent);
    end;

    if Assigned(TTurboNotebook(PageControl).FOnShowPage) then
    begin
      TTurboNotebook(PageControl).FOnShowPage(TTurboNotebook(PageControl), Self, FActiveContent);
    end;
  end;

  inherited DoShow();
end;

procedure TTurboTabSheet.DoHide();
begin
  inherited DoHide();

  if PageControl is TTurboNotebook then
  begin
    try
      if Assigned(TTurboNotebook(PageControl).FOnHidePage) then
      begin
        TTurboNotebook(PageControl).FOnHidePage(TTurboNotebook(PageControl), Self, FActiveContent);
      end;
    finally
      DeattachContent();
    end;
  end;
end;

procedure TTurboTabSheet.Resize();
begin
  if PageControl is TTurboNotebook then
  begin
    AlignContent();
  end;

  inherited Resize();
end;

{ TTurboNotebook }

constructor TTurboNotebook.Create(Owner: TComponent);
begin
  inherited Create(Owner);

  FAutoAlignContent := True;
end;

function TTurboNotebook.GetPageClass(): TCustomPageClass;
begin
  Result := TTurboTabSheet;
end;

procedure TTurboNotebook.SetContent(Value: TControl);
begin
  if FContent <> Value then
  begin
    FContent := Value;

    if (ActivePage is TTurboTabSheet) and (TTurboTabSheet(ActivePage).FContent = nil) then
    begin
      TTurboTabSheet(ActivePage).AttachContent(FContent);
    end;
  end;
end;

procedure TTurboNotebook.SetAutoAlignContent(Value: Boolean);
begin
  if FAutoAlignContent <> Value then
  begin
    FAutoAlignContent := Value;
    if ActivePage is TTurboTabSheet then
    begin
      TTurboTabSheet(ActivePage).AlignContent();
    end;
  end;
end;

function TTurboNotebook.GetActiveContent(): TControl;
begin
  if ActivePage is TTurboTabSheet then
  begin
    Result := TTurboTabSheet(ActivePage).FActiveContent;
  end;
end;

end.

