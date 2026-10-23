import 'package:flutter/material.dart';

import '../model/livro.dart';
import '../util/firestore_helper.dart';
import 'telaCadastro.dart';

class ListaLivros extends StatefulWidget {
  @override
  State<ListaLivros> createState() => ListaLivrosState();
}

class ListaLivrosState extends State<ListaLivros> {
  final FirestoreHelper helper = FirestoreHelper();

  List<Livro> livros = [];

  bool carregando = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      List<Livro> listaTemporaria = await helper.getLivros();

      if (!mounted) return;

      setState(() {
        livros = listaTemporaria;
        carregando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        carregando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao carregar livros: $e"),
        ),
      );
    }
  }

  Future<void> _abreTelaCadastro(BuildContext context) async {
    var resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return TelaCadastro();
        },
      ),
    );

    if (resultado is Livro) {
      try {
        await helper.insertLivro(resultado);

        await getData();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Livro cadastrado!"),
          ),
        );
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao cadastrar livro: $e"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BookForm - Meus Livros"),
      ),
      body: carregando
          ? Center(
        child: CircularProgressIndicator(),
      )
          : livros.isEmpty
          ? Center(
        child: Text("Nenhum livro cadastrado."),
      )
          : RefreshIndicator(
        onRefresh: getData,
        child: livroListItems(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _abreTelaCadastro(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  ListView livroListItems() {
    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: livros.length,
      itemBuilder: (BuildContext context, int position) {
        Livro livro = livros[position];

        return Card(
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.book),
            ),
            title: Text(
              livro.titulo,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Autor: ${livro.autor}"),
                Text("Páginas: ${livro.paginas}"),
                Text("Categoria: ${livro.categoria}"),
              ],
            ),
            onTap: () {
              _mostrarOpcoes(position);
            },
          ),
        );
      },
    );
  }

  void _mostrarOpcoes(int position) {
    Livro livro = livros[position];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(livro.titulo),
          content: Text(
            "Autor: ${livro.autor}\n"
                "Páginas: ${livro.paginas}\n"
                "Categoria: ${livro.categoria}",
          ),
          actions: [
            TextButton(
              child: Text("EXCLUIR"),
              onPressed: () {
                Navigator.pop(context);
                _excluirLivro(position);
              },
            ),
            TextButton(
              child: Text("FECHAR"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _excluirLivro(int position) async {
    String? id = livros[position].id;

    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Não foi possível identificar o livro."),
        ),
      );

      return;
    }

    try {
      await helper.deleteLivro(id);

      await getData();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Livro excluído!"),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao excluir livro: $e"),
        ),
      );
    }
  }
}