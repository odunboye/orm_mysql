import 'package:get_server/get_server.dart';
import 'models/payment.dart';
import 'payment.repository.dart';

class PaymentService {
  final PaymentRepository _paymentRepository = PaymentRepository(
    dbUser: Get.find(tag: 'dbUser'),
    dbPassword: Get.find(tag: 'dbPassword'),
    db: Get.find(tag: 'db'),
  );

  Future<List<Payment>> findAll() async => await _paymentRepository.findAll();

  Future<List<Payment>> findAllWithPagination(int size, int pageNumber) async =>
      await _paymentRepository.findAllWithPagination(size, pageNumber);

  Future<Map<String, dynamic>> filter(
          String category, int limit, int pageNumber) async =>
      _paymentRepository.filter(category, limit, pageNumber);

  Future<Payment> findByID(int id) async =>
      await _paymentRepository.findOne(id);

  Future<Payment> create(Payment Payment) async =>
      await _paymentRepository.insert(Payment);

  Future<void> deleteUser(int id) async =>
      await _paymentRepository.deleteOne(id);

  Future<Payment> update(Payment payment) async {
    Payment paymentSave = await _paymentRepository.findOne(payment.id);
    if (paymentSave == null) {
      throw Exception('No Payment found with id ${payment.id}');
    }
    Payment newPayment = payment;

    //Do not allow changing id;
    newPayment.id = payment.id;

    try {
      //Update has null return for now
      _paymentRepository.update(payment.id, newPayment);
    } catch (e) {
      rethrow;
    }

    return await findByID(payment.id);
  }
}
