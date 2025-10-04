import 'package:centranews/models/local_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = NotifierProvider<UserNotifier, LocalUser?>(
  () => UserNotifier(),
);

class UserNotifier extends Notifier<LocalUser?> {
  @override
  LocalUser? build() {
    LocalUser? initialValue;
    return initialValue;
  }
}
