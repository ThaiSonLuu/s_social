import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:s_social/common/app_constants/firestore_collection_constants.dart';
import 'package:s_social/core/domain/model/notification_model.dart';

class NotificationDataSource {
  CollectionReference get _notificationCollection {
    final firestoreDatabase = FirebaseFirestore.instance;
    return firestoreDatabase
        .collection(FirestoreCollectionConstants.notifications);
  }

  Future<NotificationModel> createNotification(
      NotificationModel notification) async {
    try {
      DocumentReference<dynamic> doc = _notificationCollection.doc();
      final saveNotification = notification.copyWith(id: doc.id);
      await doc.set(saveNotification.toJson());
      return saveNotification;
    } catch (_) {
      rethrow;
    }
  }

  Future<void> createNotifications(
    List<NotificationModel> notifications,
  ) async {
    try {
      notifications.forEach((notification) async {
        DocumentReference<dynamic> doc = _notificationCollection.doc();
        final saveNotification = notification.copyWith(id: doc.id);
        await doc.set(saveNotification.toJson());
      });
    } catch (_) {
      rethrow;
    }
  }

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        return [];
      }

      final snapShot = await _notificationCollection
          .where(
            "uid",
            isEqualTo: uid,
          )
          .get();

      final result = snapShot.docs.map((doc) {
        return NotificationModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      result.sort((a, b) {
        if (a.time == null || b.time == null) {
          return 0;
        }

        return b.time!.millisecondsSinceEpoch - a.time!.millisecondsSinceEpoch;
      });

      return result;
    } catch (_) {
      rethrow;
    }
  }

  Future<void> markNotificationsAsRead(String id) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        return;
      }

      final snapshot = await _notificationCollection
          .where('id', isEqualTo: id)
          .where('uid', isEqualTo: uid)
          .where('read', isEqualTo: false)
          .get();

      final batch = FirebaseFirestore.instance.batch();

      for (var doc in snapshot.docs) {
        batch.update(doc.reference, {'read': true});
      }

      await batch.commit();
    } catch (_) {
      rethrow;
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        return;
      }

      final snapshot = await _notificationCollection
          .where('uid', isEqualTo: uid)
          .where('read', isEqualTo: false)
          .get();

      final batch = FirebaseFirestore.instance.batch();

      for (var doc in snapshot.docs) {
        batch.update(doc.reference, {'read': true});
      }

      await batch.commit();
    } catch (_) {
      rethrow;
    }
  }

  Future<int> countUnreadNotifications() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        return 0;
      }

      final snapshot = await _notificationCollection
          .where('uid', isEqualTo: uid)
          .where('read', isEqualTo: false)
          .get();

      return snapshot.docs.length;
    } catch (_) {
      rethrow;
    }
  }
}
