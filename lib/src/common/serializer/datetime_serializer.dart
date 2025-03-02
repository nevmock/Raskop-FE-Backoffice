// ignore_for_file: avoid_dynamic_calls

import 'package:json_annotation/json_annotation.dart';

/// DateTime Serializer so we can convert datetime dynamic value from Json into concrete DateTime value in flutter
class DateTimeSerializer implements JsonConverter<DateTime, dynamic> {
  /// DateTime Serializer Constructor
  const DateTimeSerializer();

  @override
  DateTime fromJson(dynamic object) => DateTime.parse(object.toString());

  @override
  dynamic toJson(DateTime object) => object.toString();
}
