import 'package:flutter/material.dart';

import 'galeria_fotos_view.dart';
import 'imovel_controller.dart';
import 'imovel_model.dart';
import 'imovel_tipos_status.dart';

class CadastroImovel extends StatefulWidget {
  final ImovelModel? imovel;

  const CadastroImovel({
    super.key,
    this.imovel,
  });

  @override
  State<CadastroImovel> createState() => _CadastroImovelState();
}

class _CadastroImovelState extends State<CadastroImovel> {
  final _formKey = GlobalKey<FormState>();
  final _controller = ImovelController();

  final _descricao = TextEditingController();
  final _cidade = TextEditingController();
  final _rua = TextEditingController();
  final _numero = TextEditingController();
  final _numeroAp = TextEditingController();
  final _bairro = TextEditingController();
  final _area = TextEditingController();
  final _dormitorios = TextEditingController();
  final _banheiros = TextEditingController();
  final _garagens = TextEditingController();
  final _valor = TextEditingController();

  TipoImovel? _tipo;
  StatusImovel _status = StatusImovel.disponivel;
  NegociacaoImovel _negociacao = NegociacaoImovel.venda;

  /// Caminho da foto escolhida na galeria interna (assets/...).
  String? _fotoSelecionada;

  bool _carregando = false;

  bool get _editando => widget.imovel != null;

  @override
  void initState() {
    super.initState();

    final imovel = widget.imovel;

    if (imovel != null) {
      _tipo = imovel.tipoImovel;
      _descricao.text = imovel.descricaoImovel;
      _cidade.text = imovel.cidadeImovel;
      _rua.text = imovel.ruaImovel;
      _numero.text = imovel.numeroImovel.toString();
      _numeroAp.text = imovel.numeroApImovel.toString();
      _bairro.text = imovel.bairroImovel;
      _area.text = imovel.areaConstruida.toString();
      _dormitorios.text = imovel.qtDormitorios.toString();
      _banheiros.text = imovel.qtBanheiros.toString();
      _garagens.text = imovel.qtGaragens.toString();
      // Formato brasileiro (350000,00): _dinheiro() remove pontos, então
      // usar valor.toString() ("350000.0") multiplicaria o valor por 10.
      _valor.text = imovel.valor.toStringAsFixed(2).replaceAll('.', ',');
      _status = imovel.statusImovel;
      _negociacao = imovel.negociacaoImovel;
      if (imovel.foto.isNotEmpty) {
        _fotoSelecionada = imovel.foto;
      }
    }
  }

  @override
  void dispose() {
    _descricao.dispose();
    _cidade.dispose();
    _rua.dispose();
    _numero.dispose();
    _numeroAp.dispose();
    _bairro.dispose();
    _area.dispose();
    _dormitorios.dispose();
    _banheiros.dispose();
    _garagens.dispose();
    _valor.dispose();
    super.dispose();
  }

  Future<void> _abrirGaleria() async {
    final caminho = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => GaleriaFotosView(
          fotoAtual: _fotoSelecionada,
        ),
      ),
    );

    if (caminho == null || !mounted) return;

    setState(() {
      _fotoSelecionada = caminho;
    });
  }

  String _texto(String campo) {
    return campo.trim();
  }

  int _inteiro(TextEditingController campo) {
    return int.tryParse(campo.text.trim()) ?? 0;
  }

  double _dinheiro(String texto) {
    final normalizado = texto
        .trim()
        .replaceAll('R\$', '')
        .replaceAll(' ', '')
        .replaceAll('.', '')
        .replaceAll(',', '.');

    return double.parse(normalizado);
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    if (_tipo == null) return;

    setState(() => _carregando = true);

    try {
      final imovel = ImovelModel(
        id: widget.imovel?.id ?? '',
        tipoImovel: _tipo!,
        descricaoImovel: _texto(_descricao.text),
        cidadeImovel: _texto(_cidade.text),
        ruaImovel: _texto(_rua.text),
        numeroImovel: _inteiro(_numero),
        numeroApImovel: _inteiro(_numeroAp),
        bairroImovel: _texto(_bairro.text),
        areaConstruida: _inteiro(_area),
        qtDormitorios: _inteiro(_dormitorios),
        qtBanheiros: _inteiro(_banheiros),
        qtGaragens: _inteiro(_garagens),
        valor: _dinheiro(_valor.text),
        statusImovel: _status,
        negociacaoImovel: _negociacao,
        foto: _fotoSelecionada ?? '',
      );

      if (_editando) {
        await _controller.atualizar(imovel);
      } else {
        await _controller.adicionar(imovel);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _editando
                ? 'Imóvel atualizado com sucesso!'
                : 'Imóvel cadastrado com sucesso!',
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar imóvel: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _carregando = false);
      }
    }
  }

  Future<void> _excluir() async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir imóvel'),
        content: const Text('Tem certeza? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmado != true || !mounted) return;

    setState(() => _carregando = true);

    try {
      await _controller.excluir(widget.imovel!.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Imóvel excluído.')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao excluir imóvel: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Widget _campo(
    String titulo,
    TextEditingController controller, {
    bool numerico = false,
    String? Function(String?)? validator,
    int linhas = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: linhas,
      keyboardType: numerico
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      decoration: InputDecoration(
        labelText: titulo,
        border: const OutlineInputBorder(),
      ),
      validator: validator ??
          (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Preencha este campo.';
            }
            return null;
          },
    );
  }

  Widget _espaco() => const SizedBox(height: 14);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _editando ? 'Editar imóvel' : 'Cadastrar imóvel',
        ),
        actions: [
          if (_editando)
            IconButton(
              tooltip: 'Excluir imóvel',
              onPressed: _carregando ? null : _excluir,
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Fotografia do imóvel (galeria interna).
            InkWell(
              onTap: _abrirGaleria,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 210,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: _buildPreviewFoto(),
              ),
            ),

            const SizedBox(height: 8),

            OutlinedButton.icon(
              onPressed: _abrirGaleria,
              icon: const Icon(Icons.photo_library_outlined),
              label: Text(
                (_fotoSelecionada != null && _fotoSelecionada!.isNotEmpty)
                    ? 'Trocar fotografia'
                    : 'Adicionar fotografia',
              ),
            ),

            _espaco(),

            DropdownButtonFormField<TipoImovel>(
              value: _tipo,
              decoration: const InputDecoration(
                labelText: 'Tipo do imóvel',
                border: OutlineInputBorder(),
              ),
              items: TipoImovel.values.map((tipo) {
                return DropdownMenuItem(
                  value: tipo,
                  child: Text(tipo.rotulo),
                );
              }).toList(),
              onChanged: (value) => setState(() => _tipo = value),
              validator: (value) =>
                  value == null ? 'Selecione o tipo.' : null,
            ),

            _espaco(),

            _campo('Descrição do imóvel', _descricao, linhas: 3),
            _espaco(),

            _campo('Cidade', _cidade),
            _espaco(),

            _campo('Rua / Avenida', _rua),
            _espaco(),

            _campo('Número do imóvel', _numero, numerico: true),
            _espaco(),

            _campo(
              'Número do apartamento (se houver)',
              _numeroAp,
              numerico: true,
              validator: (_) => null,
            ),
            _espaco(),

            _campo('Bairro', _bairro),
            _espaco(),

            _campo('Área construída (m²)', _area, numerico: true),
            _espaco(),

            _campo('Quantidade de dormitórios', _dormitorios,
                numerico: true),
            _espaco(),

            _campo('Quantidade de banheiros', _banheiros,
                numerico: true),
            _espaco(),

            _campo('Quantidade de garagens', _garagens,
                numerico: true),
            _espaco(),

            _campo(
              'Valor do imóvel (ex.: 350.000,00)',
              _valor,
              numerico: true,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Informe o valor.';
                }

                try {
                  if (_dinheiro(value) <= 0) {
                    return 'Informe um valor maior que zero.';
                  }
                } catch (_) {
                  return 'Informe um valor válido.';
                }

                return null;
              },
            ),

            _espaco(),

            DropdownButtonFormField<StatusImovel>(
              value: _status,
              decoration: const InputDecoration(
                labelText: 'Status do imóvel',
                border: OutlineInputBorder(),
              ),
              items: StatusImovel.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status.rotulo),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _status = value);
                }
              },
            ),

            _espaco(),

            DropdownButtonFormField<NegociacaoImovel>(
              value: _negociacao,
              decoration: const InputDecoration(
                labelText: 'Tipo de negociação',
                border: OutlineInputBorder(),
              ),
              items: NegociacaoImovel.values.map((negociacao) {
                return DropdownMenuItem(
                  value: negociacao,
                  child: Text(negociacao.rotulo),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _negociacao = value);
                }
              },
            ),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: _carregando ? null : _salvar,
              icon: _carregando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.save),
              label: Text(
                _carregando
                    ? 'Salvando...'
                    : _editando
                        ? 'Salvar alterações'
                        : 'Cadastrar imóvel',
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagemPadrao() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo_library_outlined, size: 48),
          SizedBox(height: 8),
          Text('Toque para escolher na galeria'),
        ],
      ),
    );
  }

  Widget _buildPreviewFoto() {
    final foto = _fotoSelecionada ?? '';
    if (foto.isEmpty) return _imagemPadrao();

    final isNetwork =
        foto.startsWith('http://') || foto.startsWith('https://');

    if (isNetwork) {
      return Image.network(
        foto,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _imagemPadrao(),
      );
    }

    return Image.asset(
      foto,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _imagemPadrao(),
    );
  }
}