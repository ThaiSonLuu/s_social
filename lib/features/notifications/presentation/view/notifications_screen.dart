import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:s_social/core/domain/model/notification_model.dart';
import 'package:s_social/core/presentation/logic/cubit/app_language/app_language_cubit.dart';
import 'package:s_social/core/utils/shimmer_loading.dart';
import 'package:s_social/core/utils/snack_bar.dart';
import 'package:s_social/core/utils/ui/cache_image.dart';
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

class _NotificationsScreen extends StatefulWidget {
  const _NotificationsScreen();

  @override
  State<_NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<_NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages("vi", timeago.ViMessages());
    timeago.setLocaleMessages("en", timeago.EnMessages());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).notifications),
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
              return _buildNotificationsList(context, state.notifications);
            }

            if (state is NotificationsError) {
              return Center(child: Text(state.message));
            }

            return _buildNotificationsLoading(context);
          },
        ),
      ),
    );
  }

  Widget _buildNotificationsList(
      BuildContext context, List<NotificationModel> notifications) {
    if (notifications.isEmpty) {
      return Center(child: Text(S.of(context).no_notifications));
    }

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        final timeAgo = getFormattedTime(context, notification.time);

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
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              leading: notification.imageUrl != null
                  ? Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: CacheImage(
                        imageUrl: notification.imageUrl!,
                        loadingWidth: 50,
                        loadingHeight: 50,
                      ),
                    )
                  : const CircleAvatar(child: Icon(Icons.notifications)),
              title: Text(
                notification.title ?? S.of(context).no_title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification.message ?? S.of(context).no_message),
                  Text(timeAgo, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotificationsLoading(BuildContext context) {
    return ListView.builder(
      itemCount: 12,
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          leading: Container(
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: const ShimmerLoading(
              width: 50,
              height: 50,
            ),
          ),
          title: const ShimmerLoading(width: 180, height: 20),
          subtitle: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4.0),
              ShimmerLoading(width: 120, height: 18),
              SizedBox(height: 4.0),
              ShimmerLoading(width: 80, height: 14),
            ],
          ),
        );
      },
    );
  }

  // Function to get the time difference as a human-readable string
  String getFormattedTime(BuildContext context, DateTime? time) {
    if (time == null) {
      return "";
    }

    try {
      final now = DateTime.now();
      final difference = now.difference(time);

      String result = timeago.format(
        time,
        locale: context.read<AppLanguageCubit>().state.languageCode,
      );

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
