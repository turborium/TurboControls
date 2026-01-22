unit UnitFrameHsvAxisPicker;

{$MODE DELPHIUNICODE}

interface

uses
  Classes, SysUtils, TypInfo, Forms, Controls, StdCtrls, Spin, TurboPickers, TurboExternalGraphics;

type

  { TFrameHsvAxisPicker }

  TFrameHsvAxisPicker = class(TFrame)
    AlphaLinePicker: TTurboAlphaLinePicker;
    CheckBoxPositionLineVisible: TCheckBox;
    ColorCellPreview: TTurboColorCell;
    ComboBoxAxisPickerLayout: TComboBox;
    ComboBoxAxisPickerThumbKind: TComboBox;
    GroupBoxAxisPickerOptions: TGroupBox;
    GroupBoxAlpha: TGroupBox;
    GroupBoxHsv: TGroupBox;
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
    HsvAxisPicker: TTurboHsvAxisPicker;
    HsvLinePickerHue: TTurboHsvLinePicker;
    procedure AlphaLinePickerChange(Sender: TObject);
    procedure CheckBoxPositionLineVisibleChange(Sender: TObject);
    procedure ComboBoxAxisPickerLayoutChange(Sender: TObject);
    procedure ComboBoxAxisPickerThumbKindChange(Sender: TObject);
    procedure HsvPickerChange(Sender: TObject);
    procedure RgbLinePickerChange(Sender: TObject);
    procedure SpinEditAlphaChange(Sender: TObject);
    procedure SpinEditRgbChange(Sender: TObject);
  private
    FUpdating: Boolean;
    procedure ImmediateUpdateSpinEdit(SpinEdit: TSpinEdit; Value: Integer);
    procedure UpdateAlpha(Alpha: Byte);
    procedure UpdateHsv(Hue, Saturation, Value: Double);
    procedure UpdateRgb(Red, Green, Blue: Byte);
    procedure UpdateAxisPickerThumbKind(Value: TTurboAxisPickerThumbKind);
    procedure UpdateAxisPickerLayout(Value: TTurboAxisPickerLayout);
    procedure UpdateAxisPositionLineVisible(Value: Boolean);
  public
    constructor Create(Owner: TComponent); override;
  end;

implementation

{$R *.lfm}

{ TFrameHsvAxisPicker }

constructor TFrameHsvAxisPicker.Create(Owner: TComponent);
var
  I: Integer;
begin
  inherited Create(Owner);

  Caption := 'HSV AxisPicker';

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

  UpdateHsv(0.5, 0.5, 0.5);
  UpdateAlpha(255);

  UpdateAxisPickerThumbKind(TTurboAxisPickerThumbKind.Circle);
  UpdateAxisPickerLayout(TTurboAxisPickerLayout.OverlapThumb);
  UpdateAxisPositionLineVisible(False);
end;

procedure TFrameHsvAxisPicker.UpdateAlpha(Alpha: Byte);
begin
  // update Alpha
  AlphaLinePicker.Alpha := Alpha;
  ImmediateUpdateSpinEdit(SpinEditAlpha, Alpha);

  // update Preview
  ColorCellPreview.AlphaPreview := Alpha;
end;

procedure TFrameHsvAxisPicker.UpdateHsv(Hue, Saturation, Value: Double);
begin
  if FUpdating then
  begin
    exit;
  end;

  FUpdating := True;
  try
    // update Saturation and Value
    HsvAxisPicker.SetHsv(Hue, Saturation, Value);

    // update Hue
    HsvLinePickerHue.SetHsv(Hue, Saturation, Value);

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

procedure TFrameHsvAxisPicker.UpdateRgb(Red, Green, Blue: Byte);
var
  Hue, Saturation, Value: Double;
begin
  // make HSV from RGB
  RgbToHsv(Red, Green, Blue, Hue, Saturation, Value);

  // Trick: save old params for white and black
  if ((Value = 1.0) and (Saturation = 0.0)) or (Value = 0.0) then
  begin
    Hue := HsvLinePickerHue.Hue;
    Saturation := HsvAxisPicker.Saturation;
  end;

  // update
  UpdateHsv(Hue, Saturation, Value);
end;

procedure TFrameHsvAxisPicker.UpdateAxisPickerThumbKind(Value: TTurboAxisPickerThumbKind);
begin
  ComboBoxAxisPickerThumbKind.ItemIndex := Ord(Value);
  HsvAxisPicker.ThumbKind := Value;
end;

procedure TFrameHsvAxisPicker.UpdateAxisPickerLayout(Value: TTurboAxisPickerLayout);
begin
  ComboBoxAxisPickerLayout.ItemIndex := Ord(Value);
  HsvAxisPicker.Layout := Value;
end;

procedure TFrameHsvAxisPicker.UpdateAxisPositionLineVisible(Value: Boolean);
begin
  HsvAxisPicker.PositionLineVisible := Value;
end;

procedure TFrameHsvAxisPicker.HsvPickerChange(Sender: TObject);
begin
  UpdateHsv(HsvLinePickerHue.Hue, HsvAxisPicker.Saturation, HsvAxisPicker.Value);
end;

procedure TFrameHsvAxisPicker.AlphaLinePickerChange(Sender: TObject);
begin
  UpdateAlpha(AlphaLinePicker.Alpha);
end;

procedure TFrameHsvAxisPicker.CheckBoxPositionLineVisibleChange(Sender: TObject);
begin
  UpdateAxisPositionLineVisible(CheckBoxPositionLineVisible.Checked);
end;

procedure TFrameHsvAxisPicker.ComboBoxAxisPickerLayoutChange(Sender: TObject);
begin
  UpdateAxisPickerLayout(TTurboAxisPickerLayout(ComboBoxAxisPickerLayout.ItemIndex));
end;

procedure TFrameHsvAxisPicker.ComboBoxAxisPickerThumbKindChange(Sender: TObject);
begin
  UpdateAxisPickerThumbKind(TTurboAxisPickerThumbKind(ComboBoxAxisPickerThumbKind.ItemIndex));
end;

procedure TFrameHsvAxisPicker.RgbLinePickerChange(Sender: TObject);
begin
  UpdateRgb(RgbLinePickerRed.Red, RgbLinePickerGreen.Green, RgbLinePickerBlue.Blue);
end;

procedure TFrameHsvAxisPicker.SpinEditAlphaChange(Sender: TObject);
begin
  UpdateAlpha(SpinEditAlpha.Value);
end;

procedure TFrameHsvAxisPicker.SpinEditRgbChange(Sender: TObject);
begin
  UpdateRgb(SpinEditRed.Value, SpinEditGreen.Value, SpinEditBlue.Value);
end;

procedure TFrameHsvAxisPicker.ImmediateUpdateSpinEdit(SpinEdit: TSpinEdit; Value: Integer);
begin
  if SpinEdit.Value <> Value then
  begin
    SpinEdit.Value := Value;
    SpinEdit.Repaint();
  end;
end;

end.

