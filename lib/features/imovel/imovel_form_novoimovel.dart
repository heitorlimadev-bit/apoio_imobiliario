import 'package:apoio_imobiliario/features/imovel/imovel_tipos_status.dart';
import 'package:flutter/material.dart'; // Biblioteca de componentes visuais

import 'dart:io';

import 'package:image_picker/image_picker.dart';

class CadastroImovel extends StatefulWidget {
  // Widget que possui estado
  const CadastroImovel({super.key});

  @override
  State<CadastroImovel> createState() => _CadastroImovelState(); // Cria o estado
}

class _CadastroImovelState extends State<CadastroImovel> {
  final _formKey = GlobalKey<FormState>(); // Identifica e controla o formulário

  TipoImovel? _tipoSelecionado;
  final _descricaoController = TextEditingController(); // Controla campo título
  final _cidadeController = TextEditingController();
  final _ruaController = TextEditingController(); // Controla o campo valor
  final _numeroController = TextEditingController(); //campo numero imovel
  final _numeroApController = TextEditingController();
  final _bairroImovelController = TextEditingController();
  final _areaConstruidaController = TextEditingController();
  final _qtDormitoriosController = TextEditingController();
  final _qtBanheirosController = TextEditingController();
  final _qtGaragensController = TextEditingController();
  final _valorImovelController = TextEditingController();
  StatusImovel? _statusSelecionado;
  NegociacaoImovel? _interesseSelecionado;
  File? _fotoSelecionada;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    // Executado quando a tela é destruída
    _descricaoController.dispose(); // Libera o controller do título
    _cidadeController.dispose();
    _ruaController.dispose(); // Libera o controller do valor
    _numeroController.dispose();
    _numeroApController.dispose();
    _bairroImovelController.dispose();
    _areaConstruidaController.dispose();
    _qtDormitoriosController.dispose();
    _qtBanheirosController.dispose();
    _qtGaragensController.dispose();
    _valorImovelController.dispose();
    super.dispose(); // Executa a limpeza da classe pai
  }

  void cadastrarImovel() {
    // Função chamada pelo botão

    if (_formKey.currentState!.validate()) {
      // Verifica se todos os campos são válidos

      String descricao = _descricaoController.text; // Captura o texto digitado
      double valor = double.parse(
        _ruaController.text,
      ); // Converte texto em número decimal

      debugPrint('Descrição: $descricao'); // Exibe o título no console
      debugPrint('Valor: $valor'); // Exibe o valor no console
    }
  }

  Future<void> _capturarImagem(ImageSource origem) async {
    final XFile? imagem = await _picker.pickImage(
      source: origem,
      imageQuality: 80,
    );

    if (imagem != null) {
      setState(() {
        _fotoSelecionada = File(imagem.path);
      });
    }
  }

  void _mostrarOpcoesFoto() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Tirar foto com a Câmera'),
                onTap: () {
                  Navigator.pop(context); // Fecha o modal
                  _capturarImagem(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Escolher da Galeria'),
                onTap: () {
                  Navigator.pop(context); // Fecha o modal
                  _capturarImagem(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Constrói a interface da tela
    return Scaffold(
      backgroundColor: Colors.transparent,
      // Estrutura básica de uma tela Flutter

      appBar: AppBar(
        title: const Text('Cadastrar imóvel'),
        backgroundColor: Colors.transparent,
      ),

      body: Padding(
        // Cria espaçamento interno
        padding: const EdgeInsets.all(16),

        child: SingleChildScrollView(
          child: Form(
            // Agrupa os campos do formulário
            key: _formKey, // Associa o formulário à chave de controle

            child: Column(
              // Organiza os elementos verticalmente
              children: [
                //-------------------
                const SizedBox(height: 16),
                //------------------

                // tipo de imovel (escolha)
                DropdownButtonFormField<TipoImovel>(
                  value: _tipoSelecionado,
                  decoration: const InputDecoration(
                    labelText: 'Tipo do imóvel',
                    border: OutlineInputBorder(),
                  ),
                  hint: const Text('Selecione o tipo'),

                  items: const [
                    DropdownMenuItem(
                      value: TipoImovel.apartamento,
                      child: Text('Apartamento'),
                    ),

                    DropdownMenuItem(
                      value: TipoImovel.casa,
                      child: Text('Casa'),
                    ),

                    DropdownMenuItem(
                      value: TipoImovel.terreno,
                      child: Text('Terreno'),
                    ),

                    DropdownMenuItem(
                      value: TipoImovel.salaComercial,
                      child: Text('Sala'),
                    ),

                    DropdownMenuItem(
                      value: TipoImovel.galpao,
                      child: Text('Galpão'),
                    ),
                  ],

                  onChanged: (TipoImovel? novoTipo) {
                    setState(() {
                      _tipoSelecionado = novoTipo;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Selecione o tipo do imóvel';
                    }
                    return null;
                  },
                ),

                //------------------
                const SizedBox(height: 16),
                //------------------

                //descrição imovel
                TextFormField(
                  // Primeiro campo de entrada
                  controller:
                      _descricaoController, // Vincula o campo ao controller
                  decoration: const InputDecoration(
                    labelText:
                        'Descricao do imóvel', // Texto identificador do campo
                    border: OutlineInputBorder(), // Desenha uma borda
                  ),
                  validator: (value) {
                    // Função de validação
                    if (value == null || value.isEmpty) {
                      return 'Informe a descricao do imovel'; // Mensagem de erro
                    }
                    return null; // null significa que o campo é válido
                  },
                ),

                //-------------------------
                const SizedBox(height: 16), // Espaçamento vertical
                //-------------------------

                //cidade imovel
                TextFormField(
                  controller: _cidadeController,
                  decoration: const InputDecoration(
                    labelText: 'Cidade do imóvel',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe a cidade';
                    }
                    return null;
                  },
                ),

                //-------------------------
                const SizedBox(height: 16), // Espaçamento vertical
                //-------------------------

                //rua imovel
                TextFormField(
                  // Segundo campo de entrada
                  controller: _ruaController,
                  decoration: const InputDecoration(
                    labelText: 'Valor do imóvel',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o valor';
                    }
                    return null;
                  },
                ),

                //-------------------------
                const SizedBox(height: 16), // Espaçamento vertical
                //-------------------------

                //numero imovel
                TextFormField(
                  // Segundo campo de entrada
                  controller: _numeroController,
                  keyboardType:
                      TextInputType.number, // Solicita teclado numérico
                  decoration: const InputDecoration(
                    labelText: 'Número',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o número do imovel';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Digite um número válido';
                    }
                    return null;
                  },
                ),

                //-------------------------
                const SizedBox(height: 16), // Espaçamento vertical
                //-------------------------

                //numero apartamento (aparece só se for tipo apartamento)
                if (_tipoSelecionado == TipoImovel.apartamento ||
                    _tipoSelecionado == TipoImovel.salaComercial) ...[
                  TextFormField(
                    controller: _numeroApController,
                    keyboardType:
                        TextInputType.number, // Solicita teclado numérico
                    decoration: const InputDecoration(
                      labelText: 'Número do Apartamento',
                      border: OutlineInputBorder(),
                      hintText: 'Ex: 42',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o número do apartamento';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Digite um número válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                //--------------------------

                //bairro imovel
                TextFormField(
                  // Primeiro campo de entrada
                  controller:
                      _bairroImovelController, // Vincula o campo ao controller
                  decoration: const InputDecoration(
                    labelText:
                        'Bairro do imóvel', // Texto identificador do campo
                    border: OutlineInputBorder(), // Desenha uma borda
                  ),
                  validator: (value) {
                    // Função de validação
                    if (value == null || value.isEmpty) {
                      return 'Informe a descricao do imovel'; // Mensagem de erro
                    }
                    return null; // null significa que o campo é válido
                  },
                ),

                //-------------------------
                const SizedBox(height: 16), // Espaçamento vertical
                //-------------------------

                //Area construida
                TextFormField(
                  // Segundo campo de entrada
                  controller: _areaConstruidaController,
                  keyboardType:
                      TextInputType.number, // Solicita teclado numérico
                  decoration: const InputDecoration(
                    labelText: 'area em m² construidos do imóvel',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o valor';
                    }
                    return null;
                  },
                ),

                //-----------------------
                const SizedBox(height: 16),
                //-----------------------

                //qt dormitorios
                TextFormField(                  
                  controller: _qtDormitoriosController,
                  keyboardType:
                      TextInputType.number, // Solicita teclado numérico
                  decoration: const InputDecoration(
                    labelText: 'Quantidade dormitórios',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe a quantidade';
                    }
                    return null;
                  },
                ),

                //-------------------------
                const SizedBox(height: 16), // Espaçamento vertical
                //-------------------------

                //qt banheiros
                TextFormField(                  
                  controller: _qtBanheirosController,
                  keyboardType:
                      TextInputType.number, // Solicita teclado numérico
                  decoration: const InputDecoration(
                    labelText: 'Quantidade de banheiros',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe a quantidade';
                    }
                    return null;
                  },
                ),

                //-------------------------
                const SizedBox(height: 16), // Espaçamento vertical
                //-------------------------

                //qt garagens
                TextFormField(
                  // Segundo campo de entrada
                  controller: _qtGaragensController,
                  keyboardType:
                      TextInputType.number, // Solicita teclado numérico
                  decoration: const InputDecoration(
                    labelText: 'quantidade de garagens',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe a quantidade';
                    }
                    return null;
                  },
                ),

                //-------------------------
                const SizedBox(height: 16), // Espaçamento vertical
                //-------------------------

                //valor imovel
                TextFormField(
                  // Primeiro campo de entrada
                  controller:
                      _valorImovelController, // Vincula o campo ao controller
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText:
                        'Valor do imóvel', // Texto identificador do campo
                    border: OutlineInputBorder(), // Desenha uma borda
                  ),
                  validator: (value) {
                    // Função de validação
                    if (value == null || value.isEmpty) {
                      return 'Informe o valor do imovel'; // Mensagem de erro
                    }
                    return null; // null significa que o campo é válido
                  },
                ),

                //-------------------------
                const SizedBox(height: 16), // Espaçamento vertical
                //-------------------------

                // Negociação do imovel (escolha)
                DropdownButtonFormField<NegociacaoImovel>(
                  value: _interesseSelecionado,
                  decoration: const InputDecoration(
                    labelText: 'Interesse em negociar',
                    border: OutlineInputBorder(),
                  ),
                  hint: const Text('Interesse em negócios'),

                  items: const [
                    DropdownMenuItem(
                      value: NegociacaoImovel.aluguel,
                      child: Text('Aluguel'),
                    ),

                    DropdownMenuItem(
                      value: NegociacaoImovel.venda,
                      child: Text('Venda'),
                    ),

                    DropdownMenuItem(
                      value: NegociacaoImovel.troca,
                      child: Text('Troca'),
                    ),
                  ],
                  onChanged: (NegociacaoImovel? novoInteresse) {
                    setState(() {
                      _interesseSelecionado = novoInteresse;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Selecione o tipo do imóvel';
                    }
                    return null;
                  },
                ),

                //-------------------------
                const SizedBox(height: 16), // Espaçamento vertical
                //-------------------------

                // Status do imovel (escolha)
                DropdownButtonFormField<StatusImovel>(
                  value: _statusSelecionado,
                  decoration: const InputDecoration(
                    labelText: 'Status do imóvel',
                    border: OutlineInputBorder(),
                  ),
                  hint: const Text('Selecione o status'),

                  items: const [
                    DropdownMenuItem(
                      value: StatusImovel.disponivel,
                      child: Text('Disponível'),
                    ),

                    DropdownMenuItem(
                      value: StatusImovel.vendido,
                      child: Text('Vendido'),
                    ),

                    DropdownMenuItem(
                      value: StatusImovel.alugado,
                      child: Text('Terreno'),
                    ),
                  ],
                  onChanged: (StatusImovel? novoStatus) {
                    setState(() {
                      _statusSelecionado = novoStatus;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Selecione o tipo do imóvel';
                    }
                    return null;
                  },
                ),

                //-------------------------
                const SizedBox(height: 16), // Espaçamento vertical
                //-------------------------

                // SELETOR VISUAL DE FOTO
                InkWell(
                  onTap: _mostrarOpcoesFoto,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: _fotoSelecionada != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _fotoSelecionada!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt_outlined,
                                size: 48,
                                color: Colors.grey.shade700,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Toque para selecionar a foto do imóvel',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                //--------------------------
                const SizedBox(height: 20),
                //--------------------------

                ElevatedButton(
                  // Botão de cadastro
                  onPressed: cadastrarImovel, // Executa a função ao clicar
                  child: const Text('Cadastrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
