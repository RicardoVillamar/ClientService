import 'package:flutter_test/flutter_test.dart';
import 'package:client_service/viewmodel/camara_viewmodel.dart';
import '../mocks.mocks.dart';

void main() {
  group('CamaraViewModel', () {
    late CamaraViewModel viewModel;
    late MockCamaraRepository repo;

    setUp(() {
      repo = MockCamaraRepository();
      viewModel = CamaraViewModel(repo);
    });

    test('Inicializa lista de cámaras vacía', () async {
      expect(viewModel.camaras, isA<List>());
      expect(viewModel.camaras, isEmpty);
    });
  });
}
