import 'package:raskop_fe_backoffice/core/core.dart';
import 'package:raskop_fe_backoffice/src/supplier/domain/entities/supplier_entity.dart';

///
abstract class SupplierRepositoryInterface {
  ///
  FutureEither<List<SupplierEntity>> getAllSupplierData();

  ///
  FutureEither<SupplierEntity> getSupplierDataByID({required String id});

  ///
  FutureEitherVoid createNewSupplier();

  ///
  FutureEitherVoid updateCurrentSupplier();

  ///
  FutureEitherVoid deleteSupplier();
}
