import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum Pages {
  splash,
  login,
  home,
  portfolio,
  watchlist,
  transactions,
  settings,
  profile,
}

extension PageExtention on Pages {
  String toPath({
    bool isSubRoute = false,
    String? pathParam,
    String? pathPrefix,
  }) {
    String path = name.toLowerCase();

    if (pathPrefix != null && pathPrefix.isNotEmpty) {
      final prefix = pathPrefix.startsWith('/') ? pathPrefix : '/$pathPrefix';
      path = '$prefix/$path';
    } else {
      path = '/$path';
    }

    if (pathParam != null && pathParam.isNotEmpty) {
      final param = pathParam.startsWith(':') ? pathParam : ':$pathParam';
      path = '$path/$param';
    }

    if (isSubRoute) {
      path = path.replaceFirst('/', '');
    }

    return path;
  }

  String toPathName() {
    return name.toLowerCase();
  }

  void go(
    BuildContext context, {
    Map<String, String> params = const <String, String>{},
    Map<String, String> queryParams = const <String, String>{},
    Object? extra,
  }) {
    GoRouter.of(context).goNamed(
      toPathName(),
      pathParameters: params,
      queryParameters: queryParams,
      extra: extra,
    );
  }

  void push(
    BuildContext context, {
    Map<String, String> params = const <String, String>{},
    Map<String, String> queryParams = const <String, String>{},
    Object? extra,
  }) {
    GoRouter.of(context).pushNamed(
      toPathName(),
      pathParameters: params,
      queryParameters: queryParams,
      extra: extra,
    );
  }
}
