import 'package:apoio_imobiliario/features/cliente/clientes_mock.dart';
import 'package:apoio_imobiliario/features/cliente/etapa_financiamento.dart';
import 'package:apoio_imobiliario/features/cliente/cliente_model.dart';

class ClienteController {
  final _clientes = List.of(clientesMock);

  List<ClienteModel> listarPorEtapa(EtapaFinanciamento statusAtual) {
    return _clientes
        .where((cliente) => cliente.etapaFinanciamento == statusAtual)
        .toList();
  }

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
}