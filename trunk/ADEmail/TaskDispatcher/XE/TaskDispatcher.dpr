program TaskDispatcher;

uses
  FastMM4 in '..\..\..\..\Source\Utils\FastMM4.pas',
  FastMM4Messages in '..\..\..\..\Source\Utils\FastMM4Messages.pas',
  Forms,
  SysUtils,
  FileLogger in '..\..\..\..\Source\IOCP\FileLogger.pas',
  uBuffer in '..\..\..\..\Source\IOCP\uBuffer.pas',
  uIOCPCentre in '..\..\..\..\Source\IOCP\uIOCPCentre.pas',
  uIOCPConsole in '..\..\..\..\Source\IOCP\uIOCPConsole.pas',
  uIOCPDebugger in '..\..\..\..\Source\IOCP\uIOCPDebugger.pas',
  uIOCPFileLogger in '..\..\..\..\Source\IOCP\uIOCPFileLogger.pas',
  uIOCPProtocol in '..\..\..\..\Source\IOCP\uIOCPProtocol.pas',
  uIOCPTools in '..\..\..\..\Source\IOCP\uIOCPTools.pas',
  uIOCPWorker in '..\..\..\..\Source\IOCP\uIOCPWorker.pas',
  uMemPool in '..\..\..\..\Source\IOCP\uMemPool.pas',
  uSocketListener in '..\..\..\..\Source\IOCP\uSocketListener.pas',
  JwaMSWSock in '..\..\..\..\Source\WinSock2\JwaMSWSock.pas',
  JwaQos in '..\..\..\..\Source\WinSock2\JwaQos.pas',
  JwaWinsock2 in '..\..\..\..\Source\WinSock2\JwaWinsock2.pas',
  uMemoLogger in '..\..\..\..\Source\Utils\uMemoLogger.pas',
  uSocketTools in '..\..\..\..\Source\Utils\uSocketTools.pas',
  uZipTools in '..\..\..\..\Source\Utils\uZipTools.pas',
  uCMDObject in '..\..\Common\uCMDObject.pas',
  superobject in '..\..\..\Common\superobject.pas',
  uCRCTools in '..\..\..\Common\uCRCTools.pas',
  uIOCPCMDObjectDecoder in '..\..\Common\uIOCPCMDObjectDecoder.pas',
  uIOCPCMDObjectEncoder in '..\..\Common\uIOCPCMDObjectEncoder.pas',
  uIOCPRunner in '..\uIOCPRunner.pas',
  uClientContext in '..\uClientContext.pas',
  ufrmMain in '..\ufrmMain.pas' {frmMain},
  uFMIOCPDebugINfo in '..\..\..\Common\uFMIOCPDebugINfo.pas' {FMIOCPDebugINfo: TFrame},
  uRunTimeINfoTools in '..\..\..\Common\uRunTimeINfoTools.pas',
  uClientSessions in '..\uClientSessions.pas',
  CDSOperatorWrapper in '..\..\..\UniDACPool\CDSOperatorWrapper.pas',
  uCDSProvider in '..\..\..\UniDACPool\uCDSProvider.pas',
  uDBAccessOperator in '..\..\..\UniDACPool\uDBAccessOperator.pas',
  uICDSOperator in '..\..\..\UniDACPool\uICDSOperator.pas',
  UntCobblerUniPool in '..\..\..\UniDACPool\UntCobblerUniPool.pas',
  UntThreadTimer in '..\..\..\UniDACPool\UntThreadTimer.pas',
  uUniConfigTools in '..\..\..\UniDACPool\uUniConfigTools.pas',
  uUniOperator in '..\..\..\UniDACPool\uUniOperator.pas',
  uUniPool in '..\..\..\UniDACPool\uUniPool.pas',
  uCMDConsts in '..\..\Common\uCMDConsts.pas',
  EDecryptionWrapper in '..\..\..\Common\EDecryptionWrapper.pas',
  uFileHandler in '..\FilesHandler\uFileHandler.pas',
  uStringTools in '..\..\..\Common\uStringTools.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
