import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:s_social/core/domain/model/notification_model.dart';
import 'package:s_social/core/utils/snack_bar.dart';
import 'package:s_social/di/injection_container.dart';
import 'package:s_social/features/notifications/presentation/logic/notifications_cubit.dart';
import 'package:s_social/generated/l10n.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          NotificationsCubit(serviceLocator())..getNotifications(),
      child: const _NotificationsScreen(),
    );
  }
}

class _NotificationsScreen extends StatelessWidget {
  const _NotificationsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.checklist_rtl),
            onPressed: () {
              context.read<NotificationsCubit>().markNotificationsAsRead();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<NotificationsCubit>().getNotifications();
        },
        child: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoaded) {
              return _buildNotificationsList(state.notifications);
            }

            if (state is NotificationsError) {
              return Center(child: Text(state.message));
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildNotificationsList(List<NotificationModel> notifications) {
    if (notifications.isEmpty) {
      return const Center(child: Text('No notifications.'));
    }

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        final timeAgo = getFormattedTime(notification.time);

        return InkWell(
          onTap: () async {
            if (notification.route != null) {
              try {
                await context.push(notification.route!);
                if (context.mounted) {
                  await context
                      .read<NotificationsCubit>()
                      .markNotificationAsRead(notification.id ?? "");
                }
              } catch (e) {
                if (context.mounted) {
                  context.showSnackBarFail(
                    text: S.of(context).an_error_occur,
                  );
                }
              }
            }
          },
          child: Container(
            color: notification.read
                ? null
                : Theme.of(context).colorScheme.surfaceContainerLowest,
            // Lighter background for unread notifications
            child: ListTile(
              leading: notification.imageUrl != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(notification.imageUrl!),
                    )
                  : const CircleAvatar(child: Icon(Icons.notifications)),
              title: Text(
                notification.title ?? 'No Title',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification.message ?? 'No Message'),
                  Text(timeAgo, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Function to get the time difference as a human-readable string
  String getFormattedTime(DateTime? time) {
    if (time == null) {
      return "";
    }

    try {
      final now = DateTime.now();
      final difference = now.difference(time);

      String result = timeago.format(time);

      result = result[0].toUpperCase() + result.substring(1);

      if (difference.inDays > 7) {
        result += ', ${time.day}/${time.month}/${time.year}';
      }

      return result;
    } catch (e) {
      return "";
    }
  }
}
