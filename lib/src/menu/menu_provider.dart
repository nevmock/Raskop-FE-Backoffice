import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:raskop_fe_backoffice/core/client.dart';
import 'package:raskop_fe_backoffice/src/menu/repositories/menu_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'menu_provider.g.dart';

@riverpod

///
MenuRepository menuRepository(Ref ref) {
  final client = http.Client();
  final baseClient = ref.watch(apiClientProvider);
  return MenuRepository(client: client, baseClient: baseClient);
}
