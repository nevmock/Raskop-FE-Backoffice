import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:raskop_fe_backoffice/core/client.dart';
import 'package:raskop_fe_backoffice/src/table/repositories/table_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'table_provider.g.dart';

@riverpod

///
TableRepository tableRepository(Ref ref) {
  final client = http.Client();
  final baseClient = ref.watch(apiClientProvider());
  return TableRepository(client: client, baseClient: baseClient);
}
