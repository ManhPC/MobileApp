import 'package:intl/intl.dart';

class Utils {
  String formatNumber(int number) {
    return NumberFormat.decimalPattern().format(number);
  }

  String formatBillion(String? number) {
    String numString = number ?? "";
    if (numString.isEmpty) {
      return "0";
    }

    // Chuyển đổi chuỗi thành số
    double value = double.parse(numString);

    // Chuyển đổi thành tỷ (1 tỷ = 10^9)
    double valueInBillion = value / 1e9;

    // Định dạng số với 2 chữ số sau dấu thập phân
    String formatted = valueInBillion.toStringAsFixed(2);

    // Chia phần nguyên và phần thập phân
    List<String> parts = formatted.split('.');

    // Định dạng phần nguyên với dấu phẩy
    String integerPart = parts[0];
    String fractionalPart = parts.length > 1 ? parts[1] : "00";

    String formattedIntegerPart = integerPart.replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');

    return "$formattedIntegerPart.$fractionalPart";
  }

  String formatString(String input) {
    // Xóa bỏ mọi ký tự không phải là số
    String cleanedInput = input.replaceAll(RegExp(r'\D'), '');

    // Kiểm tra độ dài của chuỗi
    if (cleanedInput.length <= 2) {
      return cleanedInput; // Nếu chuỗi có ít hơn hoặc bằng 2 ký tự, trả về chuỗi gốc
    }

    // Khởi tạo biến để giữ kết quả định dạng
    StringBuffer formattedString = StringBuffer();

    // Lấy phần đầu của chuỗi (nếu độ dài là lẻ, lấy 1 ký tự đầu tiên, nếu không lấy 2)
    int prefixLength = cleanedInput.length % 2 == 0 ? 2 : 1;
    formattedString.write(cleanedInput.substring(0, prefixLength));

    // Lấy phần còn lại của chuỗi và thêm dấu phẩy sau mỗi hai ký tự
    for (int i = prefixLength; i < cleanedInput.length; i++) {
      if ((i - prefixLength) % 2 == 0) {
        formattedString.write(',');
      }
      formattedString.write(cleanedInput[i]);
    }

    return formattedString.toString();
  }
}
