import 'package:intl/intl.dart';

String getCurrentDate() => DateTime.now().toUtc().toIso8601String();

String toFormattedDateString(String? dateString,
    {String? defaultEmpty, String pattern = 'dd/MM/y'}) {
  final dateStr = dateString ?? '';
  if (dateStr.isEmpty) return defaultEmpty ?? '';

  final date = DateTime.parse(dateStr).toLocal();
  return DateFormat(pattern).format(date);
}

String toFormattedTimeString(String? ds, [hasSecond = false]) {
  try {
    if (ds == null) {
      return '-';
    }
    final date = DateTime.parse(ds).toLocal();
    return hasSecond
        ? DateFormat.Hms().format(date)
        : DateFormat.Hm().format(date);
  } catch (e) {
    return '-';
  }
}

DateTime convertUTCToLocal(String dateTime,
    {String format = 'yyyy-MM-ddTHH:mm:ssZ'}) {
  return DateFormat(format).parse(dateTime, true).toLocal();
}

String convertUTCToLocalString(String dateTime,
    {String format = 'dd/MM/yyyy',
    String currentFormat = 'yyyy-MM-ddTHH:mm:ssZ'}) {
  return DateFormat(format)
      .format(convertUTCToLocal(dateTime, format: currentFormat));
}

String formatDate(DateTime? date, {String format = 'dd/MM/yyyy'}) {
  if (date == null) return '-';
  return DateFormat(format).format(date);
}

String convertToLocalDateTime(String? dateTime,
    {String format = 'HH:mm dd-MM-yyyy'}) {
  return DateFormat(format).format(DateTime.parse(dateTime ?? '').toLocal());
}

String convertToDateTime(DateTime dateTime,
    {String format = 'HH:mm dd-MM-yyyy'}) {
  return DateFormat(format).format(dateTime);
}

DateTime convertStringToDate(String dateTime,
    {String pattern = 'yyyy-MM-ddTHH:mm:ssZ'}) {
  return DateFormat(pattern).parse(dateTime, false);
}

String getStringCurrentDate({String format = 'yyyy-MM-dd'}) {
  return DateFormat(format).format(DateTime.now());
}

String? convertDateToServerTime(DateTime dateTime) {
  try {
    return dateTime.toIso8601String();
  } catch (error) {
    return null;
  }
}

String? convertStringToServerTime(String stringDateTime,
    {String pattern = 'dd/MM/yyyy'}) {
  try {
    final dateTime = DateFormat(pattern).parse(stringDateTime);
    return convertDateToServerTime(dateTime);
  } catch (error) {
    return null;
  }
}

int? nowCompareToDate(String stringDateTime) {
  try {
    return DateTime.now().compareTo(DateTime.parse(stringDateTime));
  } catch (_) {
    return null;
  }
}

String getCurrentDateTimeUTC() => DateTime.now().toUtc().toIso8601String();

int getUnixTime(DateTime time, {bool isUtc = true}) {
  // ignore: constant_identifier_names
  const SECOND_RATIO = 1000;
  int converter(DateTime timeConverter) =>
      (timeConverter.millisecondsSinceEpoch / SECOND_RATIO).ceil();

  final unixTime = isUtc ? converter(time.toUtc()) : converter(time);

  return unixTime;
}

String dateFormatUnixTime(double time, {String pattern = 'dd/MM/yyyy'}) {
  final date = DateTime.fromMillisecondsSinceEpoch((time * 1000).ceil());
  final formatDate = DateFormat(pattern).format(date);
  return formatDate;
}
