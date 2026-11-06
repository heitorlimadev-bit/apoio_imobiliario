
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class SelecionarContatoView extends StatefulWidget {
  const SelecionarContatoView({super.key});

  @override
  State<SelecionarContatoView> createState() =>
      _SelecionarContatoViewState();
}

class _SelecionarContatoViewState
    extends State<SelecionarContatoView> {
  final TextEditingController _buscaController =
      TextEditingController();

  List<Contact> _contatos = [];

  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregarContatos();
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _carregarContatos() async {
    try {
      final permissao =
          await FlutterContacts.permissions.request(
        PermissionType.read,
      );

      if (permissao != PermissionStatus.granted) {
        throw Exception(
          'Permissão para acessar os contatos não concedida.',
        );
      }

      final contatos = await FlutterContacts.getAll(
        properties: {
          ContactProperty.phone,
        },
      );

      // Mantém somente contatos que possuem telefone.
      contatos.removeWhere(
        (contato) => contato.phones.isEmpty,
      );

      contatos.sort(
        (a, b) => (a.displayName ?? '').toLowerCase().compareTo(
              (b.displayName ?? '').toLowerCase(),
            ),
      );

      if (!mounted) return;

      setState(() {
        _contatos = contatos;
        _carregando = false;
        _erro = null;
      });
    } catch (erro) {
      if (!mounted) return;

      setState(() {
        _erro = erro.toString();
        _carregando = false;
      });
    }
  }

  List<Contact> get _contatosFiltrados {
    final busca = _buscaController.text.toLowerCase().trim();

    if (busca.isEmpty) return _contatos;

    return _contatos.where((contato) {
      final nome = (contato.displayName ?? '').toLowerCase();

      final telefone = contato.phones
          .map((telefone) => telefone.number)
          .join(' ')
          .toLowerCase();

      return nome.contains(busca) || telefone.contains(busca);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final contatos = _contatosFiltrados;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Importar contato'),
      ),
      body: _carregando
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _erro != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.contacts_outlined,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _erro!,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _carregando = true;
                              _erro = null;
                            });
                            _carregarContatos();
                          },
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        controller: _buscaController,
                        decoration: InputDecoration(
                          hintText: 'Pesquisar contato...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _buscaController.clear();
                              setState(() {});
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),

                    Expanded(
                      child: contatos.isEmpty
                          ? const Center(
                              child: Text(
                                'Nenhum contato encontrado.',
                              ),
                            )
                          : ListView.separated(
                              itemCount: contatos.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final contato = contatos[index];

                                final nome =
                                    contato.displayName?.trim().isNotEmpty ==
                                            true
                                        ? contato.displayName!
                                        : 'Contato sem nome';

                                final telefone =
                                    contato.phones.first.number;

                                return ListTile(
                                  leading: CircleAvatar(
                                    child: Text(
                                      nome[0].toUpperCase(),
                                    ),
                                  ),
                                  title: Text(nome),
                                  subtitle: Text(telefone),
                                  trailing: const Icon(
                                    Icons.chevron_right,
                                  ),
                                  onTap: () {
                                    Navigator.pop(
                                      context,
                                      contato,
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
    );
  }
}
