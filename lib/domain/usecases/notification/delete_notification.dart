import 'package:instax/data/models/child_classes/notification.dart';
import 'package:instax/domain/entities/notification_check.dart';
import 'package:instax/domain/repositories/firestore_notification_repository.dart';

import '../../../core/use_cases/use_case.dart';

class DeleteNotificationUseCase implements UseCase<void, NotificationCheck> {
  final FireStoreNotificationRepository _notificationRepository;

  DeleteNotificationUseCase(this._notificationRepository);

  @override
  Future<void> call({required NotificationCheck params}) =>
      _notificationRepository.deleteNotification(notificationCheck: params);
}
