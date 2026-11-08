import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import 'package:apoio_imobiliario/features/cliente/cliente_controller.dart';
import 'package:apoio_imobiliario/features/cliente/cliente_model.dart';
import 'package:apoio_imobiliario/features/cliente/etapa_financiamento.dart';

class ImportarContatosView extends StatefulWidget {
  final ClienteController controller;
  final EtapaFinanciamento etapaInicial;

  const ImportarContatosView({
    super.key,
    required this.controller,
    this.etapaInicial = EtapaFinanciamento.montagemDePasta,
  });

  @override
  State<ImportarContatosView> createState() =>
      _ImportarContatosViewState();
}

class _ImportarContatosViewState extends State<ImportarContatosView> {
  bool _carregando = true;
  bool _importando = false;
  String? _erro;
  List<Contact> _contatos = [];
  final Set<String> _selecionados = {};
  String _busca = '';

  @override
  void initState() {
    super.initState();
    _carregarContatos();
  }

  String _nomeDe(Contact c) => (c.displayName ?? '').trim();

  String _idDe(Contact c) => c.id ?? '';

  Future<void> _carregarContatos() async {
    if (kIsWeb) {
      setState(() {
        _carregando = false;
        _erro =
            'A importação da agenda só funciona no app Android ou iOS, não no navegador.';
      });
      return;
    }

    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      // API 2.6+
      final status = await FlutterContacts.permissions.request(
        PermissionType.read,
      );

      if (status != PermissionStatus.granted &&
          status != PermissionStatus.limited) {
        setState(() {
          _carregando = false;
          _erro =
              'Permissão negada. Ative o acesso aos contatos nas configurações do celular.';
        });
        return;
      }

      final lista = await FlutterContacts.getAll(
        properties: {
          ContactProperty.name,
          ContactProperty.phone,
          ContactProperty.email,
        },
      );

      lista.sort(
        (a, b) => _nomeDe(a).toLowerCase().compareTo(
              _nomeDe(b).toLowerCase(),
            ),
      );

      if (!mounted) return;

      setState(() {
        _contatos = lista.where((c) => _idDe(c).isNotEmpty).toList();
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _carregando = false;
        _erro = 'Erro ao ler contatos: $e';
      });
    }
  }

  List<Contact> get _filtrados {
    final q = _busca.trim().toLowerCase();
    if (q.isEmpty) return _contatos;

    return _contatos.where((c) {
      final nome = _nomeDe(c).toLowerCase();
      final telefones =
          c.phones.map((p) => p.number).join(' ').toLowerCase();
      final emails =
          c.emails.map((e) => e.address).join(' ').toLowerCase();
      return nome.contains(q) ||
          telefones.contains(q) ||
          emails.contains(q);
    }).toList();
  }

  String _telefoneDe(Contact c) {
    if (c.phones.isEmpty) return '';
    return c.phones.first.number;
  }

  String _emailDe(Contact c) {
    if (c.emails.isEmpty) return '';
    return c.emails.first.address;
  }

  void _alternar(Contact c) {
    final id = _idDe(c);
    if (id.isEmpty) return;

    setState(() {
      if (_selecionados.contains(id)) {
        _selecionados.remove(id);
      } else {
        _selecionados.add(id);
      }
    });
  }

  void _selecionarTodosVisiveis() {
    final ids = _filtrados
        .map(_idDe)
        .where((id) => id.isNotEmpty)
        .toSet();

    setState(() {
      if (ids.every(_selecionados.contains)) {
        _selecionados.removeAll(ids);
      } else {
        _selecionados.addAll(ids);
      }
    });
  }

  Future<void> _importar() async {
    if (_selecionados.isEmpty) return;

    setState(() => _importando = true);

    try {
      final escolhidos = _contatos
          .where((c) => _selecionados.contains(_idDe(c)))
          .toList();

      int importados = 0;
      int ignorados = 0;

      for (final c in escolhidos) {
        final nome = _nomeDe(c);
        if (nome.isEmpty) {
          ignorados++;
          continue;
        }

        final telefone = _telefoneDe(c).trim();
        final email = _emailDe(c).trim();

        final cliente = ClienteModel(
          id: '',
          nome: nome,
          email: email.isEmpty ? 'sem-email@importado.local' : email,
          telefone: telefone.isEmpty ? 'sem telefone' : telefone,
          capitalProprio: 0,
          cartaCredito: 0,
          etapaFinanciamento: widget.etapaInicial,
        );

        await widget.controller.adicionar(cliente);
        importados++;
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ignorados == 0
                ? '$importados contato(s) importado(s).'
                : '$importados importado(s), $ignorados ignorado(s).',
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao importar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _importando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtrados = _filtrados;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Importar da agenda'),
        actions: [
          if (!_carregando && _erro == null)
            TextButton(
              onPressed: _selecionarTodosVisiveis,
              child: const Text('Todos'),
            ),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _erro != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.contacts_outlined, size: 48),
                        const SizedBox(height: 12),
                        Text(
                          _erro!,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        if (!kIsWeb)
                          FilledButton(
                            onPressed: _carregarContatos,
                            child: const Text('Tentar de novo'),
                          ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Buscar contato...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        onChanged: (v) => setState(() => _busca = v),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${_selecionados.length} selecionado(s) · ${filtrados.length} contato(s)',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: filtrados.isEmpty
                          ? const Center(
                              child: Text('Nenhum contato encontrado.'),
                            )
                          : ListView.separated(
                              itemCount: filtrados.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final c = filtrados[index];
                                final id = _idDe(c);
                                final marcado = _selecionados.contains(id);
                                final nome = _nomeDe(c);
                                final telefone = _telefoneDe(c);
                                final email = _emailDe(c);

                                return CheckboxListTile(
                                  value: marcado,
                                  onChanged: (_) => _alternar(c),
                                  title: Text(
                                    nome.isEmpty ? '(Sem nome)' : nome,
                                  ),
                                  subtitle: Text(
                                    [
                                      if (telefone.isNotEmpty) telefone,
                                      if (email.isNotEmpty) email,
                                    ].join(' · '),
                                  ),
                                  secondary: CircleAvatar(
                                    child: Text(
                                      nome.isNotEmpty
                                          ? nome[0].toUpperCase()
                                          : '?',
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: FilledButton.icon(
            onPressed: _importando || _selecionados.isEmpty
                ? null
                : _importar,
            icon: _importando
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.person_add_alt_1),
            label: Text(
              _importando
                  ? 'Importando...'
                  : 'Importar ${_selecionados.length} contato(s)',
            ),
          ),
        ),
      ),
    );
  }
}