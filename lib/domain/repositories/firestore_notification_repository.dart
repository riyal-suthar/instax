import 'package:instax/data/models/child_classes/notification.dart';
import 'package:instax/domain/entities/notification_check.dart';

abstract class FireStoreNotificationRepository {
  Future<String> createNotification(
      {required CustomNotification newNotification});
  Future<List<CustomNotification>> getNotifications({required String userId});
  Future<void> deleteNotification(
      {required NotificationCheck notificationCheck});
}
