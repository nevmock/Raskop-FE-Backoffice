import 'package:raskop_fe_backoffice/core/core.dart';
import 'package:raskop_fe_backoffice/src/menu/domain/entities/menu_entity.dart';

///
abstract class MenuRepositoryInterface {
  ///
  FutureEither<List<MenuEntity>> getAllMenuData();

  ///
  FutureEither<MenuEntity> getMenuDataByID({required String id});

  ///
  FutureEitherVoid createNewMenu({required MenuEntity request});

  ///
  FutureEitherVoid updateCurrentMenu({
    required MenuEntity request,
    required String id,
  });

  ///
  FutureEitherVoid updateMenuStatus({
    required MenuEntity request,
    required String id,
    required bool status,
  });

  ///
  FutureEitherVoid deleteMenu({
    required String id,
    required bool deletePermanent,
  });
}
