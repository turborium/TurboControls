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

unit TurboExternalGraphics;

{$MODE DELPHIUNICODE}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$OVERFLOWCHECKS ON}
{$OPTIMIZATION ON}
{$SCOPEDENUMS ON}

interface

uses
  Classes, SysUtils, Math, FpImage, IntfGraphics, Graphics, LCLIntf, LCLType;

type

  { TTurboCanvasObject }

  TTurboCanvasObject = (Pen, Brush, Font);

  { TTurboCanvasParams }

  TTurboCanvasParams = set of TTurboCanvasObject;

  { TTurboCanvasState }

  // only internal use
  TTurboCanvasState = class
  strict private
    FBrush: TBrush;
    FFont: TFont;
    FPen: TPen;
  public
    constructor Create();
    destructor Destroy(); override;
    procedure Save(Canvas: TCanvas; Params: TTurboCanvasParams);
    procedure Apply(Canvas: TCanvas);
    property Pen: TPen read FPen;
    property Brush: TBrush read FBrush;
    property Font: TFont read FFont;
  end;

function SaveCanvasState(Canvas: TCanvas; Params: TTurboCanvasParams): TTurboCanvasState;
procedure ApplyCanvasState(Canvas: TCanvas; State: TTurboCanvasState);
procedure RestoreCanvasState(Canvas: TCanvas; State: TTurboCanvasState);

type

  { TTurboColor }

  TTurboColor = record
  strict private
    function GetColor(): TColor; inline;
    function GetFPColor(): TFPColor; inline;
    procedure SetColor(Value: TColor); inline;
    procedure SetFPColor(Value: TFPColor); inline;
  public
    R, G, B, A: Byte;
  public
    class function Create(R, G, B, A: Byte): TTurboColor; static; inline; overload;
    class function Create(R, G, B: Byte): TTurboColor; static; inline; overload;
    property Color: TColor read GetColor write SetColor;
    property FPColor: TFPColor read GetFPColor write SetFPColor;
  end;

// color spaces convert

function HueToRgbComponent(MinValue, MaxValue, AdjustedHue: Double): Double; inline;
procedure HslToRgb(Hue, Saturation, Lightness: Double; out Red, Green, Blue: Byte); inline;
procedure RgbToHsl(Red, Green, Blue: Byte; out Hue, Saturation, Lightness: Double); inline;
procedure HsvToRgb(Hue, Saturation, Value: Double; out Red, Green, Blue: Byte); inline;
procedure RgbToHsv(Red, Green, Blue: Byte; out Hue, Saturation, Value: Double); inline;
procedure HslToHsv(HslHue, HslSaturation, HslLightness: Double; out HsvHue, HsvSaturation, HsvValue: Double);
procedure HsvToHsl(HsvHue, HsvSaturation, HsvValue: Double; out HslHue, HslSaturation, HslLightness: Double);

// blending

function BlendColor(BackgroundColor: TColor; ForegroundColor: TColor; Alpha: Byte): TColor; inline;
function BlendFPColor(BackgroundColor: TFPColor; ForegroundColor: TFPColor; Alpha: Byte): TFPColor; inline;
procedure ApplyImageOpacity(Image: TLazIntfImage; Opacity: Byte);

// drawing

procedure ImageFillTriangle(Image: TLazIntfImage; X1, Y1, X2, Y2, X3, Y3: Double; Color: TColor);
procedure ImageStrokeTriangleAA(Image: TLazIntfImage; X1, Y1, X2, Y2, X3, Y3: Double; Thickness: Double; Color: TColor);
procedure ImageFillCircleAA(Image: TLazIntfImage; CenterX, CenterY, Radius: Double; Color: TColor);
procedure ImageStrokeCircle(Image: TLazIntfImage; CenterX, CenterY, Radius, Thickness: Double; Color: TColor);
procedure ImageStrokeCircleAA(Image: TLazIntfImage; CenterX, CenterY, Radius, Thickness: Double; Color: TColor);
procedure ImageFillRect(Image: TLazIntfImage; X, Y, Width, Height: Integer; Color: TColor);
procedure ImageStrokeRect(Image: TLazIntfImage; X, Y, Width, Height, Size: Integer; Color: TColor);
procedure ImageDrawCross(Image: TLazIntfImage; X, Y, Size, Space, Offset, Width: Integer; Color: TColor);

type

  { TTurboThumbDrawStyle }

  TTurboThumbDrawStyle = (Color, Invert, Mixed);

procedure DrawCircleThumb(Canvas: TCanvas; X, Y: Integer; Size: Integer; FillColor, StrokeColor, ValueColor: TColor; Style: TTurboThumbDrawStyle);
procedure DrawCrossThumb(Canvas: TCanvas; X, Y, Size: Integer; FillColor, StrokeColor: TColor; Style: TTurboThumbDrawStyle);

type
  TTurboTriangleThumbOrientation = (Left, Right, Up, Down);

procedure DrawTriangleThumb(Canvas: TCanvas; X, Y, Width, Height: Integer; Orientation: TTurboTriangleThumbOrientation; FillColor, StrokeColor: TColor);

procedure DrawRectangleThumb(Canvas: TCanvas; X, Y, Width, Height: Integer; FillColor, StrokeColor, ValueColor: TColor);

procedure DrawAxisLine(Canvas: TCanvas; X, Y, Size: Integer; IsVertical: Boolean; FillColor, StrokeColor: TColor; Opacity: Byte);

procedure DrawInvertAxisLine(Canvas: TCanvas; X, Y, Size: Integer; IsVertical: Boolean; DashSize: Integer; Color1, Color2: TColor);

procedure DrawFrameRect(Canvas: TCanvas; FrameRect: TRect; Width: Integer; Color: TColor);

type
  TTurboTransparentBackgroundKind = (Chess, Diagonal);

function AlphaBackgroundCase(Kind: TTurboTransparentBackgroundKind; Size: Integer; X, Y: Integer): Boolean; inline;

procedure DrawColorPreviewRect(Canvas: TCanvas; Rect: TRect; Color: TColor; Alpha: Byte; Kind: TTurboTransparentBackgroundKind; CellSize: Integer; CellColor1, CellColor2: TColor);

procedure DrawSelectionFrame(Canvas: TCanvas; Rect: TRect; ColorOuter, ColorInner: TColor; Alpha: Byte);

implementation

{ TTurboCanvasState }

constructor TTurboCanvasState.Create();
begin
  // nope
end;

procedure TTurboCanvasState.Save(Canvas: TCanvas; Params: TTurboCanvasParams);
begin
  if TTurboCanvasObject.Pen in Params then
  begin
    if FPen = nil then
    begin
      FPen := TPen.Create();
    end;
    FPen.Assign(Canvas.Pen);
  end;
  if TTurboCanvasObject.Brush in Params then
  begin
    if FBrush = nil then
    begin
      FBrush := TBrush.Create();
    end;
    FBrush.Assign(Canvas.Brush);
  end;
  if TTurboCanvasObject.Font in Params then
  begin
    if FFont = nil then
    begin
      FFont := TFont.Create();
    end;
    FFont.Assign(Canvas.Font);
  end;
end;

procedure TTurboCanvasState.Apply(Canvas: TCanvas);
begin
  if FPen <> nil then
  begin
    Canvas.Pen.Assign(FPen);
  end;
  if FBrush <> nil then
  begin
    Canvas.Brush.Assign(FBrush);
  end;
  if FFont <> nil then
  begin
    Canvas.Font.Assign(FFont);
  end;
end;

destructor TTurboCanvasState.Destroy();
begin
  FPen.Free();
  FBrush.Free();
  FFont.Free();

  inherited Destroy();
end;

function SaveCanvasState(Canvas: TCanvas; Params: TTurboCanvasParams): TTurboCanvasState;
begin
  Result := TTurboCanvasState.Create();
  try
    Result.Save(Canvas, Params);
  except
    Result.Free();
    raise;
  end;
end;

procedure ApplyCanvasState(Canvas: TCanvas; State: TTurboCanvasState);
begin
  State.Apply(Canvas);
end;

procedure RestoreCanvasState(Canvas: TCanvas; State: TTurboCanvasState);
begin
  try
    State.Apply(Canvas);
  finally
    State.Free();
  end;
end;

{ TTurboColor }

class function TTurboColor.Create(R, G, B, A: Byte): TTurboColor;
begin
  Result := TTurboColor((A shl 24) or (B shl 16) or (G shl 8) or R);
end;

class function TTurboColor.Create(R, G, B: Byte): TTurboColor;
begin
  Result := TTurboColor(($FF shl 24) or (B shl 16) or (G shl 8) or R);
end;

function TTurboColor.GetColor(): TColor;
begin
  Result := Cardinal(Self) and $00FFFFFF;
end;

function TTurboColor.GetFPColor(): TFPColor;
begin
  Result.Red := (Cardinal(Self) and $FF);
  Result.Red := Result.Red + (Result.Red shl 8);
  Result.Green := (Cardinal(Self) and $FF00);
  Result.Green := Result.Green + (Result.Green shr 8);
  Result.Blue := (Cardinal(Self) and $FF0000) shr 8;
  Result.Blue := Result.Blue + (Result.Blue shr 8);
  Result.Alpha := (Cardinal(Self) and $FF000000) shr 16;
  Result.Alpha := Result.Alpha + (Result.Alpha shr 8);
end;

procedure TTurboColor.SetColor(Value: TColor);
begin
  Self := TTurboColor(Cardinal(Value or $FF000000));
end;

procedure TTurboColor.SetFPColor(Value: TFPColor);
begin
  Self.R := Value.Red shr 8;
  Self.G := Value.Green shr 8;
  Self.B := Value.Blue shr 8;
  Self.A := Value.Alpha shr 8;
end;

function HueToRgbComponent(MinValue, MaxValue, AdjustedHue: Double): Double;
begin
  // normalize: AdjustedHue in [0..6)
  if AdjustedHue < 0 then
  begin
    AdjustedHue := AdjustedHue + 6.0;
  end else
  if AdjustedHue >= 6 then
  begin
    AdjustedHue := AdjustedHue - 6.0;
  end;

  if AdjustedHue < 1.0 then
  begin
    exit(MinValue + (MaxValue - MinValue) * AdjustedHue);
  end else
  if AdjustedHue < 3.0 then
  begin
    exit(MaxValue);
  end else
  if AdjustedHue < 4.0 then
  begin
    exit(MinValue + (MaxValue - MinValue) * (4.0 - AdjustedHue))
  end else
  begin
    exit(MinValue);
  end;
end;

{$IFOPT R+}{$DEFINE RANGECHECKS_ON}{$ENDIF}
{$IFOPT Q+}{$DEFINE OVERFLOWCHECKS_ON}{$ENDIF}
{$RANGECHECKS OFF}
{$OVERFLOWCHECKS OFF}
procedure HslToRgb(Hue, Saturation, Lightness: Double; out Red, Green, Blue: Byte);
var
  R, G, B: Double;
  MinValue, MaxValue: Double;
begin
  Hue := Frac(Hue) + Integer(Hue < 0.0);
  //Hue := Hue - Floor(Hue);

  Hue := Hue * 6.0;

  if Saturation = 0.0 then
  begin
    R := Lightness;
    G := Lightness;
    B := Lightness;
  end else
  begin
    if Lightness < 0.5 then
    begin
      MaxValue := Lightness * (1.0 + Saturation);
    end else
    begin
      MaxValue := Lightness + Saturation - Lightness * Saturation;
    end;

    MinValue := 2.0 * Lightness - MaxValue;

    R := HueToRGBComponent(MinValue, MaxValue, Hue + 2.0);
    G := HueToRGBComponent(MinValue, MaxValue, Hue);
    B := HueToRGBComponent(MinValue, MaxValue, Hue - 2.0);
  end;

  // this check may be unnecessary
  R := EnsureRange(R, 0.0, 1.0);
  G := EnsureRange(G, 0.0, 1.0);
  B := EnsureRange(B, 0.0, 1.0);

  Red := Trunc(R * 255.0 + 0.5);
  Green := Trunc(G * 255.0 + 0.5);
  Blue := Trunc(B * 255.0 + 0.5);
end;
{$IFDEF RANGECHECKS_ON}{$RANGECHECKS ON}{$ELSE}{$RANGECHECKS OFF}{$ENDIF}
{$IFDEF OVERFLOWCHECKS_ON}{$OVERFLOWCHECKS ON}{$ELSE}{$OVERFLOWCHECKS OFF}{$ENDIF}

procedure RgbToHsl(Red, Green, Blue: Byte; out Hue, Saturation, Lightness: Double);
var
  R, G, B: Double;
  ColorMin, ColorMax, Delta: Double;
begin
  R := Red / 255.0;
  G := Green / 255.0;
  B := Blue / 255.0;

  ColorMin := R;
  if G < ColorMin then
  begin
    ColorMin := G;
  end;
  if B < ColorMin then
  begin
    ColorMin := B;
  end;

  ColorMax := R;
  if G > ColorMax then
  begin
    ColorMax := G;
  end;
  if B > ColorMax then
  begin
    ColorMax := B;
  end;

  Delta := ColorMax - ColorMin;
  Lightness := (ColorMax + ColorMin) / 2.0;

  if Delta = 0 then
  begin
    Hue := 0.0;
    Saturation := 0.0;
  end else
  begin
    if Lightness < 0.5 then
    begin
      Saturation := Delta / (ColorMax + ColorMin);
    end else
    begin
      Saturation := Delta / (2.0 - ColorMax - ColorMin);
    end;

    if R = ColorMax then
    begin
      Hue := (G - B) / Delta;
      if G < B then
      begin
        Hue := Hue + 6.0;
      end;
    end else
    if G = ColorMax then
    begin
      Hue := (B - R) / Delta + 2.0
    end else
    begin
      Hue := (R - G) / Delta + 4.0;
    end;

    Hue := Hue / 6.0;
  end;
end;

{$IFOPT R+}{$DEFINE RANGECHECKS_ON}{$ENDIF}
{$IFOPT Q+}{$DEFINE OVERFLOWCHECKS_ON}{$ENDIF}
{$RANGECHECKS OFF}
{$OVERFLOWCHECKS OFF}
procedure HsvToRgb(Hue, Saturation, Value: Double; out Red, Green, Blue: Byte);
var
  SectorIndex: Integer;
  Fractional: Double;
  IntermediateP, IntermediateQ, IntermediateT: Double;
  R, G, B: Double;
begin
  Hue := Frac(Hue) + Integer(Hue < 0.0);
  //Hue := Hue - Floor(Hue);

  if Saturation = 0.0 then
  begin
    R := Value;
    G := Value;
    B := Value;
  end else
  begin
    Hue := Hue * 6.0;
    SectorIndex := Trunc(Hue);
    Fractional := Hue - SectorIndex;

    IntermediateP := Value * (1.0 - Saturation);
    IntermediateQ := Value * (1.0 - Saturation * Fractional);
    IntermediateT := Value * (1.0 - Saturation * (1.0 - Fractional));

    case SectorIndex of
      0:
      begin
        R := Value;
        G := IntermediateT;
        B := IntermediateP;
      end;
      1:
      begin
        R := IntermediateQ;
        G := Value;
        B := IntermediateP;
      end;
      2:
      begin
        R := IntermediateP;
        G := Value;
        B := IntermediateT;
      end;
      3:
      begin
        R := IntermediateP;
        G := IntermediateQ;
        B := Value;
      end;
      4:
      begin
        R := IntermediateT;
        G := IntermediateP;
        B := Value;
      end;
      else
        R := Value;
        G := IntermediateP;
        B := IntermediateQ;
    end;
  end;

  // this check may be unnecessary
  R := EnsureRange(R, 0.0, 1.0);
  G := EnsureRange(G, 0.0, 1.0);
  B := EnsureRange(B, 0.0, 1.0);

  Red := Trunc(R * 255.0 + 0.5);
  Green := Trunc(G * 255.0 + 0.5);
  Blue := Trunc(B * 255.0 + 0.5);
end;
{$IFDEF RANGECHECKS_ON}{$RANGECHECKS ON}{$ELSE}{$RANGECHECKS OFF}{$ENDIF}
{$IFDEF OVERFLOWCHECKS_ON}{$OVERFLOWCHECKS ON}{$ELSE}{$OVERFLOWCHECKS OFF}{$ENDIF}

procedure RgbToHsv(Red, Green, Blue: Byte; out Hue, Saturation, Value: Double);
var
  R, G, B: Double;
  MaxValue, MinValue, Delta: Double;
begin
  R := Red / 255.0;
  G := Green / 255.0;
  B := Blue / 255.0;

  if R > G then
  begin
    MaxValue := R;
  end else
  begin
    MaxValue := G;
  end;

  if MaxValue > B then
  begin
    MaxValue := MaxValue;
  end else
  begin
    MaxValue := B;
  end;

  if R < G then
  begin
    MinValue := R;
  end else
  begin
    MinValue := G;
  end;

  if MinValue < B then
  begin
    MinValue := MinValue;
  end else
  begin
    MinValue := B;
  end;

  Value := MaxValue;
  Delta := MaxValue - MinValue;

  if MaxValue = 0.0 then
  begin
    Saturation := 0.0;
  end else
  begin
    Saturation := Delta / MaxValue;
  end;

  if Delta = 0.0 then
  begin
    Hue := 0.0;
  end else
  begin
    if MaxValue = R then
    begin
      Hue := (G - B) / Delta;
    end else
    if MaxValue = G then
    begin
      Hue := 2.0 + (B - R) / Delta;
    end else
    begin
      Hue := 4.0 + (R - G) / Delta;
    end;

    Hue := Hue / 6.0;
    if Hue < 0.0 then
    begin
      Hue := Hue + 1.0;
    end;
  end;
end;

procedure HslToHsv(HslHue, HslSaturation, HslLightness: Double; out HsvHue, HsvSaturation, HsvValue: Double);
var
  Temp: Double;
begin
  HsvHue := HslHue;

  Temp := HslSaturation * Min(HslLightness, 1.0 - HslLightness);

  HsvValue := HslLightness + Temp;
  if HsvValue = 0.0 then
  begin
    HsvSaturation := 0.0
  end else
  begin
    HsvSaturation := 2.0 * (1.0 - HslLightness / HsvValue);
  end;
end;

procedure HsvToHsl(HsvHue, HsvSaturation, HsvValue: Double; out HslHue, HslSaturation, HslLightness: Double);
begin
  HslHue := HsvHue;

  HslLightness := HsvValue * (1 - HsvSaturation / 2);
  if (HslLightness = 0) or (HslLightness = 1) then
  begin
    HslSaturation := 0
  end else
  begin
    HslSaturation := (HsvValue - HslLightness) / Min(HslLightness, 1 - HslLightness);
  end;
end;

function BlendColor(BackgroundColor: TColor; ForegroundColor: TColor; Alpha: Byte): TColor;
var
  R, G, B: Byte;
begin
  R := (GetRValue(ForegroundColor) * Alpha + GetRValue(BackgroundColor) * (255 - Alpha) + 127) div 255;
  G := (GetGValue(ForegroundColor) * Alpha + GetGValue(BackgroundColor) * (255 - Alpha) + 127) div 255;
  B := (GetBValue(ForegroundColor) * Alpha + GetBValue(BackgroundColor) * (255 - Alpha) + 127) div 255;
  Result := RGB(R, G, B);
end;

function BlendFPColor(BackgroundColor: TFPColor; ForegroundColor: TFPColor; Alpha: Byte): TFPColor;
var
  ForegroundAlpha, BackgroundAlpha, NewAlpha, BlendAlpha: Byte;
  Weight: Integer;
begin
  BackgroundAlpha := BackgroundColor.Alpha shr 8;
  ForegroundAlpha := ForegroundColor.Alpha shr 8;

  // alpha
  NewAlpha := (ForegroundAlpha * Alpha + 127) div 255;
  BlendAlpha := NewAlpha + (BackgroundAlpha * (255 - NewAlpha) + 127) div 255;

  // colors
  Result.Alpha := (BlendAlpha shl 8) or BlendAlpha;
  if BlendAlpha = 0 then
  begin
    Result.Red := 0;
    Result.Green := 0;
    Result.Blue := 0;
  end else
  begin
    Weight := BackgroundAlpha * (255 - NewAlpha);
    Result.Red := (((ForegroundColor.Red shr 8) * NewAlpha) + ((BackgroundColor.Red shr 8) * Weight) div 255) div BlendAlpha;
    Result.Red := (Result.Red shl 8) or Result.Red;
    Result.Green := (((ForegroundColor.Green shr 8) * NewAlpha) + ((BackgroundColor.Green shr 8) * Weight) div 255) div BlendAlpha;
    Result.Green := (Result.Green shl 8) or Result.Green;
    Result.Blue := (((ForegroundColor.Blue shr 8) * NewAlpha) + ((BackgroundColor.Blue shr 8) * Weight) div 255) div BlendAlpha;
    Result.Blue := (Result.Blue shl 8) or Result.Blue;
  end;
end;

procedure ApplyImageOpacity(Image: TLazIntfImage; Opacity: Byte);
var
  X, Y: Integer;
  Color: TFPColor;
begin
  for Y := 0 to Image.Height - 1 do
  begin
    for X := 0 to Image.Width - 1 do
    begin
      Image.GetInternalColorProc(X, Y, Color);
      Color.Alpha := (Color.Alpha * Opacity) div 255;
      Image.SetInternalColorProc(X, Y, Color);
    end;
  end;
end;

function EdgeFunction(PX, PY, AX, AY, BX, BY: Double): Double; inline;
begin
  Result := (PX - AX) * (BY - AY) - (PY - AY) * (BX - AX);
end;

function DistanceToLine(PX, PY, AX, AY, BX, BY: Double): Double; inline;
var
  VX, VY, WX, WY, C1, C2, T, ProjX, ProjY: Double;
begin
  VX := BX - AX;
  VY := BY - AY;
  WX := PX - AX;
  WY := PY - AY;

  C1 := WX * VX + WY * VY;
  if C1 <= 0.0 then
  begin
    exit(Hypot(PX - AX, PY - AY));
  end;

  C2 := VX * VX + VY * VY;
  if C2 <= C1 then
  begin
    exit(Hypot(PX - BX, PY - BY));
  end;

  T := C1 / C2;

  ProjX := AX + T * VX;
  ProjY := AY + T * VY;

  Result := Hypot(PX - ProjX, PY - ProjY);
end;

procedure ImageFillTriangle(Image: TLazIntfImage; X1, Y1, X2, Y2, X3, Y3: Double; Color: TColor);
var
  X, Y: Integer;
  MinX, MaxX, MinY, MaxY: Integer;
  W0, W1, W2: Double;
  FPColor: TFPColor;
begin
  FPColor := TColorToFPColor(Color);

  // get triangle rect
  MinX := Trunc(Min(Min(X1, X2), X3));
  MaxX := Ceil(Max(Max(X1, X2), X3));
  MinY := Trunc(Min(Min(Y1, Y2), Y3));
  MaxY := Ceil(Max(Max(Y1, Y2), Y3));

  // fixup for image size
  MinX := Max(MinX, 0);
  MinY := Max(MinY, 0);
  MaxX := Min(MaxX, Image.Width - 1);
  MaxY := Min(MaxY, Image.Height - 1);

  for Y := MinY to MaxY do
  begin
    for X := MinX to MaxX do
    begin
      W0 := EdgeFunction(X, Y, X2, Y2, X3, Y3);
      W1 := EdgeFunction(X, Y, X3, Y3, X1, Y1);
      W2 := EdgeFunction(X, Y, X1, Y1, X2, Y2);
      if ((W0 >= 0.0) and (W1 >= 0.0) and (W2 >= 0.0)) or
         ((W0 <= 0.0) and (W1 <= 0.0) and (W2 <= 0.0)) then
      begin
        Image.SetInternalColorProc(X, Y, FPColor);
      end;
    end;
  end;
end;

procedure ImageStrokeTriangleAA(Image: TLazIntfImage; X1, Y1, X2, Y2, X3, Y3: Double;  Thickness: Double; Color: TColor);
var
  X, Y: Integer;
  MinX, MaxX, MinY, MaxY: Integer;
  Distance, Temp, AlphaScale, Alpha: Double;
  FPPixel, FPColor: TFPColor;
begin
  FPColor := TColorToFPColor(Color);

  // Thickness < 1.0 fix
  AlphaScale := Min(Thickness, 1.0);

  // get triangle rect
  MinX := Trunc(Min(Min(X1, X2), X3));
  MaxX := Ceil(Max(Max(X1, X2), X3));
  MinY := Trunc(Min(Min(Y1, Y2), Y3));
  MaxY := Ceil(Max(Max(Y1, Y2), Y3));

  // fixup for image size
  MinX := Max(MinX, 0);
  MinY := Max(MinY, 0);
  MaxX := Min(MaxX, Image.Width - 1);
  MaxY := Min(MaxY, Image.Height - 1);

  for Y := MinY to MaxY do
  begin
    for X := MinX to MaxX do
    begin
      // calc distance
      Distance := DistanceToLine(X, Y, X1, Y1, X2, Y2);
      Temp := DistanceToLine(X, Y, X2, Y2, X3, Y3);
      if Distance > Temp then
      begin
        Distance := Temp;
      end;
      Temp := DistanceToLine(X, Y, X3, Y3, X1, Y1);
      if Distance > Temp then
      begin
        Distance := Temp;
      end;

      // set pixel if need
      if Distance <= Thickness / 2.0 + 1.0 then
      begin
        Alpha := 1.0 - (Distance - Thickness / 2.0 + 0.5);
        if Alpha < 0.0 then
        begin
          Alpha := 0.0;
        end;
        if Alpha > 1.0 then
        begin
          Alpha := 1.0;
        end;
        Alpha := Alpha * AlphaScale;
        Image.GetInternalColorProc(X, Y, FPPixel);
        Image.SetInternalColorProc(X, Y, BlendFPColor(FPPixel, FPColor, Trunc(Alpha * 255.0 + 0.5)));
      end;
    end;
  end;
end;

procedure ImageFillCircleAA(Image: TLazIntfImage; CenterX, CenterY, Radius: Double; Color: TColor);
var
  X, Y: Integer;
  MinX, MaxX, MinY, MaxY: Integer;
  Distance, Alpha: Double;
  FPPixel, FPColor: TFPColor;
begin
  FPColor := TColorToFPColor(Color);

  CenterX := CenterX - 0.5;
  CenterY := CenterY - 0.5;
  Radius := Radius - 1.0;

  // get circle rect
  MinX := Trunc(CenterX - Radius);
  MaxX := Ceil(CenterX + Radius);
  MinY := Trunc(CenterY - Radius);
  MaxY := Ceil(CenterY + Radius);

  // fixup for image size
  MinX := Max(MinX, 0);
  MinY := Max(MinY, 0);
  MaxX := Min(MaxX, Image.Width - 1);
  MaxY := Min(MaxY, Image.Height - 1);

  for Y := MinY to MaxY do
  begin
    for X := MinX to MaxX do
    begin
      Distance := Hypot(X - CenterX, Y - CenterY);

      if Distance <= Radius + 1.0 then
      begin
        if Distance <= Radius then
        begin
          Alpha := 1.0;
        end else
        begin
          Alpha := Radius + 1.0 - Distance;
        end;

        if Alpha < 0.0 then
        begin
          Alpha := 0.0;
        end;

        if Alpha > 1.0 then
        begin
          Alpha := 1.0;
        end;

        Image.GetInternalColorProc(X, Y, FPPixel);
        Image.SetInternalColorProc(X, Y, BlendFPColor(FPPixel, FPColor, Trunc(Alpha * 255.0 + 0.5)));
      end;
    end;
  end;
end;

procedure ImageStrokeCircle(Image: TLazIntfImage; CenterX, CenterY, Radius, Thickness: Double; Color: TColor);
var
  X, Y: Integer;
  MinX, MaxX, MinY, MaxY: Integer;
  Dist, Inner, Outer, Alpha: Double;
  FPColor: TFPColor;
begin
  FPColor := TColorToFPColor(Color);

  CenterX := CenterX - 0.5;
  CenterY := CenterY - 0.5;
  Radius := Radius;

  // get circle rect
  MinX := Trunc(CenterX - Radius - Thickness);
  MaxX := Ceil(CenterX + Radius + Thickness);
  MinY := Trunc(CenterY - Radius - Thickness);
  MaxY := Ceil(CenterY + Radius + Thickness);

  // fixup for image size
  MinX := Max(MinX, 0);
  MinY := Max(MinY, 0);
  MaxX := Min(MaxX, Image.Width - 1);
  MaxY := Min(MaxY, Image.Height - 1);

  Inner := Radius - Thickness / 2.0 + 1.0;
  Outer := Radius + Thickness / 2.0;

  for Y := MinY to MaxY do
  begin
    for X := MinX to MaxX do
    begin
      Dist := Hypot(X - CenterX, Y - CenterY);

      if (Dist >= Inner - 1.0) and (Dist <= Outer + 1.0) then
      begin
        // aa
        if Dist < Inner then
        begin
          Alpha := Dist - (Inner - 1.0);
        end else
        if Dist > Outer then
        begin
          Alpha := Outer + 1.0 - Dist;
        end else
        begin
          Alpha := 1.0;
        end;

        if Alpha > 0.5 then
        begin
          Image.SetInternalColorProc(X, Y, FPColor);
        end;
      end;
    end;
  end;
end;

procedure ImageStrokeCircleAA(Image: TLazIntfImage; CenterX, CenterY, Radius, Thickness: Double; Color: TColor);
var
  X, Y: Integer;
  MinX, MaxX, MinY, MaxY: Integer;
  Dist, Inner, Outer, Alpha, AlphaScale: Double;
  FPPixel, FPColor: TFPColor;
begin
  FPColor := TColorToFPColor(Color);

  CenterX := CenterX - 0.5;
  CenterY := CenterY - 0.5;
  Radius := Radius - 1.0;

  // get circle rect
  MinX := Trunc(CenterX - Radius - Thickness);
  MaxX := Ceil(CenterX + Radius + Thickness);
  MinY := Trunc(CenterY - Radius - Thickness);
  MaxY := Ceil(CenterY + Radius + Thickness);

  // fixup for image size
  MinX := Max(MinX, 0);
  MinY := Max(MinY, 0);
  MaxX := Min(MaxX, Image.Width - 1);
  MaxY := Min(MaxY, Image.Height - 1);

  Inner := Radius - Thickness / 2.0 + 1.0;
  Outer := Radius + Thickness / 2.0;

  // Для очень тонких линий альфа масштабируется
  if Thickness < 1.0 then
  begin
    AlphaScale := Thickness
  end else
  begin
    AlphaScale := 1.0;
  end;

  for Y := MinY to MaxY do
  begin
    for X := MinX to MaxX do
    begin
      Dist := Hypot(X - CenterX, Y - CenterY);

      if (Dist >= Inner - 1.0) and (Dist <= Outer + 1.0) then
      begin
        // антиалиасинг по границе
        if Dist < Inner then
        begin
          Alpha := Dist - (Inner - 1.0);
        end else
        if Dist > Outer then
        begin
          Alpha := Outer + 1.0 - Dist;
        end else
        begin
          Alpha := 1.0;
        end;

        if Alpha < 0.0 then
        begin
          Alpha := 0.0;
        end else
        if Alpha > 1.0 then
        begin
          Alpha := 1.0;
        end;

        Image.GetInternalColorProc(X, Y, FPPixel);
        Image.SetInternalColorProc(X, Y, BlendFPColor(FPPixel, FPColor, Trunc(Alpha * AlphaScale * 255.0 + 0.5)));
      end;
    end;
  end;
end;

procedure ImageFillRect(Image: TLazIntfImage; X, Y, Width, Height: Integer; Color: TColor);
var
  IX, IY: Integer;
  MinX, MaxX, MinY, MaxY: Integer;
  FPColor: TFPColor;
begin
  FPColor := TColorToFPColor(Color);

  if (X + Width < 0) or (Y + Height < 0) or (X >= Image.Width) or (Y >= Image.Height) then
  begin
    exit;
  end;

  MinX := Max(X, 0);
  MinY := Max(Y, 0);
  MaxX := Min(X + Width - 1, Image.Width - 1);
  MaxY := Min(Y + Height - 1, Image.Height - 1);

  for IY := MinY to MaxY do
  begin
    for IX := MinX to MaxX do
    begin
      Image.SetInternalColorProc(IX, IY, FPColor);
    end;
  end;
end;

procedure ImageStrokeRect(Image: TLazIntfImage; X, Y, Width, Height, Size: Integer; Color: TColor);
begin
  if (Width < Size * 2) or (Height < Size * 2) then
  begin
    ImageFillRect(Image, X, Y, Width, Height, Color);
  end else
  begin
    // left
    ImageFillRect(Image, X, Y, Size, Height, Color);
    // right
    ImageFillRect(Image, X + Width - Size, Y, Size, Height, Color);
    // top
    ImageFillRect(Image, X + Size, Y, Width - Size, Size, Color);
    // bottom
    ImageFillRect(Image, X + Size, Y + Height - Size, Width - Size, Size, Color);
  end;
end;

procedure ImageDrawCross(Image: TLazIntfImage; X, Y, Size, Space, Offset, Width: Integer; Color: TColor);
var
  LineSize: Integer;
  RectOffset: Integer;
begin
  LineSize := Size div 2 - Space - Offset * 2;
  RectOffset := Width div 2;

  // left
  ImageFillRect(Image, X - LineSize - Space - Offset, Y - RectOffset, LineSize, Width, Color);
  // right
  ImageFillRect(Image, X + Space + Offset + 1, Y - RectOffset, LineSize, Width, Color);
  // top
  ImageFillRect(Image, X - RectOffset, Y - LineSize - Space - Offset, Width, LineSize, Color);
  // bottom
  ImageFillRect(Image, X - RectOffset, Y + Space + Offset + 1, Width, LineSize, Color);
end;


procedure DrawCircleThumb(Canvas: TCanvas; X, Y: Integer; Size: Integer; FillColor, StrokeColor, ValueColor: TColor; Style: TTurboThumbDrawStyle);
var
  Bitmap: TBitmap;
  Image: TLazIntfImage;
  InnerLineWidth: Double;
  OuterLineWidth: Double;
begin
  if Size > 16 then
  begin
    InnerLineWidth := 1.5;
    OuterLineWidth := 4.5;
  end else
  begin
    InnerLineWidth := 1.1;
    OuterLineWidth := 3.2;
  end;

  case Style of
    TTurboThumbDrawStyle.Color:
    begin
      Bitmap := TBitmap.Create();
      try
        Bitmap.PixelFormat := pf32bit;
        Bitmap.SetSize(Size, Size);

        Image := Bitmap.CreateIntfImage();
        try
          Image.FillPixels(FPColor(0, 0, 0, 0));

          if ValueColor <> clNone then
          begin
            ImageFillCircleAA(Image, Bitmap.Width / 2.0, Bitmap.Height / 2.0, Size / 2.0 - OuterLineWidth / 2.0, ValueColor);
          end;

          ImageStrokeCircleAA(Image, Bitmap.Width / 2.0, Bitmap.Height / 2.0, Size / 2.0 - OuterLineWidth / 2.0, OuterLineWidth, StrokeColor);
          ImageStrokeCircleAA(Image, Bitmap.Width / 2.0, Bitmap.Height / 2.0, Size / 2.0 - OuterLineWidth / 2.0, InnerLineWidth, FillColor);

          Bitmap.LoadFromIntfImage(Image);
        finally
          Image.Free();
        end;

        Canvas.Draw(X, Y, Bitmap);
      finally
        Bitmap.Free();
      end;
    end;
    TTurboThumbDrawStyle.Invert:
    begin
      Bitmap := TBitmap.Create();
      try
        Bitmap.PixelFormat := pf24bit;
        Bitmap.SetSize(Size, Size);

        Image := Bitmap.CreateIntfImage();
        try
          Image.FillPixels(FPColor(0, 0, 0));

          ImageStrokeCircle(Image, Bitmap.Width / 2.0, Bitmap.Height / 2.0, Bitmap.Width / 2.0 - OuterLineWidth / 2.0, OuterLineWidth - 1.1, $808080);
          ImageStrokeCircle(Image, Bitmap.Width / 2.0, Bitmap.Height / 2.0, Bitmap.Width / 2.0 - OuterLineWidth / 2.0, InnerLineWidth, $A0A0A0);

          Bitmap.LoadFromIntfImage(Image);
        finally
          Image.Free();
        end;

        BitBlt(Canvas.Handle, X, Y, Bitmap.Width, Bitmap.Height, Bitmap.Canvas.Handle, 0, 0, SRCINVERT);
      finally
        Bitmap.Free();
      end;

      if ValueColor <> clNone then
      begin
        Bitmap := TBitmap.Create();
        try
          Bitmap.PixelFormat := pf32bit;
          Bitmap.SetSize(Size, Size);

          Image := Bitmap.CreateIntfImage();
          try
            Image.FillPixels(FPColor(0, 0, 0, 0));

            ImageFillCircleAA(Image, Bitmap.Width / 2.0, Bitmap.Height / 2.0, Size / 2.0 - OuterLineWidth + 1.5, ValueColor);

            Bitmap.LoadFromIntfImage(Image);
          finally
            Image.Free();
          end;

          Canvas.Draw(X, Y, Bitmap);
        finally
          Bitmap.Free();
        end;
      end;
    end;
    TTurboThumbDrawStyle.Mixed:
    begin
      Bitmap := TBitmap.Create();
      try
        Bitmap.PixelFormat := pf24bit;
        Bitmap.SetSize(Size, Size);

        Image := Bitmap.CreateIntfImage();
        try
          Image.FillPixels(FPColor(0, 0, 0));

          ImageStrokeCircle(Image, Bitmap.Width / 2.0, Bitmap.Height / 2.0, Bitmap.Width / 2.0 - OuterLineWidth / 2.0, OuterLineWidth, $808080);

          Bitmap.LoadFromIntfImage(Image);
        finally
          Image.Free();
        end;

        BitBlt(Canvas.Handle, X, Y, Bitmap.Width, Bitmap.Height, Bitmap.Canvas.Handle, 0, 0, SRCINVERT);
      finally
        Bitmap.Free();
      end;
      Bitmap := TBitmap.Create();
      try
        Bitmap.PixelFormat := pf32bit;
        Bitmap.SetSize(Size, Size);

        Image := Bitmap.CreateIntfImage();
        try
          Image.FillPixels(FPColor(0, 0, 0, 0));

          if ValueColor <> clNone then
          begin
            ImageFillCircleAA(Image, Bitmap.Width / 2.0, Bitmap.Height / 2.0, Size / 2.0 - OuterLineWidth / 2.0, ValueColor);
          end;

          ImageStrokeCircleAA(Image, Bitmap.Width / 2.0, Bitmap.Height / 2.0, Size / 2.0 - OuterLineWidth / 2.0, OuterLineWidth - 0.5, StrokeColor);
          ImageStrokeCircleAA(Image, Bitmap.Width / 2.0, Bitmap.Height / 2.0, Size / 2.0 - OuterLineWidth / 2.0, InnerLineWidth, FillColor);

          Bitmap.LoadFromIntfImage(Image);
        finally
          Image.Free();
        end;

        Canvas.Draw(X, Y, Bitmap);
      finally
        Bitmap.Free();
      end;
    end;
  end;
end;

procedure DrawCrossThumb(Canvas: TCanvas; X, Y, Size: Integer; FillColor, StrokeColor: TColor; Style: TTurboThumbDrawStyle);
var
  Bitmap: TBitmap;
  Image: TLazIntfImage;
begin
  case Style of
    TTurboThumbDrawStyle.Color:
    begin
      Bitmap := TBitmap.Create();
      try
        Bitmap.PixelFormat := pf32bit;
        Bitmap.SetSize(Size, Size);

        Image := Bitmap.CreateIntfImage();
        try
          Image.FillPixels(FPColor(0, 0, 0, 0));

          if Size >= 16 then
          begin
            ImageDrawCross(Image, Bitmap.Width div 2, Bitmap.Height div 2, Size, 0, 0, 5, StrokeColor);
            ImageDrawCross(Image, Bitmap.Width div 2, Bitmap.Height div 2, Size, 0, 1, 3, BlendColor(StrokeColor, FillColor, 127));
            ImageDrawCross(Image, Bitmap.Width div 2, Bitmap.Height div 2, Size, 0, 2, 1, FillColor);
          end else
          begin
            ImageDrawCross(Image, Bitmap.Width div 2, Bitmap.Height div 2, Size, 0, 0, 3, StrokeColor);
            ImageDrawCross(Image, Bitmap.Width div 2, Bitmap.Height div 2, Size, 0, 1, 1, FillColor);
          end;

          Bitmap.LoadFromIntfImage(Image);
        finally
          Image.Free();
        end;

        Canvas.Draw(X, Y, Bitmap);
      finally
        Bitmap.Free();
      end;
    end;
    TTurboThumbDrawStyle.Invert:
    begin
      Bitmap := TBitmap.Create();
      try
        Bitmap.PixelFormat := pf24bit;
        Bitmap.SetSize(Size, Size);

        Image := Bitmap.CreateIntfImage();
        try
          Image.FillPixels(FPColor(0, 0, 0));

          ImageDrawCross(Image, Bitmap.Width div 2, Bitmap.Height div 2, Size, 0, 0, 3, $808080);
          ImageDrawCross(Image, Bitmap.Width div 2, Bitmap.Height div 2, Size, 0, 1, 1, $A0A0A0);

          Bitmap.LoadFromIntfImage(Image);
        finally
          Image.Free();
        end;

        BitBlt(Canvas.Handle, X, Y, Bitmap.Width, Bitmap.Height, Bitmap.Canvas.Handle, 0, 0, SRCINVERT);
      finally
        Bitmap.Free();
      end;
    end;
    TTurboThumbDrawStyle.Mixed:
    begin
      Bitmap := TBitmap.Create();
      try
        Bitmap.PixelFormat := pf24bit;
        Bitmap.SetSize(Size, Size);

        Image := Bitmap.CreateIntfImage();
        try
          Image.FillPixels(FPColor(0, 0, 0));

          ImageDrawCross(Image, Bitmap.Width div 2, Bitmap.Height div 2, Size, 0, 0, 5, $808080);

          Bitmap.LoadFromIntfImage(Image);
        finally
          Image.Free();
        end;

        BitBlt(Canvas.Handle, X, Y, Bitmap.Width, Bitmap.Height, Bitmap.Canvas.Handle, 0, 0, SRCINVERT);
      finally
        Bitmap.Free();
      end;
      Bitmap := TBitmap.Create();
      try
        Bitmap.PixelFormat := pf32bit;
        Bitmap.SetSize(Size, Size);

        Image := Bitmap.CreateIntfImage();
        try
          Image.FillPixels(FPColor(0, 0, 0, 0));

          ImageDrawCross(Image, Bitmap.Width div 2, Bitmap.Height div 2, Size, 0, 1, 3, StrokeColor);
          ImageDrawCross(Image, Bitmap.Width div 2, Bitmap.Height div 2, Size, 0, 2, 1, FillColor);

          Bitmap.LoadFromIntfImage(Image);
        finally
          Image.Free();
        end;

        Canvas.Draw(X, Y, Bitmap);
      finally
        Bitmap.Free();
      end;
    end;
  end;
end;

procedure DrawTriangleThumb(Canvas: TCanvas; X, Y, Width, Height: Integer; Orientation: TTurboTriangleThumbOrientation; FillColor, StrokeColor: TColor);
var
  Bitmap: TBitmap;
  Image: TLazIntfImage;
  X1, Y1, X2, Y2, X3, Y3: Double;
  LineWidth: Double;
begin
  if (Width >= 10) and (Height >= 10) then
  begin
    LineWidth := 1.7;
  end else
  begin
    LineWidth := 1.2;
  end;

  case Orientation of
    TTurboTriangleThumbOrientation.Up:
    begin
      X1 := (Width - 1.0) / 2.0;
      Y1 := 0.0;
      X2 := 0.0;
      Y2 := Height - 1.0;
      X3 := Width - 1.0;
      Y3 := Height - 1.0;
    end;

    TTurboTriangleThumbOrientation.Down:
    begin
      X1 := 0.0;
      Y1 := 0.0;
      X2 := Width - 1.0;
      Y2 := 0.0;
      X3 := (Width - 1.0) / 2.0;
      Y3 := Height - 1.0;
    end;

    TTurboTriangleThumbOrientation.Left:
    begin
      X1 := Width - 1.0;
      Y1 := 0.0;
      X2 := 0.0;
      Y2 := (Height - 1.0) / 2.0;
      X3 := Width - 1.0;
      Y3 := Height - 1.0;
    end;

    TTurboTriangleThumbOrientation.Right:
    begin
      X1 := 0.0;
      Y1 := 0.0;
      X2 := Width - 1.0;
      Y2 := (Height - 1.0) / 2.0;
      X3 := 0.0;
      Y3 := Height - 1.0;
    end;
  end;

  Bitmap := TBitmap.Create();
  try
    Bitmap.PixelFormat := pf32bit;
    Bitmap.SetSize(Width, Height);

    Image := Bitmap.CreateIntfImage();
    try
      Image.FillPixels(FPColor(0, 0, 0, 0));

      ImageFillTriangle(Image, X1, Y1, X2, Y2, X3, Y3, FillColor);
      ImageStrokeTriangleAA(Image, X1, Y1, X2, Y2, X3, Y3, LineWidth, StrokeColor);

      Bitmap.LoadFromIntfImage(Image);
    finally
      Image.Free();
    end;

    Canvas.Draw(X, Y, Bitmap);
  finally
    Bitmap.Free();
  end;
end;

procedure DrawRectangleThumb(Canvas: TCanvas; X, Y, Width, Height: Integer; FillColor, StrokeColor, ValueColor: TColor);
var
  Bitmap: TBitmap;
  Image: TLazIntfImage;
begin
  Bitmap := TBitmap.Create();
  try
    Bitmap.PixelFormat := pf32bit;
    Bitmap.SetSize(Width, Height);

    Image := Bitmap.CreateIntfImage();
    try
      Image.FillPixels(FPColor(0, 0, 0, 0));

      if (Width > 8) and (Height > 8) then
      begin
        ImageFillRect(Image, 0, 0, Width, Height, StrokeColor);
        ImageFillRect(Image, 1, 1, Width - 2, Height - 2, BlendColor(StrokeColor, FillColor, 127));
        ImageFillRect(Image, 2, 2, Width - 4, Height - 4, FillColor);

        if ValueColor <> clNone then
        begin
          ImageFillRect(Image, 3, 3, Width - 6, Height - 6, ValueColor);
        end;
      end else
      begin
        ImageFillRect(Image, 0, 0, Width, Height, StrokeColor);
        ImageFillRect(Image, 1, 1, Width - 2, Height - 2, FillColor);

        if ValueColor <> clNone then
        begin
          ImageFillRect(Image, 2, 2, Width - 4, Height - 4, ValueColor);
        end;
      end;

      Bitmap.LoadFromIntfImage(Image);
    finally
      Image.Free();
    end;

    Canvas.Draw(X, Y, Bitmap);
  finally
    Bitmap.Free();
  end;
end;

procedure DrawAxisLine(Canvas: TCanvas; X, Y, Size: Integer; IsVertical: Boolean; FillColor, StrokeColor: TColor; Opacity: Byte);
var
  Bitmap: TBitmap;
  Image: TLazIntfImage;
begin
  Bitmap := TBitmap.Create();
  try
    Bitmap.PixelFormat := pf32bit;
    if IsVertical then
    begin
      Bitmap.SetSize(3, Size);
    end else
    begin
      Bitmap.SetSize(Size, 3);
    end;

    Image := Bitmap.CreateIntfImage();
    try
      Image.FillPixels(FPColor(0, 0, 0, 0));

      if IsVertical then
      begin
        ImageFillRect(Image, 0, 0, 3, Size, StrokeColor);
        ImageFillRect(Image, 1, 0, 1, Size, FillColor);
      end else
      begin
        ImageFillRect(Image, 0, 0, Size, 3, StrokeColor);
        ImageFillRect(Image, 0, 1, Size, 1, FillColor);
      end;

      ApplyImageOpacity(Image, Opacity);

      Bitmap.LoadFromIntfImage(Image);
    finally
      Image.Free();
    end;

    if IsVertical then
    begin
      Canvas.Draw(X - 1, Y, Bitmap);
    end else
    begin
      Canvas.Draw(X, Y - 1, Bitmap);
    end;
  finally
    Bitmap.Free();
  end;
end;

procedure DrawInvertAxisLine(Canvas: TCanvas; X, Y, Size: Integer; IsVertical: Boolean; DashSize: Integer; Color1, Color2: TColor);
var
  Bitmap: TBitmap;
  Image: TLazIntfImage;
  FPColor1, FPColor2: TFPColor;
  I: Integer;
begin
  FPColor1 := TColorToFPColor(Color1);
  FPColor2 := TColorToFPColor(Color2);

  Bitmap := TBitmap.Create();
  try
    Bitmap.PixelFormat := pf24bit;
    if IsVertical then
    begin
      Bitmap.SetSize(1, Size);
    end else
    begin
      Bitmap.SetSize(Size, 1);
    end;

    Image := Bitmap.CreateIntfImage();
    try
      Image.FillPixels(FPColor(0, 0, 0));

      if IsVertical then
      begin
        for I := 0 to Size - 1 do
        begin
          if Odd(I div DashSize) then
          begin
            Image.SetInternalColorProc(0, I, FPColor2);
          end else
          begin
            Image.SetInternalColorProc(0, I, FPColor1);
          end;
        end;
      end else
      begin
        for I := 0 to Size - 1 do
        begin
          if Odd(I div DashSize) then
          begin
            Image.SetInternalColorProc(I, 0, FPColor2);
          end else
          begin
            Image.SetInternalColorProc(I, 0, FPColor1);
          end;
        end;      end;

      Bitmap.LoadFromIntfImage(Image);
    finally
      Image.Free();
    end;

    BitBlt(Canvas.Handle, X, Y, Bitmap.Width, Bitmap.Height, Bitmap.Canvas.Handle, 0, 0, SRCINVERT);
  finally
    Bitmap.Free();
  end;
end;

procedure DrawFrameRect(Canvas: TCanvas; FrameRect: TRect; Width: Integer; Color: TColor);
var
  State: TTurboCanvasState;
  I: Integer;
begin
  State := SaveCanvasState(Canvas, [TTurboCanvasObject.Brush]);
  try
    Canvas.Brush.Color := Color;
    for I := 0 to Width - 1 do
    begin
      Canvas.FrameRect(FrameRect);
      InflateRect(FrameRect, -1, -1);
    end;
  finally
    RestoreCanvasState(Canvas, State);
  end;
end;

function AlphaBackgroundCase(Kind: TTurboTransparentBackgroundKind; Size: Integer; X, Y: Integer): Boolean; inline;
begin
  case Kind of
    TTurboTransparentBackgroundKind.Chess:
    begin
      Result := Boolean(((X div Size) xor (Y div Size)) and 1);
    end;
    TTurboTransparentBackgroundKind.Diagonal:
    begin
      Result := Boolean((((X - Y) - Ord((X - Y) < 0) * (Size - 1)) div Size) and 1);
    end;
  end;
end;

procedure DrawColorPreviewRect(Canvas: TCanvas; Rect: TRect; Color: TColor; Alpha: Byte; Kind: TTurboTransparentBackgroundKind; CellSize: Integer; CellColor1, CellColor2: TColor);
var
  Image: TLazIntfImage;
  Bitmap: TBitmap;
  X, Y: Integer;
  FPColors: array [Boolean] of TFPColor;
begin
  FPColors[False] := TColorToFPColor(BlendColor(CellColor1, Color, Alpha));
  FPColors[True] := TColorToFPColor(BlendColor(CellColor2, Color, Alpha));
  Bitmap := TBitmap.Create();
  try
    Bitmap.SetSize(Rect.Width, Rect.Height);

    Image := Bitmap.CreateIntfImage();
    try
      for Y := 0 to Image.Height - 1 do
      begin
        for X := 0 to Image.Width - 1 do
        begin
          Image.SetInternalColorProc(X, Y, FPColors[AlphaBackgroundCase(Kind, CellSize, X, Y)]);
        end;
      end;
      Bitmap.LoadFromIntfImage(Image);
    finally
      Image.Free();
    end;
    Canvas.Draw(Rect.Left, Rect.Top, Bitmap);
  finally
    Bitmap.Free();
  end;
end;

procedure DrawSelectionFrame(Canvas: TCanvas; Rect: TRect; ColorOuter, ColorInner: TColor; Alpha: Byte);
var
  Image: TLazIntfImage;
  Bitmap: TBitmap;
begin
  Bitmap := TBitmap.Create();
  try
    Bitmap.PixelFormat := pf32bit;
    Bitmap.SetSize(Rect.Width, Rect.Height);
    Image := Bitmap.CreateIntfImage();
    try
      Image.FillPixels(FPColor(0, 0, 0, 0));


      ImageStrokeRect(Image, 0, 0, Bitmap.Width, Bitmap.Height, 1, ColorOuter);
      //ImageStrokeRect(Image, 1, 1, Bitmap.Width - 2, Bitmap.Height - 2, 1, BlendColor(ColorOuter, ColorInner, 127));
      ImageStrokeRect(Image, 1, 1, Bitmap.Width - 2, Bitmap.Height - 2, 1, ColorInner);

      ApplyImageOpacity(Image, Alpha);

      Bitmap.LoadFromIntfImage(Image);
    finally
      Image.Free();
    end;

    Canvas.Draw(Rect.Left, Rect.Top, Bitmap);
  finally
    Bitmap.Free();
  end;
end;

end.

