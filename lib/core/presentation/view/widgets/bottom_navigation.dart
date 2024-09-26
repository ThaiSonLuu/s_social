import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:s_social/core/utils/app_router/app_router.dart';

class BottomNavigation extends StatelessWidget {
  BottomNavigation({super.key});

  final items = [
    // (icon: Icons.home_filled, route: RouterUri.newsFeeds),
    (icon: Icons.home_outlined, route: RouterUri.home),
    (icon: Icons.wechat_rounded, route: RouterUri.messages),
    (icon: Icons.notifications_outlined, route: RouterUri.notifications),
    (icon: Icons.settings_outlined, route: RouterUri.settings)
  ];

  @override
  Widget build(BuildContext context) {
    final currentRoute =
        GoRouterState.of(context).topRoute?.path ?? items[0].route;
    return Row(
      children: items.map(
        (e) {
          final selected = currentRoute == e.route;
          return Expanded(
            child: InkWell(
              splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
              onTap: () {
                if (currentRoute == e.route) {
                  return;
                }

                if (e.route == items[0].route) {
                  context.pop();
                }

                if (currentRoute == items[0].route) {
                  context.push(e.route);
                } else {
                  context.pushReplacement(e.route);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Icon(
                  e.icon,
                  color: selected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                  size: 26.0,
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
