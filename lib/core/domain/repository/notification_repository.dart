import 'package:s_social/core/domain/model/notification_model.dart';

abstract class NotificationRepository {
  Future<NotificationModel> createNotification(NotificationModel notification);

  Future<void> createNotifications(List<NotificationModel> notifications);

  Future<List<NotificationModel>> getNotifications();

  Future<void> markNotificationAsRead(String id);

  Future<void> markAllNotificationsAsRead();

  Stream<int> countUnreadNotifications();
}
