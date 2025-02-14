import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raskop_fe_backoffice/core/core.dart';
import 'package:raskop_fe_backoffice/src/supplier/repositories/supplier_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'supplier_provider.g.dart';

@riverpod

///
SupplierRepository supplierRepository(Ref ref) {
  final client = ref.watch(apiClientProvider);
  return SupplierRepository(client: client);
}
