import 'package:flutter/material.dart';

import '../model/livro.dart';

class TelaCadastro extends StatefulWidget {
  @override
  State<TelaCadastro> createState() => TelaCadastroState();
}

class TelaCadastroState extends State<TelaCadastro> {
  TextEditingController tcTitulo = TextEditingController();
  TextEditingController tcAutor = TextEditingController();
  TextEditingController tcPaginas = TextEditingController();
  TextEditingController tcCategoria = TextEditingController();

  InputDecoration decora(String texto) {
    return InputDecoration(
      hintStyle: TextStyle(fontSize: 20),
      hintText: texto,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
    );
  }

  void _salvar() {
    if (tcTitulo.text.trim().isEmpty ||
        tcAutor.text.trim().isEmpty ||
        tcPaginas.text.trim().isEmpty ||
        tcCategoria.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Preencha todos os campos"),
        ),
      );

      return;
    }

    int? paginas = int.tryParse(tcPaginas.text.trim());

    if (paginas == null || paginas <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Digite um número de páginas válido"),
        ),
      );

      return;
    }

    Livro livro = Livro(
      tcTitulo.text.trim(),
      tcAutor.text.trim(),
      paginas,
      tcCategoria.text.trim(),
    );

    Navigator.pop(context, livro);
  }

  @override
  void dispose() {
    tcTitulo.dispose();
    tcAutor.dispose();
    tcPaginas.dispose();
    tcCategoria.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BookForm - Cadastro"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(12.0),
              child: TextField(
                controller: tcTitulo,
                decoration: decora("Digite o título"),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: TextField(
                controller: tcAutor,
                decoration: decora("Digite o autor"),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: TextField(
                controller: tcPaginas,
                keyboardType: TextInputType.number,
                decoration: decora("Número de páginas"),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: TextField(
                controller: tcCategoria,
                decoration: decora("Categoria"),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      child: Text("SALVAR"),
                      onPressed: _salvar,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      child: Text("CANCELAR"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}