program KBShortcuts;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, LCLType, SysUtils,
  wndSS, wndCfg, libData;

{$R *.res}

var
   prm: string;

begin
   RequireDerivedFormResource:=True;
   Application.Scaled:=True;
   {$PUSH}{$WARN 5044 OFF}
   Application.MainFormOnTaskbar:=False;
   {$POP}
   //Application.Initialize;
   //Application.CreateForm(TfrmSS, frmSS);
   //Application.Run;

   Application.Initialize;
   if ParamCount > 0 then
   begin
      prm:=LowerCase(Trim(ParamStr(1)));
      prm:=Copy(prm, 1, 2);
      case prm of
         '/s':
         begin
            frmSS:=TfrmSS.Create(nil);
            frmSS.Show;
            Application.Run;
            {Application.CreateForm(TfrmSS, frmSS);}
         end;

         '/c':
         begin
            Application.CreateForm(TfrmCfg, frmCfg);
         end;

         '/p':
         begin
            // Preview mode – usually ignore or handle differently
            Halt;
         end;

      else

         begin
         // Default: act like /s
         Application.CreateForm(TfrmSS, frmSS);
         end;
      end;
   end;
   Application.Run;
end.
