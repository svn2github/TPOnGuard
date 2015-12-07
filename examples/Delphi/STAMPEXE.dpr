program Stampexe;

uses
  Forms,
  STAMPEX1 in 'STAMPEX1.PAS' {frmStamp},
  ogstamp in '..\..\source\ogstamp.pas';

begin
  Application.CreateForm(TfrmStamp, frmStamp);
  Application.Run;
end.
