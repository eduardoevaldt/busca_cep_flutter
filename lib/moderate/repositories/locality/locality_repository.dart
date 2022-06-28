import 'package:web_service/moderate/entities/locality/locality_entity.dart';

abstract class ILocalityRepository {
  Future<Locality> findByCep(String cep);
}
