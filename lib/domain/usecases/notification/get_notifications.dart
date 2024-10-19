import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/data/models/child_classes/notification.dart';
import 'package:instax/domain/repositories/firestore_notification_repository.dart';

class GetNotificationsUseCase
    implements UseCase<List<CustomNotification>, String> {
  final FireStoreNotificationRepository _notificationRepository;

  GetNotificationsUseCase(this._notificationRepository);
  @override
  Future<List<CustomNotification>> call({required String params}) =>
      _notificationRepository.getNotifications(userId: params);
}
