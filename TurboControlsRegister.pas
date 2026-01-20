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

unit TurboControlsRegister;

{$MODE DELPHIUNICODE}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$OVERFLOWCHECKS ON}
{$OPTIMIZATION ON}
{$SCOPEDENUMS ON}

interface

uses
  Classes, SysUtils, TurboPickers;

{$R 'icons.rc' 'icons.res'}

procedure Register();

implementation

procedure Register();
begin
  RegisterComponents('TurboControls', [
    TTurboColorCell,
    TTurboAlphaLinePicker,
    TTurboRgbLinePicker,
    TTurboRgbAxisPicker,
    TTurboHslLinePicker,
    TTurboHslAxisPicker,
    TTurboHsvLinePicker,
    TTurboHsvAxisPicker
  ]);
end;

end.

