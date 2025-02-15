import 'package:raskop_fe_backoffice/core/core.dart';
import 'package:raskop_fe_backoffice/src/supplier/domain/entities/supplier_entity.dart';

///
abstract class SupplierRepositoryInterface {
  ///
  FutureEither<List<SupplierEntity>> getAllSupplierData();

  ///
  FutureEither<SupplierEntity> getSupplierDataByID({required String id});

  ///
  FutureEitherVoid createNewSupplier({required SupplierEntity request});

  ///
  FutureEitherVoid updateCurrentSupplier({
    required SupplierEntity request,
    required String id,
  });

  ///
  FutureEitherVoid updateSupplierStatus({
    required SupplierEntity request,
    required String id,
    required bool status,
  });

  ///
  FutureEitherVoid deleteSupplier({
    required String id,
    required bool deletePermanent,
  });
}
