import 'package:web_service/moderate/usecase/locality/find_locality_by_cep_usecase.dart';

import '../../services/via_cep_service.dart';

abstract class BuscarCep {
  static FindLocalityByCepUseCase create() {
    HttpLocalityRepository repository = HttpLocalityRepository();

    return FindLocalityByCepUseCase(localityRepository: repository);
  }
}
