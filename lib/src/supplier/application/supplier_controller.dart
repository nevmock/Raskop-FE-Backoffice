import 'package:raskop_fe_backoffice/src/supplier/domain/entities/supplier_entity.dart';
import 'package:raskop_fe_backoffice/src/supplier/supplier_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'supplier_controller.g.dart';

@riverpod

///
class SupplierController extends _$SupplierController {
  @override

  /// auto build widget when calling the controller
  FutureOr<List<SupplierEntity>> build() async {
    final res = await ref.read(supplierRepositoryProvider).getAllSupplierData();
    return res.fold(
      (l) => throw l,
      (r) => r,
    );
  }

  /// can be called using riverpod notifier
  Future<SupplierEntity> getByID({required String id}) async {
    final res =
        await ref.read(supplierRepositoryProvider).getSupplierDataByID(id: id);
    return res.fold(
      (l) => throw l,
      (r) => r,
    );
  }
}
