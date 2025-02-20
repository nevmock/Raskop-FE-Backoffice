import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:raskop_fe_backoffice/core/core.dart';
import 'package:raskop_fe_backoffice/res/paths.dart';

/// http provider
final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();

  ref.onDispose(client.close);

  return client;
});

/// api client provier
Provider<ApiClient> apiClientProvider({
  String baseUrl = BasePaths.baseAPIURL,
}) =>
    Provider<ApiClient>((ref) {
      final client = ref.watch(httpClientProvider);
      return ApiClient(client: client, baseUrl: baseUrl);
    });
