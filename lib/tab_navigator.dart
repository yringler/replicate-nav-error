import 'dart:math';

import 'package:flutter/material.dart';
import 'package:replicatenaverror/app.dart';
import 'package:replicatenaverror/bottom_navigation.dart';
import 'package:replicatenaverror/color_detail_page.dart';
import 'package:replicatenaverror/colors_list_page.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class TabNavigator extends StatelessWidget {
  TabNavigator({this.navigatorKey, this.tabItem});
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;

  void _push(BuildContext context, {int materialIndex: 500}) {
    var routeBuilders = _routeBuilders(context, materialIndex: materialIndex);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => routeBuilders[TabNavigatorRoutes.detail](context),
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context,
      {int materialIndex: 500}) {
    return {
      TabNavigatorRoutes.root: (context) => ColorsListPage(
            color: activeTabColor[tabItem],
            title: tabName[tabItem],
            onPush: (materialIndex) =>
                _push(context, materialIndex: materialIndex),
          ),
      TabNavigatorRoutes.detail: (context) => ColorDetailPage(
            color: activeTabColor[tabItem],
            title: tabName[tabItem],
            materialIndex: materialIndex,
          ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context);
    return Navigator(
      key: navigatorKey,
      observers: [BreadcrumbsNavigateUpdater()],
      initialRoute: TabNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        if (routeSettings.name == '/') {
          breadService.clear();
        } else {
          breadService.setCurrentBread(
              routeName: routeSettings.name, argument: routeSettings.arguments);
        }

        return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name](context),
            settings: routeSettings);
      },
    );
  }
}

/// Ensures that, if user uses back button to go to parent section, further bread
/// crumbs are built from the parent point, not appended to previous child section.
class BreadcrumbsNavigateUpdater extends NavigatorObserver {
  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    if (route.settings.name != '/') {
      // We don't know wether previous or current route are parent or child.
      // So remove untill whichever is higher, and than add bread for current screen.
      breadService.removeUntil(
          route: route.settings.name, argument: route.settings.arguments);
      breadService.removeUntil(
          route: previousRoute.settings.name,
          argument: previousRoute.settings.arguments);

      breadService.setCurrentBread(
          routeName: previousRoute.settings.name,
          argument: previousRoute.settings.arguments);
    } else if (route.settings.name == '/') {
      breadService.clear();
    }
  }
}
