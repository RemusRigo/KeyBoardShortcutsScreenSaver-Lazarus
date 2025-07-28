unit wndSS;

{$mode ObjFPC}{$H+}

interface

uses
   Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, Registry, Types,
   libData;

type

   { TfrmSS }

   TfrmSS = class(TForm)
      lblMsg: TLabel;
      tmrMsg: TTimer;
      tmrMove: TTimer;
      procedure FormCreate(Sender: TObject);
      procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
      procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
      procedure tmrMoveTimer(Sender: TObject);
      procedure tmrMsgTimer(Sender: TObject);
   private
      LastX, LastY: Integer;
      dx, dy: Integer;
      reg: TRegistry;
      catWindows, catExcel, catWord, catBrowser: Boolean;
      dbMsg: TStringList;
   public

   end;

var
   frmSS: TfrmSS;
   VirtualRect: TRect;

implementation

{$R *.lfm}

{ TfrmSS }

procedure TfrmSS.FormCreate(Sender: TObject);
var
   i: Integer;
begin
   if Screen.MonitorCount > 1 then   // multiple monitors
   begin
      VirtualRect:=Screen.Monitors[0].BoundsRect;
      for i:=1 to Screen.MonitorCount-1 do
         UnionRect(VirtualRect, VirtualRect, Screen.Monitors[i].BoundsRect);

      {VirtualRect:=Screen.DesktopRect;
      frmSS.BoundsRect:=VirtualRect;
      frmSS.Top:=VirtualRect.Top;
      frmSS.Left:=VirtualRect.Left;
      frmSS.Width:=VirtualRect.Right-VirtualRect.Left;
      frmSS.Height:=VirtualRect.Bottom-VirtualRect.Top;}
   end;

   LastX:=Mouse.CursorPos.X;   // Initial Cursor Position
   LastY:=Mouse.CursorPos.Y;

   dx:=2;   // Direction X
   dy:=2;   // Direction Y

   lblMsg.Caption:=dbWindows[High(dbWindows)];

   {Read settings from registry}
   reg := TRegistry.Create(KEY_READ);
   try
      reg.RootKey := HKEY_CURRENT_USER;
      if reg.OpenKeyReadOnly('\Software\Remus RIGO\SS\KB Shortcuts') then
      begin
         if Reg.ValueExists('catWindows') then
            catWindows:=Reg.ReadBool('catWindows')
         else
            catWindows:=True;
         if Reg.ValueExists('catExcel') then
            catExcel:=Reg.ReadBool('catWindows')
         else
            catExcel:=True;
          if Reg.ValueExists('catWord') then
            catWord:=Reg.ReadBool('catWord')
         else
            catWord:=True;
          if Reg.ValueExists('catBrowser') then
            catBrowser:=Reg.ReadBool('catBrowser')
         else
            catBrowser:=True;
        reg.CloseKey;
      end;
   finally
      reg.Free;
   end;

   {Initialize Message Shortcuts}
   dbMsg:=TStringList.Create;
   if catWindows then
      dbMsg.AddStrings(dbWindows);
   if catExcel then
      dbMsg.AddStrings(dbExcel);
   if catWord then
      dbMsg.AddStrings(dbWord);
   if catBrowser then
      dbMsg.AddStrings(dbBrowser);
end;

procedure TfrmSS.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   begin
      dbMsg.Free;
      Application.Terminate;
   end;
end;

procedure TfrmSS.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
   if (Abs(Mouse.CursorPos.X-LastX) > 5) or (Abs(Mouse.CursorPos.Y-LastY) > 5) then
   begin
      dbMsg.Free;
      Application.Terminate;
   end;
end;

procedure TfrmSS.tmrMoveTimer(Sender: TObject);
begin
   lblMsg.Left:=lblMsg.Left+dx;
   lblMsg.Top:=lblMsg.Top+dy;

   // Bounce off the edges
   if Screen.MonitorCount > 1 then   // multiple monitors
   begin
      if (lblMsg.Left < 0) or ((lblMsg.Left+lblMsg.Width) > (VirtualRect.Right-VirtualRect.Left)) then
         dx:=-dx;
      if (lblMsg.Top < 0) or ((lblMsg.Top+lblMsg.Height) > (VirtualRect.Bottom-VirtualRect.Top)) then
         dy:=-dy;
   end
   else
   begin
      if (lblMsg.Left < 0) or ((lblMsg.Left+lblMsg.Width) > ClientWidth) then
         dx:=-dx;
      if (lblMsg.Top < 0) or ((lblMsg.Top+lblMsg.Height) > ClientHeight) then
         dy:=-dy;
   end;
end;

procedure TfrmSS.tmrMsgTimer(Sender: TObject);
begin
   if (dbMsg.count>0) then
   begin
      Randomize;
      lblMsg.Caption:=dbMsg[Random(dbMsg.count)];
   end;
end;

end.

