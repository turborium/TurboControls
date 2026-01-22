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

unit TurboPickers;

{$MODE DELPHIUNICODE}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$OVERFLOWCHECKS ON}
{$OPTIMIZATION ON}
{$SCOPEDENUMS ON}

interface

uses
  Classes, SysUtils, Types, Graphics, Controls, IntfGraphics, LCLIntf,
  LCLType, FpImage, Math, GraphType, TurboControls, Themes, TurboExternalGraphics;

type
  // ###################################################################################################################
  // Base control classes
  // * TTurboCustomLinePicker
  // * TTurboCustomFloatLinePicker
  // * TTurboCustomAxisPicker
  // * TTurboCustomFloatAxisPicker
  // * TTurboCustomCell
  // ###################################################################################################################

  // ===================================================================================================================
  // TTurboAbstractLinePicker
  // ===================================================================================================================

  { TTurboLinePickerOrientation }

  TTurboLinePickerOrientation = (Horizontal, Vertical);

  { TTurboLinePickerLayout }

  TTurboLinePickerLayout = (ExternalArrows, InternalArrows, CenterArrows, OverlapBox, InsideBox);

  { TTurboLinePickerThumbLayout }

  TTurboLinePickerThumbLayout = (First, Second, Both);

  { TTurboAbstractLinePicker }

  TTurboAbstractLinePicker = class(TTurboCustomControl)
  strict private const
    DefaultThumbBoxWidth = 7;
    DefaultThumbExternalSize = 8;
    DefaultThumbInternalSize = 8;
    DefaultThumbCenterSize = 8;
  strict private
    FAllowFocus: Boolean;
    FForceRepaint: Boolean;
    FLayout: TTurboLinePickerLayout;
    FNeedUpdateRangeBitmap: Boolean;
    FOnChange: TNotifyEvent;
    FOnUserChange: TNotifyEvent;
    FOrientation: TTurboLinePickerOrientation;
    FPositionLineVisible: Boolean;
    FRangeBitmap: TBitmap;
    FRangeBorderColor: TColor;
    FRangeBorderFocusedColor: TColor;
    FRangeBorderWidth: Integer;
    FRangeBorderSpace: Integer;
    FRangeBorderVisible: Boolean;
    FRangePadding: TTurboAutoPadding;
    FReverse: Boolean;
    FThumbColor: TColor;
    FThumbFocusedColor: TColor;
    FThumbLayout: TTurboLinePickerThumbLayout;
    FThumbLineColor: TColor;
    FThumbLineFocusedColor: TColor;
    FThumbPreviewColor: TColor;
    FThumbSize: TTurboAutoSize;
    FThumbSpace: Integer;
    procedure AdjustContent();
    procedure RangePaddingChange({%H-}Sender: TObject);
    procedure SetLayout(Value: TTurboLinePickerLayout);
    procedure SetOrientation(Value: TTurboLinePickerOrientation);
    procedure SetPositionLineVisible(Value: Boolean);
    procedure SetRangeBorderColor(Value: TColor);
    procedure SetRangeBorderFocusedColor(Value: TColor);
    procedure SetRangeBorderWidth(Value: Integer);
    procedure SetRangeBorderSpace(Value: Integer);
    procedure SetRangeBorderVisible(Value: Boolean);
    procedure SetRangePadding(Value: TTurboAutoPadding);
    procedure SetReverse(Value: Boolean);
    procedure SetThumbColor(Value: TColor);
    procedure SetThumbFocusedColor(Value: TColor);
    procedure SetThumbLayout(Value: TTurboLinePickerThumbLayout);
    procedure SetThumbLineColor(Value: TColor);
    procedure SetThumbLineFocusedColor(Value: TColor);
    procedure SetThumbPreviewColor(Value: TColor);
    procedure SetThumbSize(Value: TTurboAutoSize);
    procedure SetThumbSpace(Value: Integer);
    procedure ThumbSizeChange({%H-}Sender: TObject);
    function GetPickerRangeRect(): TRect;
  protected
    class function GetControlClassDefaultSize(): TSize; override;
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; override;
    function IsAllowFocus(): Boolean; override;
    procedure DoEnter(); override;
    procedure DoExit(); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint(); override;
    procedure Resize(); override;
  protected
    function GetPickerAbsolutePosition(Width: Integer): Integer; virtual; abstract;
    function GetPickerThumbPreviewColor(): TColor; virtual;
    procedure MovePicker(Delta: Integer; Alternative: Boolean); virtual; abstract;
    procedure PaintRangeBitmap(Bitmap: TBitmap); virtual; abstract;
    procedure PickerChanged();
    procedure PickerInvalidate(NeedUpdateRangeBitmap: Boolean);
    procedure PickerRepaint(NeedUpdateRangeBitmap: Boolean);
    procedure PickerUserChanged();
    procedure SetPickerAbsolutePosition(Width, Position: Integer); virtual; abstract;
  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy(); override;
    procedure AutoAdjustLayout(Mode: TLayoutAdjustmentPolicy; const FromPPI, ToPPI, OldFormWidth, NewFormWidth: Integer); override;
  published
    property Align;
    property AllowFocus: Boolean read FAllowFocus write FAllowFocus default True;
    property Anchors;
    property BidiMode;
    property BorderSpacing;
    property BorderStyle;
    property Color;
    property Constraints;
    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ForceRepaint: Boolean read FForceRepaint write FForceRepaint default True;
    property Layout: TTurboLinePickerLayout read FLayout write SetLayout default TTurboLinePickerLayout.ExternalArrows;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnChangeBounds;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
    property OnUserChange: TNotifyEvent read FOnUserChange write FOnUserChange;
    property OnUTF8KeyPress;
    property Orientation: TTurboLinePickerOrientation read FOrientation write SetOrientation;
    property ParentBackground;
    property ParentBidiMode;
    property ParentColor;
    property ParentDoubleBuffered;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property PositionLineVisible: Boolean read FPositionLineVisible write SetPositionLineVisible default False;
    property RangeBorderColor: TColor read FRangeBorderColor write SetRangeBorderColor default clDefault;
    property RangeBorderFocusedColor: TColor read FRangeBorderFocusedColor write SetRangeBorderFocusedColor default clDefault;
    property RangeBorderWidth: Integer read FRangeBorderWidth write SetRangeBorderWidth default 1;
    property RangeBorderSpace: Integer read FRangeBorderSpace write SetRangeBorderSpace default 0;
    property RangeBorderVisible: Boolean read FRangeBorderVisible write SetRangeBorderVisible default True;
    property RangePadding: TTurboAutoPadding read FRangePadding write SetRangePadding;
    property Reverse: Boolean read FReverse write SetReverse default False;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property ThumbColor: TColor read FThumbColor write SetThumbColor default clDefault;
    property ThumbFocusedColor: TColor read FThumbFocusedColor write SetThumbFocusedColor default clDefault;
    property ThumbLayout: TTurboLinePickerThumbLayout read FThumbLayout write SetThumbLayout default TTurboLinePickerThumbLayout.Both;
    property ThumbLineColor: TColor read FThumbLineColor write SetThumbLineColor default clDefault;
    property ThumbLineFocusedColor: TColor read FThumbLineFocusedColor write SetThumbLineFocusedColor default clDefault;
    property ThumbPreviewColor: TColor read FThumbPreviewColor write SetThumbPreviewColor default clDefault;
    property ThumbSize: TTurboAutoSize read FThumbSize write SetThumbSize;
    property ThumbSpace: Integer read FThumbSpace write SetThumbSpace default 0;
    property Visible;
  end;

  // ===================================================================================================================
  // TTurboCustomLinePicker
  // ===================================================================================================================

  { TTurboCustomLinePicker }

  TTurboCustomLinePicker = class(TTurboAbstractLinePicker)
  strict private
    FIncrement: Integer;
    FIncrementMultiplier: Integer;
    FMax: Integer;
    FMin: Integer;
    function IsIncrementMultiplierStored(): Boolean;
    function IsIncrementStored(): Boolean;
    function IsMaxStored(): Boolean;
    function IsMinStored(): Boolean;
    procedure SetIncrement(Value: Integer);
    procedure SetIncrementMultiplier(Value: Integer);
    procedure SetMax(Value: Integer);
    procedure SetMin(Value: Integer);
    procedure UserUpdatePickerValue(Value: Integer);
  protected
    function GetPickerAbsolutePosition(Width: Integer): Integer; override;
    procedure MovePicker(Delta: Integer; Alternative: Boolean); override;
    procedure SetPickerAbsolutePosition(Width, Position: Integer); override;
  protected
    function GetDefaultIncrement(): Integer; virtual;
    function GetDefaultIncrementMultiplier(): Integer; virtual;
    function GetDefaultRange(): TTurboRange; virtual;
    function GetPickerValue(): Integer; virtual; abstract;
    function GetRange(): TTurboRange; virtual;
    procedure PickerChange(NeedUpdateRangeBitmap: Boolean);
    procedure SetPickerValue(Value: Integer); virtual; abstract;
  public
    constructor Create(Owner: TComponent); override;
  published
    property Increment: Integer read FIncrement write SetIncrement stored IsIncrementStored;
    property IncrementMultiplier: Integer read FIncrementMultiplier write SetIncrementMultiplier stored IsIncrementMultiplierStored;
    property Max: Integer read FMax write SetMax stored IsMaxStored;
    property Min: Integer read FMin write SetMin stored IsMinStored;
  end;

  // ===================================================================================================================
  // TTurboCustomFloatLinePicker
  // ===================================================================================================================

  { TTurboCustomFloatLinePicker }

  TTurboCustomFloatLinePicker = class(TTurboAbstractLinePicker)
  strict private
    FIncrement: Double;
    FIncrementMultiplier: Integer;
    FMax: Double;
    FMin: Double;
    function IsIncrementMultiplierStored(): Boolean;
    function IsIncrementStored(): Boolean;
    function IsMaxStored(): Boolean;
    function IsMinStored(): Boolean;
    procedure SetIncrement(Value: Double);
    procedure SetIncrementMultiplier(Value: Integer);
    procedure SetMax(Value: Double);
    procedure SetMin(Value: Double);
    procedure UserUpdatePickerValue(Value: Double);
  protected
    function GetPickerAbsolutePosition(Width: Integer): Integer; override;
    procedure MovePicker(Delta: Integer; Alternative: Boolean); override;
    procedure SetPickerAbsolutePosition(Width, Position: Integer); override;
  protected
    function GetDefaultIncrement(): Double; virtual;
    function GetDefaultIncrementMultiplier(): Integer; virtual;
    function GetDefaultRange(): TTurboFloatRange; virtual;
    function GetPickerValue(): Double; virtual; abstract;
    function GetRange(): TTurboFloatRange; virtual;
    procedure PickerChange(NeedUpdateRangeBitmap: Boolean);
    procedure SetPickerValue(Value: Double); virtual; abstract;
  public
    constructor Create(Owner: TComponent); override;
  published
    property Increment: Double read FIncrement write SetIncrement stored IsIncrementStored;
    property IncrementMultiplier: Integer read FIncrementMultiplier write SetIncrementMultiplier stored IsIncrementMultiplierStored;
    property Max: Double read FMax write SetMax stored IsMaxStored;
    property Min: Double read FMin write SetMin stored IsMinStored;
  end;

  // ===================================================================================================================
  // TTurboAbstractAxisPicker
  // ===================================================================================================================

  { TTurboAxisPickerLayout }

  TTurboAxisPickerLayout = (OverlapThumb, InsideThumb);

  { TTurboAxisPickerThumbKind }

  TTurboAxisPickerThumbKind = (Circle, Cross);

  { TTurboAxisPickerThumbStyle }

  TTurboAxisPickerThumbStyle = (Color, Invert, Mixed);

  { TTurboAbstractAxisPicker }

  TTurboAbstractAxisPicker = class(TTurboCustomControl)
  strict private const
    DefaultThumbSize = 11;
  strict private
    FAllowFocus: Boolean;
    FForceRepaint: Boolean;
    FHorizontalReverse: Boolean;
    FLayout: TTurboAxisPickerLayout;
    FNeedUpdateRangeBitmap: Boolean;
    FOnChange: TNotifyEvent;
    FOnUserChange: TNotifyEvent;
    FPositionLineVisible: Boolean;
    FRangeBitmap: TBitmap;
    FRangeBorderColor: TColor;
    FRangeBorderFocusedColor: TColor;
    FRangeBorderWidth: Integer;
    FRangeBorderSpace: Integer;
    FRangeBorderVisible: Boolean;
    FRangePadding: TTurboAutoPadding;
    FThumbColor: TColor;
    FThumbFocusedColor: TColor;
    FThumbKind: TTurboAxisPickerThumbKind;
    FThumbLineColor: TColor;
    FThumbLineFocusedColor: TColor;
    FThumbSize: TTurboAutoLength;
    FThumbStyle: TTurboAxisPickerThumbStyle;
    FVerticalReverse: Boolean;
    function GetPickerRangeRect(): TRect;
    procedure AdjustContent();
    procedure RangePaddingChange({%H-}Sender: TObject);
    procedure SetHorizontalReverse(Value: Boolean);
    procedure SetLayout(Value: TTurboAxisPickerLayout);
    procedure SetPositionLineVisible(Value: Boolean);
    procedure SetRangeBorderColor(Value: TColor);
    procedure SetRangeBorderFocusedColor(Value: TColor);
    procedure SetRangeBorderWidth(Value: Integer);
    procedure SetRangeBorderSpace(Value: Integer);
    procedure SetRangeBorderVisible(Value: Boolean);
    procedure SetRangePadding(Value: TTurboAutoPadding);
    procedure SetThumbColor(Value: TColor);
    procedure SetThumbFocusedColor(Value: TColor);
    procedure SetThumbKind(Value: TTurboAxisPickerThumbKind);
    procedure SetThumbLineColor(Value: TColor);
    procedure SetThumbLineFocusedColor(Value: TColor);
    procedure SetThumbSize(Value: TTurboAutoLength);
    procedure SetThumbStyle(Value: TTurboAxisPickerThumbStyle);
    procedure SetVerticalReverse(Value: Boolean);
    procedure ThumbSizeChange({%H-}Sender: TObject);
  protected
    class function GetControlClassDefaultSize(): TSize; override;
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; override;
    function IsAllowFocus(): Boolean; override;
    procedure DoEnter(); override;
    procedure DoExit(); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint(); override;
    procedure Resize(); override;
  protected
    function GetPickerAbsolutePosition(Size: TSize): TPoint; virtual; abstract;
    function GetPickerThumbPreviewColor(): TColor; virtual;
    procedure MovePicker(DeltaX, DeltaY: Integer; Alternative: Boolean); virtual; abstract;
    procedure PaintRangeBitmap(Bitmap: TBitmap); virtual; abstract;
    procedure PickerChanged();
    procedure PickerInvalidate(NeedUpdateRangeBitmap: Boolean);
    procedure PickerRepaint(NeedUpdateRangeBitmap: Boolean);
    procedure PickerUserChanged();
    procedure SetPickerAbsolutePosition(Size: TSize; Position: TPoint); virtual; abstract;
  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy(); override;
    procedure AutoAdjustLayout(Mode: TLayoutAdjustmentPolicy; const FromPPI, ToPPI, OldFormWidth, NewFormWidth: Integer); override;// ok
  published
    property Align;
    property AllowFocus: Boolean read FAllowFocus write FAllowFocus default True;
    property Anchors;
    property BidiMode;
    property BorderSpacing;
    property BorderStyle;
    property Color;
    property Constraints;
    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ForceRepaint: Boolean read FForceRepaint write FForceRepaint default True;
    property HorizontalReverse: Boolean read FHorizontalReverse write SetHorizontalReverse default False;
    property Layout: TTurboAxisPickerLayout read FLayout write SetLayout default TTurboAxisPickerLayout.OverlapThumb;
    property ParentBackground;
    property ParentBidiMode;
    property ParentColor;
    property ParentDoubleBuffered;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property PositionLineVisible: Boolean read FPositionLineVisible write SetPositionLineVisible default False;
    property RangeBorderColor: TColor read FRangeBorderColor write SetRangeBorderColor default clDefault;
    property RangeBorderFocusedColor: TColor read FRangeBorderFocusedColor write SetRangeBorderFocusedColor default clDefault;
    property RangeBorderSpace: Integer read FRangeBorderSpace write SetRangeBorderSpace default 0;
    property RangeBorderWidth: Integer read FRangeBorderWidth write SetRangeBorderWidth default 1;
    property RangeBorderVisible: Boolean read FRangeBorderVisible write SetRangeBorderVisible default True;
    property RangePadding: TTurboAutoPadding read FRangePadding write SetRangePadding;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property ThumbColor: TColor read FThumbColor write SetThumbColor default clDefault;
    property ThumbFocusedColor: TColor read FThumbFocusedColor write SetThumbFocusedColor default clDefault;
    property ThumbKind: TTurboAxisPickerThumbKind read FThumbKind write SetThumbKind default TTurboAxisPickerThumbKind.Circle;
    property ThumbLineColor: TColor read FThumbLineColor write SetThumbLineColor default clDefault;
    property ThumbLineFocusedColor: TColor read FThumbLineFocusedColor write SetThumbLineFocusedColor default clDefault;
    property ThumbSize: TTurboAutoLength read FThumbSize write SetThumbSize;
    property ThumbStyle: TTurboAxisPickerThumbStyle read FThumbStyle write SetThumbStyle default TTurboAxisPickerThumbStyle.Color;
    property VerticalReverse: Boolean read FVerticalReverse write SetVerticalReverse default False;
    property Visible;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnUserChange: TNotifyEvent read FOnUserChange write FOnUserChange;
    property OnChangeBounds;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
    property OnUTF8KeyPress;
  end;

  // ===================================================================================================================
  // TTurboCustomAxisPicker
  // ===================================================================================================================

  { TTurboCustomAxisPicker }

  TTurboCustomAxisPicker = class(TTurboAbstractAxisPicker)
  strict private
    FHorizontalIncrement: Integer;
    FHorizontalMax: Integer;
    FHorizontalMin: Integer;
    FIncrementMultiplier: Integer;
    FVerticalIncrement: Integer;
    FVerticalMax: Integer;
    FVerticalMin: Integer;
    function IsHorizontalIncrementStored(): Boolean;
    function IsHorizontalMaxStored(): Boolean;
    function IsHorizontalMinStored(): Boolean;
    function IsIncrementMultiplierStored(): Boolean;
    function IsVerticalIncrementStored(): Boolean;
    function IsVerticalMaxStored(): Boolean;
    function IsVerticalMinStored(): Boolean;
    procedure SetHorizontalIncrement(Value: Integer);
    procedure SetHorizontalMax(Value: Integer);
    procedure SetHorizontalMin(Value: Integer);
    procedure SetIncrementMultiplier(Value: Integer);
    procedure SetVerticalIncrement(Value: Integer);
    procedure SetVerticalMax(Value: Integer);
    procedure SetVerticalMin(Value: Integer);
    procedure UserUpdatePickerValue(Value: TPoint);
  protected
    function GetPickerAbsolutePosition(Size: TSize): TPoint; override;
    procedure MovePicker(DeltaX, DeltaY: Integer; Alternative: Boolean); override;
    procedure SetPickerAbsolutePosition(Size: TSize; Position: TPoint); override;
  protected
    function GetDefaultHorizontalIncrement(): Integer; virtual;
    function GetDefaultHorizontalRange(): TTurboRange; virtual;
    function GetDefaultIncrementMultiplier(): Integer; virtual;
    function GetDefaultVerticalIncrement(): Integer; virtual;
    function GetDefaultVerticalRange(): TTurboRange; virtual;
    function GetHorizontalRange(): TTurboRange; virtual;
    function GetPickerValue(): TPoint; virtual; abstract;
    function GetVerticalRange(): TTurboRange; virtual;
    procedure PickerChange(NeedUpdateRangeBitmap: Boolean);
    procedure SetPickerValue(Value: TPoint); virtual; abstract;
  published
    property HorizontalIncrement: Integer read FHorizontalIncrement write SetHorizontalIncrement stored IsHorizontalIncrementStored;
    property HorizontalMax: Integer read FHorizontalMax write SetHorizontalMax stored IsHorizontalMaxStored;
    property HorizontalMin: Integer read FHorizontalMin write SetHorizontalMin stored IsHorizontalMinStored;
    property IncrementMultiplier: Integer read FIncrementMultiplier write SetIncrementMultiplier stored IsIncrementMultiplierStored;
    property VerticalIncrement: Integer read FVerticalIncrement write SetVerticalIncrement stored IsVerticalIncrementStored;
    property VerticalMax: Integer read FVerticalMax write SetVerticalMax stored IsVerticalMaxStored;
    property VerticalMin: Integer read FVerticalMin write SetVerticalMin stored IsVerticalMinStored;
  public
    constructor Create(Owner: TComponent); override;
  end;

  // ===================================================================================================================
  // TTurboCustomFloatAxisPicker
  // ===================================================================================================================

  { TTurboCustomFloatAxisPicker }

  TTurboCustomFloatAxisPicker = class(TTurboAbstractAxisPicker)
  strict private
    FHorizontalIncrement: Double;
    FHorizontalMax: Double;
    FHorizontalMin: Double;
    FIncrementMultiplier: Integer;
    FVerticalIncrement: Double;
    FVerticalMax: Double;
    FVerticalMin: Double;
    function IsHorizontalIncrementStored(): Boolean;
    function IsHorizontalMaxStored(): Boolean;
    function IsHorizontalMinStored(): Boolean;
    function IsIncrementMultiplierStored(): Boolean;
    function IsVerticalIncrementStored(): Boolean;
    function IsVerticalMaxStored(): Boolean;
    function IsVerticalMinStored(): Boolean;
    procedure SetHorizontalIncrement(Value: Double);
    procedure SetHorizontalMax(Value: Double);
    procedure SetHorizontalMin(Value: Double);
    procedure SetIncrementMultiplier(Value: Integer);
    procedure SetVerticalIncrement(Value: Double);
    procedure SetVerticalMax(Value: Double);
    procedure SetVerticalMin(Value: Double);
    procedure UserUpdatePickerValue(Value: TPointF);
  protected
    function GetPickerAbsolutePosition(Size: TSize): TPoint; override;
    procedure MovePicker(DeltaX, DeltaY: Integer; Alternative: Boolean); override;
    procedure SetPickerAbsolutePosition(Size: TSize; Position: TPoint); override;
  protected
    function GetDefaultHorizontalIncrement(): Double; virtual;
    function GetDefaultHorizontalRange(): TTurboFloatRange; virtual;
    function GetDefaultIncrementMultiplier(): Integer; virtual;
    function GetDefaultVerticalIncrement(): Double; virtual;
    function GetDefaultVerticalRange(): TTurboFloatRange; virtual;
    function GetHorizontalRange(): TTurboFloatRange; virtual;
    function GetPickerValue(): TPointF; virtual; abstract;
    function GetVerticalRange(): TTurboFloatRange; virtual;
    procedure PickerChange(NeedUpdateRangeBitmap: Boolean);
    procedure SetPickerValue(Value: TPointF); virtual; abstract;
  published
    property HorizontalIncrement: Double read FHorizontalIncrement write SetHorizontalIncrement stored IsHorizontalIncrementStored;
    property HorizontalMax: Double read FHorizontalMax write SetHorizontalMax stored IsHorizontalMaxStored;
    property HorizontalMin: Double read FHorizontalMin write SetHorizontalMin stored IsHorizontalMinStored;
    property IncrementMultiplier: Integer read FIncrementMultiplier write SetIncrementMultiplier stored IsIncrementMultiplierStored;
    property VerticalIncrement: Double read FVerticalIncrement write SetVerticalIncrement stored IsVerticalIncrementStored;
    property VerticalMax: Double read FVerticalMax write SetVerticalMax stored IsVerticalMaxStored;
    property VerticalMin: Double read FVerticalMin write SetVerticalMin stored IsVerticalMinStored;
  public
    constructor Create(Owner: TComponent); override;
  end;

  // ===================================================================================================================
  // TTurboCustomCell
  // ===================================================================================================================

  { TTurboCellFocusStyle }

  TTurboCellFocusStyle = (Outline, Border);

  { TTurboCustomCell }

  TTurboCustomCell = class(TTurboCustomControl)
  strict private
    FAllowFocus: Boolean;
    FBorderColor: TColor;
    FBorderSpace: Integer;
    FBorderWidth: Integer;
    FFocusColor: TColor;
    FFocusStyle: TTurboCellFocusStyle;
    FInteractive: Boolean;
    FIsDown: Boolean;
    FIsHot: Boolean;
    FSelected: Boolean;
    FSelection: TTurboSelectionFrame;
    procedure SelectionChange({%H-}Sender: TObject);
    procedure SetBorderColor(Value: TColor);
    procedure SetBorderSpace(Value: Integer);
    procedure SetBorderWidth(Value: Integer);
    procedure SetFocusColor(Value: TColor);
    procedure SetFocusStyle(Value: TTurboCellFocusStyle);
    procedure SetSelected(Value: Boolean);
    procedure SetSelection(Value: TTurboSelectionFrame);
  protected
    class function GetControlClassDefaultSize(): TSize; override;
    procedure DoEnter(); override;
    procedure DoExit(); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseEnter(); override;
    procedure MouseLeave(); override;
    procedure Paint(); override;
    function IsAllowFocus(): Boolean; override;
    procedure DrawCell(const {%H-}CellRect: TRect); virtual;
  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy(); override;
  published
    property Action;
    property Align;
    property Anchors;
    property BidiMode;
    property BorderColor: TColor read FBorderColor write SetBorderColor default clDefault;
    property BorderSpace: Integer read FBorderSpace write SetBorderSpace default 0;
    property BorderSpacing;
    property BorderWidth: Integer read FBorderWidth write SetBorderWidth default 1;
    property Color;
    property Constraints;
    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property OnChangeBounds;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
    property OnUTF8KeyPress;
    property ParentBidiMode;
    property ParentDoubleBuffered;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property AllowFocus: Boolean read FAllowFocus write FAllowFocus default True;
    property FocusColor: TColor read FFocusColor write SetFocusColor default clDefault;
    property FocusStyle: TTurboCellFocusStyle read FFocusStyle write SetFocusStyle default TTurboCellFocusStyle.Outline;
    property Interactive: Boolean read FInteractive write FInteractive default True;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property Selected: Boolean read FSelected write SetSelected default False;
    property Selection: TTurboSelectionFrame read FSelection write SetSelection;
    property TabOrder;
    property TabStop default True;
  end;

  // ###################################################################################################################
  // Custom color picker classes
  // ###################################################################################################################

  // ===================================================================================================================
  // TTurboColorLinePicker
  // ===================================================================================================================

  { TTurboLinePickerShader1D }

  TTurboLinePickerShader1D = function (Value: Integer): TTurboColor of object;

  { TTurboLinePickerShader2D }

  TTurboLinePickerShader2D = function (ValueX: Integer; ValueY: Double): TTurboColor of object;

  { TTurboColorLinePicker }

  TTurboColorLinePicker = class(TTurboCustomLinePicker)
  strict private
    FAlphaModulation: Boolean;
    FAlphaPreview: Byte;
    FRangeBackground: TTurboTransparentBackground;
    procedure DrawRangeBitmap1D(Image: TLazIntfImage; Shader: TTurboLinePickerShader1D);
    procedure DrawRangeBitmap2D(Image: TLazIntfImage; Shader: TTurboLinePickerShader2D);
    procedure RangeBackgroundChange({%H-}Sender: TObject);
    procedure SetAlphaModulation(Value: Boolean);
    procedure SetAlphaPreview(Value: Byte);
    procedure SetRangeBackground(Value: TTurboTransparentBackground);
  protected
    function GetDefaultIncrement(): Integer; override;
    function GetDefaultIncrementMultiplier(): Integer; override;
    function GetRange(): TTurboRange; override;
    procedure PaintRangeBitmap(Bitmap: TBitmap); override;
  protected
    function GetPickerRangeOpacity(): Byte; virtual;
    function GetPickerRangeShader1D(): TTurboLinePickerShader1D; virtual;
    function GetPickerRangeShader2D(): TTurboLinePickerShader2D; virtual;
  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy(); override;
    property AlphaPreview: Byte read FAlphaPreview write SetAlphaPreview default 255;
    property AlphaModulation: Boolean read FAlphaModulation write SetAlphaModulation default True;
    property RangeBackground: TTurboTransparentBackground read FRangeBackground write SetRangeBackground;
  end;

  // ===================================================================================================================
  // TTurboColorFloatLinePicker
  // ===================================================================================================================

  { TTurboLinePickerFloatShader1D }

  TTurboLinePickerFloatShader1D = function (Value: Double): TTurboColor of object;

  { TTurboLinePickerFloatShader2D }

  TTurboLinePickerFloatShader2D = function (ValueX, ValueY: Double): TTurboColor of object;

  { TTurboColorFloatLinePicker }

  TTurboColorFloatLinePicker = class(TTurboCustomFloatLinePicker)
  strict private
    FAlphaModulation: Boolean;
    FAlphaPreview: Byte;
    FRangeBackground: TTurboTransparentBackground;
    procedure DrawRangeBitmap1D(Image: TLazIntfImage; Shader: TTurboLinePickerFloatShader1D);
    procedure DrawRangeBitmap2D(Image: TLazIntfImage; Shader: TTurboLinePickerFloatShader2D);
    procedure RangeBackgroundChange({%H-}Sender: TObject);
    procedure SetAlphaModulation(Value: Boolean);
    procedure SetAlphaPreview(Value: Byte);
    procedure SetRangeBackground(Value: TTurboTransparentBackground);
  protected
    function GetDefaultIncrement(): Double; override;
    function GetDefaultIncrementMultiplier(): Integer; override;
    function GetRange(): TTurboFloatRange; override;
    procedure PaintRangeBitmap(Bitmap: TBitmap); override;
  protected
    function GetPickerRangeOpacity(): Byte; virtual;
    function GetPickerRangeShader1D(): TTurboLinePickerFloatShader1D; virtual;
    function GetPickerRangeShader2D(): TTurboLinePickerFloatShader2D; virtual;
  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy(); override;
    property AlphaPreview: Byte read FAlphaPreview write SetAlphaPreview default 255;
    property AlphaModulation: Boolean read FAlphaModulation write SetAlphaModulation default True;
    property RangeBackground: TTurboTransparentBackground read FRangeBackground write SetRangeBackground;
  end;

  // ===================================================================================================================
  // TTurboColorAxisPicker
  // ===================================================================================================================

  { TTurboAxisPickerShader }

  TTurboAxisPickerShader = function (ValueX, ValueY: Integer): TTurboColor of object;

  { TTurboColorAxisPicker }

  TTurboColorAxisPicker = class(TTurboCustomAxisPicker)
  private
    FAlphaModulation: Boolean;
    FAlphaPreview: Byte;
    FRangeBackground: TTurboTransparentBackground;
    procedure DrawRangeBitmap(Image: TLazIntfImage; Shader: TTurboAxisPickerShader);
    procedure RangeBackgroundChange({%H-}Sender: TObject);
    procedure SetAlphaModulation(Value: Boolean);
    procedure SetAlphaPreview(Value: Byte);
    procedure SetRangeBackground(Value: TTurboTransparentBackground);
  protected
    function GetDefaultHorizontalIncrement(): Integer; override;
    function GetDefaultIncrementMultiplier(): Integer; override;
    function GetDefaultVerticalIncrement(): Integer; override;
    function GetHorizontalRange(): TTurboRange; override;
    function GetVerticalRange(): TTurboRange; override;
    procedure PaintRangeBitmap(Bitmap: TBitmap); override;
  protected
    function GetPickerRangeOpacity(): Byte; virtual;
    function GetPickerRangeShader(): TTurboAxisPickerShader; virtual;
  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy(); override;
    property AlphaPreview: Byte read FAlphaPreview write SetAlphaPreview default 255;
    property AlphaModulation: Boolean read FAlphaModulation write SetAlphaModulation default True;
    property RangeBackground: TTurboTransparentBackground read FRangeBackground write SetRangeBackground;
  end;

  // ===================================================================================================================
  // TTurboColorFloatAxisPicker
  // ===================================================================================================================

  { TTurboAxisPickerFloatShader }

  TTurboAxisPickerFloatShader = function (ValueX, ValueY: Double): TTurboColor of object;

  { TTurboColorFloatAxisPicker }

  TTurboColorFloatAxisPicker = class(TTurboCustomFloatAxisPicker)
  private
    FAlphaModulation: Boolean;
    FAlphaPreview: Byte;
    FRangeBackground: TTurboTransparentBackground;
    procedure DrawRangeBitmap(Image: TLazIntfImage; Shader: TTurboAxisPickerFloatShader);
    procedure RangeBackgroundChange({%H-}Sender: TObject);
    procedure SetAlphaModulation(Value: Boolean);
    procedure SetAlphaPreview(Value: Byte);
    procedure SetRangeBackground(Value: TTurboTransparentBackground);
  protected
    function GetDefaultHorizontalIncrement(): Double; override;
    function GetDefaultIncrementMultiplier(): Integer; override;
    function GetDefaultVerticalIncrement(): Double; override;
    function GetHorizontalRange(): TTurboFloatRange; override;
    function GetVerticalRange(): TTurboFloatRange; override;
    procedure PaintRangeBitmap(Bitmap: TBitmap); override;
    function GetPickerRangeOpacity(): Byte; virtual;
  protected
    function GetPickerRangeShader(): TTurboAxisPickerFloatShader; virtual;
  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy(); override;
    property AlphaPreview: Byte read FAlphaPreview write SetAlphaPreview default 255;
    property AlphaModulation: Boolean read FAlphaModulation write SetAlphaModulation default True;
    property RangeBackground: TTurboTransparentBackground read FRangeBackground write SetRangeBackground;
  end;

  // ###################################################################################################################
  // Concrete control classes
  // ###################################################################################################################

  // ===================================================================================================================
  // TTurboHslLinePicker
  // ===================================================================================================================

  { TTurboHslLinePickerKind }

  TTurboHslLinePickerKind = (Hue, Saturation, Lightness);

  { TTurboHslLinePickerPreviewStyle }

  TTurboHslLinePickerPreviewStyle = (RedGreenBlueGradient, GreenBlueRedGradient, RedGreenBlueLines);

  { TTurboHslLinePicker }

  TTurboHslLinePicker = class(TTurboColorFloatLinePicker)
  strict private
    FColorModulation: Boolean;
    FColorModulationLoaded: Boolean;
    FHue: Double;
    FKind: TTurboHslLinePickerKind;
    FLightness: Double;
    FPreviewStyle: TTurboHslLinePickerPreviewStyle;
    FSaturation: Double;
    function GetCurrentColor(): TColor;
    function IsColorModulationStored(): Boolean;
    function IsHueStored(): Boolean;
    function IsLightnessStored(): Boolean;
    function IsSaturationStored(): Boolean;
    function ShaderHue(Value: Double): TTurboColor;
    function ShaderLightnessGreenBlueRedGradient(ValueX, ValueY: Double): TTurboColor;
    function ShaderLightnessRedGreenBlueGradient(ValueX, ValueY: Double): TTurboColor;
    function ShaderLightnessRedGreenBlueLines(ValueX, ValueY: Double): TTurboColor;
    function ShaderModulatedHue(Value: Double): TTurboColor;
    function ShaderModulatedLightness(Value: Double): TTurboColor;
    function ShaderModulatedSaturation(Value: Double): TTurboColor;
    function ShaderSaturationGreenBlueRedGradient(ValueX, ValueY: Double): TTurboColor;
    function ShaderSaturationRedGreenBlueGradient(ValueX, ValueY: Double): TTurboColor;
    function ShaderSaturationRedGreenBlueLines(ValueX, ValueY: Double): TTurboColor;
    procedure SetColorModulation(Value: Boolean);
    procedure SetCurrentColor(Value: TColor);
    procedure SetHue(Value: Double);
    procedure SetKind(Value: TTurboHslLinePickerKind);
    procedure SetLightness(Value: Double);
    procedure SetPreviewStyle(Value: TTurboHslLinePickerPreviewStyle);
    procedure SetSaturation(Value: Double);
    procedure UpdateHsl(Hue, Saturation, Lightness: Double);
  protected
    function GetPickerRangeShader1D(): TTurboLinePickerFloatShader1D; override;
    function GetPickerRangeShader2D(): TTurboLinePickerFloatShader2D; override;
    function GetPickerThumbPreviewColor(): TColor; override;
    function GetPickerValue(): Double; override;
    procedure SetPickerValue(Value: Double); override;
  public
    constructor Create(Owner: TComponent); override;
    procedure GetHsl(out Hue, Saturation, Lightness: Double);
    procedure GetHsv(out Hue, Saturation, Value: Double);
    procedure GetRgb(out Red, Green, Blue: Byte);
    procedure SetHsl(Hue, Saturation, Lightness: Double);
    procedure SetHsv(Hue, Saturation, Value: Double);
    procedure SetRgb(Red, Green, Blue: Byte);
  published
    property AlphaPreview;
    property AlphaModulation;
    property ColorModulation: Boolean read FColorModulation write SetColorModulation stored IsColorModulationStored;
    property CurrentColor: TColor read GetCurrentColor write SetCurrentColor stored False nodefault;
    property Hue: Double read FHue write SetHue stored IsHueStored;
    property Kind: TTurboHslLinePickerKind read FKind write SetKind;
    property Lightness: Double read FLightness write SetLightness stored IsLightnessStored;
    property PreviewStyle: TTurboHslLinePickerPreviewStyle read FPreviewStyle write SetPreviewStyle default TTurboHslLinePickerPreviewStyle.RedGreenBlueGradient;
    property RangeBackground;
    property Saturation: Double read FSaturation write SetSaturation stored IsSaturationStored;
  end;

  // ===================================================================================================================
  // TTurboHsvLinePicker
  // ===================================================================================================================

  { TTurboHsvLinePickerKind }

  TTurboHsvLinePickerKind = (Hue, Saturation, Value);

  { TTurboHslLinePickerPreviewStyle }

  TTurboHsvLinePickerPreviewStyle = (RedGreenBlueGradient, GreenBlueRedGradient, RedGreenBlueLines);

  { TTurboHsvLinePicker }

  TTurboHsvLinePicker = class(TTurboColorFloatLinePicker)
  strict private
    FColorModulation: Boolean;
    FColorModulationLoaded: Boolean;
    FHue: Double;
    FKind: TTurboHsvLinePickerKind;
    FPreviewStyle: TTurboHsvLinePickerPreviewStyle;
    FSaturation: Double;
    FValue: Double;
    function GetCurrentColor(): TColor;
    function IsColorModulationStored(): Boolean;
    function IsHueStored(): Boolean;
    function IsSaturationStored(): Boolean;
    function IsValueStored(): Boolean;
    function ShaderHue(Value: Double): TTurboColor;
    function ShaderModulatedHue(Value: Double): TTurboColor;
    function ShaderModulatedSaturation(Value: Double): TTurboColor;
    function ShaderModulatedValue(Value: Double): TTurboColor;
    function ShaderSaturationGreenBlueRedGradient(ValueX, ValueY: Double): TTurboColor;
    function ShaderSaturationRedGreenBlueGradient(ValueX, ValueY: Double): TTurboColor;
    function ShaderSaturationRedGreenBlueLines(ValueX, ValueY: Double): TTurboColor;
    function ShaderValueGreenBlueRedGradient(ValueX, ValueY: Double): TTurboColor;
    function ShaderValueRedGreenBlueGradient(ValueX, ValueY: Double): TTurboColor;
    function ShaderValueRedGreenBlueLines(ValueX, ValueY: Double): TTurboColor;
    procedure SetColorModulation(Value: Boolean);
    procedure SetCurrentColor(Value: TColor);
    procedure SetHue(Value: Double);
    procedure SetKind(Value: TTurboHsvLinePickerKind);
    procedure SetPreviewStyle(Value: TTurboHsvLinePickerPreviewStyle);
    procedure SetSaturation(Value: Double);
    procedure SetValue(Value: Double);
    procedure UpdateHsv(Hue, Saturation, Value: Double);
  protected
    function GetPickerRangeShader1D(): TTurboLinePickerFloatShader1D; override;
    function GetPickerRangeShader2D(): TTurboLinePickerFloatShader2D; override;
    function GetPickerThumbPreviewColor(): TColor; override;
    function GetPickerValue(): Double; override;
    procedure SetPickerValue(Value: Double); override;
  public
    constructor Create(Owner: TComponent); override;
    procedure GetHsl(out Hue, Saturation, Lightness: Double);
    procedure GetHsv(out Hue, Saturation, Value: Double);
    procedure GetRgb(out Red, Green, Blue: Byte);
    procedure SetHsl(Hue, Saturation, Lightness: Double);
    procedure SetHsv(Hue, Saturation, Value: Double);
    procedure SetRgb(Red, Green, Blue: Byte);
  published
    property AlphaPreview;
    property AlphaModulation;
    property ColorModulation: Boolean read FColorModulation write SetColorModulation stored IsColorModulationStored;
    property CurrentColor: TColor read GetCurrentColor write SetCurrentColor stored False nodefault;
    property Hue: Double read FHue write SetHue stored IsHueStored;
    property Kind: TTurboHsvLinePickerKind read FKind write SetKind;
    property PreviewStyle: TTurboHsvLinePickerPreviewStyle read FPreviewStyle write SetPreviewStyle default TTurboHsvLinePickerPreviewStyle.RedGreenBlueGradient;
    property RangeBackground;
    property Saturation: Double read FSaturation write SetSaturation stored IsSaturationStored;
    property Value: Double read FValue write SetValue stored IsValueStored;
  end;

  // ===================================================================================================================
  // TTurboRgbLinePicker
  // ===================================================================================================================

  { TTurboRgbLinePickerKind }

  TTurboRgbLinePickerKind = (Red, Green, Blue);

  { TTurboRgbLinePicker }

  TTurboRgbLinePicker = class(TTurboColorLinePicker)
  strict private
    FBlue: Byte;
    FColorModulation: Boolean;
    FGreen: Byte;
    FKind: TTurboRgbLinePickerKind;
    FRed: Byte;
    function GetCurrentColor(): TColor;
    function ShaderBlue(Value: Integer): TTurboColor;
    function ShaderGreen(Value: Integer): TTurboColor;
    function ShaderModulatedBlue(Value: Integer): TTurboColor;
    function ShaderModulatedGreen(Value: Integer): TTurboColor;
    function ShaderModulatedRed(Value: Integer): TTurboColor;
    function ShaderRed(Value: Integer): TTurboColor;
    procedure SetBlue(Value: Byte);
    procedure SetColorModulation(Value: Boolean);
    procedure SetCurrentColor(Value: TColor);
    procedure SetGreen(Value: Byte);
    procedure SetKind(Value: TTurboRgbLinePickerKind);
    procedure SetRed(Value: Byte);
    procedure UpdateRgb(Red, Green, Blue: Byte);
  protected
    function GetPickerRangeShader1D(): TTurboLinePickerShader1D; override;
    function GetPickerThumbPreviewColor(): TColor; override;
    function GetPickerValue(): Integer; override;
    procedure SetPickerValue(Value: Integer); override;
  public
    constructor Create(Owner: TComponent); override;
    procedure GetHsl(out Hue, Saturation, Lightness: Double);
    procedure GetHsv(out Hue, Saturation, Value: Double);
    procedure GetRgb(out Red, Green, Blue: Byte);
    procedure SetHsl(Hue, Saturation, Lightness: Double);
    procedure SetHsv(Hue, Saturation, Value: Double);
    procedure SetRgb(Red, Green, Blue: Byte);
  published
    property AlphaPreview;
    property AlphaModulation;
    property Blue: Byte read FBlue write SetBlue default 127;
    property ColorModulation: Boolean read FColorModulation write SetColorModulation default True;
    property CurrentColor: TColor read GetCurrentColor write SetCurrentColor stored False nodefault;
    property Green: Byte read FGreen write SetGreen default 127;
    property Kind: TTurboRgbLinePickerKind read FKind write SetKind;
    property RangeBackground;
    property Red: Byte read FRed write SetRed default 127;
  end;

  // ===================================================================================================================
  // TTurboAlphaLinePicker
  // ===================================================================================================================

  { TTurboAlphaLinePickerPreviewStyle }

  TTurboAlphaLinePickerPreviewStyle = (RedGreenBlueGradient, GreenBlueRedGradient, RedGreenBlueLines);

  { TTurboAlphaLinePicker }

  TTurboAlphaLinePicker = class(TTurboColorLinePicker)
  strict private
    FAlpha: Byte;
    FColorModulation: Boolean;
    FColorPreview: TColor;
    FPreviewStyle: TTurboAlphaLinePickerPreviewStyle;
    function ShaderGreenBlueRedGradient(ValueX: Integer; ValueY: Double): TTurboColor;
    function ShaderModulated(Value: Integer): TTurboColor;
    function ShaderRedGreenBlueGradient(ValueX: Integer; ValueY: Double): TTurboColor;
    function ShaderRedGreenBlueLines(ValueX: Integer; ValueY: Double): TTurboColor;
    procedure SetAlpha(Value: Byte);
    procedure SetColorModulation(Value: Boolean);
    procedure SetColorPreview(Value: TColor);
    procedure SetPreviewStyle(Value: TTurboAlphaLinePickerPreviewStyle);
    procedure UpdateRgbPreview(Red, Green, Blue: Byte);
  protected
    function GetPickerRangeShader1D(): TTurboLinePickerShader1D; override;
    function GetPickerRangeShader2D(): TTurboLinePickerShader2D; override;
    function GetPickerValue(): Integer; override;
    procedure SetPickerValue(Value: Integer); override;
    function GetPickerThumbPreviewColor(): TColor; override;
  public
    constructor Create(Owner: TComponent); override;
    procedure GetHslPreview(out Hue, Saturation, Lightness: Double);
    procedure GetHsvPreview(out Hue, Saturation, Value: Double);
    procedure GetRgbPreview(out Red, Green, Blue: Byte);
    procedure SetHslPreview(Hue, Saturation, Lightness: Double);
    procedure SetHsvPreview(Hue, Saturation, Value: Double);
    procedure SetRgbPreview(Red, Green, Blue: Byte);
  published
    property RangeBackground;
    property Alpha: Byte read FAlpha write SetAlpha default 255;
    property ColorModulation: Boolean read FColorModulation write SetColorModulation default True;
    property ColorPreview: TColor read FColorPreview write SetColorPreview default $007F7F7F;
    property PreviewStyle: TTurboAlphaLinePickerPreviewStyle read FPreviewStyle write SetPreviewStyle default TTurboAlphaLinePickerPreviewStyle.RedGreenBlueGradient;
  end;

  // ===================================================================================================================
  // TTurboHslAxisPicker
  // ===================================================================================================================

  TTurboHslAxisPickerKind = (Hue, Saturation, Lightness);

  { TTurboHslAxisPicker }

  TTurboHslAxisPicker = class(TTurboColorFloatAxisPicker)
  strict private
    FHorizontalKind: TTurboHslAxisPickerKind;
    FHue: Double;
    FLightness: Double;
    FSaturation: Double;
    FVerticalKind: TTurboHslAxisPickerKind;
    function GetCurrentColor(): TColor;
    function IsHueStored(): Boolean;
    function IsLightnessStored(): Boolean;
    function IsSaturationStored(): Boolean;
    function ShaderHueAndLightness(ValueX, ValueY: Double): TTurboColor;
    function ShaderHueAndSaturation(ValueX, ValueY: Double): TTurboColor;
    function ShaderLightnessAndHue(ValueX, ValueY: Double): TTurboColor;
    function ShaderLightnessAndSaturation(ValueX, ValueY: Double): TTurboColor;
    function ShaderSaturationAndHue(ValueX, ValueY: Double): TTurboColor;
    function ShaderSaturationAndLightness(ValueX, ValueY: Double): TTurboColor;
    procedure SetCurrentColor(Value: TColor);
    procedure SetHorizontalKind(Value: TTurboHslAxisPickerKind);
    procedure SetHue(Value: Double);
    procedure SetLightness(Value: Double);
    procedure SetSaturation(Value: Double);
    procedure SetVerticalKind(Value: TTurboHslAxisPickerKind);
    procedure UpdateHsl(Hue, Saturation, Lightness: Double);
  protected
    function GetPickerRangeShader(): TTurboLinePickerFloatShader2D; override;
    function GetPickerThumbPreviewColor(): TColor; override;
    function GetPickerValue(): TPointF; override;
    procedure SetPickerValue(Value: TPointF); override;
  public
    constructor Create(Owner: TComponent); override;
    procedure GetHsl(out Hue, Saturation, Lightness: Double);
    procedure GetHsv(out Hue, Saturation, Value: Double);
    procedure GetRgb(out Red, Green, Blue: Byte);
    procedure SetHsl(Hue, Saturation, Lightness: Double);
    procedure SetHsv(Hue, Saturation, Value: Double);
    procedure SetRgb(Red, Green, Blue: Byte);
  published
    property AlphaPreview;
    property AlphaModulation;
    property CurrentColor: TColor read GetCurrentColor write SetCurrentColor stored False nodefault;
    property HorizontalKind: TTurboHslAxisPickerKind read FHorizontalKind write SetHorizontalKind;
    property Hue: Double read FHue write SetHue stored IsHueStored;
    property Lightness: Double read FLightness write SetLightness stored IsLightnessStored;
    property RangeBackground;
    property Saturation: Double read FSaturation write SetSaturation stored IsSaturationStored;
    property VerticalKind: TTurboHslAxisPickerKind read FVerticalKind write SetVerticalKind;
  end;

  // ===================================================================================================================
  // TTurboHsvAxisPicker
  // ===================================================================================================================

  TTurboHsvAxisPickerKind = (Hue, Saturation, Value);

  { TTurboHsvAxisPicker }

  TTurboHsvAxisPicker = class(TTurboColorFloatAxisPicker)
  strict private
    FHorizontalKind: TTurboHsvAxisPickerKind;
    FHue: Double;
    FSaturation: Double;
    FValue: Double;
    FVerticalKind: TTurboHsvAxisPickerKind;
    function GetCurrentColor(): TColor;
    function IsHueStored(): Boolean;
    function IsSaturationStored(): Boolean;
    function IsValueStored(): Boolean;
    function ShaderHueAndSaturation(ValueX, ValueY: Double): TTurboColor;
    function ShaderHueAndValue(ValueX, ValueY: Double): TTurboColor;
    function ShaderSaturationAndHue(ValueX, ValueY: Double): TTurboColor;
    function ShaderSaturationAndValue(ValueX, ValueY: Double): TTurboColor;
    function ShaderValueAndHue(ValueX, ValueY: Double): TTurboColor;
    function ShaderValueAndSaturation(ValueX, ValueY: Double): TTurboColor;
    procedure SetCurrentColor(Value: TColor);
    procedure SetHorizontalKind(Value: TTurboHsvAxisPickerKind);
    procedure SetHue(Value: Double);
    procedure SetSaturation(Value: Double);
    procedure SetValue(Value: Double);
    procedure SetVerticalKind(Value: TTurboHsvAxisPickerKind);
    procedure UpdateHsv(Hue, Saturation, Value: Double);
  protected
    function GetPickerRangeShader(): TTurboLinePickerFloatShader2D; override;
    function GetPickerThumbPreviewColor(): TColor; override;
    function GetPickerValue(): TPointF; override;
    procedure SetPickerValue(Value: TPointF); override;
  public
    constructor Create(Owner: TComponent); override;
    procedure GetHsl(out Hue, Saturation, Lightness: Double);
    procedure GetHsv(out Hue, Saturation, Value: Double);
    procedure GetRgb(out Red, Green, Blue: Byte);
    procedure SetHsl(Hue, Saturation, Lightness: Double);
    procedure SetHsv(Hue, Saturation, Value: Double);
    procedure SetRgb(Red, Green, Blue: Byte);
  published
    property AlphaPreview;
    property AlphaModulation;
    property CurrentColor: TColor read GetCurrentColor write SetCurrentColor stored False nodefault;
    property HorizontalKind: TTurboHsvAxisPickerKind read FHorizontalKind write SetHorizontalKind;
    property Hue: Double read FHue write SetHue stored IsHueStored;
    property RangeBackground;
    property Saturation: Double read FSaturation write SetSaturation stored IsSaturationStored;
    property Value: Double read FValue write SetValue stored IsValueStored;
    property VerticalKind: TTurboHsvAxisPickerKind read FVerticalKind write SetVerticalKind;
  end;

  // ===================================================================================================================
  // TTurboRgbAxisPicker
  // ===================================================================================================================

  TTurboRgbAxisPickerKind = (Red, Green, Blue);

  { TTurboRgbAxisPicker }

  TTurboRgbAxisPicker = class(TTurboColorAxisPicker)
  strict private
    FBlue: Byte;
    FGreen: Byte;
    FHorizontalKind: TTurboRgbAxisPickerKind;
    FRed: Byte;
    FVerticalKind: TTurboRgbAxisPickerKind;
    function GetCurrentColor(): TColor;
    function ShaderBlueAndGreen(ValueX, ValueY: Integer): TTurboColor;
    function ShaderBlueAndRed(ValueX, ValueY: Integer): TTurboColor;
    function ShaderGreenAndBlue(ValueX, ValueY: Integer): TTurboColor;
    function ShaderGreenAndRed(ValueX, ValueY: Integer): TTurboColor;
    function ShaderRedAndBlue(ValueX, ValueY: Integer): TTurboColor;
    function ShaderRedAndGreen(ValueX, ValueY: Integer): TTurboColor;
    procedure SetBlue(Value: Byte);
    procedure SetCurrentColor(Value: TColor);
    procedure SetGreen(Value: Byte);
    procedure SetHorizontalKind(Value: TTurboRgbAxisPickerKind);
    procedure SetRed(Value: Byte);
    procedure SetVerticalKind(Value: TTurboRgbAxisPickerKind);
    procedure UpdateRgb(Red, Green, Blue: Byte);
  protected
    function GetPickerRangeShader(): TTurboAxisPickerShader; override;
    function GetPickerThumbPreviewColor(): TColor; override;
    function GetPickerValue(): TPoint; override;
    procedure SetPickerValue(Value: TPoint); override;
  public
    constructor Create(Owner: TComponent); override;
    procedure GetHsl(out Hue, Saturation, Lightness: Double);
    procedure GetHsv(out Hue, Saturation, Value: Double);
    procedure GetRgb(out Red, Green, Blue: Byte);
    procedure SetHsl(Hue, Saturation, Lightness: Double);
    procedure SetHsv(Hue, Saturation, Value: Double);
    procedure SetRgb(Red, Green, Blue: Byte);
  published
    property AlphaPreview;
    property AlphaModulation;
    property Blue: Byte read FBlue write SetBlue default 127;
    property CurrentColor: TColor read GetCurrentColor write SetCurrentColor stored False nodefault;
    property Green: Byte read FGreen write SetGreen default 127;
    property HorizontalKind: TTurboRgbAxisPickerKind read FHorizontalKind write SetHorizontalKind;
    property RangeBackground;
    property Red: Byte read FRed write SetRed default 127;
    property VerticalKind: TTurboRgbAxisPickerKind read FVerticalKind write SetVerticalKind;
  end;

  // ===================================================================================================================
  // TTurboColorCell
  // ===================================================================================================================

  { TTurboColorCell }

  TTurboColorCell = class(TTurboCustomCell)
  strict private
    FAlphaPreview: Byte;
    FBackground: TTurboTransparentBackground;
    FValue: TColor;
    FForceRepaint: Boolean;
    procedure BackgroundChange({%H-}Sender: TObject);
    procedure SetAlphaPreview(Value: Byte);
    procedure SetBackground(Value: TTurboTransparentBackground);
    procedure SetValue(Value: TColor);
  protected
    procedure DrawCell(const CellRect: TRect); override;
  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy(); override;
    procedure GetHsl(out Hue, Saturation, Lightness: Double);
    procedure GetHsv(out Hue, Saturation, Value: Double);
    procedure GetRgb(out Red, Green, Blue: Byte);
    procedure SetHsl(Hue, Saturation, Lightness: Double);
    procedure SetHsv(Hue, Saturation, Value: Double);
    procedure SetRgb(Red, Green, Blue: Byte);
  published
    property AlphaPreview: Byte read FAlphaPreview write SetAlphaPreview default 255;
    property Background: TTurboTransparentBackground read FBackground write SetBackground;
    property ForceRepaint: Boolean read FForceRepaint write FForceRepaint default True;
    property Value: TColor read FValue write SetValue default $007F7F7F;
  end;

implementation

{ TTurboAbstractLinePicker }

constructor TTurboAbstractLinePicker.Create(Owner: TComponent);
begin
  inherited Create(Owner);

  // make bitmaps
  FRangeBitmap := TBitmap.Create();
  FRangeBitmap.PixelFormat := pf24bit;

  // make thumb size
  FThumbSize := TTurboAutoSize.Create();
  FThumbSize.OnChange := ThumbSizeChange;

  // make padding size
  FRangePadding := TTurboAutoPadding.Create();
  FRangePadding.OnChange := RangePaddingChange;

  // defaults
  FAllowFocus := True;
  FForceRepaint := True;
  FLayout := TTurboLinePickerLayout.ExternalArrows;
  FOrientation := TTurboLinePickerOrientation.Horizontal;
  FPositionLineVisible := False;
  FRangeBorderColor := clDefault;
  FRangeBorderFocusedColor := clDefault;
  FRangeBorderWidth := 1;
  FRangeBorderSpace := 0;
  FRangeBorderVisible := True;
  FReverse := False;
  FThumbColor := clDefault;
  FThumbFocusedColor := clDefault;
  FThumbLayout := TTurboLinePickerThumbLayout.Both;
  FThumbLineColor := clDefault;
  FThumbLineFocusedColor := clDefault;
  FThumbPreviewColor := clDefault;
  FThumbSpace := 0;

  // inherited defaults
  SetInitialBounds(0, 0, GetControlClassDefaultSize().CX, GetControlClassDefaultSize().CY);
  TabStop := True;
  ControlStyle := ControlStyle + [csCaptureMouse];

  // need update
  FNeedUpdateRangeBitmap := True;
end;

destructor TTurboAbstractLinePicker.Destroy();
begin
  FRangeBitmap.Free();
  FThumbSize.Free();
  FRangePadding.Free();

  inherited Destroy();
end;

procedure TTurboAbstractLinePicker.SetOrientation(Value: TTurboLinePickerOrientation);
var
  Temp: Integer;
begin
  if FOrientation = Value then
  begin
    exit;
  end;

  FOrientation := Value;

  if (csDesigning in ComponentState) and not (csLoading in ComponentState) then
  begin
    // swap width and height
    Temp := Width;
    Width := Height;
    Height := Temp;
  end;

  PickerInvalidate(True);
end;

procedure TTurboAbstractLinePicker.SetRangeBorderColor(Value: TColor);
begin
  if FRangeBorderColor = Value then
  begin
    exit;
  end;

  FRangeBorderColor := Value;

  Invalidate();
end;

procedure TTurboAbstractLinePicker.SetRangeBorderFocusedColor(Value: TColor);
begin
  if FRangeBorderFocusedColor = Value then
  begin
    exit;
  end;

  FRangeBorderFocusedColor := Value;

  Invalidate();
end;

procedure TTurboAbstractLinePicker.SetRangeBorderWidth(Value: Integer);
begin
  Value := EnsureRange(Value, 1, 64);

  if FRangeBorderWidth = Value then
  begin
    exit;
  end;

  FRangeBorderWidth := Value;

  AdjustContent();
end;

procedure TTurboAbstractLinePicker.SetRangeBorderSpace(Value: Integer);
begin
  Value := EnsureRange(Value, 0, 64);

  if FRangeBorderSpace = Value then
  begin
    exit;
  end;

  FRangeBorderSpace := Value;

  AdjustContent();
end;

procedure TTurboAbstractLinePicker.SetRangeBorderVisible(Value: Boolean);
begin
  if FRangeBorderVisible = Value then
  begin
    exit;
  end;

  FRangeBorderVisible := Value;

  AdjustContent();
end;

procedure TTurboAbstractLinePicker.SetRangePadding(Value: TTurboAutoPadding);
begin
  FRangePadding.Assign(Value);
end;

procedure TTurboAbstractLinePicker.SetReverse(Value: Boolean);
begin
  if FReverse = Value then
  begin
    exit;
  end;

  FReverse := Value;

  PickerInvalidate(True);
end;

procedure TTurboAbstractLinePicker.SetThumbLayout(Value: TTurboLinePickerThumbLayout);
begin
  if FThumbLayout = Value then
  begin
    exit;
  end;

  FThumbLayout := Value;

  AdjustContent();
end;

procedure TTurboAbstractLinePicker.SetThumbColor(Value: TColor);
begin
  if FThumbColor = Value then
  begin
    exit;
  end;

  FThumbColor := Value;

  Invalidate();
end;

procedure TTurboAbstractLinePicker.SetPositionLineVisible(Value: Boolean);
begin
  if FPositionLineVisible = Value then
  begin
    exit;
  end;

  FPositionLineVisible := Value;

  Invalidate();
end;

procedure TTurboAbstractLinePicker.SetThumbFocusedColor(Value: TColor);
begin
  if FThumbFocusedColor = Value then
  begin
    exit;
  end;

  FThumbFocusedColor := Value;

  Invalidate();
end;

procedure TTurboAbstractLinePicker.SetLayout(Value: TTurboLinePickerLayout);
begin
  if FLayout = Value then
  begin
    exit;
  end;

  FLayout := Value;

  AdjustContent();
end;

procedure TTurboAbstractLinePicker.SetThumbLineColor(Value: TColor);
begin
  if FThumbLineColor = Value then
  begin
    exit;
  end;

  FThumbLineColor := Value;

  Invalidate();
end;

procedure TTurboAbstractLinePicker.SetThumbLineFocusedColor(Value: TColor);
begin
  if FThumbLineFocusedColor = Value then
  begin
    exit;
  end;

  FThumbLineFocusedColor := Value;

  Invalidate();
end;

procedure TTurboAbstractLinePicker.SetThumbPreviewColor(Value: TColor);
begin
  if FThumbPreviewColor = Value then
  begin
    exit;
  end;

  FThumbPreviewColor := Value;

  Invalidate();
end;

procedure TTurboAbstractLinePicker.SetThumbSize(Value: TTurboAutoSize);
begin
  FThumbSize.Assign(Value);
end;

procedure TTurboAbstractLinePicker.SetThumbSpace(Value: Integer);
begin
  if FThumbSpace = Value then
  begin
    exit;
  end;

  FThumbSpace := Value;

  AdjustContent();

  Invalidate();
end;

function TTurboAbstractLinePicker.GetPickerRangeRect(): TRect;
begin
  Result := TRect.Create(
    ClientRect.Left + FRangePadding.Left,
    ClientRect.Top + FRangePadding.Top,
    ClientRect.Right - FRangePadding.Right,
    ClientRect.Bottom - FRangePadding.Bottom
  );
end;

procedure TTurboAbstractLinePicker.RangePaddingChange(Sender: TObject);
begin
  AdjustContent();

  PickerInvalidate(True);
end;

procedure TTurboAbstractLinePicker.ThumbSizeChange(Sender: TObject);
begin
  AdjustContent();

  Invalidate();
end;

procedure TTurboAbstractLinePicker.AdjustContent();
var
  FirstThumb, SecondThumb: Boolean;
begin
  if csLoading in ComponentState then
  begin
    exit;
  end;

  if FThumbSize.IsAutoWidth then
  begin
    case FLayout of
      TTurboLinePickerLayout.ExternalArrows:
      begin
        FThumbSize.Width := Scale96ToFont(DefaultThumbExternalSize);
      end;
      TTurboLinePickerLayout.InternalArrows:
      begin
        FThumbSize.Width := Scale96ToFont(DefaultThumbInternalSize);
      end;
      TTurboLinePickerLayout.CenterArrows:
      begin
        FThumbSize.Width := Scale96ToFont(DefaultThumbCenterSize);
      end;
      TTurboLinePickerLayout.OverlapBox, TTurboLinePickerLayout.InsideBox:
      begin
        FThumbSize.Width := Scale96ToFont(DefaultThumbBoxWidth);
      end;
    end;
  end else
  begin
    FThumbSize.Width := EnsureRange(FThumbSize.Width, 6, 64);
  end;
  if FThumbSize.IsAutoHeight then
  begin
    case FLayout of
      TTurboLinePickerLayout.ExternalArrows:
      begin
        FThumbSize.Height := Scale96ToFont(DefaultThumbExternalSize);
      end;
      TTurboLinePickerLayout.InternalArrows:
      begin
        FThumbSize.Height := Scale96ToFont(DefaultThumbInternalSize);
      end;
      TTurboLinePickerLayout.CenterArrows:
      begin
        FThumbSize.Height := Scale96ToFont(DefaultThumbCenterSize);
      end;
      TTurboLinePickerLayout.OverlapBox, TTurboLinePickerLayout.InsideBox:
      begin
        FThumbSize.Height := Scale96ToFont(DefaultThumbBoxWidth);
      end;
    end;
  end else
  begin
    FThumbSize.Height := EnsureRange(FThumbSize.Height, 6, 64);
  end;

  FirstThumb := FThumbLayout in [TTurboLinePickerThumbLayout.First, TTurboLinePickerThumbLayout.Both];
  SecondThumb := FThumbLayout in [TTurboLinePickerThumbLayout.Second, TTurboLinePickerThumbLayout.Both];
  if Orientation = TTurboLinePickerOrientation.Horizontal then
  begin
    case FLayout of
      TTurboLinePickerLayout.ExternalArrows, TTurboLinePickerLayout.CenterArrows:
      begin
        if FRangePadding.IsAutoLeft then
        begin
          FRangePadding.Left := Math.Max(
            FThumbSize.Width div 2,
            Integer(FRangeBorderVisible) * FRangeBorderWidth + Integer(FRangeBorderVisible) * FRangeBorderSpace
          );
        end;
        if FRangePadding.IsAutoRight then
        begin
          FRangePadding.Right := Math.Max(
            FThumbSize.Width div 2,
            Integer(FRangeBorderVisible) * FRangeBorderWidth + Integer(FRangeBorderVisible) * FRangeBorderSpace
          );
        end;
        if FRangePadding.IsAutoTop then
        begin
          FRangePadding.Top := Math.Max(
            Integer(FirstThumb) * FThumbSize.Height div (Integer(FLayout = TTurboLinePickerLayout.CenterArrows) + 1) + FThumbSpace,
            Integer(FRangeBorderVisible) * FRangeBorderWidth + Integer(FRangeBorderVisible) * FRangeBorderSpace
          );
        end;
        if FRangePadding.IsAutoBottom then
        begin
          FRangePadding.Bottom := Math.Max(
            Integer(SecondThumb) * FThumbSize.Height div (Integer(FLayout = TTurboLinePickerLayout.CenterArrows) + 1) + FThumbSpace,
            Integer(FRangeBorderVisible) * FRangeBorderWidth + Integer(FRangeBorderVisible) * FRangeBorderSpace
          );
        end;
      end;
      TTurboLinePickerLayout.InternalArrows:
      begin
        if FRangePadding.IsAutoLeft then
        begin
          FRangePadding.Left := Integer(FRangeBorderVisible) * FRangeBorderWidth + Integer(FRangeBorderVisible) * FRangeBorderSpace;
        end;
        if FRangePadding.IsAutoRight then
        begin
          FRangePadding.Right := Integer(FRangeBorderVisible) * FRangeBorderWidth + Integer(FRangeBorderVisible) * FRangeBorderSpace;
        end;
        if FRangePadding.IsAutoTop then
        begin
          FRangePadding.Top := Integer(FRangeBorderVisible) * FRangeBorderWidth + Integer(FRangeBorderVisible) * FRangeBorderSpace;
        end;
        if FRangePadding.IsAutoBottom then
        begin
          FRangePadding.Bottom := Integer(FRangeBorderVisible) * FRangeBorderWidth + Integer(FRangeBorderVisible) * FRangeBorderSpace;
        end;
      end;
      TTurboLinePickerLayout.OverlapBox, TTurboLinePickerLayout.InsideBox:
      begin
        if FRangePadding.IsAutoLeft then
        begin
          FRangePadding.Left := Math.Max(
            FThumbSize.Width div 2,
            Integer(FRangeBorderVisible) * FRangeBorderWidth + Integer(FRangeBorderVisible) * FRangeBorderSpace
          );
        end;
        if FRangePadding.IsAutoRight then
        begin
          FRangePadding.Right := Math.Max(
            FThumbSize.Width div 2,
            Integer(FRangeBorderVisible) * FRangeBorderWidth + Integer(FRangeBorderVisible) * FRangeBorderSpace
          );
        end;
        if FRangePadding.IsAutoTop then
        begin
          FRangePadding.Top := Math.Max(
            Integer(FirstThumb) * FThumbSize.Height * Integer(FLayout = TTurboLinePickerLayout.OverlapBox),
            Integer(FRangeBorderVisible) * FRangeBorderWidth + Integer(FRangeBorderVisible) * FRangeBorderSpace
          );
        end;
        if FRangePadding.IsAutoBottom then
        begin
          FRangePadding.Bottom := Math.Max(
            Integer(SecondThumb) * FThumbSize.Height * Integer(FLayout = TTurboLinePickerLayout.OverlapBox),
            Integer(FRangeBorderVisible) * FRangeBorderWidth + Integer(FRangeBorderVisible) * FRangeBorderSpace
          );
        end;
      end;
    end;
  end else
  begin
    case FLayout of
      TTurboLinePickerLayout.ExternalArrows, TTurboLinePickerLayout.CenterArrows:
      begin
        if FRangePadding.IsAutoTop then
        begin
          FRangePadding.Top := Math.Max(
            FThumbSize.Height div 2,
            Integer(FRangeBorderVisible) * FRangeBorderWidth + Integer(FRangeBorderVisible) * FRangeBorderSpace
          );
        end;
        if FRangePadding.IsAutoBottom then
        begin
          FRangePadding.Bottom := Math.Max(
            FThumbSize.Height div 2,
            Integer(FRangeBorderVisible) * FRangeBorderWidth + Integer(FRangeBorderVisible) * FRangeBorderSpace
          );
        end;
        if FRangePadding.IsAutoLeft then
        begin
          FRangePadding.Left := Math.Max(
            Integer(FirstThumb) * FThumbSize.Width div (Integer(FLayout = TTurboLinePickerLayout.CenterArrows) + 1) + FThumbSpace,
            Integer(FRangeBorderVisible) * FRangeBorderWidth + Integer(FRangeBorderVisible) * FRangeBorderSpace
          );
        end;
        if FRangePadding.IsAutoRight then
        begin
          FRangePadding.Right := Math.Max(
            Integer(SecondThumb) * FThumbSize.Width div (Integer(FLayout = TTurboLinePickerLayout.CenterArrows) + 1) + FThumbSpace,
            Integer(FRangeBorderVisible) * FRangeBorderWidth + Integer(FRangeBorderVisible) * FRangeBorderSpace
          );
        end;
      end;
      TTurboLinePickerLayout.InternalArrows:
      begin
        if FRangePadding.IsAutoTop then
        begin
          FRangePadding.Top := Integer(FRangeBorderVisible) * FRangeBorderWidth + Integer(FRangeBorderVisible) * FRangeBorderSpace;
        end;
        if FRangePadding.IsAutoBottom then
        begin
          FRangePadding.Bottom := Integer(FRangeBorderVisible) * FRangeBorderWidth + Integer(FRangeBorderVisible) * FRangeBorderSpace;
        end;
        if FRangePadding.IsAutoLeft then
        begin
          FRangePadding.Left := Integer(FRangeBorderVisible) * FRangeBorderWidth + Integer(FRangeBorderVisible) * FRangeBorderSpace;
        end;
        if FRangePadding.IsAutoRight then
        begin
          FRangePadding.Right := Integer(FRangeBorderVisible) * FRangeBorderWidth + Integer(FRangeBorderVisible) * FRangeBorderSpace;
        end;
      end;
      TTurboLinePickerLayout.OverlapBox, TTurboLinePickerLayout.InsideBox:
      begin
        if FRangePadding.IsAutoTop then
        begin
          FRangePadding.Top := Math.Max(
            FThumbSize.Height div 2,
            Integer(FRangeBorderVisible) * FRangeBorderWidth + Integer(FRangeBorderVisible) * FRangeBorderSpace
          );
        end;
        if FRangePadding.IsAutoBottom then
        begin
          FRangePadding.Bottom := Math.Max(
            FThumbSize.Height div 2,
            Integer(FRangeBorderVisible) * FRangeBorderWidth + Integer(FRangeBorderVisible) * FRangeBorderSpace
          );
        end;
        if FRangePadding.IsAutoLeft then
        begin
          FRangePadding.Left := Math.Max(
            Integer(FirstThumb) * FThumbSize.Width * Integer(FLayout = TTurboLinePickerLayout.OverlapBox),
            Integer(FRangeBorderVisible) * FRangeBorderWidth + Integer(FRangeBorderVisible) * FRangeBorderSpace
          );
        end;
        if FRangePadding.IsAutoRight then
        begin
          FRangePadding.Right := Math.Max(
            Integer(SecondThumb) * FThumbSize.Width * Integer(FLayout = TTurboLinePickerLayout.OverlapBox),
            Integer(FRangeBorderVisible) * FRangeBorderWidth + Integer(FRangeBorderVisible) * FRangeBorderSpace
          );
        end;
      end;
    end;
  end;
end;

procedure TTurboAbstractLinePicker.PickerRepaint(NeedUpdateRangeBitmap: Boolean);
begin
  if NeedUpdateRangeBitmap then
  begin
    FNeedUpdateRangeBitmap := True;
  end;

  if FForceRepaint then
  begin
    if csLoading in ComponentState then
    begin
      exit;
    end;
    Refresh();
  end else
  begin
    Invalidate();
  end;
end;

procedure TTurboAbstractLinePicker.PickerInvalidate(NeedUpdateRangeBitmap: Boolean);
begin
  if NeedUpdateRangeBitmap then
  begin
    FNeedUpdateRangeBitmap := True;
  end;

  Invalidate();
end;

procedure TTurboAbstractLinePicker.PickerChanged();
begin
  if Assigned(FOnChange) and not(csLoading in ComponentState) then
  begin
    FOnChange(Self);
  end;
end;

procedure TTurboAbstractLinePicker.PickerUserChanged();
begin
  if Assigned(FOnUserChange) and not(csLoading in ComponentState) then
  begin
    FOnUserChange(Self);
  end;
end;

function TTurboAbstractLinePicker.GetPickerThumbPreviewColor: TColor;
begin
  Result := clHighlight;
end;

class function TTurboAbstractLinePicker.GetControlClassDefaultSize(): TSize;
begin
  Result := TSize.Create(120, 24);
end;

procedure TTurboAbstractLinePicker.Paint();
var
  FillColor, StrokeColor, PreviewColor: TColor;
  FrameRect: TRect;
  RangeRect: TRect;
  Offset: Integer;
  Size: Integer;
begin
  inherited Paint();

  RangeRect := GetPickerRangeRect();

  // update FRangeBitmap
  if FNeedUpdateRangeBitmap then
  begin
    FRangeBitmap.SetSize(RangeRect.Width, RangeRect.Height);
    if (FRangeBitmap.Width <> 0) and (FRangeBitmap.Height <> 0) then
    begin
    	PaintRangeBitmap(FRangeBitmap);
    end;
    FNeedUpdateRangeBitmap := False;
  end;

  // draw border
  if FRangeBorderVisible then
  begin
    FrameRect := RangeRect;
    InflateRect(FrameRect, FRangeBorderSpace + FRangeBorderWidth, FRangeBorderSpace + FRangeBorderWidth);

    if Focused then
    begin
      DrawFrameRect(Canvas, FrameRect, FRangeBorderWidth, IfThen(FRangeBorderFocusedColor = clDefault, clHighlight, FRangeBorderFocusedColor));
    end else
    begin
      DrawFrameRect(Canvas, FrameRect, FRangeBorderWidth, IfThen(FRangeBorderColor = clDefault, clGrayText, FRangeBorderColor));
    end;
  end;

  // draw range
  Canvas.Draw(RangeRect.Left, RangeRect.Top, FRangeBitmap);

  // choose thumb color
  if not (FLayout in [TTurboLinePickerLayout.OverlapBox, TTurboLinePickerLayout.InsideBox]) then
  begin
    if Focused then
    begin
      FillColor := ColorToRGB(IfThen(FThumbFocusedColor = clDefault, clHighlight, FThumbFocusedColor));
      StrokeColor := ColorToRGB(IfThen(FThumbLineFocusedColor = clDefault, clHighlightText, FThumbLineFocusedColor));
    end else
    begin
      FillColor := ColorToRGB(IfThen(FThumbColor = clDefault, clWindowText, FThumbColor));
      StrokeColor := ColorToRGB(IfThen(FThumbLineColor = clDefault, clWindow, FThumbLineColor));
    end;
  end else
  begin
    if Focused then
    begin
      FillColor := ColorToRGB(IfThen(FThumbLineFocusedColor = clDefault, clHighlightText, FThumbLineFocusedColor));
      StrokeColor := ColorToRGB(IfThen(FThumbFocusedColor = clDefault, clHighlight, FThumbFocusedColor));
    end else
    begin
      FillColor := ColorToRGB(IfThen(FThumbLineColor = clDefault, clForm, FThumbLineColor));
      StrokeColor := ColorToRGB(IfThen(FThumbColor = clDefault, clWindowText, FThumbColor));
    end;
    PreviewColor := ColorToRGB(IfThen(FThumbPreviewColor = clDefault, GetPickerThumbPreviewColor(), FThumbPreviewColor));
  end;

  // draw thumb
  if FOrientation = TTurboLinePickerOrientation.Horizontal then
  begin
    // calc disp offset
    Offset := GetPickerAbsolutePosition(RangeRect.Width);

    // draw position line
    if FPositionLineVisible then
    begin
      Canvas.SaveHandleState();
      try
        IntersectClipRect(Canvas.Handle, RangeRect.Left, RangeRect.Top, RangeRect.Right, RangeRect.Bottom);

        DrawAxisLine(Canvas, RangeRect.Left + Offset, RangeRect.Top, RangeRect.Height, True, FillColor, StrokeColor, 160);
      finally
        Canvas.RestoreHandleState();
      end;
    end;

    // draw thumb
    Size := FThumbSize.Width + Integer(not Odd(FThumbSize.Width));
    case FLayout of
      TTurboLinePickerLayout.ExternalArrows, TTurboLinePickerLayout.CenterArrows:
      begin
        // top
        if FThumbLayout in [TTurboLinePickerThumbLayout.First, TTurboLinePickerThumbLayout.Both] then
        begin
          DrawTriangleThumb(
            Canvas,
            RangeRect.Left + Offset - Size div 2,
            RangeRect.Top - FThumbSize.Height div (Integer(FLayout = TTurboLinePickerLayout.CenterArrows) + 1) - FThumbSpace,
            Size,
            FThumbSize.Height,
            TTurboTriangleThumbOrientation.Down,
            FillColor,
            StrokeColor
          );
        end;
        // bottom
        if FThumbLayout in [TTurboLinePickerThumbLayout.Second, TTurboLinePickerThumbLayout.Both] then
        begin
          DrawTriangleThumb(
            Canvas,
            RangeRect.Left + Offset - Size div 2,
            RangeRect.Bottom - (FThumbSize.Height div 2 * Integer(FLayout = TTurboLinePickerLayout.CenterArrows)) + FThumbSpace,
            Size,
            FThumbSize.Height,
            TTurboTriangleThumbOrientation.Up,
            FillColor,
            StrokeColor
          );
        end;
      end;
      TTurboLinePickerLayout.InternalArrows:
      begin
        Canvas.SaveHandleState();
        try
          IntersectClipRect(Canvas.Handle, RangeRect.Left, RangeRect.Top, RangeRect.Right, RangeRect.Bottom);
          // top
          if FThumbLayout in [TTurboLinePickerThumbLayout.First, TTurboLinePickerThumbLayout.Both] then
          begin
            DrawTriangleThumb(
              Canvas,
              RangeRect.Left + Offset - Size div 2,
              RangeRect.Top + FThumbSpace,
              Size,
              FThumbSize.Height,
              TTurboTriangleThumbOrientation.Down,
              FillColor,
              StrokeColor
            );
          end;
          // bottom
          if FThumbLayout in [TTurboLinePickerThumbLayout.Second, TTurboLinePickerThumbLayout.Both] then
          begin
            DrawTriangleThumb(
              Canvas,
              RangeRect.Left + Offset - Size div 2,
              RangeRect.Bottom - FThumbSize.Height - FThumbSpace,
              Size,
              FThumbSize.Height,
              TTurboTriangleThumbOrientation.Up,
              FillColor,
              StrokeColor
            );
          end;
        finally
          Canvas.RestoreHandleState();
        end;
      end;
      TTurboLinePickerLayout.OverlapBox, TTurboLinePickerLayout.InsideBox:
      begin
        DrawRectangleThumb(
          Canvas,
          RangeRect.Left + Offset - Size div 2,
          ClientRect.Top,
          Size,
          ClientHeight,
          FillColor,
          StrokeColor,
          PreviewColor
        );
      end;
    end;
  end else
  begin
    // calc disp offset
    Offset := GetPickerAbsolutePosition(RangeRect.Height);

    // draw position line
    if FPositionLineVisible then
    begin
      Canvas.SaveHandleState();
      try
        IntersectClipRect(Canvas.Handle, RangeRect.Left, RangeRect.Top, RangeRect.Right, RangeRect.Bottom);

        DrawAxisLine(Canvas, RangeRect.Left, RangeRect.Top + Offset, RangeRect.Width, False, FillColor, StrokeColor, 160);
      finally
        Canvas.RestoreHandleState();
      end;
    end;

    // draw thumb
    Size := FThumbSize.Height + Integer(not Odd(FThumbSize.Height));
    case FLayout of
      TTurboLinePickerLayout.ExternalArrows, TTurboLinePickerLayout.CenterArrows:
      begin
        // left
        if FThumbLayout in [TTurboLinePickerThumbLayout.First, TTurboLinePickerThumbLayout.Both] then
        begin
          DrawTriangleThumb(
            Canvas,
            RangeRect.Left - FThumbSize.Width div (Integer(FLayout = TTurboLinePickerLayout.CenterArrows) + 1) - FThumbSpace,
            RangeRect.Top + Offset - Size div 2,
            FThumbSize.Width,
            Size,
            TTurboTriangleThumbOrientation.Right,
            FillColor,
            StrokeColor
          );
        end;
        // right
        if FThumbLayout in [TTurboLinePickerThumbLayout.Second, TTurboLinePickerThumbLayout.Both] then
        begin
          DrawTriangleThumb(
            Canvas,
            RangeRect.Right - (FThumbSize.Width div 2 * Integer(FLayout = TTurboLinePickerLayout.CenterArrows)) + FThumbSpace,
            RangeRect.Top + Offset - Size div 2,
            FThumbSize.Width,
            Size,
            TTurboTriangleThumbOrientation.Left,
            FillColor,
            StrokeColor
          );
        end;
      end;
      TTurboLinePickerLayout.InternalArrows:
      begin
        Canvas.SaveHandleState();
        try
          IntersectClipRect(Canvas.Handle, RangeRect.Left, RangeRect.Top, RangeRect.Right, RangeRect.Bottom);
          // top
          if FThumbLayout in [TTurboLinePickerThumbLayout.First, TTurboLinePickerThumbLayout.Both] then
          begin
            DrawTriangleThumb(
              Canvas,
              RangeRect.Left + FThumbSpace,
              RangeRect.Top + Offset - Size div 2,
              FThumbSize.Width,
              Size,
              TTurboTriangleThumbOrientation.Right,
              FillColor,
              StrokeColor
            );
          end;
          // bottom
          if FThumbLayout in [TTurboLinePickerThumbLayout.Second, TTurboLinePickerThumbLayout.Both] then
          begin
            DrawTriangleThumb(
              Canvas,
              RangeRect.Right - FThumbSize.Width - FThumbSpace,
              RangeRect.Top + Offset - Size div 2,
              FThumbSize.Width,
              Size,
              TTurboTriangleThumbOrientation.Left,
              FillColor,
              StrokeColor
            );
          end;
        finally
          Canvas.RestoreHandleState();
        end;
      end;
      TTurboLinePickerLayout.OverlapBox, TTurboLinePickerLayout.InsideBox:
      begin
        DrawRectangleThumb(
          Canvas,
          ClientRect.Left,
          RangeRect.Top + Offset - Size div 2,
          ClientWidth,
          Size,
          FillColor,
          StrokeColor,
          PreviewColor
        );
      end;
    end;
  end;
end;

procedure TTurboAbstractLinePicker.AutoAdjustLayout(Mode: TLayoutAdjustmentPolicy; const FromPPI, ToPPI, OldFormWidth, NewFormWidth: Integer);
begin
  inherited AutoAdjustLayout(Mode, FromPPI, ToPPI, OldFormWidth, NewFormWidth);

  FThumbSpace := MulDiv(FThumbSpace, ToPPI, FromPPI);

  FThumbSize.Width := MulDiv(FThumbSize.Width, ToPPI, FromPPI);
  FThumbSize.Height := MulDiv(FThumbSize.Height, ToPPI, FromPPI);

  FRangePadding.Left := MulDiv(FRangePadding.Left, ToPPI, FromPPI);
  FRangePadding.Right := MulDiv(FRangePadding.Right, ToPPI, FromPPI);
  FRangePadding.Top := MulDiv(FRangePadding.Top, ToPPI, FromPPI);
  FRangePadding.Bottom := MulDiv(FRangePadding.Bottom, ToPPI, FromPPI);
end;

function TTurboAbstractLinePicker.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean;
var
  Delta: Integer;
begin
  inherited DoMouseWheel(Shift, WheelDelta, MousePos);
  Result := True;

  if WheelDelta < 0 then
  begin
    Delta := Min(-1, WheelDelta div 120);
  end else
  begin
    Delta := Max(1, WheelDelta div 120);
  end;

  if FReverse {and (FOrientation = TTurboLinePickerOrientation.Vertical)} then
  begin
    Delta := -Delta;
  end;

  MovePicker(Delta, ssCtrl in Shift);
end;

function TTurboAbstractLinePicker.IsAllowFocus(): Boolean;
begin
  Result := FAllowFocus;
end;

procedure TTurboAbstractLinePicker.KeyDown(var Key: Word; Shift: TShiftState);
var
  OriginalKey: Word;
  Delta: Integer;
begin
  OriginalKey := Key;
  Key := 0;

  if FReverse then
  begin
  	Delta := -1;
  end else
  begin
    Delta := 1;
  end;

  if FOrientation = TTurboLinePickerOrientation.Horizontal then
  begin
    case OriginalKey of
      VK_LEFT:
      begin
        MovePicker(-Delta, ssCtrl in Shift);
      end;
      VK_RIGHT:
      begin
        MovePicker(Delta, ssCtrl in Shift);
      end;
      else
        Key := OriginalKey;
    end;
  end else
  begin
    case OriginalKey of
      VK_DOWN:
      begin
        MovePicker(Delta, ssCtrl in Shift);
      end;
      VK_UP:
      begin
        MovePicker(-Delta, ssCtrl in Shift);
      end;
      else
        Key := OriginalKey;
    end;
  end;

  inherited KeyDown(Key, Shift);
end;

procedure TTurboAbstractLinePicker.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);

  if Button = mbLeft then
  begin
    TrySetFocus();

    if FOrientation = TTurboLinePickerOrientation.Horizontal then
    begin
      SetPickerAbsolutePosition(GetPickerRangeRect().Width, X - GetPickerRangeRect().Left);
    end else
    begin
      SetPickerAbsolutePosition(GetPickerRangeRect().Height, Y - GetPickerRangeRect().Top);
    end;
  end;
end;

procedure TTurboAbstractLinePicker.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove(Shift, X, Y);

  if csLButtonDown in ControlState then
  begin
    if FOrientation = TTurboLinePickerOrientation.Horizontal then
    begin
      SetPickerAbsolutePosition(GetPickerRangeRect().Width, X - GetPickerRangeRect().Left);
    end else
    begin
      SetPickerAbsolutePosition(GetPickerRangeRect().Height, Y - GetPickerRangeRect().Top);
    end;
  end;
end;

procedure TTurboAbstractLinePicker.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);

  if Button = mbLeft then
  begin
    if FOrientation = TTurboLinePickerOrientation.Horizontal then
    begin
      SetPickerAbsolutePosition(GetPickerRangeRect().Width, X - GetPickerRangeRect().Left);
    end else
    begin
      SetPickerAbsolutePosition(GetPickerRangeRect().Height, Y - GetPickerRangeRect().Top);
    end;
  end;
end;

procedure TTurboAbstractLinePicker.Resize();
begin
  inherited Resize();

  AdjustContent();

  PickerInvalidate(True);
end;

procedure TTurboAbstractLinePicker.DoEnter();
begin
  inherited DoEnter();

  Invalidate();
end;

procedure TTurboAbstractLinePicker.DoExit();
begin
  inherited DoExit();

  Invalidate();
end;

{ TTurboCustomLinePicker }

constructor TTurboCustomLinePicker.Create(Owner: TComponent);
begin
  inherited Create(Owner);

  FMin := GetDefaultRange().Min;
  FMax := GetDefaultRange().Max;

  FIncrement := GetDefaultIncrement();
  FIncrementMultiplier := GetDefaultIncrementMultiplier();
end;

function TTurboCustomLinePicker.IsIncrementMultiplierStored(): Boolean;
begin
  Result := FIncrementMultiplier <> GetDefaultIncrementMultiplier();
end;

function TTurboCustomLinePicker.IsIncrementStored(): Boolean;
begin
  Result := GetDefaultIncrement() <> FIncrement;
end;

function TTurboCustomLinePicker.IsMaxStored(): Boolean;
begin
  Result := GetDefaultRange().Max <> FMax;
end;

function TTurboCustomLinePicker.IsMinStored(): Boolean;
begin
  Result := GetDefaultRange().Min <> FMin;
end;

procedure TTurboCustomLinePicker.SetIncrement(Value: Integer);
begin
  if Value < 0 then
  begin
    Value := 0;
  end;

  if FIncrement = Value then
  begin
    exit;
  end;

  FIncrement := Value;
end;

procedure TTurboCustomLinePicker.SetIncrementMultiplier(Value: Integer);
begin
  if Value < 1 then
  begin
    Value := 1;
  end;

  if FIncrementMultiplier = Value then
  begin
    exit;
  end;

  FIncrementMultiplier := Value;
end;

procedure TTurboCustomLinePicker.SetMax(Value: Integer);
begin
  Value := GetRange().Ensure(Value);

  if FMax = Value then
  begin
    exit;
  end;

  FMax := Value;
  FMin := Math.Min(FMin, FMax);

  if GetPickerValue() > FMax then
  begin
    PickerChange(True);
  end else
  begin
    PickerRepaint(True);
  end;
end;

procedure TTurboCustomLinePicker.SetMin(Value: Integer);
begin
  Value := GetRange().Ensure(Value);

  if FMin = Value then
  begin
    exit;
  end;

  FMin := Value;
  FMax := Math.Max(FMax, FMin);

  if GetPickerValue() < FMin then
  begin
    PickerChange(True);
  end else
  begin
    PickerRepaint(True);
  end;
end;

procedure TTurboCustomLinePicker.UserUpdatePickerValue(Value: Integer);
begin
  Value := EnsureRange(Value, FMin, FMax);

  if Value = GetPickerValue() then
  begin
    exit;
  end;

  SetPickerValue(Value);

  PickerRepaint(False);

  PickerChanged();

  PickerUserChanged();
end;

function TTurboCustomLinePicker.GetPickerAbsolutePosition(Width: Integer): Integer;
var
  Offset: Integer;
begin
  if FMax > FMin then
  begin
    Offset := ((GetPickerValue() - FMin) * (Width - 1) + (FMax - FMin) div 2) div (FMax - FMin);
  end else
  begin
    Offset := 0;
  end;

  if Reverse then
  begin
    Result := (Width - 1) - Offset;
  end else
  begin
    Result := Offset;
  end;
end;

procedure TTurboCustomLinePicker.MovePicker(Delta: Integer; Alternative: Boolean);
begin
  if Alternative then
  begin
    UserUpdatePickerValue(GetPickerValue() + Delta * FIncrement * FIncrementMultiplier);
  end else
  begin
    UserUpdatePickerValue(GetPickerValue() + Delta * FIncrement);
  end;
end;

procedure TTurboCustomLinePicker.SetPickerAbsolutePosition(Width, Position: Integer);
var
  Offset: Integer;
begin
  if Width > 1 then
  begin
    Offset := (Position * (FMax - FMin) + (Width - 1) div 2) div (Width - 1);
  end else
  begin
    Offset := 0;
  end;

  if Reverse then
  begin
    UserUpdatePickerValue(FMax - Offset);
  end else
  begin
    UserUpdatePickerValue(FMin + Offset);
  end;
end;

function TTurboCustomLinePicker.GetDefaultIncrement(): Integer;
begin
  Result := 1;
end;

function TTurboCustomLinePicker.GetDefaultIncrementMultiplier(): Integer;
begin
  Result := 10;
end;

function TTurboCustomLinePicker.GetDefaultRange(): TTurboRange;
begin
  Result := GetRange();
end;

function TTurboCustomLinePicker.GetRange(): TTurboRange;
begin
  Result := TTurboRange.Create(0, 255);
end;

procedure TTurboCustomLinePicker.PickerChange(NeedUpdateRangeBitmap: Boolean);
begin
  // clip value
  SetPickerValue(EnsureRange(GetPickerValue(), FMin, FMax));

  PickerRepaint(NeedUpdateRangeBitmap);

  PickerChanged();
end;

{ TTurboCustomFloatLinePicker }

constructor TTurboCustomFloatLinePicker.Create(Owner: TComponent);
begin
  inherited Create(Owner);

  FMin := GetDefaultRange().Min;
  FMax := GetDefaultRange().Max;

  FIncrement := GetDefaultIncrement();
  FIncrementMultiplier := GetDefaultIncrementMultiplier();
end;

function TTurboCustomFloatLinePicker.IsMaxStored(): Boolean;
begin
  Result := GetDefaultRange().Max <> FMax;
end;

function TTurboCustomFloatLinePicker.IsIncrementStored(): Boolean;
begin
  Result := GetDefaultIncrement() <> FIncrement;
end;

function TTurboCustomFloatLinePicker.IsIncrementMultiplierStored(): Boolean;
begin
  Result := GetDefaultIncrementMultiplier() <> FIncrementMultiplier;
end;

function TTurboCustomFloatLinePicker.IsMinStored(): Boolean;
begin
  Result := GetDefaultRange().Min <> FMin;
end;

procedure TTurboCustomFloatLinePicker.SetIncrement(Value: Double);
begin
  if Value < 0 then
  begin
    Value := 0;
  end;

  if FIncrement = Value then
  begin
    exit;
  end;

  FIncrement := Value;
end;

procedure TTurboCustomFloatLinePicker.SetIncrementMultiplier(Value: Integer);
begin
  if Value < 1 then
  begin
    Value := 1;
  end;

  if FIncrementMultiplier = Value then
  begin
    exit;
  end;

  FIncrementMultiplier := Value;
end;

procedure TTurboCustomFloatLinePicker.SetMax(Value: Double);
begin
  Value := GetRange().Ensure(Value);

  if FMax = Value then
  begin
    exit;
  end;

  FMax := Value;
  FMin := Math.Min(FMin, FMax);

  if GetPickerValue() > FMax then
  begin
    PickerChange(True);
  end else
  begin
    PickerRepaint(True);
  end;
end;

procedure TTurboCustomFloatLinePicker.SetMin(Value: Double);
begin
  Value := GetRange().Ensure(Value);

  if FMin = Value then
  begin
    exit;
  end;

  FMin := Value;
  FMax := Math.Max(FMax, FMin);

  if GetPickerValue() < FMin then
  begin
    PickerChange(True);
  end else
  begin
    PickerRepaint(True);
  end;
end;

function TTurboCustomFloatLinePicker.GetPickerAbsolutePosition(Width: Integer): Integer;
var
  Offset: Integer;
begin
  if FMax > FMin then
  begin
    Offset := Trunc(((GetPickerValue() - FMin) * (Width - 1)) / (FMax - FMin) + 0.5);
  end else
  begin
    Offset := 0;
  end;

  if Reverse then
  begin
    Result := (Width - 1) - Offset;
  end else
  begin
    Result := Offset;
  end;
end;

procedure TTurboCustomFloatLinePicker.SetPickerAbsolutePosition(Width, Position: Integer);
var
  Offset: Double;
begin
  if Width > 1 then
  begin
    Offset := (Position * (FMax - FMin)) / (Width - 1);
  end else
  begin
    Offset := 0;
  end;

  if Reverse then
  begin
    UserUpdatePickerValue(FMax - Offset);
  end else
  begin
    UserUpdatePickerValue(FMin + Offset);
  end;
end;

procedure TTurboCustomFloatLinePicker.MovePicker(Delta: Integer; Alternative: Boolean);
begin
  if Alternative then
  begin
    UserUpdatePickerValue(GetPickerValue() + Delta * FIncrement * FIncrementMultiplier);
  end else
  begin
    UserUpdatePickerValue(GetPickerValue() + Delta * FIncrement);
  end;
end;

function TTurboCustomFloatLinePicker.GetRange(): TTurboFloatRange;
begin
  Result := TTurboFloatRange.Create(0.0, 1.0);
end;

function TTurboCustomFloatLinePicker.GetDefaultRange(): TTurboFloatRange;
begin
  Result := GetRange();
end;

function TTurboCustomFloatLinePicker.GetDefaultIncrement(): Double;
begin
  Result := GetDefaultRange().Length / 100.0;
end;

function TTurboCustomFloatLinePicker.GetDefaultIncrementMultiplier(): Integer;
begin
  Result := 10;
end;

procedure TTurboCustomFloatLinePicker.UserUpdatePickerValue(Value: Double);
begin
  Value := EnsureRange(Value, FMin, FMax);

  if Value = GetPickerValue() then
  begin
    exit;
  end;

  SetPickerValue(Value);

  PickerRepaint(False);

  PickerChanged();

  PickerUserChanged();
end;

procedure TTurboCustomFloatLinePicker.PickerChange(NeedUpdateRangeBitmap: Boolean);
begin
  // clip value
  SetPickerValue(EnsureRange(GetPickerValue(), FMin, FMax));

  PickerRepaint(NeedUpdateRangeBitmap);

  PickerChanged();
end;

{ TTurboAbstractAxisPicker }

constructor TTurboAbstractAxisPicker.Create(Owner: TComponent);
begin
  inherited Create(Owner);

  // make bitmaps
  FRangeBitmap := TBitmap.Create();
  FRangeBitmap.PixelFormat := pf24bit;

  // make thumb size
  FThumbSize := TTurboAutoLength.Create();
  FThumbSize.OnChange := ThumbSizeChange;

  // make padding size
  FRangePadding := TTurboAutoPadding.Create();
  FRangePadding.OnChange := RangePaddingChange;

  // defaults
  FAllowFocus := True;
  FForceRepaint := True;
  FHorizontalReverse := False;
  FLayout := TTurboAxisPickerLayout.OverlapThumb;
  FPositionLineVisible := False;
  FRangeBorderColor := clDefault;
  FRangeBorderFocusedColor := clDefault;
  FRangeBorderWidth := 1;
  FRangeBorderSpace := 0;
  FRangeBorderVisible := True;
  FThumbColor := clDefault;
  FThumbFocusedColor := clDefault;
  FThumbKind := TTurboAxisPickerThumbKind.Circle;
  FThumbLineColor := clDefault;
  FThumbLineFocusedColor := clDefault;
  FThumbStyle := TTurboAxisPickerThumbStyle.Color;
  FVerticalReverse := False;

  // inherited defaults
  SetInitialBounds(0, 0, GetControlClassDefaultSize().CX, GetControlClassDefaultSize().CY);
  TabStop := True;
  ControlStyle := ControlStyle + [csCaptureMouse];

  // need update
  FNeedUpdateRangeBitmap := True;
end;

destructor TTurboAbstractAxisPicker.Destroy();
begin
  FRangePadding.Free();
  FThumbSize.Free();
  FRangeBitmap.Free();

  inherited Destroy();
end;

procedure TTurboAbstractAxisPicker.AutoAdjustLayout(Mode: TLayoutAdjustmentPolicy; const FromPPI, ToPPI, OldFormWidth, NewFormWidth: Integer);
begin
  inherited AutoAdjustLayout(Mode, FromPPI, ToPPI, OldFormWidth, NewFormWidth);

  FThumbSize.Size := MulDiv(FThumbSize.Size, ToPPI, FromPPI);

  FRangePadding.Left := MulDiv(FRangePadding.Left, ToPPI, FromPPI);
  FRangePadding.Right := MulDiv(FRangePadding.Right, ToPPI, FromPPI);
  FRangePadding.Top := MulDiv(FRangePadding.Top, ToPPI, FromPPI);
  FRangePadding.Bottom := MulDiv(FRangePadding.Bottom, ToPPI, FromPPI);
end;

procedure TTurboAbstractAxisPicker.SetRangeBorderColor(Value: TColor);
begin
  if FRangeBorderColor = Value then
  begin
    exit;
  end;

  FRangeBorderColor := Value;

  Invalidate();
end;

procedure TTurboAbstractAxisPicker.SetPositionLineVisible(Value: Boolean);
begin
  if FPositionLineVisible = Value then
  begin
    exit;
  end;

  FPositionLineVisible := Value;

  Invalidate();
end;

procedure TTurboAbstractAxisPicker.SetLayout(Value: TTurboAxisPickerLayout);
begin
  if FLayout = Value then
  begin
    exit;
  end;

  FLayout := Value;

  AdjustContent();

  Invalidate();
end;

procedure TTurboAbstractAxisPicker.SetRangeBorderFocusedColor(Value: TColor);
begin
  if FRangeBorderFocusedColor = Value then
  begin
    exit;
  end;

  FRangeBorderFocusedColor := Value;

  Invalidate();
end;

procedure TTurboAbstractAxisPicker.SetRangeBorderWidth(Value: Integer);
begin
  Value := EnsureRange(Value, 1, 64);

  if FRangeBorderWidth = Value then
  begin
    exit;
  end;

  FRangeBorderWidth := Value;

  AdjustContent();
end;

procedure TTurboAbstractAxisPicker.SetRangeBorderSpace(Value: Integer);
begin
  Value := EnsureRange(Value, 0, 64);

  if FRangeBorderSpace = Value then
  begin
    exit;
  end;

  FRangeBorderSpace := Value;

  AdjustContent();
end;

procedure TTurboAbstractAxisPicker.SetRangeBorderVisible(Value: Boolean);
begin
  if FRangeBorderVisible = Value then
  begin
    exit;
  end;

  FRangeBorderVisible := Value;

  AdjustContent();
end;

procedure TTurboAbstractAxisPicker.SetRangePadding(Value: TTurboAutoPadding);
begin
  FRangePadding.Assign(Value);
end;

procedure TTurboAbstractAxisPicker.SetHorizontalReverse(Value: Boolean);
begin
  if FHorizontalReverse = Value then
  begin
    exit;
  end;

  FHorizontalReverse := Value;

  PickerInvalidate(True);
end;

procedure TTurboAbstractAxisPicker.SetThumbColor(Value: TColor);
begin
  if FThumbColor = Value then
  begin
    exit;
  end;

  FThumbColor := Value;

  Invalidate();
end;

procedure TTurboAbstractAxisPicker.SetThumbFocusedColor(Value: TColor);
begin
  if FThumbFocusedColor = Value then
  begin
    exit;
  end;

  FThumbFocusedColor := Value;

  Invalidate();
end;

procedure TTurboAbstractAxisPicker.SetThumbKind(Value: TTurboAxisPickerThumbKind);
begin
  if FThumbKind = Value then
  begin
    exit;
  end;

  FThumbKind := Value;

  AdjustContent();

  Invalidate();
end;

procedure TTurboAbstractAxisPicker.SetThumbLineColor(Value: TColor);
begin
  if FThumbLineColor = Value then
  begin
    exit;
  end;

  FThumbLineColor := Value;

  Invalidate();
end;

procedure TTurboAbstractAxisPicker.SetThumbLineFocusedColor(Value: TColor);
begin
  if FThumbLineFocusedColor = Value then
  begin
    exit;
  end;

  FThumbLineFocusedColor := Value;

  Invalidate();
end;

procedure TTurboAbstractAxisPicker.SetThumbSize(Value: TTurboAutoLength);
begin
  FThumbSize.Assign(Value);
end;

procedure TTurboAbstractAxisPicker.SetThumbStyle(Value: TTurboAxisPickerThumbStyle);
begin
  if FThumbStyle = Value then
  begin
    exit;
  end;

  FThumbStyle := Value;

  Invalidate();
end;

procedure TTurboAbstractAxisPicker.SetVerticalReverse(Value: Boolean);
begin
  if FVerticalReverse = Value then
  begin
    exit;
  end;

  FVerticalReverse := Value;

  PickerInvalidate(True);
end;

procedure TTurboAbstractAxisPicker.RangePaddingChange(Sender: TObject);
begin
  AdjustContent();

  PickerInvalidate(True);
end;

procedure TTurboAbstractAxisPicker.AdjustContent();
begin
  if csLoading in ComponentState then
  begin
    exit;
  end;

  if FThumbSize.IsAuto then
  begin
    FThumbSize.Size := Scale96ToFont(DefaultThumbSize);
  end else
  begin
    FThumbSize.Size := EnsureRange(FThumbSize.Size, 6, 64);
  end;

  if FRangePadding.IsAutoLeft then
  begin
    FRangePadding.Left := Math.Max(
      Integer(FLayout = TTurboAxisPickerLayout.OverlapThumb) * (FThumbSize.Size div 2),
      Integer(FRangeBorderVisible) * FRangeBorderWidth + Integer(FRangeBorderVisible) * FRangeBorderSpace
    );
  end;
  if FRangePadding.IsAutoRight then
  begin
    FRangePadding.Right := Math.Max(
      Integer(FLayout = TTurboAxisPickerLayout.OverlapThumb) * (FThumbSize.Size div 2),
      Integer(FRangeBorderVisible) * FRangeBorderWidth + Integer(FRangeBorderVisible) * FRangeBorderSpace
    );
  end;
  if FRangePadding.IsAutoTop then
  begin
    FRangePadding.Top := Math.Max(
      Integer(FLayout = TTurboAxisPickerLayout.OverlapThumb) * (FThumbSize.Size div 2),
      Integer(FRangeBorderVisible) * FRangeBorderWidth + Integer(FRangeBorderVisible) * FRangeBorderSpace
    );
  end;
  if FRangePadding.IsAutoBottom then
  begin
    FRangePadding.Bottom := Math.Max(
      Integer(FLayout = TTurboAxisPickerLayout.OverlapThumb) * (FThumbSize.Size div 2),
      Integer(FRangeBorderVisible) * FRangeBorderWidth + Integer(FRangeBorderVisible) * FRangeBorderSpace
    );
  end;
end;

procedure TTurboAbstractAxisPicker.ThumbSizeChange(Sender: TObject);
begin
  AdjustContent();

  Invalidate();
end;

class function TTurboAbstractAxisPicker.GetControlClassDefaultSize(): TSize;
begin
  Result := TSize.Create(200, 200);
end;

function TTurboAbstractAxisPicker.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean;
var
  DeltaX, DeltaY: Integer;
begin
  inherited DoMouseWheel(Shift, WheelDelta, MousePos);
  Result := True;

  DeltaX := 0;
  DeltaY := 0;
  if WheelDelta < 0 then
  begin
    if ssShift in Shift then
    begin
      DeltaY := Min(-1, WheelDelta div 120);
    end else
    begin
      DeltaX := Min(-1, WheelDelta div 120);
    end;
  end else
  begin
    if ssShift in Shift then
    begin
      DeltaY := Max(1, WheelDelta div 120);
    end else
    begin
      DeltaX := Max(1, WheelDelta div 120);
    end;
  end;

  if FVerticalReverse then
  begin
    DeltaY := -DeltaY;
  end;

  if FHorizontalReverse then
  begin
    DeltaX := -DeltaX;
  end;

  MovePicker(DeltaX, DeltaY, ssCtrl in Shift);
end;

function TTurboAbstractAxisPicker.IsAllowFocus(): Boolean;
begin
  Result := FAllowFocus;
end;

procedure TTurboAbstractAxisPicker.DoEnter();
begin
  inherited DoEnter();

  Invalidate();
end;

procedure TTurboAbstractAxisPicker.DoExit();
begin
  inherited DoExit();

  Invalidate();
end;

procedure TTurboAbstractAxisPicker.KeyDown(var Key: Word; Shift: TShiftState);
var
  OriginalKey: Word;
  DeltaX, DeltaY: Integer;
begin
  OriginalKey := Key;
  Key := 0;

  if FHorizontalReverse then
  begin
  	DeltaX := -1;
  end else
  begin
    DeltaX := 1;
  end;

  if FVerticalReverse then
  begin
  	DeltaY := -1;
  end else
  begin
    DeltaY := 1;
  end;

  case OriginalKey of
    VK_LEFT:
    begin
      MovePicker(-DeltaX, 0, ssCtrl in Shift);
    end;
    VK_RIGHT:
    begin
      MovePicker(DeltaX, 0, ssCtrl in Shift);
    end;
    VK_DOWN:
    begin
      MovePicker(0, DeltaY, ssCtrl in Shift);
    end;
    VK_UP:
    begin
      MovePicker(0, -DeltaY, ssCtrl in Shift);
    end;
    else
      Key := OriginalKey;
  end;

  inherited KeyDown(Key, Shift);
end;

procedure TTurboAbstractAxisPicker.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);

  if Button = mbLeft then
  begin
    TrySetFocus();

    SetPickerAbsolutePosition(GetPickerRangeRect().Size, TPoint.Create(X - GetPickerRangeRect().Left, Y - GetPickerRangeRect().Top));
  end;
end;

procedure TTurboAbstractAxisPicker.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove(Shift, X, Y);

  if csLButtonDown in ControlState then
  begin
    SetPickerAbsolutePosition(GetPickerRangeRect().Size, TPoint.Create(X - GetPickerRangeRect().Left, Y - GetPickerRangeRect().Top));
  end;
end;

procedure TTurboAbstractAxisPicker.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);

  if Button = mbLeft then
  begin
    SetPickerAbsolutePosition(GetPickerRangeRect().Size, TPoint.Create(X - GetPickerRangeRect().Left, Y - GetPickerRangeRect().Top));
  end;
end;

procedure TTurboAbstractAxisPicker.Paint();
var
  RangeRect, FrameRect: TRect;
  Offset: TPoint;
  FillColor, StrokeColor: TColor;
begin
  inherited Paint();

  RangeRect := GetPickerRangeRect();

  // update FRangeBitmap
  if FNeedUpdateRangeBitmap then
  begin
    FRangeBitmap.SetSize(RangeRect.Width, RangeRect.Height);
    if (FRangeBitmap.Width <> 0) and (FRangeBitmap.Height <> 0) then
    begin
    	PaintRangeBitmap(FRangeBitmap);
    end;
    FNeedUpdateRangeBitmap := False;
  end;

  // draw border
  if FRangeBorderVisible then
  begin
    FrameRect := RangeRect;
    InflateRect(FrameRect, FRangeBorderSpace + FRangeBorderWidth, FRangeBorderSpace + FRangeBorderWidth);

    if Focused then
    begin
      DrawFrameRect(Canvas, FrameRect, FRangeBorderWidth, IfThen(FRangeBorderFocusedColor = clDefault, clHighlight, FRangeBorderFocusedColor));
    end else
    begin
      DrawFrameRect(Canvas, FrameRect, FRangeBorderWidth, IfThen(FRangeBorderColor = clDefault, clGrayText, FRangeBorderColor));
    end;
  end;

  if Focused then
  begin
    FillColor := ColorToRGB(IfThen(FThumbFocusedColor = clDefault, clHighlight, FThumbFocusedColor));
    StrokeColor := ColorToRGB(IfThen(FThumbLineFocusedColor = clDefault, clHighlightText, FThumbLineFocusedColor));
  end else
  begin
    FillColor := ColorToRGB(IfThen(FThumbColor = clDefault, clWindowText, FThumbColor));
    StrokeColor := ColorToRGB(IfThen(FThumbLineColor = clDefault, clWindow, FThumbLineColor));
  end;

  Offset := GetPickerAbsolutePosition(TSize.Create(RangeRect.Width, RangeRect.Height));
  Offset.X := Offset.X + RangeRect.Left;
  Offset.Y := Offset.Y + RangeRect.Top;

  // draw range bitmap
  Canvas.Draw(RangeRect.Left, RangeRect.Top, FRangeBitmap);

  // draw position line
  if FPositionLineVisible then
  begin
    Canvas.SaveHandleState();
    try
      ExcludeClipRect(
        Canvas.Handle,
        Offset.X - (FThumbSize.Size div 2) - 1,
        Offset.Y - (FThumbSize.Size div 2) - 1,
        Offset.X + (FThumbSize.Size div 2) + 2,
        Offset.Y + (FThumbSize.Size div 2) + 2
      );
      IntersectClipRect(
        Canvas.Handle,
        RangeRect.Left,
        RangeRect.Top,
        RangeRect.Right,
        RangeRect.Bottom
      );
      if {$IFDEF LCLCocoa}True{$ELSE}FThumbStyle = TTurboAxisPickerThumbStyle.Color{$ENDIF} then
      begin
        DrawAxisLine(Canvas, RangeRect.Left, Offset.Y, RangeRect.Width, False, FillColor, StrokeColor, 127);
        DrawAxisLine(Canvas, Offset.X, RangeRect.Top, RangeRect.Height, True, FillColor, StrokeColor, 127);
      end else
      begin
        DrawInvertAxisLine(Canvas, RangeRect.Left, Offset.Y, RangeRect.Width, False, 2, $909090, $202020);
        DrawInvertAxisLine(Canvas, Offset.X, RangeRect.Top, RangeRect.Height, True, 2, $909090, $202020);
      end;
    finally
      Canvas.RestoreHandleState();
    end;
  end;

  // draw thumb
  if FLayout = TTurboAxisPickerLayout.InsideThumb then
  begin
    Canvas.SaveHandleState();
  end;
  try
    if FLayout = TTurboAxisPickerLayout.InsideThumb then
    begin
      IntersectClipRect(Canvas.Handle, RangeRect.Left, RangeRect.Top, RangeRect.Right, RangeRect.Bottom);
    end;
    case FThumbKind of
      TTurboAxisPickerThumbKind.Cross:
      begin
        DrawCrossThumb(
          Canvas,
          Offset.X - FThumbSize.Size div 2,
          Offset.Y - FThumbSize.Size div 2,
          (FThumbSize.Size div 2) * 2 + 1,
          FillColor,
          StrokeColor,
          {$IFDEF LCLCocoa}TTurboThumbDrawStyle.Color{$ELSE}TTurboThumbDrawStyle(FThumbStyle){$ENDIF}
        );
      end;
      TTurboAxisPickerThumbKind.Circle:
      begin
        DrawCircleThumb(
          Canvas,
          Offset.X - FThumbSize.Size div 2,
          Offset.Y - FThumbSize.Size div 2,
          (FThumbSize.Size div 2) * 2 + 1,
          FillColor,
          StrokeColor,
          ColorToRGB(GetPickerThumbPreviewColor()),
          {$IFDEF LCLCocoa}TTurboThumbDrawStyle.Color{$ELSE}TTurboThumbDrawStyle(FThumbStyle){$ENDIF}
        );
      end;
    end;
  finally
    if FLayout = TTurboAxisPickerLayout.InsideThumb then
    begin
      Canvas.RestoreHandleState();
    end;
  end;
end;

procedure TTurboAbstractAxisPicker.Resize();
begin
  inherited Resize();

  AdjustContent();

  PickerInvalidate(True);
end;

function TTurboAbstractAxisPicker.GetPickerRangeRect(): TRect;
begin
  Result := TRect.Create(
    ClientRect.Left + FRangePadding.Left,
    ClientRect.Top + FRangePadding.Top,
    ClientRect.Right - FRangePadding.Right,
    ClientRect.Bottom - FRangePadding.Bottom
  );
end;

procedure TTurboAbstractAxisPicker.PickerChanged();
begin
  if Assigned(FOnChange) and not(csLoading in ComponentState) then
  begin
    FOnChange(Self);
  end;
end;

procedure TTurboAbstractAxisPicker.PickerInvalidate(NeedUpdateRangeBitmap: Boolean);
begin
  if NeedUpdateRangeBitmap then
  begin
    FNeedUpdateRangeBitmap := True;
  end;

  Invalidate();
end;

procedure TTurboAbstractAxisPicker.PickerRepaint(NeedUpdateRangeBitmap: Boolean);
begin
  if NeedUpdateRangeBitmap then
  begin
    FNeedUpdateRangeBitmap := True;
  end;

  if FForceRepaint then
  begin
    if csLoading in ComponentState then
    begin
      exit;
    end;
    Refresh();
  end else
  begin
    Invalidate();
  end;
end;

procedure TTurboAbstractAxisPicker.PickerUserChanged();
begin
  if Assigned(FOnUserChange) and not(csLoading in ComponentState) then
  begin
    FOnUserChange(Self);
  end;
end;

function TTurboAbstractAxisPicker.GetPickerThumbPreviewColor(): TColor;
begin
  Result := clHighlight;
end;

{ TTurboCustomAxisPicker }

constructor TTurboCustomAxisPicker.Create(Owner: TComponent);
begin
  inherited Create(Owner);

  FHorizontalMin := GetDefaultHorizontalRange().Min;
  FHorizontalMax := GetDefaultHorizontalRange().Max;
  FVerticalMin := GetDefaultVerticalRange().Min;
  FVerticalMax := GetDefaultVerticalRange().Max;

  FVerticalIncrement := GetDefaultVerticalIncrement();
  FHorizontalIncrement := GetDefaultHorizontalIncrement();

  FIncrementMultiplier := GetDefaultIncrementMultiplier();
end;

function TTurboCustomAxisPicker.IsHorizontalIncrementStored(): Boolean;
begin
  Result := GetDefaultHorizontalIncrement() <> FHorizontalIncrement;
end;

function TTurboCustomAxisPicker.IsHorizontalMaxStored(): Boolean;
begin
  Result := GetDefaultHorizontalRange().Max <> FHorizontalMax;
end;

function TTurboCustomAxisPicker.IsHorizontalMinStored(): Boolean;
begin
  Result := GetDefaultHorizontalRange().Min <> FHorizontalMin;
end;

function TTurboCustomAxisPicker.IsIncrementMultiplierStored(): Boolean;
begin
  Result := GetDefaultIncrementMultiplier() <> FIncrementMultiplier;
end;

function TTurboCustomAxisPicker.IsVerticalIncrementStored(): Boolean;
begin
  Result := GetDefaultVerticalIncrement() <> FVerticalIncrement;
end;

function TTurboCustomAxisPicker.IsVerticalMaxStored(): Boolean;
begin
  Result := GetDefaultVerticalRange().Max <> FVerticalMax;
end;

function TTurboCustomAxisPicker.IsVerticalMinStored(): Boolean;
begin
  Result := GetDefaultVerticalRange().Min <> FVerticalMin;
end;

procedure TTurboCustomAxisPicker.SetHorizontalIncrement(Value: Integer);
begin
  if Value < 0 then
  begin
    Value := 0;
  end;

  if FHorizontalIncrement = Value then
  begin
    exit;
  end;

  FHorizontalIncrement := Value;
end;

procedure TTurboCustomAxisPicker.SetHorizontalMax(Value: Integer);
begin
  Value := GetHorizontalRange().Ensure(Value);

  if FHorizontalMax = Value then
  begin
    exit;
  end;

  FHorizontalMax := Value;
  FHorizontalMin := Math.Min(FHorizontalMin, FHorizontalMax);

  if GetPickerValue().X > FHorizontalMax then
  begin
    PickerChange(True);
  end else
  begin
    PickerRepaint(True);
  end;
end;

procedure TTurboCustomAxisPicker.SetHorizontalMin(Value: Integer);
begin
  Value := GetHorizontalRange().Ensure(Value);

  if FHorizontalMin = Value then
  begin
    exit;
  end;

  FHorizontalMin := Value;
  FHorizontalMax := Math.Max(FHorizontalMax, FHorizontalMin);

  if GetPickerValue().X < FHorizontalMin then
  begin
    PickerChange(True);
  end else
  begin
    PickerRepaint(True);
  end;
end;

procedure TTurboCustomAxisPicker.SetIncrementMultiplier(Value: Integer);
begin
  if Value < 1 then
  begin
    Value := 1;
  end;

  if FIncrementMultiplier = Value then
  begin
    exit;
  end;

  FIncrementMultiplier := Value;
end;

procedure TTurboCustomAxisPicker.SetVerticalIncrement(Value: Integer);
begin
  if Value < 0 then
  begin
    Value := 0;
  end;

  if FVerticalIncrement = Value then
  begin
    exit;
  end;

  FVerticalIncrement := Value;
end;

procedure TTurboCustomAxisPicker.SetVerticalMax(Value: Integer);
begin
  Value := GetVerticalRange().Ensure(Value);

  if FVerticalMax = Value then
  begin
    exit;
  end;

  FVerticalMax := Value;
  FVerticalMin := Math.Min(FVerticalMin, FVerticalMax);

  if GetPickerValue().Y > FVerticalMax then
  begin
    PickerChange(True);
  end else
  begin
    PickerRepaint(True);
  end;
end;

procedure TTurboCustomAxisPicker.SetVerticalMin(Value: Integer);
begin
  Value := GetVerticalRange().Ensure(Value);

  if FVerticalMin = Value then
  begin
    exit;
  end;

  FVerticalMin := Value;
  FVerticalMax := Math.Max(FVerticalMax, FVerticalMin);

  if GetPickerValue().Y < FVerticalMin then
  begin
    PickerChange(True);
  end else
  begin
    PickerRepaint(True);
  end;
end;

procedure TTurboCustomAxisPicker.UserUpdatePickerValue(Value: TPoint);
begin
  Value.X := EnsureRange(Value.X, FHorizontalMin, FHorizontalMax);
  Value.Y := EnsureRange(Value.Y, FVerticalMin, FVerticalMax);

  if Value.Subtract(GetPickerValue()).IsZero then
  begin
    exit;
  end;

  SetPickerValue(Value);

  PickerRepaint(False);

  PickerChanged();

  PickerUserChanged();
end;

function TTurboCustomAxisPicker.GetPickerAbsolutePosition(Size: TSize): TPoint;
var
  Offset: TPoint;
begin
  if FHorizontalMax > FHorizontalMin then
  begin
    Offset.X := ((GetPickerValue().X - FHorizontalMin) * (Size.CX - 1) + (FHorizontalMax - FHorizontalMin) div 2) div (FHorizontalMax - FHorizontalMin);
  end else
  begin
    Offset.X := 0;
  end;

  if HorizontalReverse then
  begin
    Result.X := (Size.CX - 1) - Offset.X;
  end else
  begin
    Result.X := Offset.X;
  end;

  if FVerticalMax > FVerticalMin then
  begin
    Offset.Y := ((GetPickerValue().Y - FVerticalMin) * (Size.CY - 1) + (FVerticalMax - FVerticalMin) div 2) div (FVerticalMax - FVerticalMin);
  end else
  begin
    Offset.Y := 0;
  end;

  if VerticalReverse then
  begin
    Result.Y := (Size.CY - 1) - Offset.Y;
  end else
  begin
    Result.Y := Offset.Y;
  end;
end;

procedure TTurboCustomAxisPicker.MovePicker(DeltaX, DeltaY: Integer; Alternative: Boolean);
begin
  if Alternative then
  begin
    UserUpdatePickerValue(
      TPoint.Create(
        GetPickerValue().X + DeltaX * FHorizontalIncrement * FIncrementMultiplier,
        GetPickerValue().Y + DeltaY * FVerticalIncrement * FIncrementMultiplier
      )
    );
  end else
  begin
    UserUpdatePickerValue(
      TPoint.Create(
        GetPickerValue().X + DeltaX * FHorizontalIncrement,
        GetPickerValue().Y + DeltaY * FVerticalIncrement
      )
    );
  end;
end;

procedure TTurboCustomAxisPicker.SetPickerAbsolutePosition(Size: TSize; Position: TPoint);
var
  Offset: TPoint;
begin
  if Size.Width > 1 then
  begin
    Offset.X := (Position.X * (FHorizontalMax - FHorizontalMin) + (Size.CX - 1) div 2) div (Size.CX - 1);
  end else
  begin
    Offset.X := 0;
  end;

  if HorizontalReverse then
  begin
    Offset.X := FHorizontalMax - Offset.X;
  end else
  begin
    Offset.X := FHorizontalMin + Offset.X;
  end;

  if Size.Height > 1 then
  begin
    Offset.Y := (Position.Y * (FVerticalMax - FVerticalMin) + (Size.CY - 1) div 2) div (Size.CY - 1);
  end else
  begin
    Offset.Y := 0;
  end;

  if VerticalReverse then
  begin
    Offset.Y := FVerticalMax - Offset.Y;
  end else
  begin
    Offset.Y := FVerticalMin + Offset.Y;
  end;

  UserUpdatePickerValue(Offset);
end;

function TTurboCustomAxisPicker.GetDefaultHorizontalIncrement(): Integer;
begin
  Result := 1;
end;

function TTurboCustomAxisPicker.GetDefaultHorizontalRange(): TTurboRange;
begin
  Result := GetHorizontalRange();
end;

function TTurboCustomAxisPicker.GetDefaultIncrementMultiplier(): Integer;
begin
  Result := 10;
end;

function TTurboCustomAxisPicker.GetDefaultVerticalIncrement(): Integer;
begin
  Result := 1;
end;

function TTurboCustomAxisPicker.GetDefaultVerticalRange(): TTurboRange;
begin
  Result := GetVerticalRange();
end;

function TTurboCustomAxisPicker.GetHorizontalRange(): TTurboRange;
begin
  Result := TTurboRange.Create(0, 255);
end;

function TTurboCustomAxisPicker.GetVerticalRange(): TTurboRange;
begin
  Result := TTurboRange.Create(0, 255);
end;

procedure TTurboCustomAxisPicker.PickerChange(NeedUpdateRangeBitmap: Boolean);
begin
  // clip value
  SetPickerValue(TPoint.Create(
    EnsureRange(GetPickerValue().X, FHorizontalMin, FHorizontalMax),
    EnsureRange(GetPickerValue().Y, FVerticalMin, FVerticalMax)
  ));

  PickerRepaint(NeedUpdateRangeBitmap);

  PickerChanged();
end;

{ TTurboCustomFloatAxisPicker }

constructor TTurboCustomFloatAxisPicker.Create(Owner: TComponent);
begin
  inherited Create(Owner);

  FHorizontalMin := GetDefaultHorizontalRange().Min;
  FHorizontalMax := GetDefaultHorizontalRange().Max;
  FVerticalMin := GetDefaultVerticalRange().Min;
  FVerticalMax := GetDefaultVerticalRange().Max;

  FVerticalIncrement := GetDefaultVerticalIncrement();
  FHorizontalIncrement := GetDefaultHorizontalIncrement();

  FIncrementMultiplier := GetDefaultIncrementMultiplier();
end;

function TTurboCustomFloatAxisPicker.IsHorizontalMaxStored(): Boolean;
begin
  Result := GetDefaultHorizontalRange().Max <> FHorizontalMax;
end;

function TTurboCustomFloatAxisPicker.IsHorizontalIncrementStored(): Boolean;
begin
  Result := GetDefaultHorizontalIncrement() <> FHorizontalIncrement;
end;

function TTurboCustomFloatAxisPicker.IsHorizontalMinStored(): Boolean;
begin
  Result := GetDefaultHorizontalRange().Min <> FHorizontalMin;
end;

function TTurboCustomFloatAxisPicker.IsIncrementMultiplierStored(): Boolean;
begin
  Result := GetDefaultIncrementMultiplier() <> FIncrementMultiplier;
end;

function TTurboCustomFloatAxisPicker.IsVerticalIncrementStored(): Boolean;
begin
  Result := GetDefaultVerticalIncrement() <> FVerticalIncrement;
end;

function TTurboCustomFloatAxisPicker.IsVerticalMaxStored(): Boolean;
begin
  Result := GetDefaultVerticalRange().Max <> FVerticalMax;
end;

function TTurboCustomFloatAxisPicker.IsVerticalMinStored(): Boolean;
begin
  Result := GetDefaultVerticalRange().Min <> FVerticalMin;
end;

procedure TTurboCustomFloatAxisPicker.SetHorizontalIncrement(Value: Double);
begin
  if Value < 0.0 then
  begin
    Value := 0.0;
  end;

  if FHorizontalIncrement = Value then
  begin
    exit;
  end;

  FHorizontalIncrement := Value;
end;

procedure TTurboCustomFloatAxisPicker.SetHorizontalMax(Value: Double);
begin
  Value := GetHorizontalRange().Ensure(Value);

  if FHorizontalMax = Value then
  begin
    exit;
  end;

  FHorizontalMax := Value;
  FHorizontalMin := Math.Min(FHorizontalMin, FHorizontalMax);

  if GetPickerValue().X > FHorizontalMax then
  begin
    PickerChange(True);
  end else
  begin
    PickerRepaint(True);
  end;
end;

procedure TTurboCustomFloatAxisPicker.SetHorizontalMin(Value: Double);
begin
  Value := GetHorizontalRange().Ensure(Value);

  if FHorizontalMin = Value then
  begin
    exit;
  end;

  FHorizontalMin := Value;
  FHorizontalMax := Math.Max(FHorizontalMax, FHorizontalMin);

  if GetPickerValue().X < FHorizontalMin then
  begin
    PickerChange(True);
  end else
  begin
    PickerRepaint(True);
  end;
end;

procedure TTurboCustomFloatAxisPicker.SetIncrementMultiplier(Value: Integer);
begin
  if Value < 1 then
  begin
    Value := 1;
  end;

  if FIncrementMultiplier = Value then
  begin
    exit;
  end;

  FIncrementMultiplier := Value;
end;

procedure TTurboCustomFloatAxisPicker.SetVerticalIncrement(Value: Double);
begin
  if Value < 0.0 then
  begin
    Value := 0.0;
  end;

  if FVerticalIncrement = Value then
  begin
    exit;
  end;

  FVerticalIncrement := Value;
end;

procedure TTurboCustomFloatAxisPicker.SetVerticalMax(Value: Double);
begin
  Value := GetVerticalRange().Ensure(Value);

  if FVerticalMax = Value then
  begin
    exit;
  end;

  FVerticalMax := Value;
  FVerticalMin := Math.Min(FVerticalMin, FVerticalMax);

  if GetPickerValue().Y > FVerticalMax then
  begin
    PickerChange(True);
  end else
  begin
    PickerRepaint(True);
  end;
end;

procedure TTurboCustomFloatAxisPicker.SetVerticalMin(Value: Double);
begin
  Value := GetVerticalRange().Ensure(Value);

  if FVerticalMin = Value then
  begin
    exit;
  end;

  FVerticalMin := Value;
  FVerticalMax := Math.Max(FVerticalMax, FVerticalMin);

  if GetPickerValue().Y < FVerticalMin then
  begin
    PickerChange(True);
  end else
  begin
    PickerRepaint(True);
  end;
end;

procedure TTurboCustomFloatAxisPicker.UserUpdatePickerValue(Value: TPointF);
begin
  Value.X := EnsureRange(Value.X, FHorizontalMin, FHorizontalMax);
  Value.Y := EnsureRange(Value.Y, FVerticalMin, FVerticalMax);

  if SameValue(Value.X, GetPickerValue().X) and SameValue(Value.Y, GetPickerValue().Y) then
  begin
    exit;
  end;

  SetPickerValue(Value);

  PickerRepaint(False);

  PickerChanged();

  PickerUserChanged();
end;

function TTurboCustomFloatAxisPicker.GetPickerAbsolutePosition(Size: TSize): TPoint;
var
  Offset: TPoint;
begin
  if FHorizontalMax > FHorizontalMin then
  begin
    Offset.X := Trunc(((GetPickerValue().X - FHorizontalMin) * (Size.CX - 1)) / (FHorizontalMax - FHorizontalMin) + 0.5);
  end else
  begin
    Offset.X := 0;
  end;

  if HorizontalReverse then
  begin
    Result.X := (Size.CX - 1) - Offset.X;
  end else
  begin
    Result.X := Offset.X;
  end;

  if FVerticalMax > FVerticalMin then
  begin
    Offset.Y := Trunc(((GetPickerValue().Y - FVerticalMin) * (Size.CY - 1)) / (FVerticalMax - FVerticalMin) + 0.5);
  end else
  begin
    Offset.Y := 0;
  end;

  if VerticalReverse then
  begin
    Result.Y := (Size.CY - 1) - Offset.Y;
  end else
  begin
    Result.Y := Offset.Y;
  end;
end;

procedure TTurboCustomFloatAxisPicker.MovePicker(DeltaX, DeltaY: Integer; Alternative: Boolean);
begin
  if Alternative then
  begin
    UserUpdatePickerValue(
      TPointF.Create(
        GetPickerValue().X + DeltaX * FHorizontalIncrement * FIncrementMultiplier,
        GetPickerValue().Y + DeltaY * FVerticalIncrement * FIncrementMultiplier
      )
    );
  end else
  begin
    UserUpdatePickerValue(
      TPointF.Create(
        GetPickerValue().X + DeltaX * FHorizontalIncrement,
        GetPickerValue().Y + DeltaY * FVerticalIncrement
      )
    );
  end;
end;

procedure TTurboCustomFloatAxisPicker.SetPickerAbsolutePosition(Size: TSize; Position: TPoint);
var
  Offset: TPointF;
begin
  if Size.Width > 1 then
  begin
    Offset.X := (Position.X * (FHorizontalMax - FHorizontalMin)) / (Size.CX - 1);
  end else
  begin
    Offset.X := 0.0;
  end;

  if HorizontalReverse then
  begin
    Offset.X := FHorizontalMax - Offset.X;
  end else
  begin
    Offset.X := FHorizontalMin + Offset.X;
  end;

  if Size.Height > 1 then
  begin
    Offset.Y := (Position.Y * (FVerticalMax - FVerticalMin)) / (Size.CY - 1);
  end else
  begin
    Offset.Y := 0.0;
  end;

  if VerticalReverse then
  begin
    Offset.Y := FVerticalMax - Offset.Y;
  end else
  begin
    Offset.Y := FVerticalMin + Offset.Y;
  end;

  UserUpdatePickerValue(Offset);
end;

procedure TTurboCustomFloatAxisPicker.PickerChange(NeedUpdateRangeBitmap: Boolean);
begin
  // clip value
  SetPickerValue(TPointF.Create(
    EnsureRange(GetPickerValue().X, FHorizontalMin, FHorizontalMax),
    EnsureRange(GetPickerValue().Y, FVerticalMin, FVerticalMax)
  ));

  PickerRepaint(NeedUpdateRangeBitmap);

  PickerChanged();
end;

function TTurboCustomFloatAxisPicker.GetVerticalRange(): TTurboFloatRange;
begin
  Result := TTurboFloatRange.Create(0.0, 1.0);
end;

function TTurboCustomFloatAxisPicker.GetHorizontalRange(): TTurboFloatRange;
begin
  Result := TTurboFloatRange.Create(0.0, 1.0);
end;

function TTurboCustomFloatAxisPicker.GetDefaultHorizontalIncrement(): Double;
begin
  Result := GetDefaultHorizontalRange().Length / 100.0;
end;

function TTurboCustomFloatAxisPicker.GetDefaultVerticalIncrement(): Double;
begin
  Result := GetDefaultVerticalRange().Length / 100.0;
end;

function TTurboCustomFloatAxisPicker.GetDefaultIncrementMultiplier(): Integer;
begin
  Result := 10;
end;

function TTurboCustomFloatAxisPicker.GetDefaultVerticalRange(): TTurboFloatRange;
begin
  Result := GetVerticalRange();
end;

function TTurboCustomFloatAxisPicker.GetDefaultHorizontalRange(): TTurboFloatRange;
begin
  Result := GetHorizontalRange();
end;

{ TTurboCustomCell }

constructor TTurboCustomCell.Create(Owner: TComponent);
begin
  inherited Create(Owner);

  FSelection := TTurboSelectionFrame.Create();
  FSelection.OnChange := SelectionChange;

  FAllowFocus := True;
  FBorderColor := clDefault;
  FBorderSpace := 0;
  FBorderWidth := 1;
  FFocusColor := clDefault;
  FFocusStyle := TTurboCellFocusStyle.Outline;
  FInteractive := True;
  FSelected := False;

  TabStop := True;
  SetInitialBounds(0, 0, GetControlClassDefaultSize().CX, GetControlClassDefaultSize().CY);
  ControlStyle := ControlStyle + [csCaptureMouse];
end;

destructor TTurboCustomCell.Destroy();
begin
  FSelection.Free();

  inherited Destroy();
end;

class function TTurboCustomCell.GetControlClassDefaultSize(): TSize;
begin
  Result := TSize.Create(32, 32);
end;

procedure TTurboCustomCell.DoEnter();
begin
  inherited DoEnter();

  Invalidate();
end;

procedure TTurboCustomCell.DoExit();
begin
  inherited DoExit();

  Invalidate();
end;

procedure TTurboCustomCell.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (not FIsDown) and (Key in [VK_RETURN, VK_SPACE]) then
  begin
    FIsDown := True;
    Invalidate();
  end;

  inherited KeyDown(Key, Shift);
end;

procedure TTurboCustomCell.KeyUp(var Key: Word; Shift: TShiftState);
begin
  if FIsDown and (Key in [VK_RETURN, VK_SPACE]) then
  begin
    FIsDown := False;
    Click();
    Invalidate();
  end;

  inherited KeyUp(Key, Shift);
end;

procedure TTurboCustomCell.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);

  if FInteractive and (Button = mbLeft) then
  begin
    FIsDown := True;
    TrySetFocus();
    Invalidate();
  end;
end;

procedure TTurboCustomCell.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);

  if FInteractive and (Button = mbLeft) then
  begin
    FIsDown := False;
    Invalidate();
  end;
end;

procedure TTurboCustomCell.MouseEnter();
begin
  inherited MouseEnter();

  if FInteractive then
  begin
    FIsHot := True;
    Invalidate();
  end;
end;

procedure TTurboCustomCell.MouseLeave();
begin
  inherited MouseLeave();

  if FInteractive then
  begin
    FIsHot := False;
    Invalidate();
  end;
end;

procedure TTurboCustomCell.Paint();
var
  Rect: TRect;
  Color: TColor;
begin
  // draw border
  if FFocusStyle = TTurboCellFocusStyle.Border then
  begin
    Rect := ClientRect;
    Rect.Inflate(-1, -1);

    if Focused then
    begin
      Color := IfThen(FFocusColor = clDefault, clHighlight, FFocusColor);
    end else
    begin
      Color := IfThen(FBorderColor = clDefault, clGrayText, FBorderColor);
    end;

    DrawFrameRect(Canvas, Rect, FBorderWidth, Color);
  end else
  begin
    if Focused then
    begin
      Rect := ClientRect;
      Color := IfThen(FFocusColor = clDefault, clHighlight, FFocusColor);
      DrawFrameRect(Canvas, Rect, 1, Color);
    end;

    Rect := ClientRect;
    Rect.Inflate(-1, -1);

    Color := IfThen(FBorderColor = clDefault, clGrayText, FBorderColor);
    DrawFrameRect(Canvas, Rect, FBorderWidth, Color);
  end;

  // draw cell
  Rect := ClientRect;
  Rect.Inflate(-1 - FBorderWidth - FBorderSpace, -1 - FBorderWidth - FBorderSpace);
  DrawCell(Rect);

  // draw selection
  Rect.Inflate(-1, -1);
  if FSelected and (not FIsDown) then
  begin
    DrawSelectionFrame(Canvas, Rect, FSelection.Color1, FSelection.Color2, FSelection.Opacity);
  end else
  if FIsDown then
  begin
    DrawSelectionFrame(Canvas, Rect, FSelection.Color1, FSelection.Color2, FSelection.PressedOpacity);
  end else
  if FIsHot then
  begin
    DrawSelectionFrame(Canvas, Rect, FSelection.Color1, FSelection.Color2, FSelection.HotOpacity);
  end;
end;

function TTurboCustomCell.IsAllowFocus(): Boolean;
begin
  Result := FAllowFocus and FInteractive;
end;

procedure TTurboCustomCell.DrawCell(const CellRect: TRect);
begin
  // nope
end;

procedure TTurboCustomCell.SetBorderColor(Value: TColor);
begin
  if FBorderColor = Value then
  begin
    exit;
  end;

  FBorderColor := Value;

  Invalidate();
end;

procedure TTurboCustomCell.SelectionChange(Sender: TObject);
begin
  Invalidate();
end;

procedure TTurboCustomCell.SetBorderSpace(Value: Integer);
begin
  Value := EnsureRange(Value, 0, 64);

  if FBorderSpace = Value then
  begin
    exit;
  end;

  FBorderSpace := Value;

  Invalidate();
end;

procedure TTurboCustomCell.SetBorderWidth(Value: Integer);
begin
  Value := EnsureRange(Value, 1, 64);

  if FBorderWidth = Value then
  begin
    exit;
  end;

  FBorderWidth := Value;

  Invalidate();
end;

procedure TTurboCustomCell.SetFocusColor(Value: TColor);
begin
  if FFocusColor = Value then
  begin
    exit;
  end;

  FFocusColor := Value;

  Invalidate();
end;

procedure TTurboCustomCell.SetFocusStyle(Value: TTurboCellFocusStyle);
begin
  if FFocusStyle = Value then
  begin
    exit;
  end;

  FFocusStyle := Value;

  Invalidate();
end;

procedure TTurboCustomCell.SetSelected(Value: Boolean);
begin
  if FSelected = Value then
  begin
    exit;
  end;

  FSelected := Value;

  Invalidate();
end;

procedure TTurboCustomCell.SetSelection(Value: TTurboSelectionFrame);
begin
  FSelection.Assign(Value);
end;

{ TTurboColorLinePicker }

constructor TTurboColorLinePicker.Create(Owner: TComponent);
begin
  inherited Create(Owner);

  FRangeBackground := TTurboTransparentBackground.Create();
  FRangeBackground.OnChange := RangeBackgroundChange;

  FAlphaPreview := 255;
  FAlphaModulation := True;
end;

destructor TTurboColorLinePicker.Destroy();
begin
  FRangeBackground.Free();

  inherited Destroy();
end;

{$IFOPT R+}{$DEFINE RANGECHECKS_ON}{$ENDIF}
{$IFOPT Q+}{$DEFINE OVERFLOWCHECKS_ON}{$ENDIF}
{$RANGECHECKS OFF}
{$OVERFLOWCHECKS OFF}
procedure TTurboColorLinePicker.DrawRangeBitmap1D(Image: TLazIntfImage; Shader: TTurboLinePickerShader1D);
var
  X, Y, I: Integer;
  Line: array of TFPColor;
  AlphaLine: array of array [Boolean] of TFPColor;
  Value, MaxValue, MinValue: Integer;
  Divider, Multipler: Integer;
  ShaderColor: TTurboColor;
  Opacity, AlphaTest: Byte;
  // background
  BackgroundColor1, BackgroundColor2: TFPColor;
  BackgroundCellSize: Integer;
  BackgroundKind: TTurboTransparentBackgroundKind;
begin
  // we are caching this values for performance in hotload loops
  Opacity := GetPickerRangeOpacity();
  BackgroundKind := FRangeBackground.Kind;
  BackgroundCellSize := FRangeBackground.CellSize;
  BackgroundColor1 := TColorToFPColor(FRangeBackground.Color1);
  BackgroundColor2 := TColorToFPColor(FRangeBackground.Color2);
  MinValue := Min;
  MaxValue := Max;

  // make 1d gradient
  Line := nil;
  if Orientation = TTurboLinePickerOrientation.Horizontal then
  begin
    SetLength(Line, Image.Width);
  end else
  begin
    SetLength(Line, Image.Height);
  end;
  Divider := Math.Max(1, Length(Line) - 1);
  Multipler := Max - Min;
  AlphaTest := $FF;
  if Reverse then
  begin
    for I := 0 to Length(Line) - 1 do
    begin
      Value := MaxValue - ((I * Multipler + Divider div 2) div Divider);
      ShaderColor := Shader(Value);
      Line[I] := ShaderColor.FPColor;
      AlphaTest := AlphaTest and ShaderColor.A;
    end;
  end else
  begin
    for I := 0 to Length(Line) - 1 do
    begin
      Value := MinValue + ((I * Multipler + Divider div 2) div Divider);
      ShaderColor := Shader(Value);
      Line[I] := ShaderColor.FPColor;
      AlphaTest := AlphaTest and ShaderColor.A;
    end;
  end;

  // draw
  if (Opacity = 255) and (AlphaTest = $FF) then
  begin
    // fast way, no alpha
    if Orientation = TTurboLinePickerOrientation.Horizontal then
    begin
      for Y := 0 to Image.Height - 1 do
      begin
        for X := 0 to Image.Width - 1 do
        begin
          Image.SetInternalColorProc(X, Y, Line[X]);
        end;
      end;
    end else
    begin
      for Y := 0 to Image.Height - 1 do
      begin
        for X := 0 to Image.Width - 1 do
        begin
          Image.SetInternalColorProc(X, Y, Line[Y]);
        end;
      end;
    end;
  end else
  begin
    // create alpha lines
    AlphaLine := nil;
    SetLength(AlphaLine, Length(Line));
    for I := 0 to Length(AlphaLine) - 1 do
    begin
      AlphaLine[I, False] := BlendFPColor(BackgroundColor1, Line[I], Opacity);
      AlphaLine[I, True] := BlendFPColor(BackgroundColor2, Line[I], Opacity);
    end;
    // draw
    if Orientation = TTurboLinePickerOrientation.Horizontal then
    begin
      for Y := 0 to Image.Height - 1 do
      begin
        for X := 0 to Image.Width - 1 do
        begin
          Image.SetInternalColorProc(X, Y, AlphaLine[X, AlphaBackgroundCase(BackgroundKind, BackgroundCellSize, X, Y)]);
        end;
      end;
    end else
    begin
      for Y := 0 to Image.Height - 1 do
      begin
        for X := 0 to Image.Width - 1 do
        begin
          Image.SetInternalColorProc(X, Y, AlphaLine[Y, AlphaBackgroundCase(BackgroundKind, BackgroundCellSize, X, Y)]);
        end;
      end;
    end;
  end;
end;
{$IFDEF RANGECHECKS_ON}{$RANGECHECKS ON}{$ELSE}{$RANGECHECKS OFF}{$ENDIF}
{$IFDEF OVERFLOWCHECKS_ON}{$OVERFLOWCHECKS ON}{$ELSE}{$OVERFLOWCHECKS OFF}{$ENDIF}

{$IFOPT R+}{$DEFINE RANGECHECKS_ON}{$ENDIF}
{$IFOPT Q+}{$DEFINE OVERFLOWCHECKS_ON}{$ENDIF}
{$RANGECHECKS OFF}
{$OVERFLOWCHECKS OFF}
procedure TTurboColorLinePicker.DrawRangeBitmap2D(Image: TLazIntfImage; Shader: TTurboLinePickerShader2D);
var
  X, Y, I: Integer;
  ValueX: Integer;
  ValueY: Double;
  DividerX, DividerY, Multipler: Integer;
  MaxValue, MinValue: Integer;
  Values: array of Integer;
  ShaderColor: TTurboColor;
  Opacity: Byte;
  BackgroundColor: TFPColor;
  // background
  BackgroundColor1, BackgroundColor2: TFPColor;
  BackgroundColors: array [Boolean] of TFPColor;
  BackgroundCellSize: Integer;
  BackgroundKind: TTurboTransparentBackgroundKind;
begin
  // we are caching this values for performance in hotload loops
  Opacity := GetPickerRangeOpacity();
  BackgroundKind := FRangeBackground.Kind;
  BackgroundCellSize := FRangeBackground.CellSize;
  BackgroundColor1 := TColorToFPColor(FRangeBackground.Color1);
  BackgroundColor2 := TColorToFPColor(FRangeBackground.Color2);
  BackgroundColors[False] := BackgroundColor1;
  BackgroundColors[True] := BackgroundColor2;
  MinValue := Min;
  MaxValue := Max;

  DividerX := Math.Max(1, Image.Width - 1);
  DividerY := Math.Max(1, Image.Height - 1);
  Multipler := MaxValue - MinValue;
  Values := nil;

  if Orientation = TTurboLinePickerOrientation.Horizontal then
  begin
    SetLength(Values, Image.Width);
    for I := 0 to Image.Width - 1 do
    begin
      if Reverse then
      begin
        Values[I] := MaxValue - ((I * Multipler + DividerX div 2) div DividerX);
      end else
      begin
        Values[I] := MinValue + ((I * Multipler + DividerX div 2) div DividerX);
      end;
    end;

    for Y := 0 to Image.Height - 1 do
    begin
      ValueY := Y / DividerY;
      for X := 0 to Image.Width - 1 do
      begin
        ValueX := Values[X];
        ShaderColor := Shader(ValueX, ValueY);
        if ShaderColor.A and Opacity = 255 then
        begin
          Image.SetInternalColorProc(X, Y, ShaderColor.FPColor);
        end else
        begin
          BackgroundColor := BackgroundColors[AlphaBackgroundCase(BackgroundKind, BackgroundCellSize, X, Y)];
          Image.SetInternalColorProc(X, Y, BlendFPColor(BackgroundColor, ShaderColor.FPColor, Opacity));
        end;
      end;
    end;
  end else
  begin
    for Y := 0 to Image.Height - 1 do
    begin
      if Reverse then
      begin
        ValueX := MaxValue - ((Y * Multipler + DividerY div 2) div DividerY);
      end else
      begin
        ValueX := MinValue + ((Y * Multipler + DividerY div 2) div DividerY);
      end;
      for X := 0 to Image.Width - 1 do
      begin
        ValueY := X / DividerX;
        ShaderColor := Shader(ValueX, ValueY);
        if ShaderColor.A and Opacity = 255 then
        begin
          Image.SetInternalColorProc(X, Y, ShaderColor.FPColor);
        end else
        begin
          BackgroundColor := BackgroundColors[AlphaBackgroundCase(BackgroundKind, BackgroundCellSize, X, Y)];
          Image.SetInternalColorProc(X, Y, BlendFPColor(BackgroundColor, ShaderColor.FPColor, Opacity));
        end;
      end;
    end;
  end;
end;
{$IFDEF RANGECHECKS_ON}{$RANGECHECKS ON}{$ELSE}{$RANGECHECKS OFF}{$ENDIF}
{$IFDEF OVERFLOWCHECKS_ON}{$OVERFLOWCHECKS ON}{$ELSE}{$OVERFLOWCHECKS OFF}{$ENDIF}

procedure TTurboColorLinePicker.RangeBackgroundChange(Sender: TObject);
begin
  PickerInvalidate(True);
end;

procedure TTurboColorLinePicker.SetAlphaModulation(Value: Boolean);
begin
  if FAlphaModulation = Value then
  begin
    exit;
  end;

  FAlphaModulation := Value;
  PickerInvalidate(True);
end;

procedure TTurboColorLinePicker.SetAlphaPreview(Value: Byte);
begin
  if FAlphaPreview = Value then
  begin
    exit;
  end;

  FAlphaPreview := Value;
  PickerRepaint(True);
end;

procedure TTurboColorLinePicker.SetRangeBackground(Value: TTurboTransparentBackground);
begin
  FRangeBackground.Assign(Value);
end;

procedure TTurboColorLinePicker.PaintRangeBitmap(Bitmap: TBitmap);
var
  Image: TLazIntfImage;
  Shader1D: TTurboLinePickerShader1D;
  Shader2D: TTurboLinePickerShader2D;
begin
  Image := Bitmap.CreateIntfImage();
  try
    Shader1D := GetPickerRangeShader1D();
    if Assigned(Shader1D) then
    begin
      DrawRangeBitmap1D(Image, Shader1D);
    end else
    begin
      Shader2D := GetPickerRangeShader2D();
      if Assigned(Shader2D) then
      begin
        DrawRangeBitmap2D(Image, Shader2D);
      end;
    end;
    Bitmap.LoadFromIntfImage(Image);
  finally
    Image.Free();
  end;
end;

function TTurboColorLinePicker.GetDefaultIncrement(): Integer;
begin
  Result := 1;
end;

function TTurboColorLinePicker.GetDefaultIncrementMultiplier(): Integer;
begin
  Result := 8;
end;

function TTurboColorLinePicker.GetRange(): TTurboRange;
begin
  Result := TTurboRange.Create(0, 255);
end;

function TTurboColorLinePicker.GetPickerRangeOpacity(): Byte;
begin
  if FAlphaModulation then
  begin
    Result := FAlphaPreview;
  end else
  begin
    Result := 255;
  end;
end;

function TTurboColorLinePicker.GetPickerRangeShader1D(): TTurboLinePickerShader1D;
begin
  Result := nil;
end;

function TTurboColorLinePicker.GetPickerRangeShader2D(): TTurboLinePickerShader2D;
begin
  Result := nil;
end;

{ TTurboColorFloatLinePicker }

constructor TTurboColorFloatLinePicker.Create(Owner: TComponent);
begin
  inherited Create(Owner);

  FRangeBackground := TTurboTransparentBackground.Create();
  FRangeBackground.OnChange := RangeBackgroundChange;

  FAlphaPreview := 255;
  FAlphaModulation := True;
end;

destructor TTurboColorFloatLinePicker.Destroy();
begin
  FRangeBackground.Free();

  inherited Destroy();
end;

{$IFOPT R+}{$DEFINE RANGECHECKS_ON}{$ENDIF}
{$IFOPT Q+}{$DEFINE OVERFLOWCHECKS_ON}{$ENDIF}
{$RANGECHECKS OFF}
{$OVERFLOWCHECKS OFF}
procedure TTurboColorFloatLinePicker.DrawRangeBitmap1D(Image: TLazIntfImage; Shader: TTurboLinePickerFloatShader1D);
var
  X, Y, I: Integer;
  Line: array of TFPColor;
  AlphaLine: array of array [Boolean] of TFPColor;
  Value, MaxValue, MinValue: Double;
  Divider: Double;
  ShaderColor: TTurboColor;
  Opacity, AlphaTest: Byte;
  // background
  BackgroundColor1, BackgroundColor2: TFPColor;
  BackgroundCellSize: Integer;
  BackgroundKind: TTurboTransparentBackgroundKind;
begin
  // we are caching this values for performance in hotload loops
  Opacity := GetPickerRangeOpacity();
  BackgroundKind := FRangeBackground.Kind;
  BackgroundCellSize := FRangeBackground.CellSize;
  BackgroundColor1 := TColorToFPColor(FRangeBackground.Color1);
  BackgroundColor2 := TColorToFPColor(FRangeBackground.Color2);
  MinValue := Min;
  MaxValue := Max;

  // make 1d gradient
  Line := nil;
  if Orientation = TTurboLinePickerOrientation.Horizontal then
  begin
    SetLength(Line, Image.Width);
  end else
  begin
    SetLength(Line, Image.Height);
  end;
  Divider := Math.Max(1, Length(Line) - 1);
  AlphaTest := $FF;
  if Reverse then
  begin
    for I := 0 to Length(Line) - 1 do
    begin
      Value := MaxValue - ((I * (MaxValue - MinValue)) / Divider);
      ShaderColor := Shader(Value);
      Line[I] := ShaderColor.FPColor;
      AlphaTest := AlphaTest and ShaderColor.A;
    end;
  end else
  begin
    for I := 0 to Length(Line) - 1 do
    begin
      Value := MinValue + ((I * (MaxValue - MinValue)) / Divider);
      ShaderColor := Shader(Value);
      Line[I] := ShaderColor.FPColor;
      AlphaTest := AlphaTest and ShaderColor.A;
    end;
  end;

  // draw
  if (Opacity = 255) and (AlphaTest = $FF) then
  begin
    // fast way, no alpha
    if Orientation = TTurboLinePickerOrientation.Horizontal then
    begin
      for Y := 0 to Image.Height - 1 do
      begin
        for X := 0 to Image.Width - 1 do
        begin
          Image.SetInternalColorProc(X, Y, Line[X]);
        end;
      end;
    end else
    begin
      for Y := 0 to Image.Height - 1 do
      begin
        for X := 0 to Image.Width - 1 do
        begin
          Image.SetInternalColorProc(X, Y, Line[Y]);
        end;
      end;
    end;
  end else
  begin
    // create alpha lines
    AlphaLine := nil;
    SetLength(AlphaLine, Length(Line));
    for I := 0 to Length(AlphaLine) - 1 do
    begin
      AlphaLine[I, False] := BlendFPColor(BackgroundColor1, Line[I], Opacity);
      AlphaLine[I, True] := BlendFPColor(BackgroundColor2, Line[I], Opacity);
    end;
    // draw
    if Orientation = TTurboLinePickerOrientation.Horizontal then
    begin
      for Y := 0 to Image.Height - 1 do
      begin
        for X := 0 to Image.Width - 1 do
        begin
          Image.SetInternalColorProc(X, Y, AlphaLine[X, AlphaBackgroundCase(BackgroundKind, BackgroundCellSize, X, Y)]);
        end;
      end;
    end else
    begin
      for Y := 0 to Image.Height - 1 do
      begin
        for X := 0 to Image.Width - 1 do
        begin
          Image.SetInternalColorProc(X, Y, AlphaLine[Y, AlphaBackgroundCase(BackgroundKind, BackgroundCellSize, X, Y)]);
        end;
      end;
    end;
  end;
end;
{$IFDEF RANGECHECKS_ON}{$RANGECHECKS ON}{$ELSE}{$RANGECHECKS OFF}{$ENDIF}
{$IFDEF OVERFLOWCHECKS_ON}{$OVERFLOWCHECKS ON}{$ELSE}{$OVERFLOWCHECKS OFF}{$ENDIF}

{$IFOPT R+}{$DEFINE RANGECHECKS_ON}{$ENDIF}
{$IFOPT Q+}{$DEFINE OVERFLOWCHECKS_ON}{$ENDIF}
{$RANGECHECKS OFF}
{$OVERFLOWCHECKS OFF}
procedure TTurboColorFloatLinePicker.DrawRangeBitmap2D(Image: TLazIntfImage; Shader: TTurboLinePickerFloatShader2D);
var
  X, Y, I: Integer;
  ValueX, ValueY: Double;
  DividerX, DividerY: Double;
  MaxValue, MinValue: Double;
  Values: array of Double;
  ShaderColor: TTurboColor;
  Opacity: Byte;
  BackgroundColor: TFPColor;
  // background
  BackgroundColors: array [Boolean] of TFPColor;
  BackgroundCellSize: Integer;
  BackgroundKind: TTurboTransparentBackgroundKind;
begin
  // we are caching this values for performance in hotload loops
  Opacity := GetPickerRangeOpacity();
  BackgroundKind := FRangeBackground.Kind;
  BackgroundCellSize := FRangeBackground.CellSize;
  BackgroundColors[False] := TColorToFPColor(FRangeBackground.Color1);
  BackgroundColors[True] := TColorToFPColor(FRangeBackground.Color2);
  MinValue := Min;
  MaxValue := Max;

  DividerX := Math.Max(1, Image.Width - 1);
  DividerY := Math.Max(1, Image.Height - 1);
  Values := nil;

  if Orientation = TTurboLinePickerOrientation.Horizontal then
  begin
    SetLength(Values, Image.Width);
    for I := 0 to Image.Width - 1 do
    begin
      if Reverse then
      begin
        Values[I] := MaxValue - ((I * (MaxValue - MinValue)) / DividerX);
      end else
      begin
        Values[I] := MinValue + ((I * (MaxValue - MinValue)) / DividerX);
      end;
    end;

    for Y := 0 to Image.Height - 1 do
    begin
      ValueY := Y / DividerY;
      for X := 0 to Image.Width - 1 do
      begin
        ValueX := Values[X];
        ShaderColor := Shader(ValueX, ValueY);
        if ShaderColor.A and Opacity = 255 then
        begin
          Image.SetInternalColorProc(X, Y, ShaderColor.FPColor);
        end else
        begin
          BackgroundColor := BackgroundColors[AlphaBackgroundCase(BackgroundKind, BackgroundCellSize, X, Y)];
          Image.SetInternalColorProc(X, Y, BlendFPColor(BackgroundColor, ShaderColor.FPColor, Opacity));
        end;
      end;
    end;
  end else
  begin
    for Y := 0 to Image.Height - 1 do
    begin
      if Reverse then
      begin
        ValueX := MaxValue - ((Y * (MaxValue - MinValue)) / DividerY);
      end else
      begin
        ValueX := MinValue + ((Y * (MaxValue - MinValue)) / DividerY);
      end;
      for X := 0 to Image.Width - 1 do
      begin
        ValueY := X / DividerX;
        ShaderColor := Shader(ValueX, ValueY);
        if ShaderColor.A and Opacity = 255 then
        begin
          Image.SetInternalColorProc(X, Y, ShaderColor.FPColor);
        end else
        begin
          BackgroundColor := BackgroundColors[AlphaBackgroundCase(BackgroundKind, BackgroundCellSize, X, Y)];
          Image.SetInternalColorProc(X, Y, BlendFPColor(BackgroundColor, ShaderColor.FPColor, Opacity));
        end;
      end;
    end;
  end;
end;
{$IFDEF RANGECHECKS_ON}{$RANGECHECKS ON}{$ELSE}{$RANGECHECKS OFF}{$ENDIF}
{$IFDEF OVERFLOWCHECKS_ON}{$OVERFLOWCHECKS ON}{$ELSE}{$OVERFLOWCHECKS OFF}{$ENDIF}

procedure TTurboColorFloatLinePicker.RangeBackgroundChange(Sender: TObject);
begin
  PickerInvalidate(True);
end;

procedure TTurboColorFloatLinePicker.SetAlphaModulation(Value: Boolean);
begin
  if FAlphaModulation = Value then
  begin
    exit;
  end;

  FAlphaModulation := Value;
  PickerInvalidate(True);
end;

procedure TTurboColorFloatLinePicker.SetAlphaPreview(Value: Byte);
begin
  if FAlphaPreview = Value then
  begin
    exit;
  end;

  FAlphaPreview := Value;
  PickerRepaint(True);
end;

procedure TTurboColorFloatLinePicker.SetRangeBackground(Value: TTurboTransparentBackground);
begin
  FRangeBackground.Assign(Value);
end;

function TTurboColorFloatLinePicker.GetPickerRangeOpacity(): Byte;
begin
  if FAlphaModulation then
  begin
    Result := FAlphaPreview;
  end else
  begin
    Result := 255;
  end;
end;

procedure TTurboColorFloatLinePicker.PaintRangeBitmap(Bitmap: TBitmap);
var
  Image: TLazIntfImage;
  Shader1D: TTurboLinePickerFloatShader1D;
  Shader2D: TTurboLinePickerFloatShader2D;
begin
  Image := Bitmap.CreateIntfImage();
  try
    Shader1D := GetPickerRangeShader1D();
    if Assigned(Shader1D) then
    begin
      DrawRangeBitmap1D(Image, Shader1D);
    end else
    begin
      Shader2D := GetPickerRangeShader2D();
      if Assigned(Shader2D) then
      begin
        DrawRangeBitmap2D(Image, Shader2D);
      end;
    end;
    Bitmap.LoadFromIntfImage(Image);
  finally
    Image.Free();
  end;
end;

function TTurboColorFloatLinePicker.GetDefaultIncrement(): Double;
begin
  Result := GetRange().Length / 100.0;
end;

function TTurboColorFloatLinePicker.GetDefaultIncrementMultiplier(): Integer;
begin
  Result := 5;
end;

function TTurboColorFloatLinePicker.GetRange(): TTurboFloatRange;
begin
  Result := TTurboFloatRange.Create(0.0, 1.0);
end;

function TTurboColorFloatLinePicker.GetPickerRangeShader1D(): TTurboLinePickerFloatShader1D;
begin
  Result := nil;
end;

function TTurboColorFloatLinePicker.GetPickerRangeShader2D(): TTurboLinePickerFloatShader2D;
begin
  Result := nil;
end;

{ TTurboColorAxisPicker }

constructor TTurboColorAxisPicker.Create(Owner: TComponent);
begin
  inherited Create(Owner);

  FRangeBackground := TTurboTransparentBackground.Create();
  FRangeBackground.OnChange := RangeBackgroundChange;

  FAlphaPreview := 255;
  FAlphaModulation := True;
end;

destructor TTurboColorAxisPicker.Destroy();
begin
  FRangeBackground.Free();

  inherited Destroy();
end;

{$IFOPT R+}{$DEFINE RANGECHECKS_ON}{$ENDIF}
{$IFOPT Q+}{$DEFINE OVERFLOWCHECKS_ON}{$ENDIF}
{$RANGECHECKS OFF}
{$OVERFLOWCHECKS OFF}
procedure TTurboColorAxisPicker.DrawRangeBitmap(Image: TLazIntfImage; Shader: TTurboAxisPickerShader);
var
  X, Y, I: Integer;
  ValueX, ValueY: Integer;
  DividerX, DividerY: Integer;
  HorizontalMaxValue, HorizontalMinValue: Integer;
  VerticalMaxValue, VerticalMinValue: Integer;
  Values: array of Integer;
  ShaderColor: TTurboColor;
  Opacity: Byte;
  BackgroundColor: TFPColor;
  // background
  BackgroundColors: array [Boolean] of TFPColor;
  BackgroundCellSize: Integer;
  BackgroundKind: TTurboTransparentBackgroundKind;
begin
  // we are caching this values for performance in hotload loops
  BackgroundKind := FRangeBackground.Kind;
  BackgroundCellSize := FRangeBackground.CellSize;
  BackgroundColors[False] := TColorToFPColor(FRangeBackground.Color1);
  BackgroundColors[True] := TColorToFPColor(FRangeBackground.Color2);
  HorizontalMinValue := HorizontalMin;
  HorizontalMaxValue := HorizontalMax;
  VerticalMinValue := VerticalMin;
  VerticalMaxValue := VerticalMax;
  Opacity := GetPickerRangeOpacity();

  DividerX := Max(1, Image.Width - 1);
  DividerY := Max(1, Image.Height - 1);

  // make horz value line
  Values := nil;
  SetLength(Values, Image.Width);
  for I := 0 to Image.Width - 1 do
  begin
    if HorizontalReverse then
    begin
      Values[I] := HorizontalMaxValue - ((I * (HorizontalMaxValue - HorizontalMinValue) + DividerX div 2) div DividerX);
    end else
    begin
      Values[I] := HorizontalMinValue + ((I * (HorizontalMaxValue - HorizontalMinValue) + DividerX div 2) div DividerX);
    end;
  end;

  // shade
  for Y := 0 to Image.Height - 1 do
  begin
    if VerticalReverse then
    begin
      ValueY := VerticalMaxValue - ((Y * (VerticalMaxValue - VerticalMinValue) + DividerY div 2) div DividerY);
    end else
    begin
      ValueY := VerticalMinValue + ((Y * (VerticalMaxValue - VerticalMinValue) + DividerY div 2) div DividerY);
    end;
    for X := 0 to Image.Width - 1 do
    begin
      ValueX := Values[X];

      ShaderColor := Shader(ValueX, ValueY);

      if ShaderColor.A and Opacity = 255 then
      begin
        Image.SetInternalColorProc(X, Y, ShaderColor.FPColor);
      end else
      begin
        BackgroundColor := BackgroundColors[AlphaBackgroundCase(BackgroundKind, BackgroundCellSize, X, Y)];
        Image.SetInternalColorProc(X, Y, BlendFPColor(BackgroundColor, ShaderColor.FPColor, Opacity));
      end;
    end;
  end;
end;
{$IFDEF RANGECHECKS_ON}{$RANGECHECKS ON}{$ELSE}{$RANGECHECKS OFF}{$ENDIF}
{$IFDEF OVERFLOWCHECKS_ON}{$OVERFLOWCHECKS ON}{$ELSE}{$OVERFLOWCHECKS OFF}{$ENDIF}

procedure TTurboColorAxisPicker.RangeBackgroundChange(Sender: TObject);
begin
  PickerInvalidate(True);
end;

procedure TTurboColorAxisPicker.SetAlphaModulation(Value: Boolean);
begin
  if FAlphaModulation = Value then
  begin
    exit;
  end;

  FAlphaModulation := Value;
  PickerInvalidate(True);
end;

procedure TTurboColorAxisPicker.SetAlphaPreview(Value: Byte);
begin
  if FAlphaPreview = Value then
  begin
    exit;
  end;

  FAlphaPreview := Value;
  PickerRepaint(True);
end;

procedure TTurboColorAxisPicker.SetRangeBackground(Value: TTurboTransparentBackground);
begin
  FRangeBackground.Assign(Value);
end;

function TTurboColorAxisPicker.GetDefaultHorizontalIncrement(): Integer;
begin
  Result := 1;
end;

function TTurboColorAxisPicker.GetDefaultIncrementMultiplier(): Integer;
begin
  Result := 8;
end;

function TTurboColorAxisPicker.GetDefaultVerticalIncrement(): Integer;
begin
  Result := 1;
end;

function TTurboColorAxisPicker.GetHorizontalRange(): TTurboRange;
begin
  Result := TTurboRange.Create(0, 255);
end;

function TTurboColorAxisPicker.GetVerticalRange(): TTurboRange;
begin
  Result := TTurboRange.Create(0, 255);
end;

procedure TTurboColorAxisPicker.PaintRangeBitmap(Bitmap: TBitmap);
var
  Image: TLazIntfImage;
  Shader: TTurboAxisPickerShader;
begin
  Image := Bitmap.CreateIntfImage();
  try
    Shader := GetPickerRangeShader();
    if Assigned(Shader) then
    begin
      DrawRangeBitmap(Image, Shader);
    end;
    Bitmap.LoadFromIntfImage(Image);
  finally
    Image.Free();
  end;
end;

function TTurboColorAxisPicker.GetPickerRangeOpacity(): Byte;
begin
  if FAlphaModulation then
  begin
    Result := FAlphaPreview;
  end else
  begin
    Result := 255;
  end;
end;

function TTurboColorAxisPicker.GetPickerRangeShader(): TTurboAxisPickerShader;
begin
  Result := nil;
end;

{ TTurboColorFloatAxisPicker }

constructor TTurboColorFloatAxisPicker.Create(Owner: TComponent);
begin
  inherited Create(Owner);

  FRangeBackground := TTurboTransparentBackground.Create();
  FRangeBackground.OnChange := RangeBackgroundChange;

  FAlphaPreview := 255;
  FAlphaModulation := True;
end;

destructor TTurboColorFloatAxisPicker.Destroy();
begin
  FRangeBackground.Free();

  inherited Destroy();
end;

{$IFOPT R+}{$DEFINE RANGECHECKS_ON}{$ENDIF}
{$IFOPT Q+}{$DEFINE OVERFLOWCHECKS_ON}{$ENDIF}
{$RANGECHECKS OFF}
{$OVERFLOWCHECKS OFF}
procedure TTurboColorFloatAxisPicker.DrawRangeBitmap(Image: TLazIntfImage; Shader: TTurboAxisPickerFloatShader);
var
  X, Y, I: Integer;
  ValueX, ValueY: Double;
  DividerX, DividerY: Double;
  HorizontalMaxValue, HorizontalMinValue: Double;
  VerticalMaxValue, VerticalMinValue: Double;
  Values: array of Double;
  ShaderColor: TTurboColor;
  Opacity: Byte;
  BackgroundColor: TFPColor;
  // background
  BackgroundColors: array [Boolean] of TFPColor;
  BackgroundCellSize: Integer;
  BackgroundKind: TTurboTransparentBackgroundKind;
begin
  // we are caching this values for performance in hotload loops
  BackgroundKind := FRangeBackground.Kind;
  BackgroundCellSize := FRangeBackground.CellSize;
  BackgroundColors[False] := TColorToFPColor(FRangeBackground.Color1);
  BackgroundColors[True] := TColorToFPColor(FRangeBackground.Color2);
  HorizontalMinValue := HorizontalMin;
  HorizontalMaxValue := HorizontalMax;
  VerticalMinValue := VerticalMin;
  VerticalMaxValue := VerticalMax;
  Opacity := GetPickerRangeOpacity();

  DividerX := Max(1, Image.Width - 1);
  DividerY := Max(1, Image.Height - 1);

  // make horz value line
  Values := nil;
  SetLength(Values, Image.Width);
  for I := 0 to Image.Width - 1 do
  begin
    if HorizontalReverse then
    begin
      Values[I] := HorizontalMaxValue - ((I * (HorizontalMaxValue - HorizontalMinValue)) / DividerX);
    end else
    begin
      Values[I] := HorizontalMinValue + ((I * (HorizontalMaxValue - HorizontalMinValue)) / DividerX);
    end;
  end;

  // shade
  for Y := 0 to Image.Height - 1 do
  begin
    if VerticalReverse then
    begin
      ValueY := VerticalMaxValue - ((Y * (VerticalMaxValue - VerticalMinValue)) / DividerY);
    end else
    begin
      ValueY := VerticalMinValue + ((Y * (VerticalMaxValue - VerticalMinValue)) / DividerY);
    end;
    for X := 0 to Image.Width - 1 do
    begin
      ValueX := Values[X];

      ShaderColor := Shader(ValueX, ValueY);

      if ShaderColor.A and Opacity = 255 then
      begin
        Image.SetInternalColorProc(X, Y, ShaderColor.FPColor);
      end else
      begin
        BackgroundColor := BackgroundColors[AlphaBackgroundCase(BackgroundKind, BackgroundCellSize, X, Y)];
        Image.SetInternalColorProc(X, Y, BlendFPColor(BackgroundColor, ShaderColor.FPColor, Opacity));
      end;
    end;
  end;
end;
{$IFDEF RANGECHECKS_ON}{$RANGECHECKS ON}{$ELSE}{$RANGECHECKS OFF}{$ENDIF}
{$IFDEF OVERFLOWCHECKS_ON}{$OVERFLOWCHECKS ON}{$ELSE}{$OVERFLOWCHECKS OFF}{$ENDIF}

procedure TTurboColorFloatAxisPicker.RangeBackgroundChange(Sender: TObject);
begin
  PickerInvalidate(True);
end;

procedure TTurboColorFloatAxisPicker.SetAlphaModulation(Value: Boolean);
begin
  if FAlphaModulation = Value then
  begin
    exit;
  end;

  FAlphaModulation := Value;
  PickerInvalidate(True);
end;

procedure TTurboColorFloatAxisPicker.SetAlphaPreview(Value: Byte);
begin
  if FAlphaPreview = Value then
  begin
    exit;
  end;

  FAlphaPreview := Value;
  PickerRepaint(True);
end;

procedure TTurboColorFloatAxisPicker.SetRangeBackground(Value: TTurboTransparentBackground);
begin
  FRangeBackground.Assign(Value);
end;

function TTurboColorFloatAxisPicker.GetDefaultHorizontalIncrement(): Double;
begin
  Result := GetHorizontalRange().Length / 100.0;
end;

function TTurboColorFloatAxisPicker.GetDefaultIncrementMultiplier(): Integer;
begin
  Result := 5;
end;

function TTurboColorFloatAxisPicker.GetDefaultVerticalIncrement(): Double;
begin
  Result := GetVerticalRange().Length / 100.0;
end;

function TTurboColorFloatAxisPicker.GetHorizontalRange(): TTurboFloatRange;
begin
  Result := TTurboFloatRange.Create(0.0, 1.0);
end;

function TTurboColorFloatAxisPicker.GetVerticalRange(): TTurboFloatRange;
begin
  Result := TTurboFloatRange.Create(0.0, 1.0);
end;

procedure TTurboColorFloatAxisPicker.PaintRangeBitmap(Bitmap: TBitmap);
var
  Image: TLazIntfImage;
  Shader: TTurboAxisPickerFloatShader;
begin
  Image := Bitmap.CreateIntfImage();
  try
    Shader := GetPickerRangeShader();
    if Assigned(Shader) then
    begin
      DrawRangeBitmap(Image, Shader);
    end;
    Bitmap.LoadFromIntfImage(Image);
  finally
    Image.Free();
  end;
end;

function TTurboColorFloatAxisPicker.GetPickerRangeOpacity(): Byte;
begin
  if FAlphaModulation then
  begin
    Result := FAlphaPreview;
  end else
  begin
    Result := 255;
  end;
end;

function TTurboColorFloatAxisPicker.GetPickerRangeShader(): TTurboAxisPickerFloatShader;
begin
  Result := nil;
end;

{ TTurboHslLinePicker }

constructor TTurboHslLinePicker.Create(Owner: TComponent);
begin
  inherited Create(Owner);

  FColorModulation := False;
  FColorModulationLoaded := False;
  FHue := 0.5;
  FKind := TTurboHslLinePickerKind.Hue;
  FLightness := 0.5;
  FPreviewStyle := TTurboHslLinePickerPreviewStyle.RedGreenBlueGradient;
  FSaturation := 0.5;
end;

procedure TTurboHslLinePicker.GetHsl(out Hue, Saturation, Lightness: Double);
begin
  Hue := FHue;
  Saturation := FSaturation;
  Lightness := FLightness;
end;

procedure TTurboHslLinePicker.GetHsv(out Hue, Saturation, Value: Double);
begin
  HslToHsv(FHue, FSaturation, FLightness, Hue, Saturation, Value);
end;

procedure TTurboHslLinePicker.GetRgb(out Red, Green, Blue: Byte);
begin
  HslToRgb(FHue, FSaturation, FLightness, Red, Green, Blue);
end;

procedure TTurboHslLinePicker.SetHsl(Hue, Saturation, Lightness: Double);
begin
  UpdateHsl(Hue, Saturation, Lightness);
end;

procedure TTurboHslLinePicker.SetHsv(Hue, Saturation, Value: Double);
var
  H, S, L: Double;
begin
  HsvToHsl(Hue, Saturation, Value, H, S, L);

  UpdateHsl(H, S, L);
end;

procedure TTurboHslLinePicker.SetRgb(Red, Green, Blue: Byte);
var
  H, S, L: Double;
begin
  RgbToHsl(Red, Green, Blue, H, S, L);

  UpdateHsl(H, S, L);
end;

{$IFOPT R+}{$DEFINE RANGECHECKS_ON}{$ENDIF}
{$IFOPT Q+}{$DEFINE OVERFLOWCHECKS_ON}{$ENDIF}
{$RANGECHECKS OFF}
{$OVERFLOWCHECKS OFF}
function TTurboHslLinePicker.ShaderHue(Value: Double): TTurboColor;
var
  R, G, B: Byte;
begin
  HslToRgb(Value, 1.0, 0.5, R, G, B);
  Result := TTurboColor.Create(R, G, B);
end;

function TTurboHslLinePicker.ShaderLightnessGreenBlueRedGradient(ValueX, ValueY: Double): TTurboColor;
const
  Angle = 120.0;
  Range = 240.0;
  Scale = 1.0 - 1.0 / 9.0;
  Multiplier = (Range / 360.0) * (1.0 / Scale);
  Adder = (Angle / 360.0) + 0.5 * (Range / 360.0) - 0.5 * Multiplier;
var
  R, G, B: Byte;
begin
  if ValueY < (1.0 - Scale) / 2.0 then
  begin
    HslToRgb(120.0 / 360.0, 1.0, ValueX, R, G, B);
  end else
  if ValueY > (1.0 + Scale) / 2.0 then
  begin
    HslToRgb(360.0 / 360.0, 1.0, ValueX, R, G, B);
  end else
  begin
    HslToRgb(ValueY * Multiplier + Adder, 1.0, ValueX, R, G, B);
  end;
  Result := TTurboColor.Create(R, G, B);
end;

function TTurboHslLinePicker.ShaderLightnessRedGreenBlueGradient(ValueX, ValueY: Double): TTurboColor;
const
  Angle = 0.0;
  Range = 240.0;
  Scale = 1.0 - 1.0 / 3.0;
  Multiplier = (Range / 360.0) * (1.0 / Scale);
  Adder = (Angle / 360.0) + 0.5 * (Range / 360.0) - 0.5 * Multiplier;
var
  R, G, B: Byte;
begin
  if ValueY < (1.0 - Scale) / 2.0 then
  begin
    HslToRgb(0.0, 1.0, ValueX, R, G, B);
  end else
  if ValueY > (1.0 + Scale) / 2.0 then
  begin
    HslToRgb(240.0 / 360.0, 1.0, ValueX, R, G, B);
  end else
  begin
    HslToRgb(ValueY * Multiplier + Adder, 1.0, ValueX, R, G, B);
  end;
  Result := TTurboColor.Create(R, G, B);
end;

function TTurboHslLinePicker.ShaderLightnessRedGreenBlueLines(ValueX, ValueY: Double): TTurboColor;
var
  R, G, B: Byte;
begin
  if ValueY <= 1.0 / 3.0 then
  begin
    HslToRgb(0.0, 1.0, ValueX, R, G, B);
  end else
  if ValueY > 2.0 / 3.0 then
  begin
    HslToRgb(240.0 / 360.0, 1.0, ValueX, R, G, B);
  end else
  begin
    HslToRgb(120.0 / 360.0, 1.0, ValueX, R, G, B);
  end;
  Result := TTurboColor.Create(R, G, B);
end;

function TTurboHslLinePicker.ShaderModulatedHue(Value: Double): TTurboColor;
var
  R, G, B: Byte;
begin
  HslToRgb(Value, FSaturation, FLightness, R, G, B);
  Result := TTurboColor.Create(R, G, B);
end;

function TTurboHslLinePicker.ShaderModulatedLightness(Value: Double): TTurboColor;
var
  R, G, B: Byte;
begin
  HslToRgb(FHue, FSaturation, Value, R, G, B);
  Result := TTurboColor.Create(R, G, B);
end;

function TTurboHslLinePicker.ShaderModulatedSaturation(Value: Double): TTurboColor;
var
  R, G, B: Byte;
begin
  HslToRgb(FHue, Value, FLightness, R, G, B);
  Result := TTurboColor.Create(R, G, B);
end;

function TTurboHslLinePicker.ShaderSaturationGreenBlueRedGradient(ValueX, ValueY: Double): TTurboColor;
const
  Angle = 120.0;
  Range = 240.0;
  Scale = 1.0 - 1.0 / 9.0;
  Multiplier = (Range / 360.0) * (1.0 / Scale);
  Adder = (Angle / 360.0) + 0.5 * (Range / 360.0) - 0.5 * Multiplier;
var
  R, G, B: Byte;
begin
  if ValueY < (1.0 - Scale) / 2.0 then
  begin
    HslToRgb(120.0 / 360.0, ValueX, 0.5, R, G, B);
  end else
  if ValueY > (1.0 + Scale) / 2.0 then
  begin
    HslToRgb(360.0 / 360.0, ValueX, 0.5, R, G, B);
  end else
  begin
    HslToRgb(ValueY * Multiplier + Adder, ValueX, 0.5, R, G, B);
  end;
  Result := TTurboColor.Create(R, G, B);
end;

function TTurboHslLinePicker.ShaderSaturationRedGreenBlueGradient(ValueX, ValueY: Double): TTurboColor;
const
  Angle = 0.0;
  Range = 240.0;
  Scale = 1.0 - 1.0 / 3.0;
  Multiplier = (Range / 360.0) * (1.0 / Scale);
  Adder = (Angle / 360.0) + 0.5 * (Range / 360.0) - 0.5 * Multiplier;
var
  R, G, B: Byte;
begin
  if ValueY < (1.0 - Scale) / 2.0 then
  begin
    HslToRgb(0.0, ValueX, 0.5, R, G, B);
  end else
  if ValueY > (1.0 + Scale) / 2.0 then
  begin
    HslToRgb(240.0 / 360.0, ValueX, 0.5, R, G, B);
  end else
  begin
    HslToRgb(ValueY * Multiplier + Adder, ValueX, 0.5, R, G, B);
  end;
  Result := TTurboColor.Create(R, G, B);
end;

function TTurboHslLinePicker.ShaderSaturationRedGreenBlueLines(ValueX, ValueY: Double): TTurboColor;
var
  R, G, B: Byte;
begin
  if ValueY <= 1.0 / 3.0 then
  begin
    HslToRgb(0.0, ValueX, 0.5, R, G, B);
  end else
  if ValueY > 2.0 / 3.0 then
  begin
    HslToRgb(240.0 / 360.0, ValueX, 0.5, R, G, B);
  end else
  begin
    HslToRgb(120.0 / 360.0, ValueX, 0.5, R, G, B);
  end;
  Result := TTurboColor.Create(R, G, B);
end;
{$IFDEF RANGECHECKS_ON}{$RANGECHECKS ON}{$ELSE}{$RANGECHECKS OFF}{$ENDIF}
{$IFDEF OVERFLOWCHECKS_ON}{$OVERFLOWCHECKS ON}{$ELSE}{$OVERFLOWCHECKS OFF}{$ENDIF}

function TTurboHslLinePicker.GetCurrentColor(): TColor;
var
  R, G, B: Byte;
begin
  HslToRgb(FHue, FSaturation, FLightness, R, G, B);
  Result := RGB(R, G, B);
end;

function TTurboHslLinePicker.IsColorModulationStored(): Boolean;
begin
  Result := FColorModulation <> (FKind <> TTurboHslLinePickerKind.Hue);
end;

function TTurboHslLinePicker.IsHueStored(): Boolean;
begin
  Result := FHue <> 0.5;
end;

function TTurboHslLinePicker.IsLightnessStored(): Boolean;
begin
  Result := FLightness <> 0.5;
end;

function TTurboHslLinePicker.IsSaturationStored(): Boolean;
begin
  Result := FSaturation <> 0.5;
end;

procedure TTurboHslLinePicker.SetColorModulation(Value: Boolean);
begin
  if csLoading in ComponentState then
  begin
    FColorModulationLoaded := True;
  end;

  if FColorModulation = Value then
  begin
    exit;
  end;

  FColorModulation := Value;
  PickerInvalidate(True);
end;

procedure TTurboHslLinePicker.SetCurrentColor(Value: TColor);
var
  H, S, L: Double;
begin
  Value := ColorToRGB(Value);

  RgbToHsl(GetRValue(Value), GetGValue(Value), GetBValue(Value), H, S, L);

  UpdateHsl(H, S, L);
end;

procedure TTurboHslLinePicker.SetHue(Value: Double);
begin
  UpdateHsl(Value, FSaturation, FLightness);
end;

procedure TTurboHslLinePicker.SetSaturation(Value: Double);
begin
  UpdateHsl(FHue, Value, FLightness);
end;

procedure TTurboHslLinePicker.UpdateHsl(Hue, Saturation, Lightness: Double);
var
  NeedUpdate: Boolean;
begin
  Hue := EnsureRange(Hue, 0.0, 1.0);
  Saturation := EnsureRange(Saturation, 0.0, 1.0);
  Lightness := EnsureRange(Lightness, 0.0, 1.0);

  if (Hue = FHue) and (Saturation = FSaturation) and (Lightness = FLightness) then
  begin
    exit;
  end;

  NeedUpdate :=
    ((Hue <> FHue) and ((FKind <> TTurboHslLinePickerKind.Hue) and FColorModulation)) or
    ((Saturation <> FSaturation) and ((FKind <> TTurboHslLinePickerKind.Saturation) and FColorModulation)) or
    ((Lightness <> FLightness) and ((FKind <> TTurboHslLinePickerKind.Lightness) and FColorModulation));

  FHue := Hue;
  FSaturation := Saturation;
  FLightness := Lightness;

  PickerChange(NeedUpdate);
end;

procedure TTurboHslLinePicker.SetLightness(Value: Double);
begin
  UpdateHsl(FHue, FSaturation, Value);
end;

procedure TTurboHslLinePicker.SetKind(Value: TTurboHslLinePickerKind);
begin
  if FKind = Value then
  begin
    exit;
  end;

  FKind := Value;

  if not ((csLoading in ComponentState) and FColorModulationLoaded) then
  begin
    FColorModulation := FKind <> TTurboHslLinePickerKind.Hue;
  end;

  PickerChange(True);
end;

procedure TTurboHslLinePicker.SetPreviewStyle(Value: TTurboHslLinePickerPreviewStyle);
begin
  if FPreviewStyle = Value then
  begin
    exit;
  end;

  FPreviewStyle := Value;

  PickerInvalidate(True);
end;

function TTurboHslLinePicker.GetPickerRangeShader1D(): TTurboLinePickerFloatShader1D;
begin
  case FKind of
    TTurboHslLinePickerKind.Hue:
    begin
      if FColorModulation then
      begin
        Result := ShaderModulatedHue;
      end else
      begin
        Result := ShaderHue;
      end;
    end;
    TTurboHslLinePickerKind.Saturation:
    begin
      if FColorModulation then
      begin
        Result := ShaderModulatedSaturation;
      end else
      begin
        Result := nil;
      end;
    end;
    TTurboHslLinePickerKind.Lightness:
    begin
      if FColorModulation then
      begin
        Result := ShaderModulatedLightness;
      end else
      begin
        Result := nil;
      end;
    end;
  end;
end;

function TTurboHslLinePicker.GetPickerRangeShader2D(): TTurboLinePickerFloatShader2D;
begin
  case FKind of
    TTurboHslLinePickerKind.Saturation:
    begin
      case FPreviewStyle of
        TTurboHslLinePickerPreviewStyle.RedGreenBlueGradient:
        begin
          Result := ShaderSaturationRedGreenBlueGradient;
        end;
        TTurboHslLinePickerPreviewStyle.GreenBlueRedGradient:
        begin
          Result := ShaderSaturationGreenBlueRedGradient;
        end;
        TTurboHslLinePickerPreviewStyle.RedGreenBlueLines:
        begin
          Result := ShaderSaturationRedGreenBlueLines;
        end;
      end;
    end;
    TTurboHslLinePickerKind.Lightness:
    begin
      case FPreviewStyle of
        TTurboHslLinePickerPreviewStyle.RedGreenBlueGradient:
        begin
          Result := ShaderLightnessRedGreenBlueGradient;
        end;
        TTurboHslLinePickerPreviewStyle.GreenBlueRedGradient:
        begin
          Result := ShaderLightnessGreenBlueRedGradient;
        end;
        TTurboHslLinePickerPreviewStyle.RedGreenBlueLines:
        begin
          Result := ShaderLightnessRedGreenBlueLines;
        end;
      end;
    end;
    else
      raise ENotImplemented.Create('Bad Kind');
  end;
end;

function TTurboHslLinePicker.GetPickerValue(): Double;
begin
  case FKind of
    TTurboHslLinePickerKind.Hue:
    begin
      Result := FHue;
    end;
    TTurboHslLinePickerKind.Saturation:
    begin
      Result := FSaturation;
    end;
    TTurboHslLinePickerKind.Lightness:
    begin
      Result := FLightness;
    end;
  end;
end;

procedure TTurboHslLinePicker.SetPickerValue(Value: Double);
begin
  case FKind of
    TTurboHslLinePickerKind.Hue:
    begin
      FHue := Value;
    end;
    TTurboHslLinePickerKind.Saturation:
    begin
      FSaturation := Value;
    end;
    TTurboHslLinePickerKind.Lightness:
    begin
      FLightness := Value;
    end;
  end;
end;

function TTurboHslLinePicker.GetPickerThumbPreviewColor(): TColor;
var
  R, G, B: Byte;
begin
  if FColorModulation then
  begin
    Result := GetCurrentColor()
  end else
  begin
    case FKind of
      TTurboHslLinePickerKind.Hue:
      begin
        HslToRgb(FHue, 1.0, 0.5, R, G, B);
        Result := RGB(R, G, B);
      end;
      TTurboHslLinePickerKind.Saturation:
      begin
        Result := clHighlight;
      end;
      TTurboHslLinePickerKind.Lightness:
      begin
        Result := clHighlight;
      end;
    end;
  end;
end;

{ TTurboHsvLinePicker }

constructor TTurboHsvLinePicker.Create(Owner: TComponent);
begin
  inherited Create(Owner);

  FColorModulation := False;
  FColorModulationLoaded := False;
  FHue := 0.5;
  FKind := TTurboHsvLinePickerKind.Hue;
  FPreviewStyle := TTurboHsvLinePickerPreviewStyle.RedGreenBlueGradient;
  FSaturation := 0.5;
  FValue := 0.5;
end;

procedure TTurboHsvLinePicker.GetHsl(out Hue, Saturation, Lightness: Double);
begin
  HsvToHsl(FHue, FSaturation, FValue, Hue, Saturation, Lightness);
end;

procedure TTurboHsvLinePicker.GetHsv(out Hue, Saturation, Value: Double);
begin
  Hue := FHue;
  Saturation := FSaturation;
  Value := FValue;
end;

procedure TTurboHsvLinePicker.GetRgb(out Red, Green, Blue: Byte);
begin
  HsvToRgb(FHue, FSaturation, FValue, Red, Green, Blue);
end;

procedure TTurboHsvLinePicker.SetHsl(Hue, Saturation, Lightness: Double);
var
  H, S, V: Double;
begin
  HslToHsv(Hue, Saturation, Lightness, H, S, V);

  UpdateHsv(H, S, V);
end;

procedure TTurboHsvLinePicker.SetHsv(Hue, Saturation, Value: Double);
begin
  UpdateHsv(Hue, Saturation, Value);
end;

procedure TTurboHsvLinePicker.SetRgb(Red, Green, Blue: Byte);
var
  H, S, V: Double;
begin
  RgbToHsv(Red, Green, Blue, H, S, V);

  UpdateHsv(H, S, V);
end;

{$IFOPT R+}{$DEFINE RANGECHECKS_ON}{$ENDIF}
{$IFOPT Q+}{$DEFINE OVERFLOWCHECKS_ON}{$ENDIF}
{$RANGECHECKS OFF}
{$OVERFLOWCHECKS OFF}
function TTurboHsvLinePicker.ShaderHue(Value: Double): TTurboColor;
var
  R, G, B: Byte;
begin
  HsvToRgb(Value, 1.0, 1.0, R, G, B);
  Result := TTurboColor.Create(R, G, B);
end;

function TTurboHsvLinePicker.ShaderValueGreenBlueRedGradient(ValueX, ValueY: Double): TTurboColor;
const
  Angle = 120.0;
  Range = 240.0;
  Scale = 1.0 - 1.0 / 9.0;
  Multiplier = (Range / 360.0) * (1.0 / Scale);
  Adder = (Angle / 360.0) + 0.5 * (Range / 360.0) - 0.5 * Multiplier;
var
  R, G, B: Byte;
begin
  if ValueY < (1.0 - Scale) / 2.0 then
  begin
    HsvToRgb(120.0 / 360.0, 1.0, ValueX, R, G, B);
  end else
  if ValueY > (1.0 + Scale) / 2.0 then
  begin
    HsvToRgb(360.0 / 360.0, 1.0, ValueX, R, G, B);
  end else
  begin
    HsvToRgb(ValueY * Multiplier + Adder, 1.0, ValueX, R, G, B);
  end;
  Result := TTurboColor.Create(R, G, B);
end;

function TTurboHsvLinePicker.ShaderValueRedGreenBlueGradient(ValueX, ValueY: Double): TTurboColor;
const
  Angle = 0.0;
  Range = 240.0;
  Scale = 1.0 - 1.0 / 3.0;
  Multiplier = (Range / 360.0) * (1.0 / Scale);
  Adder = (Angle / 360.0) + 0.5 * (Range / 360.0) - 0.5 * Multiplier;
var
  R, G, B: Byte;
begin
  if ValueY < (1.0 - Scale) / 2.0 then
  begin
    HsvToRgb(0.0, 1.0, ValueX, R, G, B);
  end else
  if ValueY > (1.0 + Scale) / 2.0 then
  begin
    HsvToRgb(240.0 / 360.0, 1.0, ValueX, R, G, B);
  end else
  begin
    HsvToRgb(ValueY * Multiplier + Adder, 1.0, ValueX, R, G, B);
  end;
  Result := TTurboColor.Create(R, G, B);
end;

function TTurboHsvLinePicker.ShaderValueRedGreenBlueLines(ValueX, ValueY: Double): TTurboColor;
var
  R, G, B: Byte;
begin
  if ValueY <= 1.0 / 3.0 then
  begin
    HsvToRgb(0.0, 1.0, ValueX, R, G, B);
  end else
  if ValueY > 2.0 / 3.0 then
  begin
    HsvToRgb(240.0 / 360.0, 1.0, ValueX, R, G, B);
  end else
  begin
    HsvToRgb(120.0 / 360.0, 1.0, ValueX, R, G, B);
  end;
  Result := TTurboColor.Create(R, G, B);
end;

function TTurboHsvLinePicker.ShaderModulatedHue(Value: Double): TTurboColor;
var
  R, G, B: Byte;
begin
  HsvToRgb(Value, FSaturation, FValue, R, G, B);
  Result := TTurboColor.Create(R, G, B);
end;

function TTurboHsvLinePicker.ShaderModulatedValue(Value: Double): TTurboColor;
var
  R, G, B: Byte;
begin
  HsvToRgb(FHue, FSaturation, Value, R, G, B);
  Result := TTurboColor.Create(R, G, B);
end;

function TTurboHsvLinePicker.ShaderModulatedSaturation(Value: Double): TTurboColor;
var
  R, G, B: Byte;
begin
  HsvToRgb(FHue, Value, FValue, R, G, B);
  Result := TTurboColor.Create(R, G, B);
end;

function TTurboHsvLinePicker.ShaderSaturationGreenBlueRedGradient(ValueX, ValueY: Double): TTurboColor;
const
  Angle = 120.0;
  Range = 240.0;
  Scale = 1.0 - 1.0 / 9.0;
  Multiplier = (Range / 360.0) * (1.0 / Scale);
  Adder = (Angle / 360.0) + 0.5 * (Range / 360.0) - 0.5 * Multiplier;
var
  R, G, B: Byte;
begin
  if ValueY < (1.0 - Scale) / 2.0 then
  begin
    HsvToRgb(120.0 / 360.0, ValueX, 1.0, R, G, B);
  end else
  if ValueY > (1.0 + Scale) / 2.0 then
  begin
    HsvToRgb(360.0 / 360.0, ValueX, 1.0, R, G, B);
  end else
  begin
    HsvToRgb(ValueY * Multiplier + Adder, ValueX, 1.0, R, G, B);
  end;
  Result := TTurboColor.Create(R, G, B);
end;

function TTurboHsvLinePicker.ShaderSaturationRedGreenBlueGradient(ValueX, ValueY: Double): TTurboColor;
const
  Angle = 0.0;
  Range = 240.0;
  Scale = 1.0 - 1.0 / 3.0;
  Multiplier = (Range / 360.0) * (1.0 / Scale);
  Adder = (Angle / 360.0) + 0.5 * (Range / 360.0) - 0.5 * Multiplier;
var
  R, G, B: Byte;
begin
  if ValueY < (1.0 - Scale) / 2.0 then
  begin
    HsvToRgb(0.0, ValueX, 1.0, R, G, B);
  end else
  if ValueY > (1.0 + Scale) / 2.0 then
  begin
    HsvToRgb(240.0 / 360.0, ValueX, 1.0, R, G, B);
  end else
  begin
    HsvToRgb(ValueY * Multiplier + Adder, ValueX, 1.0, R, G, B);
  end;
  Result := TTurboColor.Create(R, G, B);
end;

function TTurboHsvLinePicker.ShaderSaturationRedGreenBlueLines(ValueX, ValueY: Double): TTurboColor;
var
  R, G, B: Byte;
begin
  if ValueY <= 1.0 / 3.0 then
  begin
    HsvToRgb(0.0, ValueX, 1.0, R, G, B);
  end else
  if ValueY > 2.0 / 3.0 then
  begin
    HsvToRgb(240.0 / 360.0, ValueX, 1.0, R, G, B);
  end else
  begin
    HsvToRgb(120.0 / 360.0, ValueX, 1.0, R, G, B);
  end;
  Result := TTurboColor.Create(R, G, B);
end;
{$IFDEF RANGECHECKS_ON}{$RANGECHECKS ON}{$ELSE}{$RANGECHECKS OFF}{$ENDIF}
{$IFDEF OVERFLOWCHECKS_ON}{$OVERFLOWCHECKS ON}{$ELSE}{$OVERFLOWCHECKS OFF}{$ENDIF}

function TTurboHsvLinePicker.GetCurrentColor(): TColor;
var
  R, G, B: Byte;
begin
  HsvToRgb(FHue, FSaturation, FValue, R, G, B);
  Result := RGB(R, G, B);
end;

function TTurboHsvLinePicker.IsColorModulationStored(): Boolean;
begin
  Result := FColorModulation <> (FKind <> TTurboHsvLinePickerKind.Hue);
end;

function TTurboHsvLinePicker.IsHueStored(): Boolean;
begin
  Result := FHue <> 0.5;
end;

function TTurboHsvLinePicker.IsValueStored(): Boolean;
begin
  Result := FValue <> 0.5;
end;

function TTurboHsvLinePicker.IsSaturationStored(): Boolean;
begin
  Result := FSaturation <> 0.5;
end;

procedure TTurboHsvLinePicker.SetColorModulation(Value: Boolean);
begin
  if csLoading in ComponentState then
  begin
    FColorModulationLoaded := True;
  end;

  if FColorModulation = Value then
  begin
    exit;
  end;

  FColorModulation := Value;
  PickerInvalidate(True);
end;

procedure TTurboHsvLinePicker.SetCurrentColor(Value: TColor);
var
  H, S, V: Double;
begin
  Value := ColorToRGB(Value);

  RgbToHsv(GetRValue(Value), GetGValue(Value), GetBValue(Value), H, S, V);

  UpdateHsv(H, S, V);
end;

procedure TTurboHsvLinePicker.SetHue(Value: Double);
begin
  UpdateHsv(Value, FSaturation, FValue);
end;

procedure TTurboHsvLinePicker.SetSaturation(Value: Double);
begin
  UpdateHsv(FHue, Value, FValue);
end;

procedure TTurboHsvLinePicker.SetValue(Value: Double);
begin
  UpdateHsv(FHue, FSaturation, Value);
end;

procedure TTurboHsvLinePicker.UpdateHsv(Hue, Saturation, Value: Double);
var
  NeedUpdate: Boolean;
begin
  Hue := EnsureRange(Hue, 0.0, 1.0);
  Saturation := EnsureRange(Saturation, 0.0, 1.0);
  Value := EnsureRange(Value, 0.0, 1.0);

  if (Hue = FHue) and (Saturation = FSaturation) and (Value = FValue) then
  begin
    exit;
  end;

  NeedUpdate :=
    ((Hue <> FHue) and ((FKind <> TTurboHsvLinePickerKind.Hue) and FColorModulation)) or
    ((Saturation <> FSaturation) and ((FKind <> TTurboHsvLinePickerKind.Saturation) and FColorModulation)) or
    ((Value <> FValue) and ((FKind <> TTurboHsvLinePickerKind.Value) and FColorModulation));

  FHue := Hue;
  FSaturation := Saturation;
  FValue := Value;

  PickerChange(NeedUpdate);
end;

procedure TTurboHsvLinePicker.SetKind(Value: TTurboHsvLinePickerKind);
begin
  if FKind = Value then
  begin
    exit;
  end;

  FKind := Value;

  if not ((csLoading in ComponentState) and FColorModulationLoaded) then
  begin
    FColorModulation := FKind <> TTurboHsvLinePickerKind.Hue;
  end;

  PickerChange(True);
end;

procedure TTurboHsvLinePicker.SetPreviewStyle(Value: TTurboHsvLinePickerPreviewStyle);
begin
  if FPreviewStyle = Value then
  begin
    exit;
  end;

  FPreviewStyle := Value;

  PickerInvalidate(True);
end;

function TTurboHsvLinePicker.GetPickerRangeShader1D(): TTurboLinePickerFloatShader1D;
begin
  case FKind of
    TTurboHsvLinePickerKind.Hue:
    begin
      if FColorModulation then
      begin
        Result := ShaderModulatedHue;
      end else
      begin
        Result := ShaderHue;
      end;
    end;
    TTurboHsvLinePickerKind.Saturation:
    begin
      if FColorModulation then
      begin
        Result := ShaderModulatedSaturation;
      end else
      begin
        Result := nil;
      end;
    end;
    TTurboHsvLinePickerKind.Value:
    begin
      if FColorModulation then
      begin
        Result := ShaderModulatedValue;
      end else
      begin
        Result := nil;
      end;
    end;
  end;
end;

function TTurboHsvLinePicker.GetPickerRangeShader2D(): TTurboLinePickerFloatShader2D;
begin
  case FKind of
    TTurboHsvLinePickerKind.Saturation:
    begin
      case FPreviewStyle of
        TTurboHsvLinePickerPreviewStyle.RedGreenBlueGradient:
        begin
          Result := ShaderSaturationRedGreenBlueGradient;
        end;
        TTurboHsvLinePickerPreviewStyle.GreenBlueRedGradient:
        begin
          Result := ShaderSaturationGreenBlueRedGradient;
        end;
        TTurboHsvLinePickerPreviewStyle.RedGreenBlueLines:
        begin
          Result := ShaderSaturationRedGreenBlueLines;
        end;
      end;
    end;
    TTurboHsvLinePickerKind.Value:
    begin
      case FPreviewStyle of
        TTurboHsvLinePickerPreviewStyle.RedGreenBlueGradient:
        begin
          Result := ShaderValueRedGreenBlueGradient;
        end;
        TTurboHsvLinePickerPreviewStyle.GreenBlueRedGradient:
        begin
          Result := ShaderValueGreenBlueRedGradient;
        end;
        TTurboHsvLinePickerPreviewStyle.RedGreenBlueLines:
        begin
          Result := ShaderValueRedGreenBlueLines;
        end;
      end;
    end;
    else
      raise ENotImplemented.Create('Bad Kind');
  end;
end;

function TTurboHsvLinePicker.GetPickerValue(): Double;
begin
  case FKind of
    TTurboHsvLinePickerKind.Hue:
    begin
      Result := FHue;
    end;
    TTurboHsvLinePickerKind.Saturation:
    begin
      Result := FSaturation;
    end;
    TTurboHsvLinePickerKind.Value:
    begin
      Result := FValue;
    end;
  end;
end;

procedure TTurboHsvLinePicker.SetPickerValue(Value: Double);
begin
  case FKind of
    TTurboHsvLinePickerKind.Hue:
    begin
      FHue := Value;
    end;
    TTurboHsvLinePickerKind.Saturation:
    begin
      FSaturation := Value;
    end;
    TTurboHsvLinePickerKind.Value:
    begin
      FValue := Value;
    end;
  end;
end;

function TTurboHsvLinePicker.GetPickerThumbPreviewColor(): TColor;
var
  R, G, B: Byte;
begin
  if FColorModulation then
  begin
    Result := GetCurrentColor()
  end else
  begin
    case FKind of
      TTurboHsvLinePickerKind.Hue:
      begin
        HsvToRgb(FHue, 1.0, 1.0, R, G, B);
        Result := RGB(R, G, B);
      end;
      TTurboHsvLinePickerKind.Saturation:
      begin
        Result := clHighlight;
      end;
      TTurboHsvLinePickerKind.Value:
      begin
        Result := clHighlight;
      end;
    end;
  end;
end;

{ TTurboRgbLinePicker }

constructor TTurboRgbLinePicker.Create(Owner: TComponent);
begin
  inherited Create(Owner);

  FRed := 127;
  FGreen := 127;
  FBlue := 127;
  FColorModulation := True;
  FKind := TTurboRgbLinePickerKind.Red;
end;

procedure TTurboRgbLinePicker.GetHsl(out Hue, Saturation, Lightness: Double);
begin
  RgbToHsl(FRed, FGreen, FBlue, Hue, Saturation, Lightness);
end;

procedure TTurboRgbLinePicker.GetHsv(out Hue, Saturation, Value: Double);
begin
  RgbToHsv(FRed, FGreen, FBlue, Hue, Saturation, Value);
end;

procedure TTurboRgbLinePicker.GetRgb(out Red, Green, Blue: Byte);
begin
  Red := FRed;
  Green := FGreen;
  Blue := FBlue;
end;

procedure TTurboRgbLinePicker.SetHsl(Hue, Saturation, Lightness: Double);
var
  R, G, B: Byte;
begin
  HslToRgb(Hue, Saturation, Lightness, R, G, B);

  UpdateRgb(R, G, B);
end;

procedure TTurboRgbLinePicker.SetHsv(Hue, Saturation, Value: Double);
var
  R, G, B: Byte;
begin
  HsvToRgb(Hue, Saturation, Value, R, G, B);

  UpdateRgb(R, G, B);
end;

procedure TTurboRgbLinePicker.SetRgb(Red, Green, Blue: Byte);
begin
  UpdateRgb(Red, Green, Blue);
end;

function TTurboRgbLinePicker.GetCurrentColor(): TColor;
begin
  Result := RGB(FRed, FGreen, FBlue);
end;

procedure TTurboRgbLinePicker.SetBlue(Value: Byte);
begin
  UpdateRgb(FRed, FGreen, Value);
end;

procedure TTurboRgbLinePicker.SetColorModulation(Value: Boolean);
begin
  if FColorModulation = Value then
  begin
    exit;
  end;

  FColorModulation := Value;
  PickerInvalidate(True);
end;

procedure TTurboRgbLinePicker.SetCurrentColor(Value: TColor);
begin
  Value := ColorToRGB(Value);

  UpdateRgb(GetRValue(Value), GetGValue(Value), GetBValue(Value));
end;

procedure TTurboRgbLinePicker.SetGreen(Value: Byte);
begin
  UpdateRgb(FRed, Value, FBlue);
end;

procedure TTurboRgbLinePicker.SetKind(Value: TTurboRgbLinePickerKind);
begin
  if FKind = Value then
  begin
    exit;
  end;

  FKind := Value;

  PickerChange(True);
end;

procedure TTurboRgbLinePicker.SetRed(Value: Byte);
begin
  UpdateRgb(Value, FGreen, FBlue);
end;

procedure TTurboRgbLinePicker.UpdateRgb(Red, Green, Blue: Byte);
var
  NeedUpdate: Boolean;
begin
  if (Red = FRed) and (Green = FGreen) and (Blue = FBlue) then
  begin
    exit;
  end;

  NeedUpdate :=
    ((Red <> FRed) and ((FKind <> TTurboRgbLinePickerKind.Red) and FColorModulation)) or
    ((Green <> FGreen) and ((FKind <> TTurboRgbLinePickerKind.Green) and FColorModulation)) or
    ((Blue <> FBlue) and ((FKind <> TTurboRgbLinePickerKind.Blue) and FColorModulation));

  FRed := Red;
  FGreen := Green;
  FBlue := Blue;

  PickerChange(NeedUpdate);
end;

{$IFOPT R+}{$DEFINE RANGECHECKS_ON}{$ENDIF}
{$IFOPT Q+}{$DEFINE OVERFLOWCHECKS_ON}{$ENDIF}
{$RANGECHECKS OFF}
{$OVERFLOWCHECKS OFF}
function TTurboRgbLinePicker.ShaderRed(Value: Integer): TTurboColor;
begin
  Result := TTurboColor.Create(Value, 0, 0);
end;

function TTurboRgbLinePicker.ShaderModulatedRed(Value: Integer): TTurboColor;
begin
  Result := TTurboColor.Create(Value, FGreen, FBlue);
end;

function TTurboRgbLinePicker.ShaderGreen(Value: Integer): TTurboColor;
begin
  Result := TTurboColor.Create(0, Value, 0);
end;

function TTurboRgbLinePicker.ShaderModulatedGreen(Value: Integer): TTurboColor;
begin
  Result := TTurboColor.Create(FRed, Value, FBlue);
end;

function TTurboRgbLinePicker.ShaderBlue(Value: Integer): TTurboColor;
begin
  Result := TTurboColor.Create(0, 0, Value);
end;

function TTurboRgbLinePicker.ShaderModulatedBlue(Value: Integer): TTurboColor;
begin
  Result := TTurboColor.Create(FRed, FGreen, Value);
end;
{$IFDEF RANGECHECKS_ON}{$RANGECHECKS ON}{$ELSE}{$RANGECHECKS OFF}{$ENDIF}
{$IFDEF OVERFLOWCHECKS_ON}{$OVERFLOWCHECKS ON}{$ELSE}{$OVERFLOWCHECKS OFF}{$ENDIF}

function TTurboRgbLinePicker.GetPickerRangeShader1D(): TTurboLinePickerShader1D;
begin
  case FKind of
    TTurboRgbLinePickerKind.Red:
    begin
      if FColorModulation then
      begin
        Result := ShaderModulatedRed;
      end else
      begin
        Result := ShaderRed;
      end;
    end;
    TTurboRgbLinePickerKind.Green:
    begin
      if FColorModulation then
      begin
        Result := ShaderModulatedGreen;
      end else
      begin
        Result := ShaderGreen;
      end;
    end;
    TTurboRgbLinePickerKind.Blue:
    begin
      if FColorModulation then
      begin
        Result := ShaderModulatedBlue;
      end else
      begin
        Result := ShaderBlue;
      end;
    end;
  end;
end;

function TTurboRgbLinePicker.GetPickerValue(): Integer;
begin
  case FKind of
    TTurboRgbLinePickerKind.Red:
    begin
      Result := FRed;
    end;
    TTurboRgbLinePickerKind.Green:
    begin
      Result := FGreen;
    end;
    TTurboRgbLinePickerKind.Blue:
    begin
      Result := FBlue;
    end;
  end;
end;

procedure TTurboRgbLinePicker.SetPickerValue(Value: Integer);
begin
  case FKind of
    TTurboRgbLinePickerKind.Red:
    begin
      FRed := Value;
    end;
    TTurboRgbLinePickerKind.Green:
    begin
      FGreen := Value;
    end;
    TTurboRgbLinePickerKind.Blue:
    begin
      FBlue := Value;
    end;
  end;
end;

function TTurboRgbLinePicker.GetPickerThumbPreviewColor(): TColor;
begin
  if FColorModulation then
  begin
    Result := GetCurrentColor()
  end else
  begin
    case FKind of
      TTurboRgbLinePickerKind.Red:
      begin
        Result := clRed;
      end;
      TTurboRgbLinePickerKind.Green:
      begin
        Result := clLime;
      end;
      TTurboRgbLinePickerKind.Blue:
      begin
        Result := clBlue;
      end;
    end;
  end;
end;

{ TTurboAlphaLinePicker }

constructor TTurboAlphaLinePicker.Create(Owner: TComponent);
begin
  inherited Create(Owner);

  FAlpha := 255;
  FColorPreview := $007F7F7F;
  FColorModulation := True;
  FPreviewStyle := TTurboAlphaLinePickerPreviewStyle.RedGreenBlueGradient;
end;

procedure TTurboAlphaLinePicker.SetAlpha(Value: Byte);
begin
  Value := EnsureRange(Value, 0, 255);

  if FAlpha = Value then
  begin
    exit;
  end;

  FAlpha := Value;
  PickerChange(FColorModulation);
end;

procedure TTurboAlphaLinePicker.SetColorModulation(Value: Boolean);
begin
  if FColorModulation = Value then
  begin
    exit;
  end;

  FColorModulation := Value;
  PickerInvalidate(True);
end;

procedure TTurboAlphaLinePicker.SetColorPreview(Value: TColor);
begin
  Value := ColorToRGB(Value);

  UpdateRgbPreview(GetRValue(Value), GetGValue(Value), GetBValue(Value));
end;

procedure TTurboAlphaLinePicker.SetPreviewStyle(Value: TTurboAlphaLinePickerPreviewStyle);
begin
  if FPreviewStyle = Value then
  begin
    exit;
  end;

  FPreviewStyle := Value;

  PickerInvalidate(True);
end;

procedure TTurboAlphaLinePicker.UpdateRgbPreview(Red, Green, Blue: Byte);
begin
  if (Red = GetRValue(FColorPreview)) and (Green = GetGValue(FColorPreview)) and (Blue = GetBValue(FColorPreview)) then
  begin
    exit;
  end;

  FColorPreview := RGB(Red, Green, Blue);

  if ColorModulation then
  begin
    PickerRepaint(True);
  end;
end;

{$IFOPT R+}{$DEFINE RANGECHECKS_ON}{$ENDIF}
{$IFOPT Q+}{$DEFINE OVERFLOWCHECKS_ON}{$ENDIF}
{$RANGECHECKS OFF}
{$OVERFLOWCHECKS OFF}
function TTurboAlphaLinePicker.ShaderModulated(Value: Integer): TTurboColor;
begin
  Result := TTurboColor.Create(GetRValue(FColorPreview), GetGValue(FColorPreview), GetBValue(FColorPreview), Value);
end;

function TTurboAlphaLinePicker.ShaderRedGreenBlueLines(ValueX: Integer; ValueY: Double): TTurboColor;
begin
  if ValueY <= 1.0 / 3.0 then
  begin
    Result := TTurboColor.Create(255, 0, 0, ValueX);
  end else
  if ValueY > 2.0 / 3.0 then
  begin
    Result := TTurboColor.Create(0, 0, 255, ValueX);
  end else
  begin
    Result := TTurboColor.Create(0, 255, 0, ValueX);
  end;
end;

function TTurboAlphaLinePicker.ShaderRedGreenBlueGradient(ValueX: Integer; ValueY: Double): TTurboColor;
const
  Angle = 0.0;
  Range = 240.0;
  Scale = 1.0 - 1.0 / 3.0;
  Multiplier = (Range / 360.0) * (1.0 / Scale);
  Adder = (Angle / 360.0) + 0.5 * (Range / 360.0) - 0.5 * Multiplier;
var
  R, G, B: Byte;
begin
  if ValueY < (1.0 - Scale) / 2.0 then
  begin
    HslToRgb(0.0, 1.0, 0.5, R, G, B);
  end else
  if ValueY > (1.0 + Scale) / 2.0 then
  begin
    HslToRgb(240.0 / 360.0, 1.0, 0.5, R, G, B);
  end else
  begin
    HslToRgb(ValueY * Multiplier + Adder, 1.0, 0.5, R, G, B);
  end;
  Result := TTurboColor.Create(R, G, B, ValueX);
end;

function TTurboAlphaLinePicker.ShaderGreenBlueRedGradient(ValueX: Integer; ValueY: Double): TTurboColor;
const
  Angle = 120.0;
  Range = 240.0;
  Scale = 1.0 - 1.0 / 9.0;
  Multiplier = (Range / 360.0) * (1.0 / Scale);
  Adder = (Angle / 360.0) + 0.5 * (Range / 360.0) - 0.5 * Multiplier;
var
  R, G, B: Byte;
begin
  if ValueY < (1.0 - Scale) / 2.0 then
  begin
    HslToRgb(120.0 / 360.0, 1.0, 0.5, R, G, B);
  end else
  if ValueY > (1.0 + Scale) / 2.0 then
  begin
    HslToRgb(360.0 / 360.0, 1.0, 0.5, R, G, B);
  end else
  begin
    HslToRgb(ValueY * Multiplier + Adder, 1.0, 0.5, R, G, B);
  end;

  Result := TTurboColor.Create(R, G, B, ValueX);
end;
{$IFDEF RANGECHECKS_ON}{$RANGECHECKS ON}{$ELSE}{$RANGECHECKS OFF}{$ENDIF}
{$IFDEF OVERFLOWCHECKS_ON}{$OVERFLOWCHECKS ON}{$ELSE}{$OVERFLOWCHECKS OFF}{$ENDIF}

function TTurboAlphaLinePicker.GetPickerRangeShader1D(): TTurboLinePickerShader1D;
begin
  if FColorModulation then
  begin
    Result := ShaderModulated;
  end else
  begin
    Result := nil;
  end;
end;

function TTurboAlphaLinePicker.GetPickerRangeShader2D(): TTurboLinePickerShader2D;
begin
  Result := ShaderGreenBlueRedGradient;
  case FPreviewStyle of
    TTurboAlphaLinePickerPreviewStyle.RedGreenBlueGradient:
    begin
      Result := ShaderRedGreenBlueGradient;
    end;
    TTurboAlphaLinePickerPreviewStyle.GreenBlueRedGradient:
    begin
      Result := ShaderGreenBlueRedGradient;
    end;
    TTurboAlphaLinePickerPreviewStyle.RedGreenBlueLines:
    begin
      Result := ShaderRedGreenBlueLines;
    end;
  end;
end;

function TTurboAlphaLinePicker.GetPickerValue(): Integer;
begin
  Result := FAlpha;
end;

procedure TTurboAlphaLinePicker.SetPickerValue(Value: Integer);
begin
  FAlpha := Value;
end;

procedure TTurboAlphaLinePicker.GetHslPreview(out Hue, Saturation, Lightness: Double);
begin
  RgbToHsl(GetRValue(FColorPreview), GetGValue(FColorPreview), GetBValue(FColorPreview), Hue, Saturation, Lightness);
end;

procedure TTurboAlphaLinePicker.GetHsvPreview(out Hue, Saturation, Value: Double);
begin
  RgbToHsv(GetRValue(FColorPreview), GetGValue(FColorPreview), GetBValue(FColorPreview), Hue, Saturation, Value);
end;

procedure TTurboAlphaLinePicker.GetRgbPreview(out Red, Green, Blue: Byte);
begin
  Red := GetRValue(FColorPreview);
  Green := GetGValue(FColorPreview);
  Blue := GetBValue(FColorPreview);
end;

procedure TTurboAlphaLinePicker.SetHslPreview(Hue, Saturation, Lightness: Double);
var
  R, G, B: Byte;
begin
  HslToRgb(Hue, Saturation, Lightness, R, G, B);

  UpdateRgbPreview(R, G, B);
end;

procedure TTurboAlphaLinePicker.SetHsvPreview(Hue, Saturation, Value: Double);
var
  R, G, B: Byte;
begin
  HsvToRgb(Hue, Saturation, Value, R, G, B);

  UpdateRgbPreview(R, G, B);
end;

procedure TTurboAlphaLinePicker.SetRgbPreview(Red, Green, Blue: Byte);
begin
  UpdateRgbPreview(Red, Green, Blue);
end;

function TTurboAlphaLinePicker.GetPickerThumbPreviewColor(): TColor;
begin
  if FColorModulation then
  begin
    Result := FColorPreview;
  end else
  begin
    Result := clHighlight;
  end;
end;

{ TTurboHslAxisPicker }

constructor TTurboHslAxisPicker.Create(Owner: TComponent);
begin
  inherited Create(Owner);

  FHorizontalKind := TTurboHslAxisPickerKind.Saturation;
  FHue := 0.5;
  FLightness := 0.5;
  FSaturation := 0.5;
  FVerticalKind := TTurboHslAxisPickerKind.Lightness;
end;

procedure TTurboHslAxisPicker.GetHsl(out Hue, Saturation, Lightness: Double);
begin
  Hue := FHue;
  Saturation := FSaturation;
  Lightness := FLightness;
end;

procedure TTurboHslAxisPicker.GetHsv(out Hue, Saturation, Value: Double);
begin
  HslToHsv(FHue, FSaturation, FLightness, Hue, Saturation, Value);
end;

procedure TTurboHslAxisPicker.GetRgb(out Red, Green, Blue: Byte);
begin
  HslToRgb(FHue, FSaturation, FLightness, Red, Green, Blue);
end;

procedure TTurboHslAxisPicker.SetHsl(Hue, Saturation, Lightness: Double);
begin
  UpdateHsl(Hue, Saturation, Lightness);
end;

procedure TTurboHslAxisPicker.SetHsv(Hue, Saturation, Value: Double);
var
  H, S, L: Double;
begin
  HsvToHsl(Hue, Saturation, Value, H, S, L);
  UpdateHsl(H, S, L);
end;

procedure TTurboHslAxisPicker.SetRgb(Red, Green, Blue: Byte);
var
  H, S, L: Double;
begin
  RgbToHsl(Red, Green, Blue, H, S, L);
  UpdateHsl(H, S, L);
end;

procedure TTurboHslAxisPicker.SetHorizontalKind(Value: TTurboHslAxisPickerKind);
begin
  if FHorizontalKind = Value then
  begin
    exit;
  end;

  FHorizontalKind := Value;

  if FVerticalKind = FHorizontalKind then
  begin
    if FVerticalKind = High(FVerticalKind) then
    begin
      FVerticalKind := Low(FVerticalKind);
    end else
    begin
      FVerticalKind := Succ(FVerticalKind);
    end;
  end;

  PickerChange(True);
end;

function TTurboHslAxisPicker.GetCurrentColor(): TColor;
var
  R, G, B: Byte;
begin
  HslToRgb(FHue, FSaturation, FLightness, R, G, B);

  Result := RGB(R, G, B);
end;

function TTurboHslAxisPicker.IsHueStored(): Boolean;
begin
  Result := FHue <> 0.5;
end;

function TTurboHslAxisPicker.IsLightnessStored(): Boolean;
begin
  Result := FLightness <> 0.5;
end;

function TTurboHslAxisPicker.IsSaturationStored(): Boolean;
begin
  Result := FSaturation <> 0.5;
end;

procedure TTurboHslAxisPicker.SetCurrentColor(Value: TColor);
var
  H, S, L: Double;
begin
  Value := ColorToRGB(Value);

  RgbToHsl(GetRValue(Value), GetGValue(Value), GetBValue(Value), H, S, L);

  UpdateHsl(H, S, L);
end;

procedure TTurboHslAxisPicker.SetHue(Value: Double);
begin
  UpdateHsl(Value, FSaturation, FLightness);
end;

procedure TTurboHslAxisPicker.SetLightness(Value: Double);
begin
  UpdateHsl(FHue, FSaturation, Value);
end;

procedure TTurboHslAxisPicker.SetSaturation(Value: Double);
begin
  UpdateHsl(FHue, Value, FLightness);
end;

procedure TTurboHslAxisPicker.SetVerticalKind(Value: TTurboHslAxisPickerKind);
begin
  if FVerticalKind = Value then
  begin
    exit;
  end;

  FVerticalKind := Value;

  if FHorizontalKind = FVerticalKind then
  begin
    if FHorizontalKind = High(FHorizontalKind) then
    begin
      FHorizontalKind := Low(FHorizontalKind);
    end else
    begin
      FHorizontalKind := Succ(FHorizontalKind);
    end;
  end;

  PickerChange(True);
end;

procedure TTurboHslAxisPicker.UpdateHsl(Hue, Saturation, Lightness: Double);
var
  NeedUpdate: Boolean;
begin
  Hue := EnsureRange(Hue, 0.0, 1.0);
  Saturation := EnsureRange(Saturation, 0.0, 1.0);
  Lightness := EnsureRange(Lightness, 0.0, 1.0);

  if (Hue = FHue) and (Saturation = FSaturation) and (Lightness = FLightness) then
  begin
    exit;
  end;

  NeedUpdate :=
    ((Hue <> FHue) and not (TTurboHslAxisPickerKind.Hue in [FHorizontalKind, FVerticalKind])) or
    ((Saturation <> FSaturation) and not (TTurboHslAxisPickerKind.Saturation in [FHorizontalKind, FVerticalKind])) or
    ((Lightness <> FLightness) and not (TTurboHslAxisPickerKind.Lightness in [FHorizontalKind, FVerticalKind]));

  FHue := Hue;
  FSaturation := Saturation;
  FLightness := Lightness;

  PickerChange(NeedUpdate);
end;

{$IFOPT R+}{$DEFINE RANGECHECKS_ON}{$ENDIF}
{$IFOPT Q+}{$DEFINE OVERFLOWCHECKS_ON}{$ENDIF}
{$RANGECHECKS OFF}
{$OVERFLOWCHECKS OFF}
function TTurboHslAxisPicker.ShaderSaturationAndLightness(ValueX, ValueY: Double): TTurboColor;
var
  R, G, B: Byte;
begin
  HslToRgb(FHue, ValueX, ValueY, R, G, B);
  Result := TTurboColor.Create(R, G, B);
end;

function TTurboHslAxisPicker.ShaderLightnessAndSaturation(ValueX, ValueY: Double): TTurboColor;
var
  R, G, B: Byte;
begin
  HslToRgb(FHue, ValueY, ValueX, R, G, B);
  Result := TTurboColor.Create(R, G, B);
end;

function TTurboHslAxisPicker.ShaderSaturationAndHue(ValueX, ValueY: Double): TTurboColor;
var
  R, G, B: Byte;
begin
  HslToRgb(ValueY, ValueX, FLightness, R, G, B);
  Result := TTurboColor.Create(R, G, B);
end;

function TTurboHslAxisPicker.ShaderHueAndSaturation(ValueX, ValueY: Double): TTurboColor;
var
  R, G, B: Byte;
begin
  HslToRgb(ValueX, ValueY, FLightness, R, G, B);
  Result := TTurboColor.Create(R, G, B);
end;

function TTurboHslAxisPicker.ShaderLightnessAndHue(ValueX, ValueY: Double): TTurboColor;
var
  R, G, B: Byte;
begin
  HslToRgb(ValueY, FSaturation, ValueX, R, G, B);
  Result := TTurboColor.Create(R, G, B);
end;

function TTurboHslAxisPicker.ShaderHueAndLightness(ValueX, ValueY: Double): TTurboColor;
var
  R, G, B: Byte;
begin
  HslToRgb(ValueX, FSaturation, ValueY, R, G, B);
  Result := TTurboColor.Create(R, G, B);
end;
{$IFDEF RANGECHECKS_ON}{$RANGECHECKS ON}{$ELSE}{$RANGECHECKS OFF}{$ENDIF}
{$IFDEF OVERFLOWCHECKS_ON}{$OVERFLOWCHECKS ON}{$ELSE}{$OVERFLOWCHECKS OFF}{$ENDIF}

function TTurboHslAxisPicker.GetPickerRangeShader(): TTurboLinePickerFloatShader2D;
begin
  if (FHorizontalKind = TTurboHslAxisPickerKind.Hue) and (FVerticalKind = TTurboHslAxisPickerKind.Saturation) then
  begin
    Result := ShaderHueAndSaturation;
  end else
  if (FHorizontalKind = TTurboHslAxisPickerKind.Hue) and (FVerticalKind = TTurboHslAxisPickerKind.Lightness) then
  begin
    Result := ShaderHueAndLightness;
  end else
  if (FHorizontalKind = TTurboHslAxisPickerKind.Saturation) and (FVerticalKind = TTurboHslAxisPickerKind.Hue) then
  begin
    Result := ShaderSaturationAndHue;
  end else
  if (FHorizontalKind = TTurboHslAxisPickerKind.Saturation) and (FVerticalKind = TTurboHslAxisPickerKind.Lightness) then
  begin
    Result := ShaderSaturationAndLightness;
  end else
  if (FHorizontalKind = TTurboHslAxisPickerKind.Lightness) and (FVerticalKind = TTurboHslAxisPickerKind.Hue) then
  begin
    Result := ShaderLightnessAndHue;
  end else
  if (FHorizontalKind = TTurboHslAxisPickerKind.Lightness) and (FVerticalKind = TTurboHslAxisPickerKind.Saturation) then
  begin
    Result := ShaderLightnessAndSaturation;
  end else
  begin
    raise ENotSupportedException.Create('Bad HorizontalKind and VerticalKind');
  end;
end;

function TTurboHslAxisPicker.GetPickerValue(): TPointF;
begin
  case FHorizontalKind of
    TTurboHslAxisPickerKind.Hue:
    begin
      Result.X := FHue;
    end;
    TTurboHslAxisPickerKind.Saturation:
    begin
      Result.X := FSaturation;
    end;
    TTurboHslAxisPickerKind.Lightness:
    begin
      Result.X := FLightness;
    end;
  end;

  case FVerticalKind of
    TTurboHslAxisPickerKind.Hue:
    begin
      Result.Y := FHue;
    end;
    TTurboHslAxisPickerKind.Saturation:
    begin
      Result.Y := FSaturation;
    end;
    TTurboHslAxisPickerKind.Lightness:
    begin
      Result.Y := FLightness;
    end;
  end;
end;

procedure TTurboHslAxisPicker.SetPickerValue(Value: TPointF);
begin
  case FHorizontalKind of
    TTurboHslAxisPickerKind.Hue:
    begin
      FHue := Value.X;
    end;
    TTurboHslAxisPickerKind.Saturation:
    begin
      FSaturation := Value.X;
    end;
    TTurboHslAxisPickerKind.Lightness:
    begin
      FLightness := Value.X;
    end;
  end;

  case FVerticalKind of
    TTurboHslAxisPickerKind.Hue:
    begin
      FHue := Value.Y;
    end;
    TTurboHslAxisPickerKind.Saturation:
    begin
      FSaturation := Value.Y;
    end;
    TTurboHslAxisPickerKind.Lightness:
    begin
      FLightness := Value.Y;
    end;
  end;
end;

function TTurboHslAxisPicker.GetPickerThumbPreviewColor(): TColor;
begin
  Result := GetCurrentColor();
end;

{ TTurboHsvAxisPicker }

constructor TTurboHsvAxisPicker.Create(Owner: TComponent);
begin
  inherited Create(Owner);

  FHorizontalKind := TTurboHsvAxisPickerKind.Saturation;
  FHue := 0.5;
  FValue := 0.5;
  FSaturation := 0.5;
  FVerticalKind := TTurboHsvAxisPickerKind.Value;
end;

function TTurboHsvAxisPicker.GetCurrentColor(): TColor;
var
  R, G, B: Byte;
begin
  HsvToRgb(FHue, FSaturation, FValue, R, G, B);

  Result := RGB(R, G, B);
end;

function TTurboHsvAxisPicker.IsHueStored(): Boolean;
begin
  Result := FHue <> 0.5;
end;

function TTurboHsvAxisPicker.IsValueStored(): Boolean;
begin
  Result := FValue <> 0.5;
end;

function TTurboHsvAxisPicker.IsSaturationStored(): Boolean;
begin
  Result := FSaturation <> 0.5;
end;

{$IFOPT R+}{$DEFINE RANGECHECKS_ON}{$ENDIF}
{$IFOPT Q+}{$DEFINE OVERFLOWCHECKS_ON}{$ENDIF}
{$RANGECHECKS OFF}
{$OVERFLOWCHECKS OFF}
function TTurboHsvAxisPicker.ShaderHueAndValue(ValueX, ValueY: Double): TTurboColor;
var
  R, G, B: Byte;
begin
  HsvToRgb(ValueX, FSaturation, ValueY, R, G, B);
  Result := TTurboColor.Create(R, G, B);
end;

function TTurboHsvAxisPicker.ShaderHueAndSaturation(ValueX, ValueY: Double): TTurboColor;
var
  R, G, B: Byte;
begin
  HsvToRgb(ValueX, ValueY, FValue, R, G, B);
  Result := TTurboColor.Create(R, G, B);
end;

function TTurboHsvAxisPicker.ShaderValueAndHue(ValueX, ValueY: Double): TTurboColor;
var
  R, G, B: Byte;
begin
  HsvToRgb(ValueY, FSaturation, ValueX, R, G, B);
  Result := TTurboColor.Create(R, G, B);
end;

function TTurboHsvAxisPicker.ShaderValueAndSaturation(ValueX, ValueY: Double): TTurboColor;
var
  R, G, B: Byte;
begin
  HsvToRgb(FHue, ValueY, ValueX, R, G, B);
  Result := TTurboColor.Create(R, G, B);
end;

function TTurboHsvAxisPicker.ShaderSaturationAndHue(ValueX, ValueY: Double): TTurboColor;
var
  R, G, B: Byte;
begin
  HsvToRgb(ValueY, ValueX, FValue, R, G, B);
  Result := TTurboColor.Create(R, G, B);
end;

function TTurboHsvAxisPicker.ShaderSaturationAndValue(ValueX, ValueY: Double): TTurboColor;
var
  R, G, B: Byte;
begin
  HsvToRgb(FHue, ValueX, ValueY, R, G, B);
  Result := TTurboColor.Create(R, G, B);
end;
{$IFDEF RANGECHECKS_ON}{$RANGECHECKS ON}{$ELSE}{$RANGECHECKS OFF}{$ENDIF}
{$IFDEF OVERFLOWCHECKS_ON}{$OVERFLOWCHECKS ON}{$ELSE}{$OVERFLOWCHECKS OFF}{$ENDIF}

procedure TTurboHsvAxisPicker.SetCurrentColor(Value: TColor);
var
  H, S, V: Double;
begin
  Value := ColorToRGB(Value);

  RgbToHsv(GetRValue(Value), GetGValue(Value), GetBValue(Value), H, S, V);

  UpdateHsv(H, S, V);
end;

procedure TTurboHsvAxisPicker.SetHorizontalKind(Value: TTurboHsvAxisPickerKind);
begin
  if FHorizontalKind = Value then
  begin
    exit;
  end;

  FHorizontalKind := Value;

  if FVerticalKind = FHorizontalKind then
  begin
    if FVerticalKind = High(FVerticalKind) then
    begin
      FVerticalKind := Low(FVerticalKind);
    end else
    begin
      FVerticalKind := Succ(FVerticalKind);
    end;
  end;

  PickerChange(True);
end;

procedure TTurboHsvAxisPicker.SetHue(Value: Double);
begin
  UpdateHsv(Value, FSaturation, FValue);
end;

procedure TTurboHsvAxisPicker.SetValue(Value: Double);
begin
  UpdateHsv(FHue, FSaturation, Value);
end;

procedure TTurboHsvAxisPicker.SetSaturation(Value: Double);
begin
  UpdateHsv(FHue, Value, FValue);
end;

procedure TTurboHsvAxisPicker.SetVerticalKind(Value: TTurboHsvAxisPickerKind);
begin
  if FVerticalKind = Value then
  begin
    exit;
  end;

  FVerticalKind := Value;

  if FHorizontalKind = FVerticalKind then
  begin
    if FHorizontalKind = High(FHorizontalKind) then
    begin
      FHorizontalKind := Low(FHorizontalKind);
    end else
    begin
      FHorizontalKind := Succ(FHorizontalKind);
    end;
  end;

  PickerChange(True);
end;

procedure TTurboHsvAxisPicker.UpdateHsv(Hue, Saturation, Value: Double);
var
  NeedUpdate: Boolean;
begin
  Hue := EnsureRange(Hue, 0.0, 1.0);
  Saturation := EnsureRange(Saturation, 0.0, 1.0);
  Value := EnsureRange(Value, 0.0, 1.0);

  if (Hue = FHue) and (Saturation = FSaturation) and (Value = FValue) then
  begin
    exit;
  end;

  NeedUpdate :=
    ((Hue <> FHue) and not (TTurboHsvAxisPickerKind.Hue in [FHorizontalKind, FVerticalKind])) or
    ((Saturation <> FSaturation) and not (TTurboHsvAxisPickerKind.Saturation in [FHorizontalKind, FVerticalKind])) or
    ((Value <> FValue) and not (TTurboHsvAxisPickerKind.Value in [FHorizontalKind, FVerticalKind]));

  FHue := Hue;
  FSaturation := Saturation;
  FValue := Value;

  PickerChange(NeedUpdate);
end;

function TTurboHsvAxisPicker.GetPickerRangeShader(): TTurboLinePickerFloatShader2D;
begin
  if (FHorizontalKind = TTurboHsvAxisPickerKind.Hue) and (FVerticalKind = TTurboHsvAxisPickerKind.Saturation) then
  begin
    Result := ShaderHueAndSaturation;
  end else
  if (FHorizontalKind = TTurboHsvAxisPickerKind.Hue) and (FVerticalKind = TTurboHsvAxisPickerKind.Value) then
  begin
    Result := ShaderHueAndValue;
  end else
  if (FHorizontalKind = TTurboHsvAxisPickerKind.Saturation) and (FVerticalKind = TTurboHsvAxisPickerKind.Hue) then
  begin
    Result := ShaderSaturationAndHue;
  end else
  if (FHorizontalKind = TTurboHsvAxisPickerKind.Saturation) and (FVerticalKind = TTurboHsvAxisPickerKind.Value) then
  begin
    Result := ShaderSaturationAndValue;
  end else
  if (FHorizontalKind = TTurboHsvAxisPickerKind.Value) and (FVerticalKind = TTurboHsvAxisPickerKind.Hue) then
  begin
    Result := ShaderValueAndHue;
  end else
  if (FHorizontalKind = TTurboHsvAxisPickerKind.Value) and (FVerticalKind = TTurboHsvAxisPickerKind.Saturation) then
  begin
    Result := ShaderValueAndSaturation;
  end else
  begin
    raise ENotSupportedException.Create('Bad HorizontalKind and VerticalKind');
  end;
end;

function TTurboHsvAxisPicker.GetPickerValue(): TPointF;
begin
  case FHorizontalKind of
    TTurboHsvAxisPickerKind.Hue:
    begin
      Result.X := FHue;
    end;
    TTurboHsvAxisPickerKind.Saturation:
    begin
      Result.X := FSaturation;
    end;
    TTurboHsvAxisPickerKind.Value:
    begin
      Result.X := FValue;
    end;
  end;

  case FVerticalKind of
    TTurboHsvAxisPickerKind.Hue:
    begin
      Result.Y := FHue;
    end;
    TTurboHsvAxisPickerKind.Saturation:
    begin
      Result.Y := FSaturation;
    end;
    TTurboHsvAxisPickerKind.Value:
    begin
      Result.Y := FValue;
    end;
  end;
end;

procedure TTurboHsvAxisPicker.SetPickerValue(Value: TPointF);
begin
  case FHorizontalKind of
    TTurboHsvAxisPickerKind.Hue:
    begin
      FHue := Value.X;
    end;
    TTurboHsvAxisPickerKind.Saturation:
    begin
      FSaturation := Value.X;
    end;
    TTurboHsvAxisPickerKind.Value:
    begin
      FValue := Value.X;
    end;
  end;

  case FVerticalKind of
    TTurboHsvAxisPickerKind.Hue:
    begin
      FHue := Value.Y;
    end;
    TTurboHsvAxisPickerKind.Saturation:
    begin
      FSaturation := Value.Y;
    end;
    TTurboHsvAxisPickerKind.Value:
    begin
      FValue := Value.Y;
    end;
  end;
end;

function TTurboHsvAxisPicker.GetPickerThumbPreviewColor(): TColor;
begin
  Result := GetCurrentColor();
end;

procedure TTurboHsvAxisPicker.GetHsl(out Hue, Saturation, Lightness: Double);
begin
  HsvToHsl(FHue, FSaturation, FValue, Hue, Saturation, Lightness);
end;

procedure TTurboHsvAxisPicker.GetHsv(out Hue, Saturation, Value: Double);
begin
  Hue := FHue;
  Saturation := FSaturation;
  Value := FValue;
end;

procedure TTurboHsvAxisPicker.GetRgb(out Red, Green, Blue: Byte);
begin
  HsvToRgb(FHue, FSaturation, FValue, Red, Green, Blue);
end;

procedure TTurboHsvAxisPicker.SetHsl(Hue, Saturation, Lightness: Double);
var
  H, S, V: Double;
begin
  HslToHsv(Hue, Saturation, Lightness, H, S, V);
  UpdateHsv(H, S, V);
end;

procedure TTurboHsvAxisPicker.SetHsv(Hue, Saturation, Value: Double);
begin
  UpdateHsv(Hue, Saturation, Value);
end;

procedure TTurboHsvAxisPicker.SetRgb(Red, Green, Blue: Byte);
var
  H, S, V: Double;
begin
  RgbToHsv(Red, Green, Blue, H, S, V);
  UpdateHsv(H, S, V);
end;

{ TTurboRgbAxisPicker }

constructor TTurboRgbAxisPicker.Create(Owner: TComponent);
begin
  inherited Create(Owner);

  FRed := 127;
  FGreen := 127;
  FBlue := 127;

  FHorizontalKind := TTurboRgbAxisPickerKind.Red;
  FVerticalKind := TTurboRgbAxisPickerKind.Green;
end;

procedure TTurboRgbAxisPicker.GetHsl(out Hue, Saturation, Lightness: Double);
begin
  RgbToHsl(FRed, FGreen, FBlue, Hue, Saturation, Lightness);
end;

procedure TTurboRgbAxisPicker.GetHsv(out Hue, Saturation, Value: Double);
begin
  RgbToHsv(FRed, FGreen, FBlue, Hue, Saturation, Value);
end;

procedure TTurboRgbAxisPicker.GetRgb(out Red, Green, Blue: Byte);
begin
  Red := FRed;
  Green := FGreen;
  Blue := FBlue;
end;

procedure TTurboRgbAxisPicker.UpdateRgb(Red, Green, Blue: Byte);
var
  NeedUpdate: Boolean;
begin
  if (Red = FRed) and (Green = FGreen) and (Blue = FBlue) then
  begin
    exit;
  end;

  NeedUpdate :=
    ((Red <> FRed) and not (TTurboRgbAxisPickerKind.Red in [FHorizontalKind, FVerticalKind])) or
    ((Green <> FGreen) and not (TTurboRgbAxisPickerKind.Green in [FHorizontalKind, FVerticalKind])) or
    ((Blue <> FBlue) and not (TTurboRgbAxisPickerKind.Blue in [FHorizontalKind, FVerticalKind]));

  FRed := Red;
  FGreen := Green;
  FBlue := Blue;

  PickerChange(NeedUpdate);
end;

procedure TTurboRgbAxisPicker.SetHsl(Hue, Saturation, Lightness: Double);
var
  R, G, B: Byte;
begin
  HslToRgb(Hue, Saturation, Lightness, R, G, B);

  UpdateRgb(R, G, B);
end;

procedure TTurboRgbAxisPicker.SetHsv(Hue, Saturation, Value: Double);
var
  R, G, B: Byte;
begin
  HsvToRgb(Hue, Saturation, Value, R, G, B);

  UpdateRgb(R, G, B);
end;

procedure TTurboRgbAxisPicker.SetRgb(Red, Green, Blue: Byte);
begin
  UpdateRgb(Red, Green, Blue);
end;

function TTurboRgbAxisPicker.GetCurrentColor(): TColor;
begin
  Result := RGB(FRed, FGreen, FBlue);
end;

{$IFOPT R+}{$DEFINE RANGECHECKS_ON}{$ENDIF}
{$IFOPT Q+}{$DEFINE OVERFLOWCHECKS_ON}{$ENDIF}
{$RANGECHECKS OFF}
{$OVERFLOWCHECKS OFF}
function TTurboRgbAxisPicker.ShaderRedAndGreen(ValueX, ValueY: Integer): TTurboColor;
begin
  Result := TTurboColor.Create(ValueX, ValueY, FBlue);
end;

function TTurboRgbAxisPicker.ShaderRedAndBlue(ValueX, ValueY: Integer): TTurboColor;
begin
  Result := TTurboColor.Create(ValueX, FGreen, ValueY);
end;

function TTurboRgbAxisPicker.ShaderGreenAndRed(ValueX, ValueY: Integer): TTurboColor;
begin
  Result := TTurboColor.Create(ValueY, ValueX, FBlue);
end;

function TTurboRgbAxisPicker.ShaderGreenAndBlue(ValueX, ValueY: Integer): TTurboColor;
begin
  Result := TTurboColor.Create(FRed, ValueX, ValueY);
end;

function TTurboRgbAxisPicker.ShaderBlueAndRed(ValueX, ValueY: Integer): TTurboColor;
begin
  Result := TTurboColor.Create(ValueY, FGreen, ValueX);
end;

function TTurboRgbAxisPicker.ShaderBlueAndGreen(ValueX, ValueY: Integer): TTurboColor;
begin
  Result := TTurboColor.Create(FRed, ValueY, ValueX);
end;
{$IFDEF RANGECHECKS_ON}{$RANGECHECKS ON}{$ELSE}{$RANGECHECKS OFF}{$ENDIF}
{$IFDEF OVERFLOWCHECKS_ON}{$OVERFLOWCHECKS ON}{$ELSE}{$OVERFLOWCHECKS OFF}{$ENDIF}

procedure TTurboRgbAxisPicker.SetCurrentColor(Value: TColor);
begin
  Value := ColorToRGB(Value);

  UpdateRgb(GetRValue(Value), GetGValue(Value), GetBValue(Value));
end;

procedure TTurboRgbAxisPicker.SetHorizontalKind(Value: TTurboRgbAxisPickerKind);
begin
  if FHorizontalKind = Value then
  begin
    exit;
  end;

  FHorizontalKind := Value;

  if FVerticalKind = FHorizontalKind then
  begin
    if FVerticalKind = High(FVerticalKind) then
    begin
      FVerticalKind := Low(FVerticalKind);
    end else
    begin
      FVerticalKind := Succ(FVerticalKind);
    end;
  end;

  PickerChange(True);
end;

procedure TTurboRgbAxisPicker.SetRed(Value: Byte);
begin
  Value := EnsureRange(Value, 0, 255);

  UpdateRgb(Value, FGreen, FBlue);
end;

procedure TTurboRgbAxisPicker.SetGreen(Value: Byte);
begin
  Value := EnsureRange(Value, 0, 255);

  UpdateRgb(FRed, Value, FBlue);
end;

procedure TTurboRgbAxisPicker.SetBlue(Value: Byte);
begin
  Value := EnsureRange(Value, 0, 255);

  UpdateRgb(FRed, FGreen, Value);
end;

procedure TTurboRgbAxisPicker.SetVerticalKind(Value: TTurboRgbAxisPickerKind);
begin
  if FVerticalKind = Value then
  begin
    exit;
  end;

  FVerticalKind := Value;

  if FHorizontalKind = FVerticalKind then
  begin
    if FHorizontalKind = High(FHorizontalKind) then
    begin
      FHorizontalKind := Low(FHorizontalKind);
    end else
    begin
      FHorizontalKind := Succ(FHorizontalKind);
    end;
  end;

  PickerChange(True);
end;

function TTurboRgbAxisPicker.GetPickerRangeShader(): TTurboAxisPickerShader;
begin
  if (FHorizontalKind = TTurboRgbAxisPickerKind.Red) and (FVerticalKind = TTurboRgbAxisPickerKind.Green) then
  begin
    Result := ShaderRedAndGreen;
  end else
  if (FHorizontalKind = TTurboRgbAxisPickerKind.Red) and (FVerticalKind = TTurboRgbAxisPickerKind.Blue) then
  begin
    Result := ShaderRedAndBlue;
  end else
  if (FHorizontalKind = TTurboRgbAxisPickerKind.Green) and (FVerticalKind = TTurboRgbAxisPickerKind.Red) then
  begin
    Result := ShaderGreenAndRed;
  end else
  if (FHorizontalKind = TTurboRgbAxisPickerKind.Green) and (FVerticalKind = TTurboRgbAxisPickerKind.Blue) then
  begin
    Result := ShaderGreenAndBlue;
  end else
  if (FHorizontalKind = TTurboRgbAxisPickerKind.Blue) and (FVerticalKind = TTurboRgbAxisPickerKind.Red) then
  begin
    Result := ShaderBlueAndRed;
  end else
  if (FHorizontalKind = TTurboRgbAxisPickerKind.Blue) and (FVerticalKind = TTurboRgbAxisPickerKind.Green) then
  begin
    Result := ShaderBlueAndGreen;
  end else
  begin
    raise ENotSupportedException.Create('Bad HorizontalKind and VerticalKind');
  end;
end;

function TTurboRgbAxisPicker.GetPickerValue(): TPoint;
begin
  case FHorizontalKind of
    TTurboRgbAxisPickerKind.Red:
    begin
      Result.X := FRed;
    end;
    TTurboRgbAxisPickerKind.Green:
    begin
      Result.X := FGreen;
    end;
    TTurboRgbAxisPickerKind.Blue:
    begin
      Result.X := FBlue;
    end;
  end;

  case FVerticalKind of
    TTurboRgbAxisPickerKind.Red:
    begin
      Result.Y := FRed;
    end;
    TTurboRgbAxisPickerKind.Green:
    begin
      Result.Y := FGreen;
    end;
    TTurboRgbAxisPickerKind.Blue:
    begin
      Result.Y := FBlue;
    end;
  end;
end;

procedure TTurboRgbAxisPicker.SetPickerValue(Value: TPoint);
begin
  case FHorizontalKind of
    TTurboRgbAxisPickerKind.Red:
    begin
      FRed := Value.X;
    end;
    TTurboRgbAxisPickerKind.Green:
    begin
      FGreen := Value.X;
    end;
    TTurboRgbAxisPickerKind.Blue:
    begin
      FBlue := Value.X;
    end;
  end;

  case FVerticalKind of
    TTurboRgbAxisPickerKind.Red:
    begin
      FRed := Value.Y;
    end;
    TTurboRgbAxisPickerKind.Green:
    begin
      FGreen := Value.Y;
    end;
    TTurboRgbAxisPickerKind.Blue:
    begin
      FBlue := Value.Y;
    end;
  end;
end;

function TTurboRgbAxisPicker.GetPickerThumbPreviewColor(): TColor;
begin
  Result := GetCurrentColor();
end;

{ TTurboColorCell }

constructor TTurboColorCell.Create(Owner: TComponent);
begin
  inherited Create(Owner);

  FBackground := TTurboTransparentBackground.Create();
  FBackground.OnChange := BackgroundChange;

  FAlphaPreview := 255;
  FValue := $007F7F7F;
  FForceRepaint := True;
end;

destructor TTurboColorCell.Destroy();
begin
  FBackground.Free();

  inherited Destroy();
end;

procedure TTurboColorCell.GetHsl(out Hue, Saturation, Lightness: Double);
begin
  RgbToHsl(GetRValue(FValue), GetGValue(FValue), GetBValue(FValue), Hue, Saturation, Lightness);
end;

procedure TTurboColorCell.GetHsv(out Hue, Saturation, Value: Double);
begin
  RgbToHsv(GetRValue(FValue), GetGValue(FValue), GetBValue(FValue), Hue, Saturation, Value);
end;

procedure TTurboColorCell.GetRgb(out Red, Green, Blue: Byte);
begin
  Red := GetRValue(FValue);
  Green := GetGValue(FValue);
  Blue := GetBValue(FValue);
end;

procedure TTurboColorCell.SetHsl(Hue, Saturation, Lightness: Double);
var
  R, G, B: Byte;
begin
  HslToRgb(Hue, Saturation, Lightness, R, G, B);
  FValue := RGB(R, G, B);

  if FForceRepaint then
  begin
    Repaint();
  end else
  begin
    Invalidate();
  end;
end;

procedure TTurboColorCell.SetHsv(Hue, Saturation, Value: Double);
var
  R, G, B: Byte;
begin
  HsvToRgb(Hue, Saturation, Value, R, G, B);
  FValue := RGB(R, G, B);

  if FForceRepaint then
  begin
    Repaint();
  end else
  begin
    Invalidate();
  end;
end;

procedure TTurboColorCell.SetRgb(Red, Green, Blue: Byte);
begin
  FValue := RGB(Red, Green, Blue);

  if FForceRepaint then
  begin
    Repaint();
  end else
  begin
    Invalidate();
  end;
end;

procedure TTurboColorCell.SetAlphaPreview(Value: Byte);
begin
  if FAlphaPreview = Value then
  begin
    exit;
  end;

  FAlphaPreview := Value;

  if FForceRepaint then
  begin
    Repaint();
  end else
  begin
    Invalidate();
  end;
end;

procedure TTurboColorCell.BackgroundChange(Sender: TObject);
begin
  Invalidate();
end;

procedure TTurboColorCell.SetBackground(Value: TTurboTransparentBackground);
begin
  FBackground.Assign(Value);
end;

procedure TTurboColorCell.SetValue(Value: TColor);
begin
  if FValue = Value then
  begin
    exit;
  end;

  FValue := Value;

  if FForceRepaint then
  begin
    Repaint();
  end else
  begin
    Invalidate();
  end;
end;

procedure TTurboColorCell.DrawCell(const CellRect: TRect);
begin
  DrawColorPreviewRect(
    Canvas,
    CellRect,
    FValue,
    FAlphaPreview,
    FBackground.Kind,
    FBackground.CellSize,
    FBackground.Color1,
    FBackground.Color2
  );
end;

end.

