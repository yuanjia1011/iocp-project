program ADEmail;

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
  EDecryptionWrapper in '..\..\..\Common\EDecryptionWrapper.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmMain, dmMain);
  if TfrmLogin.ExecuteLogin then
  begin
    Application.CreateForm(TfrmMain, frmMain);
  end;
  Application.Run;
end.
