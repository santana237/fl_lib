import 'package:dio/dio.dart';
import 'package:fl_lib/src/core/ext/ctx/common.dart';
import 'package:fl_lib/src/core/ext/ctx/dialog.dart';
import 'package:fl_lib/src/core/ext/ctx/snackbar.dart';
import 'package:fl_lib/src/core/ext/string.dart';
import 'package:fl_lib/src/core/logger.dart';
import 'package:fl_lib/src/core/utils/platform/base.dart';
import 'package:fl_lib/src/model/update.dart';
import 'package:flutter/material.dart';

abstract final class AppUpdateIface {
  static final newestBuild = ValueNotifier<int?>(null);

  static Future<bool> _isUrlAvailable(String url) async {
    try {
      final resp = await Dio().head(url);
      return resp.statusCode == 200;
    } catch (e) {
      Loggers.app.warning('HEAD update file failed', e);
      return false;
    }
  }

  static Future<void> doUpdate({
    required int build,
    required String url,
    required BuildContext context,
    required String updateL10n,
    bool force = false,
  }) async {
    if (isWeb) return;

    final update = await AppUpdate.fromUrl(url);

    final newest = update.build.last.current;
    if (newest == null) {
      Loggers.app.warning('Update not available on ${Pfs.type}');
      return;
    }

    newestBuild.value = newest;

    if (!force && newest <= build) {
      Loggers.app.info('Update ignored: $build >= $newest');
      return;
    }
    Loggers.app.info('Update available: $newest');

    final fileUrl = update.url.current;

    if (fileUrl == null || !await _isUrlAvailable(fileUrl)) {
      Loggers.app.warning('Update file not available');
      return;
    }

    final min = update.build.min.current;

    final tip = 'v1.0.$newest\n${update.changelog.current}';

    if (min != null && min > build) {
      // ignore: use_build_context_synchronously
      context.showRoundDialog(
        title: 'v1.0.$newest',
        child: Text(update.changelog.current ?? '~'),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
              _doUpdate(update, context);
            },
            child: Text(updateL10n),
          )
        ],
      );
      return;
    }

    // ignore: use_build_context_synchronously
    context.showSnackBarWithAction(
      content: tip,
      action: updateL10n,
      onTap: () => _doUpdate(update, context),
    );
  }

  static Future<void> _doUpdate(
    AppUpdate update,
    BuildContext context
  ) async {
    final url = update.url.current;
    if (url == null) {
      Loggers.app.warning('Update url not is null');
      return;
    }

    switch (Pfs.type) {
      case Pfs.windows || Pfs.linux || Pfs.ios || Pfs.macos || Pfs.android:
        await url.launch();
        break;
      default:
        context.showRoundDialog(
          title: 'Error',
          child: Text('Unsupported platform: ${Pfs.type}'),
        );
        break;
    }
  }
}