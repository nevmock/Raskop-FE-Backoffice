import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

///
class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#.###', 'id_ID');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Jika input kosong, kembalikan nilai kosong
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Hapus karakter selain angka
    final numericOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Format angka ke dalam format currency (dengan titik)
    final formattedValue = _formatter.format(double.parse(numericOnly));

    // Kembalikan nilai baru dengan posisi kursor di akhir teks
    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}
