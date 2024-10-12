import 'package:flutter/foundation.dart';

import '../di.dart';
import 'local_notification_service.dart';

showNotification({
  required int id,
  required String title,
  required String body,
  required int delay,
}) {
  if (defaultTargetPlatform == TargetPlatform.android) {
    getIt<LocalNotificationService>().showNotificationAndroid(
      id,
      title,
      body,
      delay,
    );
  } else {
    getIt<LocalNotificationService>().showNotificationIos(
      id,
      title,
      body,
      delay,
    );
  }
}
