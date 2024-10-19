import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/data/models/child_classes/notification.dart';
import 'package:instax/domain/repositories/firestore_notification_repository.dart';

class CreateNotificationUseCase implements UseCase<String, CustomNotification> {
  final FireStoreNotificationRepository _notificationRepository;

  CreateNotificationUseCase(this._notificationRepository);
  @override
  Future<String> call({required CustomNotification params}) =>
      _notificationRepository.createNotification(newNotification: params);
}
