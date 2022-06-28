import '../../services/via_cep_service.dart';
import '../moderate/locality/find_locality_by_cep_usecase.dart';

abstract class BuscarCep {
  static FindLocalityByCepUseCase create() {
    HttpLocalityRepository repository = HttpLocalityRepository();

    return FindLocalityByCepUseCase(localityRepository: repository);
  }
}
