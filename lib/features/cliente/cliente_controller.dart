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

  void atualizar(ClienteModel clienteAtualizado) {
    final posicao = _clientes.indexWhere(
      (cliente) => cliente.id == clienteAtualizado.id,
    );

    if (posicao == -1) return;

    _clientes[posicao] = clienteAtualizado;
  }
}
