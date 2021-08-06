unit BFA.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Objects,
  System.ImageList, FMX.ImgList, System.Rtti, FMX.Grid.Style, FMX.ScrollBox,
  FMX.Grid,FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListBox, FMX.Ani, System.Threading,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.Memo, FMX.Edit, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  {$IFDEF ANDROID}
    Androidapi.Helpers, FMX.Platform.Android, System.Android.Service, System.IOUtils,
    FMX.Helpers.Android, Androidapi.JNI.PlayServices, Androidapi.JNI.Os,
  {$ELSEIF Defined(MSWINDOWS)}

  {$ENDIF}
  System.Generics.Collections, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent;

const
  //FRAME
  C_LOADING = 'LOADING';
  C_HOME = 'HOME';
  C_LOGIN = 'LOGIN';
  C_DETAIL = 'DETAIL';

  CIdle = 400;
  CFontS = 12.5;

procedure fnShowMessage(FMessage : String);
procedure fnTransitionFrame(FFrom, FGo : TControl; FFAFrom, FFAGo : TFloatAnimation; isBack : Boolean);
procedure fnGoFrame(FFrom, FGo : String; isBack : Boolean = False);
procedure fnHideFrame(FFrom : String);
procedure fnBack;

var
  goFrame, fromFrame, FToken : String;
  tabCount : Integer;

implementation

uses BFA.Func, BFA.GoFrame, BFA.Rest, frMain, uDM;

procedure fnShowMessage(FMessage : String);
begin
  TThread.Synchronize(nil, procedure
  begin
    //FMain.TM.Toast(FMessage);
  end);
end;

procedure fnTransitionFrame(FFrom, FGo : TControl; FFAFrom, FFAGo : TFloatAnimation; isBack : Boolean);
var
  FLayout : TLayout;
begin
  with FMain do begin
    if Assigned(FFrom) then begin
      FFrom.Visible := True;
    end;

    {FLayout := TLayout(FGo.FindComponent('loMain'));
    if Assigned(FLayout) then
      if goFrame <> C_LOADING then
        FLayout.Visible := False;}

    if isBack then begin
      FFAGo.Inverse := True;
      FFAFrom.Inverse := True;

      FGo.SendToBack;

      FFAGo.Parent := FFrom;
      FFAFrom.Parent := FFrom;
    end else begin
      FFAGo.Inverse := False;
      FFAFrom.Inverse := False;

      FGo.BringToFront;

      FFAGo.Parent := FGo;
      FFAFrom.Parent := FGo;
    end;

    FGo.Visible := True;

    FFAGo.PropertyName := 'Position.Y';
    FFAFrom.PropertyName := 'Opacity';

    FFAGo.StartValue := 75;
    FFAGo.StopValue := 0;

    FFAFrom.StartValue := 0.035;
    FFAFrom.StopValue := 1;

    FFAGo.Duration := 0.25;
    FFAFrom.Duration := 0.2;

    FFAFrom.Interpolation := TInterpolationType.Quadratic;
    FFAGo.Interpolation := TInterpolationType.Quadratic;

    fnShowFrame;

    Sleep(100);

    FFAGo.Enabled := True;
    FFAFrom.Enabled := True;
  end;
end;

procedure fnGoFrame(FFrom, FGo : String; isBack : Boolean = False);
begin
  fnGetFrame(C_FROM, FFrom);
  fnGetFrame(C_DESTINATION, FGo);

  if not Assigned(VFRGo) then begin
    fnShowMessage('Mohon maaf, terjadi kesalahan');
    Exit;
  end;

  fromFrame := FFrom;
  goFrame := FGo;

  tabCount := 0;

  fnTransitionFrame(VFRFrom, VFRGo, FMain.faFromX, FMain.faGoX, isBack);
end;

procedure fnHideFrame(FFrom : String);
begin
  if fromFrame <> '' then
    VFRFrom.Visible := False;

  VFRFrom := nil;
  VFRGo := nil;
end;

procedure fnBack;
begin

end;


end.