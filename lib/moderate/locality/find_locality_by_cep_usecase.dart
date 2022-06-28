import '../entities/locality/locality_entity.dart';
import '../repositories/locality/locality_repository.dart';
import 'find_locality_by_cep_output.dart';

class FindLocalityByCepUseCase {
  final ILocalityRepository localityRepository;

  FindLocalityByCepUseCase({required this.localityRepository});

  Future<FindLocalityByCepOutput> execute(String cep) async {
    try {
      Locality locality = await localityRepository.findByCep(cep);

      return FindLocalityByCepOutput(
        cep: locality.cep.value,
        city: locality.city,
        state: locality.state,
        street: locality.street,
        neighborhood: locality.neighborhood,
      );
    } catch (error) {
      rethrow;
    }
  }
}
