import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';
import 'screens/telaInicial.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const BookForm());
}

class BookForm extends StatelessWidget {
  const BookForm({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BookForm',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TelaInicial(), // 'const' removido com sucesso!
    );
  }
}
