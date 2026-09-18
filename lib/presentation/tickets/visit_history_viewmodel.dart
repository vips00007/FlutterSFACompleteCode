import 'package:get/get.dart';
import 'package:intl/intl.dart';

class VisitHistoryViewModel extends GetxController {
  final Rx<DateTime?> _selectedDate = Rx<DateTime?>(null);

  DateTime? get selectedDate => _selectedDate.value;

  String get dateText {
    if (_selectedDate.value == null) {
      return 'All Visit';
    }
    return DateFormat('EEE, d MMM yyyy').format(_selectedDate.value!);
  }

  String get subText {
    if (_selectedDate.value == null) {
      return 'No visits recorded';
    }
    return 'No visits recorded on ${DateFormat('d MMM yyyy').format(_selectedDate.value!)}';
  }

  void nextDate() {
    if (_selectedDate.value == null) {
      _selectedDate.value = DateTime.now();
    } else {
      _selectedDate.value = _selectedDate.value!.add(const Duration(days: 1));
    }
  }

  void previousDate() {
    if (_selectedDate.value == null) {
      _selectedDate.value = DateTime.now().subtract(const Duration(days: 1));
    } else {
      _selectedDate.value = _selectedDate.value!.subtract(
        const Duration(days: 1),
      );
    }
  }

  void clearDate() {
    _selectedDate.value = null;
  }

  void selectDate(DateTime date) {
    _selectedDate.value = date;
  }
}
