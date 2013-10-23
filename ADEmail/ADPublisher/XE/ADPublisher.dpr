program ADPublisher;

uses
  Vcl.Forms,
  ufrmMain in '..\ufrmMain.pas' {frmMain},
  uCMDObject in '..\..\Common\uCMDObject.pas',
  udmMain in '..\udmMain.pas' {dmMain: TDataModule},
  ufrmLogin in '..\ufrmLogin.pas' {frmLogin},
  uIdTcpClientCMDObjectCoder in '..\..\..\Common\uIdTcpClientCMDObjectCoder.pas',
  uZipTools in '..\..\..\..\Source\Utils\uZipTools.pas',
  uIOCPProtocol in '..\..\..\..\Source\IOCP\uIOCPProtocol.pas',
  JwaMSWSock in '..\..\..\..\Source\WinSock2\JwaMSWSock.pas',
  JwaQos in '..\..\..\..\Source\WinSock2\JwaQos.pas',
  JwaWinsock2 in '..\..\..\..\Source\WinSock2\JwaWinsock2.pas',
  FileLogger in '..\..\..\..\Source\IOCP\FileLogger.pas',
  superobject in '..\..\..\Common\superobject.pas',
  uCMDConsts in '..\..\Common\uCMDConsts.pas',
  EDecryptionWrapper in '..\..\..\Common\EDecryptionWrapper.pas',
  ufrmRegister in '..\sys\ufrmRegister.pas' {frmRegister},
  ufrmUpdateEmail in '..\ufrmUpdateEmail.pas' {frmUpdateEmail},
  ufrmEmailTask in '..\ufrmEmailTask.pas' {frmEmailTask},
  uFMEmailTaskList in '..\EmailTask\uFMEmailTaskList.pas' {FMEmailTaskList: TFrame},
  uFMEmailAddrList in '..\EmailAddr\uFMEmailAddrList.pas' {FMEmailAddrList: TFrame};

{$R *.res}
var
  lvTempForm:TForm;
begin
  Application.Initialize;
  Application.Title := 'ADEmail';
  Application.ShowMainForm := false;
  Application.CreateForm(TForm, lvTempForm);
  //建立临时主窗体

  Application.CreateForm(TdmMain, dmMain);
  //if TfrmLogin.ExecuteLogin then
  begin
    lvTempForm.Free;
    lvTempForm := nil;
    Application.CreateForm(TfrmMain, frmMain);
    Application.ShowMainForm := true;
    Application.Run;
  end;

end.
