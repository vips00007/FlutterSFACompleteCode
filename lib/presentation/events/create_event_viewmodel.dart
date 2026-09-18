import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreateEventViewModel extends GetxController {
  final eventDate = Rx<DateTime?>(null);
  final eventType = ''.obs;
  final partner = ''.obs;
  final venue = ''.obs;
  final remark = ''.obs;
  final expectedInvitees = ''.obs;
  final budget = ''.obs;
  final isSharedWithPartner = false.obs;
  final photos = <String>[].obs;

  String get formattedDate {
    if (eventDate.value == null) return '';
    return DateFormat('d MMM yyyy').format(eventDate.value!);
  }

  void setDate(DateTime date) {
    eventDate.value = date;
  }

  void toggleSharedWithPartner(bool value) {
    isSharedWithPartner.value = value;
  }
}
