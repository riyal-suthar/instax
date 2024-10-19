import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instax/domain/entities/notification_check.dart';

import '../../../data/models/child_classes/notification.dart';
import '../../../domain/usecases/notification/create_notification.dart';
import '../../../domain/usecases/notification/delete_notification.dart';
import '../../../domain/usecases/notification/get_notifications.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final CreateNotificationUseCase _createNotificationUseCase;
  final DeleteNotificationUseCase _deleteNotificationUseCase;
  NotificationCubit(this._getNotificationsUseCase,
      this._createNotificationUseCase, this._deleteNotificationUseCase)
      : super(NotificationInitial());

  static NotificationCubit get(BuildContext context) =>
      BlocProvider.of(context);

  List<CustomNotification> notifications = [];

  Future<void> getNotifications({required String userId}) async {
    emit(NotificationLoading());
    await _getNotificationsUseCase.call(params: userId).then((value) {
      notifications = value;
      emit(NotificationLoaded(notifications: notifications));
    }).catchError((e) {
      emit(NotificationFailed(e.toString()));
    });
  }

  Future<void> createNotification(
      {required CustomNotification newNotification}) async {
    await _createNotificationUseCase
        .call(params: newNotification)
        .then((value) {
      emit(NotificationCreated(notificationUid: value));
    }).catchError((e) {
      emit(NotificationFailed(e.toString()));
    });
  }

  deleteNotification({required NotificationCheck notificationCheck}) async {
    await _deleteNotificationUseCase
        .call(params: notificationCheck)
        .then((value) {
      emit(NotificationDeleted());
    }).catchError((e) {
      emit(NotificationFailed(e.toString()));
    });
  }
}
