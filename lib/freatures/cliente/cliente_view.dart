import 'package:flutter/material.dart';
import 'package:apoio_imobiliario/freatures/cliente/cliente_model.dart';



class ClienteView extends StatelessWidget{
  final ClienteModel cliente;


  const ClienteView({super.key,
  required this.cliente});

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(cliente.nome)


    );
  }


}