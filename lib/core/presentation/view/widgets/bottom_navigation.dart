import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:s_social/core/utils/app_router/app_router.dart';
import 'package:s_social/features/notifications/presentation/logic/unread_notification_cubit.dart';

class BottomNavigation extends StatelessWidget {
  BottomNavigation({super.key});

  final items = [
    (icon: Icons.home_outlined, route: RouterUri.home),
    (icon: Icons.wechat_rounded, route: RouterUri.messages),
    (icon: Icons.notifications_outlined, route: RouterUri.notifications),
    (icon: Icons.settings_outlined, route: RouterUri.settings),
  ];

  @override
  Widget build(BuildContext context) {
    final currentRoute =
        GoRouterState.of(context).topRoute?.path ?? items[0].route;

    return SizedBox(
      height: 60.0,
      width: double.maxFinite,
      child: Row(
        children: items.map((e) {
          final selected = currentRoute == e.route;
          return Expanded(
            child: InkWell(
              splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
              onTap: () {
                if (currentRoute == e.route) return;

                if (e.route == items[0].route) {
                  context.pop();
                } else if (currentRoute == items[0].route) {
                  context.push(e.route);
                } else {
                  context.pushReplacement(e.route);
                }
              },
              child: Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      e.icon,
                      color: selected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                      size: 26.0,
                    ),
                    if (e.route == RouterUri.notifications)
                      Positioned(
                        right: -4,
                        top: -4,
                        child: BlocBuilder<UnreadNotificationsCubit, int>(
                          builder: (context, count) {
                            if (count == 0) return const SizedBox();
                            return Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '$count',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
