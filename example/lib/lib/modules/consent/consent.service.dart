import 'package:get_server/get_server.dart';

import 'models/consent.dart';
import 'consent.repository.dart';

class ConsentService {
  final ConsentRepository _consentRepository = ConsentRepository(
    dbUser: Get.find(tag: 'dbUser'),
    dbPassword: Get.find(tag: 'dbPassword'),
    db: Get.find(tag: 'db'),
  );

  Future<List<Consent>> findAll() async => await _consentRepository.findAll();

  Future<List<Consent>> findAllWithPagination(int size, int pageNumber) async =>
      await _consentRepository.findAllWithPagination(size, pageNumber);

  Future<Map<String, dynamic>> filter(
          String category, int limit, int pageNumber) async =>
      _consentRepository.filter(category, limit, pageNumber);

  Future<Consent> findByID(int id) async =>
      await _consentRepository.findOne(id);

  Future<Consent> create(Consent Consent) async =>
      await _consentRepository.insert(Consent);

  Future<void> delete(int id) async => await _consentRepository.deleteOne(id);

  Future<Consent> update(Consent consent) async {
    Consent consentSave = await _consentRepository.findOne(consent.id);
    if (consentSave == null) {
      throw Exception('No Consent found with id ${consent.id}');
    }
    Consent newConsent = consent;

    //Do not allow changing id;
    newConsent.id = consent.id;

    //Update has null return for now
    _consentRepository.update(consent.id, newConsent);

    return await findByID(consent.id);
  }
}
