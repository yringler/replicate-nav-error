import 'dart:math';

import 'package:flutter_breadcrumb_menu/flutter_breadcrumb_menu.dart';

/// Keep track of what the current bread crumb state is.
class BreadcrumbService {
  List<Bread> breads = [];

  void setCurrentBread({String routeName, dynamic argument}) {
    // Setting a bread which is already in use rewinds us back to that point.
    if (!removeUntil(route: routeName, argument: argument)) {
      // Add it if it wasn't there already.
      breads.add(Bread(
          label: 'test' + random.nextInt(3).toString(),
          route: routeName,
          arguments: argument));
    }
  }

  /// Removes breads until bread with matching route and argument is found, exclusive.
  /// Returns true if item was found.
  bool removeUntil({String route, dynamic argument}) {
    if (breads.isEmpty) {
      return false;
    }

    final i = breads.indexWhere(
        (element) => element.arguments == argument && element.route == route);

    if (i > -1) {
      // Eg if exists at first element (index 0), the new length is 1 (index + 1).
      breads.length = i + 1;
    }

    // Return true if item was found.
    return i > -1;
  }

  void clear() {
    breads.clear();
  }
}

final random = Random();
