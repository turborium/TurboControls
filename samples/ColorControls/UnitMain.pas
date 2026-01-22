unit UnitMain;

{$MODE DELPHIUNICODE}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls,
  UnitFrameHslLinePicker, UnitFrameHsvLinePicker, UnitFrameHslAxisPicker, UnitFrameHsvAxisPicker, UnitFrameClassicPicker;

type

  { TFormMain }

  TFormMain = class(TForm)
    PageControl: TPageControl;
    procedure FormCreate(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
  private
    FFrames: array of TFrame;
    procedure SetPage(Index: Integer);
  public

  end;

type
  TFrameClass = class of TFrame;

const
  FrameClasses: array of TFrameClass = [
    TFrameHslLinePicker,
    TFrameHsvLinePicker,
    TFrameHslAxisPicker,
    TFrameHsvAxisPicker,
    TFrameClassicPicker
  ];

var
  FormMain: TFormMain;

implementation

{$R *.lfm}

{ TFormMain }

procedure TFormMain.FormCreate(Sender: TObject);
var
  Frame: TFrame;
  FrameClass: TFrameClass;
  TabSheet: TTabSheet;
begin
  // create frames by FrameClasses
  for FrameClass in FrameClasses do
  begin
    Frame := FrameClass.Create(Self);
    Frame.Name := '';
    Frame.Align := alClient;
    FFrames := FFrames + [Frame];
  end;

  // insert frames to page control
  for Frame in FFrames do
  begin
    TabSheet := PageControl.AddTabSheet();
    TabSheet.Caption := Frame.Caption;
    TabSheet.InsertControl(Frame);
  end;

  SetPage(0);
end;

procedure TFormMain.PageControlChange(Sender: TObject);
begin
  SetPage(PageControl.PageIndex);
end;

procedure TFormMain.SetPage(Index: Integer);
var
  I: Integer;
begin
  PageControl.PageIndex := Index;
  for I := 0 to PageControl.PageCount - 1 do
  begin
    PageControl.Pages[I].Controls[0].Visible := Index = I;
  end;
end;

end.

