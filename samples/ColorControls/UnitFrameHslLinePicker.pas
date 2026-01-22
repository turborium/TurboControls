unit UnitFrameHslLinePicker;

{$MODE DELPHIUNICODE}

interface

uses
  Classes, SysUtils, Forms, Controls, ComCtrls, StdCtrls, Spin, TurboPickers, TurboExternalGraphics;

type

  { TFrameHslLinePicker }

  TFrameHslLinePicker = class(TFrame)
    AlphaLinePicker: TTurboAlphaLinePicker;
    CheckBoxAlphaModulation: TCheckBox;
    CheckBoxColorModulation: TCheckBox;
    GroupBoxAlpha: TGroupBox;
    GroupBoxPreview: TGroupBox;
    GroupBoxHsl: TGroupBox;
    GroupBoxRgb: TGroupBox;
    HslLinePickerHue: TTurboHslLinePicker;
    HslLinePickerLightness: TTurboHslLinePicker;
    HslLinePickerSaturation: TTurboHslLinePicker;
    LabelAlpha: TLabel;
    LabelBlue: TLabel;
    LabelGreen: TLabel;
    LabelHue: TLabel;
    LabelLightness: TLabel;
    LabelRed: TLabel;
    LabelSaturation: TLabel;
    GroupBoxOptions: TGroupBox;
    RgbLinePickerBlue: TTurboRgbLinePicker;
    RgbLinePickerGreen: TTurboRgbLinePicker;
    RgbLinePickerRed: TTurboRgbLinePicker;
    SpinEditAlpha: TSpinEdit;
    SpinEditBlue: TSpinEdit;
    SpinEditGreen: TSpinEdit;
    SpinEditHue: TFloatSpinEdit;
    SpinEditLightness: TFloatSpinEdit;
    SpinEditRed: TSpinEdit;
    SpinEditSaturation: TFloatSpinEdit;
    ColorCellPreview: TTurboColorCell;
    procedure AlphaLinePickerChange(Sender: TObject);
    procedure CheckBoxAlphaModulationChange(Sender: TObject);
    procedure CheckBoxColorModulationChange(Sender: TObject);
    procedure HslLinePickerChange(Sender: TObject);
    procedure RgbLinePickerChange(Sender: TObject);
    procedure SpinEditAlphaChange(Sender: TObject);
    procedure SpinEditHslChange(Sender: TObject);
    procedure SpinEditRgbChange(Sender: TObject);
  private
    FUpdating: Boolean;
    procedure ImmediateUpdateFloatSpinEdit(SpinEdit: TFloatSpinEdit; Value: Double);
    procedure ImmediateUpdateSpinEdit(SpinEdit: TSpinEdit; Value: Integer);
    procedure UpdateAlpha(Alpha: Byte);
    procedure UpdateHsl(Hue, Saturation, Lightness: Double);
    procedure UpdateRgb(Red, Green, Blue: Byte);
    procedure UpdateAlphaModulation(AlphaModulation: Boolean);
    procedure UpdateColorModulation(ColorModulation: Boolean);
  public
    constructor Create(Owner: TComponent); override;
  end;

implementation

{$R *.lfm}

{ TFrameHslLinePicker }

constructor TFrameHslLinePicker.Create(Owner: TComponent);
begin
  inherited Create(Owner);

  Caption := 'HSL LinePicker';

  UpdateHsl(0.5, 0.5, 0.5);
  UpdateAlpha(255);

  UpdateAlphaModulation(False);
  UpdateColorModulation(True);
end;

procedure TFrameHslLinePicker.HslLinePickerChange(Sender: TObject);
begin
  UpdateHsl(HslLinePickerHue.Hue, HslLinePickerSaturation.Saturation, HslLinePickerLightness.Lightness);
end;

procedure TFrameHslLinePicker.AlphaLinePickerChange(Sender: TObject);
begin
  UpdateAlpha(AlphaLinePicker.Alpha);
end;

procedure TFrameHslLinePicker.CheckBoxAlphaModulationChange(Sender: TObject);
begin
  UpdateAlphaModulation(CheckBoxAlphaModulation.Checked);
end;

procedure TFrameHslLinePicker.CheckBoxColorModulationChange(Sender: TObject);
begin
  UpdateColorModulation(CheckBoxColorModulation.Checked);
end;

procedure TFrameHslLinePicker.RgbLinePickerChange(Sender: TObject);
begin
  UpdateRgb(RgbLinePickerRed.Red, RgbLinePickerGreen.Green, RgbLinePickerBlue.Blue);
end;

procedure TFrameHslLinePicker.SpinEditAlphaChange(Sender: TObject);
begin
  UpdateAlpha(SpinEditAlpha.Value);
end;

procedure TFrameHslLinePicker.SpinEditHslChange(Sender: TObject);
begin
  UpdateHsl(SpinEditHue.Value, SpinEditSaturation.Value, SpinEditLightness.Value);
end;

procedure TFrameHslLinePicker.SpinEditRgbChange(Sender: TObject);
begin
  UpdateRgb(SpinEditRed.Value, SpinEditGreen.Value, SpinEditBlue.Value);
end;

procedure TFrameHslLinePicker.UpdateHsl(Hue, Saturation, Lightness: Double);
begin
  if FUpdating then
  begin
    exit;
  end;

  FUpdating := True;
  try
    // update Hue
    HslLinePickerHue.SetHsl(Hue, Saturation, Lightness);
    ImmediateUpdateFloatSpinEdit(SpinEditHue, Hue);

    // update Saturation
    HslLinePickerSaturation.SetHsl(Hue, Saturation, Lightness);
    ImmediateUpdateFloatSpinEdit(SpinEditSaturation, Saturation);

    // update Lightness
    HslLinePickerLightness.SetHsl(Hue, Saturation, Lightness);
    ImmediateUpdateFloatSpinEdit(SpinEditLightness, Lightness);

    // update Red
    RgbLinePickerRed.SetHsl(Hue, Saturation, Lightness);
    ImmediateUpdateSpinEdit(SpinEditRed, RgbLinePickerRed.Red);

    // update Green
    RgbLinePickerGreen.SetHsl(Hue, Saturation, Lightness);
    ImmediateUpdateSpinEdit(SpinEditGreen, RgbLinePickerGreen.Green);

    // update Blue
    RgbLinePickerBlue.SetHsl(Hue, Saturation, Lightness);
    ImmediateUpdateSpinEdit(SpinEditBlue, RgbLinePickerBlue.Blue);

    // update Alpha
    AlphaLinePicker.SetHslPreview(Hue, Saturation, Lightness);

    // update Preview
    ColorCellPreview.SetHsl(Hue, Saturation, Lightness);
  finally
    FUpdating := False;
  end;
end;

procedure TFrameHslLinePicker.UpdateRgb(Red, Green, Blue: Byte);
var
  Hue, Saturation, Lightness: Double;
begin
  // make HSL from RGB
  RgbToHsl(Red, Green, Blue, Hue, Saturation, Lightness);

  // Trick: save old params for white and black
  if (Lightness = 1.0) or (Lightness = 0.0) then
  begin
    Hue := HslLinePickerHue.Hue;
    Saturation := HslLinePickerSaturation.Saturation;
  end;

  // update
  UpdateHsl(Hue, Saturation, Lightness);
end;

procedure TFrameHslLinePicker.UpdateAlphaModulation(AlphaModulation: Boolean);
begin
  CheckBoxAlphaModulation.Checked := AlphaModulation;

  // update Hue
  HslLinePickerHue.AlphaModulation := AlphaModulation;

  // update Saturation
  HslLinePickerSaturation.AlphaModulation := AlphaModulation;

  // update Lightness
  HslLinePickerLightness.AlphaModulation := AlphaModulation;

  // update Red
  RgbLinePickerRed.AlphaModulation := AlphaModulation;

  // update Green
  RgbLinePickerGreen.AlphaModulation := AlphaModulation;

  // update Blue
  RgbLinePickerBlue.AlphaModulation := AlphaModulation;
end;

procedure TFrameHslLinePicker.UpdateColorModulation(ColorModulation: Boolean);
begin
  CheckBoxColorModulation.Checked := ColorModulation;

  // update Red
  RgbLinePickerRed.ColorModulation := ColorModulation;

  // update Green
  RgbLinePickerGreen.ColorModulation := ColorModulation;

  // update Blue
  RgbLinePickerBlue.ColorModulation := ColorModulation;
end;

procedure TFrameHslLinePicker.UpdateAlpha(Alpha: Byte);
begin
  // update Alpha
  AlphaLinePicker.Alpha := Alpha;
  ImmediateUpdateSpinEdit(SpinEditAlpha, Alpha);

  // update Preview
  ColorCellPreview.AlphaPreview := Alpha;

  // update Hue
  HslLinePickerHue.AlphaPreview := Alpha;

  // update Saturation
  HslLinePickerSaturation.AlphaPreview := Alpha;

  // update Lightness
  HslLinePickerLightness.AlphaPreview := Alpha;

  // update Red
  RgbLinePickerRed.AlphaPreview := Alpha;

  // update Green
  RgbLinePickerGreen.AlphaPreview := Alpha;

  // update Blue
  RgbLinePickerBlue.AlphaPreview := Alpha;
end;

procedure TFrameHslLinePicker.ImmediateUpdateFloatSpinEdit(SpinEdit: TFloatSpinEdit; Value: Double);
begin
  if SpinEdit.Value <> Value then
  begin
    SpinEdit.Value := Value;
    SpinEdit.Repaint();
  end;
end;

procedure TFrameHslLinePicker.ImmediateUpdateSpinEdit(SpinEdit: TSpinEdit; Value: Integer);
begin
  if SpinEdit.Value <> Value then
  begin
    SpinEdit.Value := Value;
    SpinEdit.Repaint();
  end;
end;

end.

