unit UfItem;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DBXMSSQL, Data.DB, Data.SqlExpr,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids,
  Data.Win.ADODB,uControle,UItem;

type
  TFrmItem = class(TForm)
    QueryGrid: TADOQuery;
    adoConexao: TADOConnection;
    dtsourceItem: TDataSource;
    ShapeFundo: TShape;
    gpBoxItems: TGroupBox;
    lblCodigo: TLabel;
    lblDescriao: TLabel;
    lblRegistros: TLabel;
    lblId: TLabel;
    edtId: TEdit;
    edtCodigo: TEdit;
    edtDescricao: TEdit;
    dbgridItems: TDBGrid;
    btnAtualizaGrid: TButton;
    btnAlterar: TButton;
    btnDeletar: TButton;
    btnSalvar: TButton;
    btnNovo: TButton;
    btnFechar: TButton;
    imgArecoItems: TImage;
    lblSlogan: TLabel;
    lblItem: TLabel;
    lblNome: TLabel;
    edtNome: TEdit;
    lbtitulo: TLabel;
    edtValorunit: TEdit;
    l�blVltUnit: TLabel;
    procedure btnFecharClick(Sender: TObject);
    procedure btnAtualizaGridClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnDeletarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
  private
    { Private declarations }
    procedure LimpaCampos();
    procedure AtualizaGrid();
    procedure VerificaQuery;
    function  getIdView(): integer;
    function  RetornaRegistros(): string;
  public
    { Public declarations }
  end;

var
  FrmItem: TFrmItem;

implementation

{$R *.dfm}

procedure TFrmItem.AtualizaGrid;
begin
    QueryGrid.Active := false;
    QueryGrid.Active := True;
    VerificaQuery;
    RetornaRegistros;
    LimpaCampos;
end;

procedure TFrmItem.btnAlterarClick(Sender: TObject);
var
  controle : TControle;
  item : TItem;
begin
    controle := TCOntrole.Create;
    controle.Create;

    item := TItem.Create(controle);

    if item.ValidaAlteraItem(StrToInt(edtId.Text),edtCodigo.Text,edtNome.Text,
                      edtDescricao.text ,StrToFloat(edtValorunit.text)) then
    begin
      item.AlteraItem(StrToInt(edtId.Text),getIdView, edtCodigo.Text,edtNome.Text,
                      edtDescricao.text ,StrToFloat(edtValorunit.text));
      AtualizaGrid;
    end
    else
    Application.MessageBox('O campo ID n�o podem ficar vazios.', 'Inform��o',MB_ICONINFORMATION+mb_ok);


    //liberando da memoria
    item.Destroy;
    controle.Destroy;

end;

procedure TFrmItem.btnAtualizaGridClick(Sender: TObject);
begin
  AtualizaGrid;
end;

procedure TFrmItem.btnDeletarClick(Sender: TObject);
var
  controle  : TControle;
  item      : TItem;
  id        : integer;
begin
    id := 0;
    controle := TControle.Create;
    controle.Create;

    item := TItem.Create(controle);
    id:= getIdView;

    if item.ValidaExcluirItem(id) then
    begin
      item.ExcluirItem(id);
      AtualizaGrid;
    end
    else
    Application.MessageBox('O campo ID n�o podem ficar vazios.', 'Inform��o',MB_ICONINFORMATION+mb_ok);


    //liberando da memoria
    item.Destroy;
    controle.Destroy;
end;

procedure TFrmItem.btnFecharClick(Sender: TObject);
begin
  ModalResult := mrClose;
end;

procedure TFrmItem.btnNovoClick(Sender: TObject);
begin
  LimpaCampos();
  btnSalvar.Enabled := true;
end;

procedure TFrmItem.btnSalvarClick(Sender: TObject);
var
  controle  : TControle;
  item      : TItem;
begin
    controle := TControle.Create;
    controle.Create;
    item := TItem.Create(controle);

    btnSalvar.Cursor := crSQLWait;

    if not(edtId.Text = EmptyStr) then
    begin
      if item.ValidaInseriItem(StrToInt(edtId.Text),edtCodigo.Text,edtNome.Text,
                      edtDescricao.text ,StrToFloat(edtValorunit.text)) then
        item.InseriItem(StrToInt(edtId.Text),edtCodigo.Text,edtNome.Text,
                      edtDescricao.text ,StrToFloat(edtValorunit.text));
      AtualizaGrid;
    end
    else
    Application.MessageBox('Os campos n�o podem ficar vazios.', 'Inform��o',MB_ICONINFORMATION+mb_ok);
    //liberando da memoria
    item.Destroy;
    controle.Destroy;
    btnSalvar.Cursor := crDefault;

end;

function TFrmItem.getIdView: integer;
begin
  result:= dbgridItems.Columns[0].Field.Value;
end;

procedure TFrmItem.LimpaCampos;
begin
    edtId.Text     := EmptyStr;
    edtNome.Text   :=EmptyStr;
    edtCodigo.Text := EmptyStr;
    edtNome.Text   := EmptyStr;
    edtDescricao.Text := EmptyStr;
    edtValorunit.Text := EmptyStr;
end;

function TFrmItem.RetornaRegistros: string;
begin
  lblRegistros.Caption:= '('+IntToStr(QueryGrid.RecordCount) + ') Items Cadastrados.';
end;

procedure TFrmItem.VerificaQuery;
begin
  btnDeletar.Enabled := not(QueryGrid.IsEmpty);
  btnAlterar.Enabled := not(QueryGrid.IsEmpty);
  btnSalvar.Enabled  := not(QueryGrid.IsEmpty);
end;

end.
