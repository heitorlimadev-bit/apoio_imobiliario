
import 'package:apoio_imobiliario/features/cliente/clientes_mock.dart';
import 'package:apoio_imobiliario/features/cliente/etapa_financiamento.dart';
import 'package:apoio_imobiliario/features/cliente/cliente_model.dart';

class ClienteController {
  final List<ClienteModel> _clientes = List.of(clientesMock);

  List<ClienteModel> listarPorEtapa(EtapaFinanciamento statusAtual) {
    return _clientes
        .where((cliente) => cliente.etapaFinanciamento == statusAtual)
        .toList();
  }

  // Adiciona um cliente com o próximo ID disponível.
  ClienteModel adicionar(ClienteModel cliente) {
    final proximoId = _clientes.isEmpty
        ? 1
        : _clientes.map((c) => c.id).reduce((a, b) => a > b ? a : b) + 1;

    final novoCliente = ClienteModel(
      id: proximoId,
      nome: cliente.nome,
      email: cliente.email,
      telefone: cliente.telefone,
      capitalProprio: cliente.capitalProprio,
      cartaCredito: cliente.cartaCredito,
      etapaFinanciamento: cliente.etapaFinanciamento,
    );

    _clientes.add(novoCliente);

    return novoCliente;
  }

  

  // Atualiza os dados de um cliente existente.
  void etapaSeguinte(ClienteModel cliente) {
    final etapaAtual = cliente.etapaFinanciamento;
    final clienteAtualizado = cliente.copyWith(etapaFinanciamento:etapaAtual.seguinte);
    final posicao = _clientes.indexOf(cliente);
    _clientes[posicao] = clienteAtualizado;

  }
    void etapaAnterior(ClienteModel cliente) {
    final etapaAtual = cliente.etapaFinanciamento;
    final clienteAtualizado = cliente.copyWith(etapaFinanciamento:etapaAtual.anterior);
    final posicao = _clientes.indexOf(cliente);
    _clientes[posicao] = clienteAtualizado;
  }

    void atualizar(ClienteModel clienteAtualizado) {
    final posicao = _clientes.indexWhere(
      (cliente) => cliente.id == clienteAtualizado.id,
    );

    if (posicao == -1) return;

    _clientes[posicao] = clienteAtualizado;
  }

  // Busca um cliente pelo ID.
  ClienteModel? buscarPorId(int id) {
    for (final cliente in _clientes) {
      if (cliente.id == id) {
        return cliente;
      }
    }

    return null;
  }
}
