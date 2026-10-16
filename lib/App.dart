import 'package:flutter/material.dart';
import 'freatures/splash/splash_view.dart';
import 'freatures/clinte_info/cliente_info_model.dart';
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final cliente = clientes [1]
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Builder(builder: (context) {
            return Column(
              children: [
                AppBar(title: 
                  Center(child: Text('AppBar'))),
                Text('Botões debug do app'),
                ElevatedButton(
                  onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => SplashView()));},
                  child: Text('Debug Tela de Carregamento'),
                ),
                                ElevatedButton(
                  onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => SplashView()));},
                  child: Text('Debug Tela de Clientes'),
                ),
                                ElevatedButton(
                  onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => SplashView()));},
                  child: Text('Debug Tela de Detalhes do Cliente'),
                ),
                                ElevatedButton(
                  onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ClienteInfoPerfil(cliente: cliente)));},
                  child: Text('Debug Tela de Imoveis'),
                ),


                //Basta substituir o SplashView() pelo widget que você quer testar
              ]
            );
          })
        )
      )
    );
  }
}