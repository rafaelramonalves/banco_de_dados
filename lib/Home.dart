import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _recuperarBancoDados() async{
    //criar caminho para o banco de dados
    final caminhoBancoDados = await getDatabasesPath(); // banco/app1/data/
    final localBancoDados = join(caminhoBancoDados,"banco.bd"); //banco.db (nome)
    //Iniciar conexão com o banco de dados (criando o banco)
    var bd =await openDatabase(
      localBancoDados,
      version: 1, //Qual versão do banco que você está subindo
      onCreate: (db,dbVersaoRecente){
          db.execute("CREATE TABLE usuarios ("
              "id INTEGER PRIMARY KEY AUTOINCREMENT,"
              " nome VARCHAR,"
              " idade INTEGER)");
      }
    );
    return bd;
  }
  _salvar() async{
    Database bd = await _recuperarBancoDados();
    Map<String,dynamic> dadosUsuario = {
      "nome" : "zurich destefanno",
      "idade" : 46
    };
   int id = await bd.insert(
       "usuarios",
       dadosUsuario);
   //print("Salvo: $id");
  }
  _listarUsuarios() async{
    Database bd = await _recuperarBancoDados();
    //String sql = " SELECT * FROM usuarios WHERE idade = 23";
    ///onde o nome é rafael e a idade é 23
    //String sql = " SELECT * FROM usuarios WHERE idade IN ('Rafael Ramon',23)";

    ///Trazer com parte do nome
    String sql = " SELECT * FROM usuarios WHERE nome LIKE 'Rafael%' ";

    //Escrever uma Query de execução para pegar os dados em forma de lista
    List usuarios = await bd.rawQuery(sql);
    
    for(var usuario in usuarios){
      print(
          " item id: "+usuario['id'].toString()+
          " nome: "+usuario['nome']+
          " idade: "+usuario['idade'].toString()
      );
    }

  }

  _recuperarUsuarioPeloId(int id) async{
    Database bd = await _recuperarBancoDados();

    //outra forma de pesquisar
    List usuarios = await bd.query(
      "usuarios", //nome tabela
      columns: ["id" , "nome", "idade"],
      where: "id = ?",
      whereArgs: [id]
    );

    for(var usuario in usuarios){
      print(
          " item id: "+usuario['id'].toString()+
              " nome: "+usuario['nome']+
              " idade: "+usuario['idade'].toString()
      );
    }


  }

  _excluirUsuario(int id) async{
    Database bd = await _recuperarBancoDados();

    int retorno = await bd.delete( //retorno vai receber a quantidade de itens excluidos
      "usuarios", //tabela
      where: "id = ?",
      //where: "id = ? AND nome = ? AND idade = ?",
      //whereArgs: [id,"ana maria golveia",18],
      whereArgs: [id]
    );
    print(("Item quantidade removida $retorno"));
  }

  _atualizarUsuario(int id) async{
    Database bd = await _recuperarBancoDados();

    //Novos dados que serão colocados
    Map<String,dynamic> dadosUsuario = {
      "nome" : "Rafael Ramon Alterado",
      "idade" : 46
    };

    int retorno = await bd.update( //retorno recebe a quantidade de itens que foi att
        "usuarios", //tabela
        dadosUsuario,
      where: "id = ?",
      whereArgs: [id]
    );

    print(("Item quantidade removida $retorno"));
  }

  @override
  Widget build(BuildContext context) {
    //_salvar();
    //_listarUsuarios();
    //_recuperarUsuarioPeloId(2);
    _excluirUsuario(2);
    return Container();
  }
}
