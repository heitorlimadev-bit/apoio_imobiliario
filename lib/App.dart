import 'package:flutter/material.dart';
import 'package:apoio_imobiliario/freatures/cliente/cliente_view.dart';
import 'package:apoio_imobiliario/freatures/splash/splash_view.dart';
import 'package:apoio_imobiliario/freatures/cliente/cliente_list_view.dart';
import 'package:apoio_imobiliario/freatures/cliente/clientes_mock.dart';
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    return Scaffold(
    
        body: Center(
          child: Builder(builder: (context) {
            return Column(
              children: [
                AppBar(title: 
                  Center(child: Text('AppBar'))),
                Text('Botões debug do app'),
                ElevatedButton(
                  onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ClienteListView()));},
                  
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cores.primary,
                    foregroundColor: cores.onPrimary,
                  ),
                  child: Text('Debug Tela de Clientes'),
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
                  onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ClienteView(cliente: clientes[1])));},
                  child: Text('Debug Tela de Imoveis'),
                ),
                //Basta substituir o SplashView() pelo widget que você quer testar
              ]
            );
          })
        )
      );
  }
}