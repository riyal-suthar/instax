import 'package:instax/data/data_sources/remote/fiirebase_firestore/notification/firebase_notification.dart';
import 'package:instax/data/models/child_classes/notification.dart';
import 'package:instax/domain/entities/notification_check.dart';
import 'package:instax/domain/repositories/firestore_notification_repository.dart';

class FireStoreNotificationRepoImpl implements FireStoreNotificationRepository {
  final FireStoreNotification _notification;

  FireStoreNotificationRepoImpl(this._notification);

  @override
  Future<String> createNotification(
      {required CustomNotification newNotification}) async {
    try {
      return await _notification.createNotification(newNotification);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> deleteNotification(
      {required NotificationCheck notificationCheck}) {
    try {
      return _notification.deleteNotification(notification: notificationCheck);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<CustomNotification>> getNotifications({required String userId}) {
    try {
      return _notification.getNotifications(userId: userId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
