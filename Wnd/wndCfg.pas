unit wndCfg;

{$mode ObjFPC}{$H+}

interface

uses
   Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
   Registry;

type

   { TfrmCfg }

   TfrmCfg = class(TForm)
      btnOk: TButton;
      chkGrpCategory: TCheckGroup;
      procedure btnOkClick(Sender: TObject);
      procedure chkGrpCategoryClick(Sender: TObject);
      procedure FormCreate(Sender: TObject);
   private
      reg: TRegistry;
   public

   end;

var
   frmCfg: TfrmCfg;

implementation

{$R *.lfm}

{ TfrmCfg }

procedure TfrmCfg.FormCreate(Sender: TObject);
begin
   reg:=TRegistry.Create(KEY_READ);
   try
      reg.RootKey:=HKEY_CURRENT_USER;
      if reg.OpenKeyReadOnly('\Software\Remus RIGO\SS\KB Shortcuts') then
      begin
         if Reg.ValueExists('catWindows') then
            chkGrpCategory.Checked[0]:=Reg.ReadBool('catWindows')
         else
            chkGrpCategory.Checked[0]:=True;

         if Reg.ValueExists('catExcel') then
            chkGrpCategory.Checked[1]:=Reg.ReadBool('catExcel')
         else
            chkGrpCategory.Checked[1]:=True;

          if Reg.ValueExists('catWord') then
            chkGrpCategory.Checked[2]:=Reg.ReadBool('catWord')
         else
            chkGrpCategory.Checked[2]:=True;

          if Reg.ValueExists('catBrowser') then
            chkGrpCategory.Checked[3]:=Reg.ReadBool('catBrowser')
         else
            chkGrpCategory.Checked[3]:=True;

         reg.CloseKey;
      end;
   finally
      reg.Free;
   end;
end;
procedure TfrmCfg.btnOkClick(Sender: TObject);
begin
   reg:=TRegistry.Create(KEY_WRITE);
   try
      reg.RootKey:=HKEY_CURRENT_USER;
      if reg.OpenKey('\Software\Remus RIGO\SS\KB Shortcuts', True) then
      begin
         reg.WriteBool('catWindows', chkGrpCategory.Checked[0]);
         reg.WriteBool('catExcel', chkGrpCategory.Checked[1]);
         reg.WriteBool('catWord', chkGrpCategory.Checked[2]);
         reg.WriteBool('catBrowser', chkGrpCategory.Checked[3]);
         reg.CloseKey;
      end;
   finally
      reg.Free;
   end;
   Application.Terminate;
end;

procedure TfrmCfg.chkGrpCategoryClick(Sender: TObject);
begin

end;



end.

