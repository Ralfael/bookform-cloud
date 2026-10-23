import 'package:flutter/material.dart';

import '../model/livro.dart';
import '../util/firestore_helper.dart';
import 'listaLivros.dart';
import 'telaCadastro.dart';

class TelaInicial extends StatefulWidget {
  @override
  State<TelaInicial> createState() => TelaInicialState();
}

class TelaInicialState extends State<TelaInicial> {
  final FirestoreHelper helper = FirestoreHelper();

  void _abreListaLivros(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ListaLivros();
        },
      ),
    );
  }

  void _abreCadastro(BuildContext context) async {
    // Aguarda o resultado da tela de cadastro
    var resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return TelaCadastro();
        },
      ),
    );

    // Se um livro válido foi retornado, salva no Firestore
    if (resultado is Livro) {
      try {
        await helper.insertLivro(resultado);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Livro cadastrado com sucesso!"),
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
        title: Text("BookForm"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.menu_book,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              "BookForm",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              child: Text("MEUS LIVROS"),
              onPressed: () {
                _abreListaLivros(context);
              },
            ),
            SizedBox(height: 15),
            ElevatedButton(
              child: Text("CADASTRAR LIVRO"),
              onPressed: () {
                _abreCadastro(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
