import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raskop_fe_backoffice/core/core.dart';
import 'package:raskop_fe_backoffice/src/reservation/repositories/reservation_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reservation_provider.g.dart';

@riverpod

///
ReservationRepository reservationRepository(Ref ref) {
  final client = ref.watch(apiClientProvider());
  return ReservationRepository(client: client);
}
