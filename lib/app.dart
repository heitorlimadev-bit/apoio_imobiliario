import 'package:flutter/material.dart';
import 'package:apoio_imobiliario/features/cliente/cliente_view.dart';
import 'package:apoio_imobiliario/features/splash/splash_view.dart';
import 'package:apoio_imobiliario/features/cliente/cliente_list_view.dart';
import 'package:apoio_imobiliario/features/cliente/clientes_mock.dart';
import 'package:apoio_imobiliario/features/login/login_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: Builder(
          builder: (context) {
            return Column(
              children: [
                AppBar(title: const Center(child: Text('AppBar'))),
                const Text('Botões debug do app'),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ClienteListView(),
                      ),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: cores.primary,
                    foregroundColor: cores.onPrimary,
                  ),
                  child: const Text('Debug Tela lista de Clientes'),
                ),



                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SplashView(),
                      ),
                    );
                  },
                  child: const Text('Debug Tela splash (placeholder)'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SplashView(),
                      ),
                    );
                  },
                  child: const Text('Debug Tela splash (placeholder)'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClienteView(cliente: clientesMock[1]),
                      ),
                    );
                  },
                  child: const Text('Debug Tela detalhes cliente'),
                ),
                ElevatedButton(
                  onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginView()),
                  );
                },
                child: const Text('Debug Tela de Login do Corretor'),
                  ),
                //Basta substituir o SplashView() pelo widget que você quer testar

                
              ],
            );
          },
        ),
      ),
    );
  }
}

// teste de app felipe 21/10