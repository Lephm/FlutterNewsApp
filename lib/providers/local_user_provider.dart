import 'package:centranews/models/local_user.dart';
import 'package:flutter_riverpod/legacy.dart';

final userProvider = StateNotifierProvider<UserNotifier, LocalUser>(
  (ref) => UserNotifier(),
);

class UserNotifier extends StateNotifier<LocalUser> {
  UserNotifier() : super(LocalUser());
}
