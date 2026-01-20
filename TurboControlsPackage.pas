{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit TurboControlsPackage;

{$warn 5023 off : no warning about unused units}
interface

uses
  TurboControls, TurboExternalGraphics, TurboPickers, TurboControlsRegister, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('TurboControlsRegister', @TurboControlsRegister.Register);
end;

initialization
  RegisterPackage('TurboControlsPackage', @Register);
end.
