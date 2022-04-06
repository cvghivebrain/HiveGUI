unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, StrUtils, Vcl.ExtCtrls, FileCtrl;

type
  TForm1 = class(TForm)
    lstCom: TListBox;
    editInput: TEdit;
    editOutput: TEdit;
    btnInput: TButton;
    btnOutput: TButton;
    memoEvents: TMemo;
    btnRun: TButton;
    boxTabs: TComboBox;
    lblCom: TLabel;
    dlgOpen: TOpenDialog;
    dlgSave: TSaveDialog;
    btnFile: TRadioButton;
    btnFolder: TRadioButton;
    editMask: TEdit;
    editExt: TEdit;
    chkOverwrite: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure lstComClick(Sender: TObject);
    procedure boxTabsChange(Sender: TObject);
    procedure btnInputClick(Sender: TObject);
    procedure btnOutputClick(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
    procedure btnFolderClick(Sender: TObject);
    procedure btnFileClick(Sender: TObject);
  private
    { Private declarations }
    function Explode(s, d: string; n: integer): string;
    procedure SelectItem(i: integer);
    procedure FillList;
    procedure RunCommand(infile, outfile: string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  inifile: textfile;
  guifolder, currentexe, currentparams: string;
  items: array of string;
  links: array[0..1000] of integer;

implementation

{$R *.dfm}

{ TForm1 }

{ Replicate MediaWiki's "explode" string function. }
function TForm1.Explode(s, d: string; n: integer): string;
begin
  if (AnsiPos(d,s) = 0) and ((n = 0) or (n = -1)) then result := s // Output full string if delimiter not found.
  else
    begin
    s := s+d;
    while n > 0 do
      begin
      Delete(s,1,AnsiPos(d,s)+Length(d)-1); // Trim earlier substrings and delimiters.
      dec(n);
      end;
    Delete(s,AnsiPos(d,s),Length(s)-AnsiPos(d,s)+1); // Trim later substrings and delimiters.
    result := s;
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var s, item: string;
begin
  guifolder := ExtractFilePath(Application.ExeName); // Get folder for this program.
  memoEvents.Lines.Add(guifolder);
  if not DirectoryExists(guifolder+'bin\') then memoEvents.Lines.Add('bin folder not found.');
  if not FileExists(guifolder+'hivegui.ini') then memoEvents.Lines.Add('ini file not found.')
  else
    begin
    AssignFile(inifile,guifolder+'hivegui.ini'); // Open ini file.
    Reset(inifile);
    while not eof(inifile) do
      begin
      ReadLn(inifile,s);
      if AnsiPos('=',s) <> 0 then
        begin
        if Explode(s,'=',0) = 'tab' then
          begin
          boxTabs.Items.Add(Explode(s,'tab=',1)); // Add tab.
          boxTabs.ItemIndex := 0 // Select first tab.
          end
        else if Explode(s,'=',0) = 'item' then
          begin
          item := Explode(s,'item=',1);
          if FileExists(guifolder+'bin\'+Explode(item,'|',2)) then // Check if exe file exists.
            begin
            SetLength(items,Length(items)+1); // Extend item list by 1.
            items[Length(items)-1] := item; // Add item to end.
            end;
          end;
        end;
      end;
    FillList; // Show list for first tab.
    if lstCom.Items.Count > 0 then
      begin
      lstCom.ItemIndex := 0;
      SelectItem(0);
      end;
    CloseFile(inifile);
    end;
end;

procedure TForm1.FillList;
var i, k: integer;
begin
  lstCom.Clear; // Remove current items.
  currentexe := '';
  lblCom.Caption := 'Command: ';
  k := 0;
  if Length(items) > 0 then // Check if any items are loaded.
    for i := 0 to Length(items)-1 do
      if StrtoInt(Explode(items[i],'|',0)) = boxTabs.ItemIndex then // Check against current tab.
        begin
        lstCom.Items.Add(Explode(items[i],'|',1)); // Add to list.
        links[k] := i; // Remember which item is linked to command in list.
        inc(k);
        end;
  memoEvents.Lines.Add('List reset.');
end;

procedure TForm1.SelectItem(i: integer);
var s: string;
begin
  s := items[links[lstCom.ItemIndex]]; // Get item associated with selected command.
  currentexe := Explode(s,'|',2); // Get exe.
  currentparams := Explode(s,'|',3); // Get parameters.
  lblCom.Caption := 'Command: '+currentexe+' '+currentparams;
end;

procedure TForm1.lstComClick(Sender: TObject);
begin
  if lstCom.ItemIndex > -1 then SelectItem(lstCom.ItemIndex); // Check that something is selected.
end;

procedure TForm1.boxTabsChange(Sender: TObject);
begin
  FillList; // Repopulate list.
  if lstCom.Items.Count > 0 then
    begin
    lstCom.ItemIndex := 0;
    SelectItem(0);
    end;
end;

procedure TForm1.btnFileClick(Sender: TObject);
begin
  btnFolder.Checked := false;
  editMask.Visible := false;
  editExt.Visible := false;
end;

procedure TForm1.btnFolderClick(Sender: TObject);
begin
  btnFile.Checked := false;
  editMask.Visible := true;
  editExt.Visible := true;
end;

procedure TForm1.btnInputClick(Sender: TObject);
var s: string;
begin
  if btnFile.Checked = true then
    begin
    if dlgOpen.Execute then editInput.Text := dlgOpen.FileName;
    end
  else
    begin
    if SelectDirectory('','',s) then editInput.Text := s+'\';
    end;
end;

procedure TForm1.btnOutputClick(Sender: TObject);
var s: string;
begin
  if btnFile.Checked = true then
    begin
    if dlgSave.Execute then editOutput.Text := dlgSave.FileName;
    end
  else
    begin
    if SelectDirectory('','',s) then editOutput.Text := s+'\';
    end;
end;

procedure TForm1.btnRunClick(Sender: TObject);
var okrun: boolean;
  rec: TSearchRec;
  ext, outfile: string;
begin
  okrun := true; // Assume everything is ok.
  if editInput.Text = '' then
    begin
    memoEvents.Lines.Add('No input specified.');
    okrun := false; // Set flag to false if problem is found.
    end;
  if editOutput.Text = '' then
    begin
    memoEvents.Lines.Add('No output specified.');
    okrun := false;
    end;
  if (editInput.Text <> '') and (FileExists(editInput.Text) = false) and (btnFile.Checked = true) then
    begin
    memoEvents.Lines.Add('Input file not found.');
    okrun := false;
    end;
  if (editInput.Text <> '') and (DirectoryExists(editInput.Text) = false) and (btnFile.Checked = false) then
    begin
    memoEvents.Lines.Add('Input folder not found.');
    okrun := false;
    end;
  if (editOutput.Text <> '') and (DirectoryExists(editOutput.Text) = false) and (btnFile.Checked = false) then
    CreateDir(editOutput.Text); // Create output folder if it doesn't already exist.

  // Run command for file.
  if (okrun = true) and (btnFile.Checked = true) then
    begin
    RunCommand(editInput.Text,editOutput.Text);
    if FileExists(editOutput.Text) = false then memoEvents.Lines.Add('Output file not created.');
    end;

  // Run command for folder.
  if (okrun = true) and (btnFile.Checked = false) then
    begin
    editInput.Text := IncludeTrailingPathDelimiter(editInput.Text); // Add trailing backslash.
    editOutput.Text := IncludeTrailingPathDelimiter(editOutput.Text); // Add trailing backslash.
    if FindFirst(editInput.Text+editMask.Text, faAnyFile-faDirectory, rec) = 0 then
      begin
      repeat
        begin
        if editExt.Text = '' then ext := ExtractFileExt(rec.Name) // Keep extension from input file.
        else ext := '.'+editExt.Text; // Use specified extension.
        outfile := editOutput.Text+Explode(rec.Name,'.',0)+ext; // Full path and name of output file.
        RunCommand(editInput.Text+rec.Name,outfile);
        if FileExists(outfile) = false then memoEvents.Lines.Add(outfile+' not created.');
        end;
      until FindNext(rec) <> 0;
      FindClose(rec);
      end;
    end;
end;

procedure TForm1.RunCommand(infile, outfile: string);
var command: string;
  StartInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
label skip;
begin
  if (chkOverwrite.Checked = false) and (FileExists(outfile))then
    begin
    memoEvents.Lines.Add(outfile+' already exists and was skipped.');
    goto skip;
    end;

  command := ReplaceStr(currentparams,'{infile}',infile); // Use input file.
  command := ReplaceStr(command,'{outfile}',outfile); // Use output file.
  command := '"'+guifolder+'bin\'+currentexe+'" '+command; // Add exe.

  FillChar(StartInfo,SizeOf(TStartupInfo),#0);
  FillChar(ProcInfo,SizeOf(TProcessInformation),#0);
  StartInfo.cb := SizeOf(TStartupInfo);
  // Run program.
  if not CreateProcess(nil,PChar(command),nil,nil,false,CREATE_NEW_PROCESS_GROUP+NORMAL_PRIORITY_CLASS+CREATE_NO_WINDOW,nil,nil,StartInfo,ProcInfo) then
    begin
    memoEvents.Lines.Add('Command failed.');
    end
  else
    begin
    memoEvents.Lines.Add(command);
    while WaitForSingleObject(ProcInfo.hProcess, 10) > 0 do Application.ProcessMessages;
    CloseHandle(ProcInfo.hProcess);
    CloseHandle(ProcInfo.hThread);
    end;

skip:
end;

end.
