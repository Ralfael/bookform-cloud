import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/livro.dart';

class FirestoreHelper {
  final CollectionReference<Map<String, dynamic>> colecao =
  FirebaseFirestore.instance.collection('livros');

  // Cadastrar livro
  Future<String> insertLivro(Livro livro) async {
    print('1. Iniciando cadastro: ${livro.titulo}');

    try {
      DocumentReference<Map<String, dynamic>> documento =
      await colecao.add(livro.toMap());

      print('2. Livro salvo com sucesso!');
      print('ID do documento: ${documento.id}');

      DocumentSnapshot<Map<String, dynamic>> verificacao =
      await colecao.doc(documento.id).get();

      print('3. Documento existe: ${verificacao.exists}');
      print('4. Dados encontrados: ${verificacao.data()}');

      return documento.id;
    } catch (e, stackTrace) {
      print('ERRO AO CADASTRAR LIVRO: $e');
      print(stackTrace);
      rethrow;
    }
  }

  // Buscar todos os livros
  Future<List<Livro>> getLivros() async {
    print('5. Buscando livros no Firestore...');

    try {
      QuerySnapshot<Map<String, dynamic>> resultado =
      await colecao.get();

      List<Livro> livros = resultado.docs.map((documento) {
        return Livro.fromFirestore(
          documento.data(),
          documento.id,
        );
      }).toList();

      print('6. Quantidade de livros encontrados: ${livros.length}');

      return livros;
    } catch (e, stackTrace) {
      print('ERRO AO BUSCAR LIVROS: $e');
      print(stackTrace);
      rethrow;
    }
  }

  // Contar livros
  Future<int> getCount() async {
    QuerySnapshot<Map<String, dynamic>> resultado =
    await colecao.get();

    return resultado.size;
  }

  // Atualizar livro
  Future<void> updateLivro(Livro livro) async {
    if (livro.id == null) {
      throw Exception('Livro sem identificador.');
    }

    try {
      await colecao.doc(livro.id).update(livro.toMap());
      print('Livro atualizado: ${livro.id}');
    } catch (e, stackTrace) {
      print('ERRO AO ATUALIZAR LIVRO: $e');
      print(stackTrace);
      rethrow;
    }
  }

  // Excluir livro
  Future<void> deleteLivro(String id) async {
    try {
      await colecao.doc(id).delete();
      print('Livro excluído: $id');
    } catch (e, stackTrace) {
      print('ERRO AO EXCLUIR LIVRO: $e');
      print(stackTrace);
      rethrow;
    }
  }
}