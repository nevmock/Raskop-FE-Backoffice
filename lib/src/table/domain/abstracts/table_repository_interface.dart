import 'package:raskop_fe_backoffice/core/core.dart';
import 'package:raskop_fe_backoffice/src/table/domain/entities/table_entity.dart';

///
abstract class TableRepositoryInterface {
  ///
  FutureEither<List<TableEntity>> getAllTableData();

  ///
  FutureEither<TableEntity> getTableDataByID({required String id});

  ///
  FutureEitherVoid updateTableStatus({
    required TableEntity request,
    required String id,
    required bool isActive,
  });

  ///
  FutureEitherVoid updateTableLocation({
    required TableEntity request,
    required String id,
    required bool isOutdoor,
  });

  ///
  FutureEitherVoid updateTableDescription({
    required TableEntity request,
    required String id,
    required String description,
  });

  ///
  FutureEitherVoid updateTableCapacity({
    required TableEntity request,
    required String id,
    required int minCapacity,
    required int maxCapacity,
  });

  ///
  FutureEitherVoid deleteTable({
    required String id,
    required bool deletePermanent,
  });
}
