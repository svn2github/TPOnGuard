{form used for Serial Number/ReleaseCode input}
unit Exsrnmu2;

interface

uses
  {$IFDEF Win16} WinTypes, WinProcs, {$ELSE} Windows, {$ENDIF}
  SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons;

type
  TSNEntryDlg = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    SNText: TEdit;
    CodeText: TEdit;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Label3: TLabel;
    procedure CancelBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SNEntryDlg: TSNEntryDlg;

implementation

{$R *.DFM}

procedure TSNEntryDlg.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

end.
