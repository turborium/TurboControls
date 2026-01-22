unit UnitFrameClassicPicker;

{$MODE DELPHIUNICODE}

interface

uses
  Classes, SysUtils, Forms, Controls, Spin, StdCtrls, ExtCtrls, TurboPickers, TurboExternalGraphics;

type

  { TFrameClassicPicker }

  TFrameClassicPicker = class(TFrame)
    GroupBoxPalette: TGroupBox;
    HslAxisPicker: TTurboHslAxisPicker;
    HslLinePicker: TTurboHslLinePicker;
    LabelRed: TLabel;
    LabelGreen: TLabel;
    LabelBlue: TLabel;
    SpinEditBlue: TSpinEdit;
    SpinEditGreen: TSpinEdit;
    SpinEditRed: TSpinEdit;
    ColorCellPreview: TTurboColorCell;
    ColorCell1: TTurboColorCell;
    ColorCell2: TTurboColorCell;
    ColorCell3: TTurboColorCell;
    ColorCell4: TTurboColorCell;
    procedure ColorCellClick(Sender: TObject);
    procedure HslPickerChange(Sender: TObject);
    procedure SpinEditColorChange(Sender: TObject);
  private
    FUpdating: Boolean;
    procedure UpdateHsl(Hue, Saturation, Lightness: Double);
    procedure UpdateRgb(Red, Green, Blue: Byte);
  public
    constructor Create(Owner: TComponent); override;
  end;

implementation

{$R *.lfm}

{ TFrameClassicPicker }

constructor TFrameClassicPicker.Create(Owner: TComponent);
begin
  inherited Create(Owner);

  Caption := 'ClassicPicker';

  UpdateHsl(0.7, 0.3, 0.5);
end;

procedure TFrameClassicPicker.HslPickerChange(Sender: TObject);
begin
  UpdateHsl(HslAxisPicker.Hue, HslAxisPicker.Saturation, HslLinePicker.Lightness);
end;

procedure TFrameClassicPicker.ColorCellClick(Sender: TObject);
var
  R, G, B: Byte;
begin
  TTurboColorCell(Sender).GetRgb(R, G, B);
  UpdateRgb(R, G, B);
end;

procedure TFrameClassicPicker.SpinEditColorChange(Sender: TObject);
begin
  UpdateRgb(SpinEditRed.Value, SpinEditGreen.Value, SpinEditBlue.Value);
end;

procedure TFrameClassicPicker.UpdateHsl(Hue, Saturation, Lightness: Double);
var
  R, G, B: Byte;
begin
  if FUpdating then
  begin
    exit;
  end;

  FUpdating := True;
  try
    // Update line picker
    HslLinePicker.SetHsl(Hue, Saturation, Lightness);

    // Update axis picker
    HslAxisPicker.SetHsl(Hue, Saturation, 0.5);

    // update RGB
    HslToRgb(Hue, Saturation, Lightness, R, G, B);;
    SpinEditRed.Value := R;
    SpinEditGreen.Value := G;
    SpinEditBlue.Value := B;

    // update Preview
    ColorCellPreview.SetHsl(Hue, Saturation, Lightness);
  finally
    FUpdating := False;
  end;
end;


procedure TFrameClassicPicker.UpdateRgb(Red, Green, Blue: Byte);
var
  Hue, Saturation, Lightness: Double;
begin
  // make HSL from RGB
  RgbToHsl(Red, Green, Blue, Hue, Saturation, Lightness);

  // Trick: save old params for white and black
  if (Lightness = 1.0) or (Lightness = 0.0) then
  begin
    Hue := HslAxisPicker.Hue;
    Saturation := HslAxisPicker.Saturation;
  end;

  // update
  UpdateHsl(Hue, Saturation, Lightness);
end;

end.

