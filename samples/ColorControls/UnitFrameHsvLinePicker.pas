unit UnitFrameHsvLinePicker;

{$MODE DELPHIUNICODE}

interface

uses
  Classes, SysUtils, Forms, Controls, ComCtrls, StdCtrls, Spin, TurboPickers, TurboExternalGraphics;

type

  { TFrameHsvLinePicker }

  TFrameHsvLinePicker = class(TFrame)
    AlphaLinePicker: TTurboAlphaLinePicker;
    CheckBoxAlphaModulation: TCheckBox;
    CheckBoxColorModulation: TCheckBox;
    GroupBoxAlpha: TGroupBox;
    GroupBoxPreview: TGroupBox;
    GroupBoxHsl: TGroupBox;
    GroupBoxRgb: TGroupBox;
    HsvLinePickerHue: TTurboHsvLinePicker;
    HsvLinePickerValue: TTurboHsvLinePicker;
    HsvLinePickerSaturation: TTurboHsvLinePicker;
    LabelAlpha: TLabel;
    LabelBlue: TLabel;
    LabelGreen: TLabel;
    LabelHue: TLabel;
    LabelValue: TLabel;
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
    SpinEditValue: TFloatSpinEdit;
    SpinEditRed: TSpinEdit;
    SpinEditSaturation: TFloatSpinEdit;
    ColorCellPreview: TTurboColorCell;
    procedure AlphaLinePickerChange(Sender: TObject);
    procedure CheckBoxAlphaModulationChange(Sender: TObject);
    procedure CheckBoxColorModulationChange(Sender: TObject);
    procedure HsvLinePickerChange(Sender: TObject);
    procedure RgbLinePickerChange(Sender: TObject);
    procedure SpinEditAlphaChange(Sender: TObject);
    procedure SpinEditHsvChange(Sender: TObject);
    procedure SpinEditRgbChange(Sender: TObject);
  private
    FUpdating: Boolean;
    procedure ImmediateUpdateFloatSpinEdit(SpinEdit: TFloatSpinEdit; Value: Double);
    procedure ImmediateUpdateSpinEdit(SpinEdit: TSpinEdit; Value: Integer);
    procedure UpdateAlpha(Alpha: Byte);
    procedure UpdateHsv(Hue, Saturation, Value: Double);
    procedure UpdateRgb(Red, Green, Blue: Byte);
    procedure UpdateAlphaModulation(AlphaModulation: Boolean);
    procedure UpdateColorModulation(ColorModulation: Boolean);
  public
    constructor Create(Owner: TComponent); override;
  end;

implementation

{$R *.lfm}

{ TFrameHsvLinePicker }

constructor TFrameHsvLinePicker.Create(Owner: TComponent);
begin
  inherited Create(Owner);

  Caption := 'HSV LinePicker';

  UpdateHsv(0.5, 0.5, 0.5);
  UpdateAlpha(255);

  UpdateAlphaModulation(False);
  UpdateColorModulation(True);
end;

procedure TFrameHsvLinePicker.HsvLinePickerChange(Sender: TObject);
begin
  UpdateHsv(HsvLinePickerHue.Hue, HsvLinePickerSaturation.Saturation, HsvLinePickerValue.Value);
end;

procedure TFrameHsvLinePicker.AlphaLinePickerChange(Sender: TObject);
begin
  UpdateAlpha(AlphaLinePicker.Alpha);
end;

procedure TFrameHsvLinePicker.CheckBoxAlphaModulationChange(Sender: TObject);
begin
  UpdateAlphaModulation(CheckBoxAlphaModulation.Checked);
end;

procedure TFrameHsvLinePicker.CheckBoxColorModulationChange(Sender: TObject);
begin
  UpdateColorModulation(CheckBoxColorModulation.Checked);
end;

procedure TFrameHsvLinePicker.RgbLinePickerChange(Sender: TObject);
begin
  UpdateRgb(RgbLinePickerRed.Red, RgbLinePickerGreen.Green, RgbLinePickerBlue.Blue);
end;

procedure TFrameHsvLinePicker.SpinEditAlphaChange(Sender: TObject);
begin
  UpdateAlpha(SpinEditAlpha.Value);
end;

procedure TFrameHsvLinePicker.SpinEditHsvChange(Sender: TObject);
begin
  UpdateHsv(SpinEditHue.Value, SpinEditSaturation.Value, SpinEditValue.Value);
end;

procedure TFrameHsvLinePicker.SpinEditRgbChange(Sender: TObject);
begin
  UpdateRgb(SpinEditRed.Value, SpinEditGreen.Value, SpinEditBlue.Value);
end;

procedure TFrameHsvLinePicker.UpdateHsv(Hue, Saturation, Value: Double);
begin
  if FUpdating then
  begin
    exit;
  end;

  FUpdating := True;
  try
    // update Hue
    HsvLinePickerHue.SetHsv(Hue, Saturation, Value);
    ImmediateUpdateFloatSpinEdit(SpinEditHue, Hue);

    // update Saturation
    HsvLinePickerSaturation.SetHsv(Hue, Saturation, Value);
    ImmediateUpdateFloatSpinEdit(SpinEditSaturation, Saturation);

    // update Value
    HsvLinePickerValue.SetHsv(Hue, Saturation, Value);
    ImmediateUpdateFloatSpinEdit(SpinEditValue, Value);

    // update Red
    RgbLinePickerRed.SetHsv(Hue, Saturation, Value);
    ImmediateUpdateSpinEdit(SpinEditRed, RgbLinePickerRed.Red);

    // update Green
    RgbLinePickerGreen.SetHsv(Hue, Saturation, Value);
    ImmediateUpdateSpinEdit(SpinEditGreen, RgbLinePickerGreen.Green);

    // update Blue
    RgbLinePickerBlue.SetHsv(Hue, Saturation, Value);
    ImmediateUpdateSpinEdit(SpinEditBlue, RgbLinePickerBlue.Blue);

    // update Alpha
    AlphaLinePicker.SetHsvPreview(Hue, Saturation, Value);

    // update Preview
    ColorCellPreview.SetHsv(Hue, Saturation, Value);
  finally
    FUpdating := False;
  end;
end;

procedure TFrameHsvLinePicker.UpdateRgb(Red, Green, Blue: Byte);
var
  Hue, Saturation, Value: Double;
begin
  // make HSV from RGB
  RgbToHsv(Red, Green, Blue, Hue, Saturation, Value);

  // Trick: save old params for white and black
  if ((Value = 1.0) and (Saturation = 0.0)) or (Value = 0.0) then
  begin
    Hue := HsvLinePickerHue.Hue;
    Saturation := HsvLinePickerSaturation.Saturation;
  end;

  // update
  UpdateHsv(Hue, Saturation, Value);
end;

procedure TFrameHsvLinePicker.UpdateAlphaModulation(AlphaModulation: Boolean);
begin
  CheckBoxAlphaModulation.Checked := AlphaModulation;

  // update Hue
  HsvLinePickerHue.AlphaModulation := AlphaModulation;

  // update Saturation
  HsvLinePickerSaturation.AlphaModulation := AlphaModulation;

  // update Value
  HsvLinePickerValue.AlphaModulation := AlphaModulation;

  // update Red
  RgbLinePickerRed.AlphaModulation := AlphaModulation;

  // update Green
  RgbLinePickerGreen.AlphaModulation := AlphaModulation;

  // update Blue
  RgbLinePickerBlue.AlphaModulation := AlphaModulation;
end;

procedure TFrameHsvLinePicker.UpdateColorModulation(ColorModulation: Boolean);
begin
  CheckBoxColorModulation.Checked := ColorModulation;

  // update Red
  RgbLinePickerRed.ColorModulation := ColorModulation;

  // update Green
  RgbLinePickerGreen.ColorModulation := ColorModulation;

  // update Blue
  RgbLinePickerBlue.ColorModulation := ColorModulation;
end;

procedure TFrameHsvLinePicker.UpdateAlpha(Alpha: Byte);
begin
  // update Alpha
  AlphaLinePicker.Alpha := Alpha;
  ImmediateUpdateSpinEdit(SpinEditAlpha, Alpha);

  // update Preview
  ColorCellPreview.AlphaPreview := Alpha;

  // update Hue
  HsvLinePickerHue.AlphaPreview := Alpha;

  // update Saturation
  HsvLinePickerSaturation.AlphaPreview := Alpha;

  // update Value
  HsvLinePickerValue.AlphaPreview := Alpha;

  // update Red
  RgbLinePickerRed.AlphaPreview := Alpha;

  // update Green
  RgbLinePickerGreen.AlphaPreview := Alpha;

  // update Blue
  RgbLinePickerBlue.AlphaPreview := Alpha;
end;

procedure TFrameHsvLinePicker.ImmediateUpdateFloatSpinEdit(SpinEdit: TFloatSpinEdit; Value: Double);
begin
  if SpinEdit.Value <> Value then
  begin
    SpinEdit.Value := Value;
    SpinEdit.Repaint();
  end;
end;

procedure TFrameHsvLinePicker.ImmediateUpdateSpinEdit(SpinEdit: TSpinEdit; Value: Integer);
begin
  if SpinEdit.Value <> Value then
  begin
    SpinEdit.Value := Value;
    SpinEdit.Repaint();
  end;
end;

end.

