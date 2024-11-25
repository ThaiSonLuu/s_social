import 'package:s_social/core/data/data_source/notification_data_source.dart';
import 'package:s_social/core/domain/model/notification_model.dart';
import 'package:s_social/core/domain/repository/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationDataSource _dataSource;

  NotificationRepositoryImpl(this._dataSource);

  @override
  Future<NotificationModel> createNotification(
      NotificationModel notification) async {
    try {
      return await _dataSource.createNotification(notification);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> createNotifications(
      List<NotificationModel> notifications) async {
    try {
      await _dataSource.createNotifications(notifications);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<NotificationModel>> getNotifications() async {
    try {
      return await _dataSource.getNotifications();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> markNotificationAsRead(String id) async {
    try {
      await _dataSource.markNotificationsAsRead(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> markAllNotificationsAsRead() async {
    try {
      await _dataSource.markAllNotificationsAsRead();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<int> countUnreadNotifications() {
    try {
      return _dataSource.countUnreadNotifications();
    } catch (e) {
      rethrow;
    }
  }
}
