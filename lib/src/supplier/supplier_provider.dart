import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:raskop_fe_backoffice/src/supplier/repositories/supplier_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'supplier_provider.g.dart';

@riverpod

///
SupplierRepository supplierRepository(Ref ref) {
  final client = http.Client();
  return SupplierRepository(client: client);
}
