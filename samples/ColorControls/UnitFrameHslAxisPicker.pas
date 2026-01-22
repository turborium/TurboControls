unit UnitFrameHslAxisPicker;

{$MODE DELPHIUNICODE}

interface

uses
  Classes, SysUtils, TypInfo, Forms, Controls, StdCtrls, Spin, TurboPickers, TurboExternalGraphics;

type

  { TFrameHslAxisPicker }

  TFrameHslAxisPicker = class(TFrame)
    AlphaLinePicker: TTurboAlphaLinePicker;
    CheckBoxPositionLineVisible: TCheckBox;
    ColorCellPreview: TTurboColorCell;
    ComboBoxAxisPickerLayout: TComboBox;
    ComboBoxAxisPickerThumbKind: TComboBox;
    GroupBoxAxisPickerOptions: TGroupBox;
    GroupBoxAlpha: TGroupBox;
    GroupBoxHsl: TGroupBox;
    GroupBoxPreview: TGroupBox;
    GroupBoxRgb: TGroupBox;
    LabelAxisPickerLayout: TLabel;
    LabelAxisPickerThumbKind: TLabel;
    LabelAlpha: TLabel;
    LabelBlue: TLabel;
    LabelGreen: TLabel;
    LabelRed: TLabel;
    RgbLinePickerBlue: TTurboRgbLinePicker;
    RgbLinePickerGreen: TTurboRgbLinePicker;
    RgbLinePickerRed: TTurboRgbLinePicker;
    SpinEditAlpha: TSpinEdit;
    SpinEditBlue: TSpinEdit;
    SpinEditGreen: TSpinEdit;
    SpinEditRed: TSpinEdit;
    HslAxisPicker: TTurboHslAxisPicker;
    HslLinePickerHue: TTurboHslLinePicker;
    procedure AlphaLinePickerChange(Sender: TObject);
    procedure CheckBoxPositionLineVisibleChange(Sender: TObject);
    procedure ComboBoxAxisPickerLayoutChange(Sender: TObject);
    procedure ComboBoxAxisPickerThumbKindChange(Sender: TObject);
    procedure HslPickerChange(Sender: TObject);
    procedure RgbLinePickerChange(Sender: TObject);
    procedure SpinEditAlphaChange(Sender: TObject);
    procedure SpinEditRgbChange(Sender: TObject);
  private
    FUpdating: Boolean;
    procedure ImmediateUpdateSpinEdit(SpinEdit: TSpinEdit; Value: Integer);
    procedure UpdateAlpha(Alpha: Byte);
    procedure UpdateHsl(Hue, Saturation, Lightness: Double);
    procedure UpdateRgb(Red, Green, Blue: Byte);
    procedure UpdateAxisPickerThumbKind(Value: TTurboAxisPickerThumbKind);
    procedure UpdateAxisPickerLayout(Value: TTurboAxisPickerLayout);
    procedure UpdateAxisPositionLineVisible(Value: Boolean);
  public
    constructor Create(Owner: TComponent); override;
  end;

implementation

{$R *.lfm}

{ TFrameHslAxisPicker }

constructor TFrameHslAxisPicker.Create(Owner: TComponent);
var
  I: Integer;
begin
  inherited Create(Owner);

  Caption := 'HSL AxisPicker';

  // TTurboAxisPickerThumbKind
  for I := 0 to Ord(High(TTurboAxisPickerThumbKind)) do
  begin
    ComboBoxAxisPickerThumbKind.Items.Add(GetEnumName(TypeInfo(TTurboAxisPickerThumbKind), I));
  end;
  // TTurboAxisPickerLayout
  for I := 0 to Ord(High(TTurboAxisPickerLayout)) do
  begin
    ComboBoxAxisPickerLayout.Items.Add(GetEnumName(TypeInfo(TTurboAxisPickerLayout), I));
  end;

  UpdateHsl(0.5, 0.5, 0.5);
  UpdateAlpha(255);

  UpdateAxisPickerThumbKind(TTurboAxisPickerThumbKind.Circle);
  UpdateAxisPickerLayout(TTurboAxisPickerLayout.OverlapThumb);
  UpdateAxisPositionLineVisible(False);
end;

procedure TFrameHslAxisPicker.UpdateAlpha(Alpha: Byte);
begin
  // update Alpha
  AlphaLinePicker.Alpha := Alpha;
  ImmediateUpdateSpinEdit(SpinEditAlpha, Alpha);

  // update Preview
  ColorCellPreview.AlphaPreview := Alpha;
end;

procedure TFrameHslAxisPicker.UpdateHsl(Hue, Saturation, Lightness: Double);
begin
  if FUpdating then
  begin
    exit;
  end;

  FUpdating := True;
  try
    // update Saturation and Lightness
    HslAxisPicker.SetHsl(Hue, Saturation, Lightness);

    // update Hue
    HslLinePickerHue.SetHsl(Hue, Saturation, Lightness);

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

procedure TFrameHslAxisPicker.UpdateRgb(Red, Green, Blue: Byte);
var
  Hue, Saturation, Lightness: Double;
begin
  // make HSL from RGB
  RgbToHsl(Red, Green, Blue, Hue, Saturation, Lightness);

  // Trick: save old params for white and black
  if (Lightness = 1.0) or (Lightness = 0.0) then
  begin
    Hue := HslLinePickerHue.Hue;
    Saturation := HslAxisPicker.Saturation;
  end;

  // update
  UpdateHsl(Hue, Saturation, Lightness);
end;

procedure TFrameHslAxisPicker.UpdateAxisPickerThumbKind(Value: TTurboAxisPickerThumbKind);
begin
  ComboBoxAxisPickerThumbKind.ItemIndex := Ord(Value);
  HslAxisPicker.ThumbKind := Value;
end;

procedure TFrameHslAxisPicker.UpdateAxisPickerLayout(Value: TTurboAxisPickerLayout);
begin
  ComboBoxAxisPickerLayout.ItemIndex := Ord(Value);
  HslAxisPicker.Layout := Value;
end;

procedure TFrameHslAxisPicker.UpdateAxisPositionLineVisible(Value: Boolean);
begin
  HslAxisPicker.PositionLineVisible := Value;
end;

procedure TFrameHslAxisPicker.HslPickerChange(Sender: TObject);
begin
  UpdateHsl(HslLinePickerHue.Hue, HslAxisPicker.Saturation, HslAxisPicker.Lightness);
end;

procedure TFrameHslAxisPicker.AlphaLinePickerChange(Sender: TObject);
begin
  UpdateAlpha(AlphaLinePicker.Alpha);
end;

procedure TFrameHslAxisPicker.CheckBoxPositionLineVisibleChange(Sender: TObject);
begin
  UpdateAxisPositionLineVisible(CheckBoxPositionLineVisible.Checked);
end;

procedure TFrameHslAxisPicker.ComboBoxAxisPickerLayoutChange(Sender: TObject);
begin
  UpdateAxisPickerLayout(TTurboAxisPickerLayout(ComboBoxAxisPickerLayout.ItemIndex));
end;

procedure TFrameHslAxisPicker.ComboBoxAxisPickerThumbKindChange(Sender: TObject);
begin
  UpdateAxisPickerThumbKind(TTurboAxisPickerThumbKind(ComboBoxAxisPickerThumbKind.ItemIndex));
end;

procedure TFrameHslAxisPicker.RgbLinePickerChange(Sender: TObject);
begin
  UpdateRgb(RgbLinePickerRed.Red, RgbLinePickerGreen.Green, RgbLinePickerBlue.Blue);
end;

procedure TFrameHslAxisPicker.SpinEditAlphaChange(Sender: TObject);
begin
  UpdateAlpha(SpinEditAlpha.Value);
end;

procedure TFrameHslAxisPicker.SpinEditRgbChange(Sender: TObject);
begin
  UpdateRgb(SpinEditRed.Value, SpinEditGreen.Value, SpinEditBlue.Value);
end;

procedure TFrameHslAxisPicker.ImmediateUpdateSpinEdit(SpinEdit: TSpinEdit; Value: Integer);
begin
  if SpinEdit.Value <> Value then
  begin
    SpinEdit.Value := Value;
    SpinEdit.Repaint();
  end;
end;

end.

