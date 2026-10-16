import 'package:flutter/material.dart';
import 'freatures/splash/splash_view.dart';
import 'freatures/clinte_info/cliente_info_model.dart';
import 'lib/App.dart';


class ClienteInfoPerfil extends StatelessWidget{
  final ClienteInfo cliente;


  ClienteInfoPerfil({super.key
  required this cliente,
  });

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(cliente.nome,cliente.email)


    )
  }


}