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

unit TurboControls;

{$MODE DELPHIUNICODE}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$OVERFLOWCHECKS ON}
{$OPTIMIZATION ON}
{$SCOPEDENUMS ON}

interface

uses
  Classes, Math, SysUtils, Graphics, Controls, TurboExternalGraphics;

type

  { TTurboChangeEvent }

  TTurboChangeEvent = procedure(Sender: TObject; IsUserInput: Boolean) of object;

  { TTurboSide }

  TTurboSide = (Left, Top, Right, Bottom);

  { TTurboSides }

  TTurboSides = set of TTurboSide;

  { TTurboPadding }

  TTurboPadding = class(TPersistent)
  private
    FLeft: Integer;
    FTop: Integer;
    FRight: Integer;
    FBottom: Integer;
    FDefaultLeft: Integer;
    FDefaultTop: Integer;
    FDefaultRight: Integer;
    FDefaultBottom: Integer;
    FAuto: TTurboSides;
    FDefaultAuto: TTurboSides;
    FOnChange: TNotifyEvent;
    procedure SetLeft(Value: Integer);
    procedure SetTop(Value: Integer);
    procedure SetRight(Value: Integer);
    procedure SetBottom(Value: Integer);
    procedure SetAuto(Value: TTurboSides);
    function IsLeftStored(): Boolean;
    function IsTopStored(): Boolean;
    function IsRightStored(): Boolean;
    function IsBottomStored(): Boolean;
    function IsAutoStored(): Boolean;
    procedure Change();
  protected
    property Auto: TTurboSides read FAuto write SetAuto stored IsAutoStored;
  public
    constructor Create(DefaultLeft, DefaultTop, DefaultRight, DefaultBottom: Integer); overload;
    constructor Create(); overload;
    procedure AssignTo(Dest: TPersistent); override;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  published
    property Left: Integer read FLeft write SetLeft stored IsLeftStored;
    property Top: Integer read FTop write SetTop stored IsTopStored;
    property Right: Integer read FRight write SetRight stored IsRightStored;
    property Bottom: Integer read FBottom write SetBottom stored IsBottomStored;
  end;

  { TTurboAutoPadding }

  TTurboAutoPadding = class(TTurboPadding)
  private
    function GetIsAutoLeft(): Boolean;
    function GetIsAutoTop(): Boolean;
    function GetIsAutoRight(): Boolean;
    function GetIsAutoBottom(): Boolean;
  public
    constructor Create(DefaultLeft, DefaultTop, DefaultRight, DefaultBottom: Integer; DefaultAutoSides: TTurboSides); overload;
    constructor Create(); overload;
    property IsAutoLeft: Boolean read GetIsAutoLeft;
    property IsAutoTop: Boolean read GetIsAutoTop;
    property IsAutoRight: Boolean read GetIsAutoRight;
    property IsAutoBottom: Boolean read GetIsAutoBottom;
  published
    property Auto;
  end;

  { TTurboDimension }

  TTurboDimension = (Width, Height);

  { TTurboDimensions }

  TTurboDimensions = set of TTurboDimension;

  { TTurboSize }

  TTurboSize = class(TPersistent)
  private
    FWidth: Integer;
    FHeight: Integer;
    FDefaultWidth: Integer;
    FDefaultHeight: Integer;
    FAuto: TTurboDimensions;
    FDefaultAuto: TTurboDimensions;
    FOnChange: TNotifyEvent;
    function IsAutoStored(): Boolean;
    procedure SetAuto(Value: TTurboDimensions);
    procedure SetHeight(Value: Integer);
    procedure SetWidth(Value: Integer);
    function IsWidthStored(): Boolean;
    function IsHeightStored(): Boolean;
    procedure Change();
  protected
    property Auto: TTurboDimensions read FAuto write SetAuto stored IsAutoStored;
  public
    constructor Create(DefaultWidth, DefaultHeight: Integer); overload;
    constructor Create(); overload;
    procedure AssignTo(Dest: TPersistent); override;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  published
    property Width: Integer read FWidth write SetWidth stored IsWidthStored;
    property Height: Integer read FHeight write SetHeight stored IsHeightStored;
  end;

  { TTurboAutoSize }

  TTurboAutoSize = class(TTurboSize)
  private
    function GetIsAutoWidth(): Boolean;
    function GetIsAutoHeight(): Boolean;
  public
    constructor Create(DefaultWidth, DefaultHeight: Integer; DefaultAuto: TTurboDimensions); overload;
    constructor Create(); overload;
    property IsAutoWidth: Boolean read GetIsAutoWidth;
    property IsAutoHeight: Boolean read GetIsAutoHeight;
  published
    property Auto;
  end;

  { TTurboLength }

  TTurboLength = class(TPersistent)
  private
    FAuto: Boolean;
    FSize: Integer;
    FDefaultAuto: Boolean;
    FDefaultSize: Integer;
    FOnChange: TNotifyEvent;
    function IsAutoStored(): Boolean;
    function IsSizeStored(): Boolean;
    procedure SetAuto(Value: Boolean);
    procedure SetSize(Value: Integer);
    procedure Change();
  protected
    property Auto: Boolean read FAuto write SetAuto stored IsAutoStored;
  public
    constructor Create(DefaultSize: Integer); overload;
    constructor Create(); overload;
    procedure AssignTo(Dest: TPersistent); override;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  published
    property Size: Integer read FSize write SetSize stored IsSizeStored;
  end;

  { TTurboAutoLength }

  TTurboAutoLength = class(TTurboLength)
  private
    function GetIsAuto(): Boolean;
  public
    constructor Create(DefaultSize: Integer; DefaultAuto: Boolean); overload;
    constructor Create(); overload;
    property IsAuto: Boolean read GetIsAuto;
  published
    property Auto;
  end;

  { TTurboRange }

  TTurboRange = record
  private
    FMax: Integer;
    FMin: Integer;
    function GetLength(): Integer; inline;
    procedure SetMax(Value: Integer); inline;
    procedure SetMin(Value: Integer); inline;
  public
    constructor Create(Min, Max: Integer);
    function Ensure(Value: Integer): Integer; inline;
    property Min: Integer read FMin write SetMin;
    property Max: Integer read FMax write SetMax;
    property Length: Integer read GetLength;
  end;

  { TTurboFloatRange }

  TTurboFloatRange = record
  private
    FMax: Double;
    FMin: Double;
    function GetLength(): Double; inline;
    procedure SetMax(Value: Double); inline;
    procedure SetMin(Value: Double); inline;
  public
    constructor Create(Min, Max: Double);
    function Ensure(Value: Double): Double; inline;
    property Min: Double read FMin write SetMin;
    property Max: Double read FMax write SetMax;
    property Length: Double read GetLength;
  end;

  { TTurboCustomControl }

  TTurboCustomControl = class(TCustomControl)
  private
    procedure UpdateOpaque();
  protected
    property ParentBackground default True;
    procedure SetParentBackground(const ParentBackground: Boolean); override;
    function IsAllowFocus(): Boolean; virtual;
  public
    constructor Create(Owner: TComponent); override;
    function CanFocus(): Boolean; override;
    procedure TrySetFocus();
  end;

  { TTurboTransparentBackground }

  TTurboTransparentBackground = class(TPersistent)
  private
    FCellSize: Integer;
    FColor1: TColor;
    FColor2: TColor;
    FKind: TTurboTransparentBackgroundKind;
    FOnChange: TNotifyEvent;
    procedure SetCellSize(Value: Integer);
    procedure SetColor1(Value: TColor);
    procedure SetColor2(Value: TColor);
    procedure SetKind(Value: TTurboTransparentBackgroundKind);
    procedure Change();
  public
    constructor Create();
    procedure AssignTo(Dest: TPersistent); override;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  published
    property CellSize: Integer read FCellSize write SetCellSize default 4;
    property Color1: TColor read FColor1 write SetColor1 default clGray;
    property Color2: TColor read FColor2 write SetColor2 default clLtGray;
    property Kind: TTurboTransparentBackgroundKind read FKind write SetKind default TTurboTransparentBackgroundKind.Chess;
  end;

  { TTurboSelectionFrame }

  TTurboSelectionFrame = class(TPersistent)
  private
    FColor1: TColor;
    FColor2: TColor;
    FHotOpacity: Byte;
    FOnChange: TNotifyEvent;
    FOpacity: Byte;
    FPressedOpacity: Byte;
    procedure SetColor1(Value: TColor);
    procedure SetColor2(Value: TColor);
    procedure SetHotOpacity(Value: Byte);
    procedure SetOpacity(Value: Byte);
    procedure SetPressedOpacity(Value: Byte);
    procedure Change();
  public
    constructor Create();
    procedure AssignTo(Dest: TPersistent); override;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  published
    property Color1: TColor read FColor1 write SetColor1 default clWhite;
    property Color2: TColor read FColor2 write SetColor2 default clBlack;
    property HotOpacity: Byte read FHotOpacity write SetHotOpacity default 127;
    property Opacity: Byte read FOpacity write SetOpacity default 255;
    property PressedOpacity: Byte read FPressedOpacity write SetPressedOpacity default 200;
  end;

implementation

{ TTurboPadding }

constructor TTurboPadding.Create(DefaultLeft, DefaultTop, DefaultRight, DefaultBottom: Integer);
begin
  inherited Create();

  FDefaultLeft := DefaultLeft;
  FDefaultTop := DefaultTop;
  FDefaultRight := DefaultRight;
  FDefaultBottom := DefaultBottom;

  FLeft := FDefaultLeft;
  FTop := FDefaultTop;
  FRight := FDefaultRight;
  FBottom := FDefaultBottom;
end;

constructor TTurboPadding.Create();
begin
  Create(0, 0, 0, 0);
end;

procedure TTurboPadding.SetLeft(Value: Integer);
begin
  if Value < 0 then
  begin
    Value := 0;
  end;

  if Value = FLeft then
  begin
    exit;
  end;

  FLeft := Value;

  Change();
end;

procedure TTurboPadding.SetTop(Value: Integer);
begin
  if Value < 0 then
  begin
    Value := 0;
  end;

  if Value = FTop then
  begin
    exit;
  end;

  FTop := Value;

  Change();
end;

procedure TTurboPadding.SetRight(Value: Integer);
begin
  if Value < 0 then
  begin
    Value := 0;
  end;

  if Value = FRight then
  begin
    exit;
  end;

  FRight := Value;

  Change();
end;

procedure TTurboPadding.SetBottom(Value: Integer);
begin
  if Value < 0 then
  begin
    Value := 0;
  end;

  if Value = FBottom then
  begin
    exit;
  end;

  FBottom := Value;

  Change();
end;

procedure TTurboPadding.SetAuto(Value: TTurboSides);
begin
  if Value = FAuto then
  begin
    exit;
  end;

  FAuto := Value;

  Change();
end;

function TTurboPadding.IsLeftStored(): Boolean;
begin
  Result := ((FDefaultLeft <> FLeft) and not (Self is TTurboAutoPadding)) or not (TTurboSide.Left in FAuto);
end;

function TTurboPadding.IsTopStored(): Boolean;
begin
  Result := ((FDefaultTop <> FTop) and not (Self is TTurboAutoPadding)) or not (TTurboSide.Top in FAuto);
end;

function TTurboPadding.IsRightStored(): Boolean;
begin
  Result := ((FDefaultRight <> FRight) and not (Self is TTurboAutoPadding)) or not (TTurboSide.Right in FAuto);
end;

function TTurboPadding.IsBottomStored(): Boolean;
begin
  Result := ((FDefaultBottom <> FBottom) and not (Self is TTurboAutoPadding)) or not (TTurboSide.Bottom in FAuto);
end;

function TTurboPadding.IsAutoStored(): Boolean;
begin
  Result := FDefaultAuto <> FAuto;
end;

procedure TTurboPadding.Change();
begin
  if Assigned(FOnChange) then
  begin
    FOnChange(Self);
  end;
end;

procedure TTurboPadding.AssignTo(Dest: TPersistent);
var
  NeedChange: Boolean;
begin
  NeedChange := False;

  if (Self is TTurboAutoPadding) and (Dest is TTurboAutoPadding) and (TTurboAutoPadding(Dest).FAuto <> FAuto) then
  begin
    TTurboAutoPadding(Dest).FAuto := FAuto;
    NeedChange := True;
  end;

  if Dest is TTurboPadding then
  begin
    if (TTurboPadding(Dest).FLeft <> FLeft) or
      (TTurboPadding(Dest).FTop <> FTop) or
      (TTurboPadding(Dest).FRight <> FRight) or
      (TTurboPadding(Dest).FBottom <> FBottom) then
    begin
      TTurboPadding(Dest).FLeft := FLeft;
      TTurboPadding(Dest).FTop := FTop;
      TTurboPadding(Dest).FRight := FRight;
      TTurboPadding(Dest).FBottom := FBottom;
      NeedChange := True;
    end;

    if NeedChange then
    begin
      TTurboPadding(Dest).Change();
    end;
  end else
  begin
    inherited AssignTo(Dest);
  end;
end;

{ TTurboAutoPadding }

constructor TTurboAutoPadding.Create(DefaultLeft, DefaultTop, DefaultRight, DefaultBottom: Integer; DefaultAutoSides: TTurboSides);
begin
  inherited Create(DefaultLeft, DefaultTop, DefaultRight, DefaultBottom);

  FDefaultAuto := DefaultAutoSides;

  FAuto := FDefaultAuto;
end;

constructor TTurboAutoPadding.Create();
begin
  Create(0, 0, 0, 0, [TTurboSide.Left, TTurboSide.Top, TTurboSide.Right, TTurboSide.Bottom]);
end;

function TTurboAutoPadding.GetIsAutoLeft(): Boolean;
begin
  Result := TTurboSide.Left in FAuto;
end;

function TTurboAutoPadding.GetIsAutoTop(): Boolean;
begin
  Result := TTurboSide.Top in FAuto;
end;

function TTurboAutoPadding.GetIsAutoRight(): Boolean;
begin
  Result := TTurboSide.Right in FAuto;
end;

function TTurboAutoPadding.GetIsAutoBottom(): Boolean;
begin
  Result := TTurboSide.Bottom in FAuto;
end;

{ TTurboSize }

constructor TTurboSize.Create(DefaultWidth, DefaultHeight: Integer);
begin
  inherited Create();

  FDefaultWidth := DefaultWidth;
  FDefaultHeight := DefaultHeight;

  FWidth := FDefaultWidth;
  FHeight := FDefaultHeight;
end;

constructor TTurboSize.Create();
begin
  Create(0, 0);
end;

procedure TTurboSize.SetAuto(Value: TTurboDimensions);
begin
  if Value = FAuto then
  begin
    exit;
  end;

  FAuto := Value;

  Change();
end;

function TTurboSize.IsAutoStored(): Boolean;
begin
  Result := FDefaultAuto <> FAuto;
end;

procedure TTurboSize.SetWidth(Value: Integer);
begin
  if Value < 0 then
  begin
    Value := 0;
  end;

  if Value = FWidth then
  begin
    exit;
  end;

  FWidth := Value;

  Change();
end;

procedure TTurboSize.SetHeight(Value: Integer);
begin
  if Value < 0 then
  begin
    Value := 0;
  end;

  if Value = FHeight then
  begin
    exit;
  end;

  FHeight := Value;

  Change();
end;

function TTurboSize.IsWidthStored(): Boolean;
begin
  Result := ((FDefaultWidth <> FWidth) and not (Self is TTurboAutoSize)) or not (TTurboDimension.Width in FAuto);
end;

function TTurboSize.IsHeightStored(): Boolean;
begin
  Result := ((FDefaultHeight <> FHeight) and not (Self is TTurboAutoSize)) or not (TTurboDimension.Height in FAuto);
end;

procedure TTurboSize.Change();
begin
  if Assigned(FOnChange) then
  begin
    FOnChange(Self);
  end;
end;

procedure TTurboSize.AssignTo(Dest: TPersistent);
var
  NeedChange: Boolean;
begin
  NeedChange := False;

  if (Self is TTurboAutoSize) and (Dest is TTurboAutoSize) and (TTurboAutoSize(Dest).FAuto <> FAuto) then
  begin
    TTurboAutoSize(Dest).FAuto := FAuto;
    NeedChange := True;
  end;

  if Dest is TTurboSize then
  begin
    if (TTurboSize(Dest).FWidth <> FWidth) or
      (TTurboSize(Dest).FHeight <> FHeight) then
    begin
      TTurboSize(Dest).FWidth := FWidth;
      TTurboSize(Dest).FHeight := FHeight;
      NeedChange := True;
    end;

    if NeedChange then
    begin
      TTurboSize(Dest).Change();
    end;
  end else
  begin
    inherited AssignTo(Dest);
  end;
end;

{ TTurboAutoSize }

constructor TTurboAutoSize.Create(DefaultWidth, DefaultHeight: Integer; DefaultAuto: TTurboDimensions);
begin
  inherited Create(DefaultWidth, DefaultHeight);

  FDefaultAuto := DefaultAuto;

  FAuto := FDefaultAuto;
end;

constructor TTurboAutoSize.Create();
begin
  Create(0, 0, [TTurboDimension.Width, TTurboDimension.Height]);
end;

function TTurboAutoSize.GetIsAutoWidth(): Boolean;
begin
  Result := TTurboDimension.Width in FAuto;
end;

function TTurboAutoSize.GetIsAutoHeight(): Boolean;
begin
  Result := TTurboDimension.Height in FAuto;
end;

{ TTurboLength }

constructor TTurboLength.Create(DefaultSize: Integer);
begin
  FDefaultSize := DefaultSize;

  FSize := FDefaultSize;
end;

constructor TTurboLength.Create();
begin
  Create(0);
end;

function TTurboLength.IsAutoStored(): Boolean;
begin
  Result := FAuto <> FDefaultAuto;
end;

function TTurboLength.IsSizeStored(): Boolean;
begin
  Result := ((FDefaultSize <> FSize) and not (Self is TTurboAutoLength)) or not (FAuto);
end;

procedure TTurboLength.SetAuto(Value: Boolean);
begin
  if Value = FAuto then
  begin
    exit;
  end;

  FAuto := Value;

  Change();
end;

procedure TTurboLength.SetSize(Value: Integer);
begin
  if Value < 0 then
  begin
    Value := 0;
  end;

  if Value = FSize then
  begin
    exit;
  end;

  FSize := Value;

  Change();
end;

procedure TTurboLength.Change();
begin
  if Assigned(FOnChange) then
  begin
    FOnChange(Self);
  end;
end;

procedure TTurboLength.AssignTo(Dest: TPersistent);
var
  NeedChange: Boolean;
begin
  NeedChange := False;

  if (Self is TTurboAutoLength) and (Dest is TTurboAutoLength) and (TTurboAutoLength(Dest).FAuto <> FAuto) then
  begin
    TTurboAutoLength(Dest).FAuto := FAuto;
    NeedChange := True;
  end;

  if Dest is TTurboLength then
  begin
    if (TTurboLength(Dest).FSize <> FSize) then
    begin
      TTurboLength(Dest).FSize := FSize;
      NeedChange := True;
    end;

    if NeedChange then
    begin
      TTurboLength(Dest).Change();
    end;
  end else
  begin
    inherited AssignTo(Dest);
  end;
end;

{ TTurboAutoLength }

constructor TTurboAutoLength.Create(DefaultSize: Integer; DefaultAuto: Boolean);
begin
  inherited Create(DefaultSize);

  FDefaultAuto := DefaultAuto;

  FAuto := FDefaultAuto;
end;

constructor TTurboAutoLength.Create();
begin
  Create(0, True);
end;

function TTurboAutoLength.GetIsAuto(): Boolean;
begin
  Result := FAuto;
end;

{ TTurboRange }

constructor TTurboRange.Create(Min, Max: Integer);
begin
  if Min > Max then
  begin
    raise EArgumentException.Create('Min is greater than Max');
  end;
  FMin := Min;
  FMax := Max;
end;

function TTurboRange.Ensure(Value: Integer): Integer;
begin
  if Value < FMin then
  begin
    Result := FMin;
  end else
  if Value > FMax then
  begin
    Result := FMax;
  end else
  begin
    Result := Value;
  end;
end;

procedure TTurboRange.SetMax(Value: Integer);
begin
  if FMax = Value then
  begin
    exit;
  end;

  FMax := Value;
  if Value < FMin then
  begin
    FMin := Value;
  end;
end;

function TTurboRange.GetLength(): Integer;
begin
  Result := FMax - FMin;
end;

procedure TTurboRange.SetMin(Value: Integer);
begin
  if FMin = Value then
  begin
    exit;
  end;

  FMin := Value;
  if Value > FMax then
  begin
    FMax := Value;
  end;
end;

{ TTurboFloatRange }

constructor TTurboFloatRange.Create(Min, Max: Double);
begin
  if Min > Max then
  begin
    raise EArgumentException.Create('Min is greater than Max');
  end;
  FMin := Min;
  FMax := Max;
end;

function TTurboFloatRange.GetLength(): Double;
begin
  Result := FMax - FMin;
end;

procedure TTurboFloatRange.SetMax(Value: Double);
begin
  if FMax = Value then
  begin
    exit;
  end;

  FMax := Value;
  if Value < FMin then
  begin
    FMin := Value;
  end;
end;

procedure TTurboFloatRange.SetMin(Value: Double);
begin
  if FMin = Value then
  begin
    exit;
  end;

  FMin := Value;
  if Value > FMax then
  begin
    FMax := Value;
  end;
end;

function TTurboFloatRange.Ensure(Value: Double): Double;
begin
  if Value < FMin then
  begin
    Result := FMin;
  end else
  if Value > FMax then
  begin
    Result := FMax;
  end else
  begin
    Result := Value;
  end;
end;

{ TTurboCustomControl }

constructor TTurboCustomControl.Create(Owner: TComponent);
begin
  inherited Create(Owner);

  ControlStyle := ControlStyle + [csParentBackground] - [csOpaque];

  ParentColor := True;
end;

function TTurboCustomControl.CanFocus(): Boolean;
begin
  Result := inherited CanFocus() and IsAllowFocus();
end;

procedure TTurboCustomControl.TrySetFocus();
begin
  if CanFocus() then
  begin
    SetFocus();
  end;
end;

procedure TTurboCustomControl.UpdateOpaque();
begin
  if ParentBackground or ParentColor then
    ControlStyle := ControlStyle - [csOpaque]
  else
    ControlStyle := ControlStyle + [csOpaque];
end;

procedure TTurboCustomControl.SetParentBackground(const ParentBackground: Boolean);
begin
  inherited SetParentBackground(ParentBackground);

  UpdateOpaque();
end;

function TTurboCustomControl.IsAllowFocus(): Boolean;
begin
  Result := False;
end;

{ TTurboTransparentBackground }

constructor TTurboTransparentBackground.Create();
begin
  inherited Create();
  
  FKind := TTurboTransparentBackgroundKind.Chess;
  FCellSize := 4;
  FColor1 := clGray;
  FColor2 := clLtGray;
end;

procedure TTurboTransparentBackground.SetCellSize(Value: Integer);
begin
  FCellSize := EnsureRange(Value, 1, 32);

  if FCellSize = Value then
  begin
    exit;
  end;

  FCellSize := Value;

  Change();
end;

procedure TTurboTransparentBackground.SetColor1(Value: TColor);
begin
  if FColor1 = Value then
  begin
    exit;
  end;

  FColor1 := Value;

  Change();
end;

procedure TTurboTransparentBackground.SetColor2(Value: TColor);
begin
  if FColor2 = Value then
  begin
    exit;
  end;

  FColor2 := Value;

  Change();
end;

procedure TTurboTransparentBackground.SetKind(Value: TTurboTransparentBackgroundKind);
begin
  if FKind = Value then
  begin
    exit;
  end;

  FKind := Value;

  Change();
end;

procedure TTurboTransparentBackground.Change();
begin
  if Assigned(FOnChange) then
  begin
    FOnChange(Self);
  end;
end;

procedure TTurboTransparentBackground.AssignTo(Dest: TPersistent);
begin
  if Dest is TTurboTransparentBackground then
  begin
    if (TTurboTransparentBackground(Dest).FCellSize <> FCellSize) or
      (TTurboTransparentBackground(Dest).FKind <> FKind) or
      (TTurboTransparentBackground(Dest).FColor1 <> FColor1) or
      (TTurboTransparentBackground(Dest).FColor2 <> FColor2) then
    begin
      TTurboTransparentBackground(Dest).FCellSize := FCellSize;
      TTurboTransparentBackground(Dest).FKind := FKind;
      TTurboTransparentBackground(Dest).FColor1 := FColor1;
      TTurboTransparentBackground(Dest).FColor2 := FColor2;
      TTurboTransparentBackground(Dest).Change();
    end;
  end else
  begin
    inherited AssignTo(Dest);
  end;
end;

{ TTurboSelectionFrame }

constructor TTurboSelectionFrame.Create();
begin
  inherited Create();

  FColor1 := clWhite;
  FColor2 := clBlack;
  FHotOpacity := 127;
  FOpacity := 255;
  FPressedOpacity := 200;
end;

procedure TTurboSelectionFrame.SetColor1(Value: TColor);
begin
  if FColor1 = Value then
  begin
    exit;
  end;

  FColor1 := Value;

  Change();
end;

procedure TTurboSelectionFrame.SetColor2(Value: TColor);
begin
  if FColor2 = Value then
  begin
    exit;
  end;

  FColor2 := Value;

  Change();
end;

procedure TTurboSelectionFrame.SetHotOpacity(Value: Byte);
begin
  if FHotOpacity = Value then
  begin
    exit;
  end;

  FHotOpacity := Value;

  Change();
end;

procedure TTurboSelectionFrame.SetOpacity(Value: Byte);
begin
  if FOpacity = Value then
  begin
    exit;
  end;

  FOpacity := Value;

  Change();
end;

procedure TTurboSelectionFrame.SetPressedOpacity(Value: Byte);
begin
  if FPressedOpacity = Value then
  begin
    exit;
  end;

  FPressedOpacity := Value;

  Change();
end;

procedure TTurboSelectionFrame.Change();
begin
  if Assigned(FOnChange) then
  begin
    FOnChange(Self);
  end;
end;

procedure TTurboSelectionFrame.AssignTo(Dest: TPersistent);
begin
  if Dest is TTurboSelectionFrame then
  begin
    if (TTurboSelectionFrame(Dest).FColor1 <> FColor1) or
      (TTurboSelectionFrame(Dest).FColor2 <> FColor2) or
      (TTurboSelectionFrame(Dest).FHotOpacity <> FHotOpacity) or
      (TTurboSelectionFrame(Dest).FOpacity <> FOpacity) or
      (TTurboSelectionFrame(Dest).FPressedOpacity <> FPressedOpacity) then
    begin
      TTurboSelectionFrame(Dest).FColor1 := FColor1;
      TTurboSelectionFrame(Dest).FColor2 := FColor2;
      TTurboSelectionFrame(Dest).FHotOpacity := FHotOpacity;
      TTurboSelectionFrame(Dest).FOpacity := FOpacity;
      TTurboSelectionFrame(Dest).FPressedOpacity := FPressedOpacity;
      TTurboSelectionFrame(Dest).Change();
    end;
  end else
  begin
    inherited AssignTo(Dest);
  end;
end;

end.

