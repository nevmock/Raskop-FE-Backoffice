import 'package:flutter/services.dart';

///

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Jika input kosong, biarkan kosong
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Hapus semua karakter selain angka
    final numericOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Jika kosong setelah dihapus, kembalikan kosong
    if (numericOnly.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Format angka ke dalam format ribuan (dengan titik)
    final formattedValue = _formatCurrency(numericOnly);

    // Kembalikan nilai baru dengan posisi kursor di akhir teks
    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }

  // Fungsi untuk memformat angka ke dalam format ribuan dengan titik
  String _formatCurrency(String value) {
    return value.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
