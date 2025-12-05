// Basic number to words converter supporting values up to 999,999.99
// This is sufficient for typical invoice totals and keeps logic simple.
String numberToWords(double value, {String currency = "euro"}) {
  final intPart = value.floor();
  final cents = ((value - intPart) * 100).round();

  final words = _convertHundreds(intPart);
  final centsWords = _convertTens(cents);
  final currencyLabel = intPart == 1 ? currency : '${currency}s';
  final centLabel = cents == 1 ? 'cent' : 'cents';

  if (cents > 0) {
    return '${words.isEmpty ? 'zero' : words} $currencyLabel and $centsWords $centLabel';
  }
  return '${words.isEmpty ? 'zero' : words} $currencyLabel';
}

final List<String> _units = [
  'zero',
  'one',
  'two',
  'three',
  'four',
  'five',
  'six',
  'seven',
  'eight',
  'nine',
  'ten',
  'eleven',
  'twelve',
  'thirteen',
  'fourteen',
  'fifteen',
  'sixteen',
  'seventeen',
  'eighteen',
  'nineteen',
];

final List<String> _tens = [
  '',
  '',
  'twenty',
  'thirty',
  'forty',
  'fifty',
  'sixty',
  'seventy',
  'eighty',
  'ninety',
];

String _convertHundreds(int number) {
  if (number == 0) return '';
  if (number < 20) return _units[number];
  if (number < 100) return _convertTens(number);
  if (number < 1000) {
    final hundreds = number ~/ 100;
    final remainder = number % 100;
    final remainderWords = remainder > 0 ? ' ${_convertTens(remainder)}' : '';
    return '${_units[hundreds]} hundred$remainderWords';
  }
  if (number < 1000000) {
    final thousands = number ~/ 1000;
    final remainder = number % 1000;
    final thousandWords = '${_convertHundreds(thousands)} thousand';
    final remainderWords = remainder > 0 ? ' ${_convertHundreds(remainder)}' : '';
    return '$thousandWords$remainderWords';
  }
  return number.toString();
}

String _convertTens(int number) {
  if (number < 20) return _units[number];
  final ten = number ~/ 10;
  final unit = number % 10;
  if (unit == 0) return _tens[ten];
  return '${_tens[ten]}-${_units[unit]}';
}
