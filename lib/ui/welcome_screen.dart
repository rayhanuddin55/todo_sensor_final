import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_sensor/di.dart';
import 'package:todo_sensor/router.dart';
import 'package:todo_sensor/utils/app_colors.dart';
import 'package:todo_sensor/utils/local_notification_service.dart';

import '../utils/show_notification.dart';

class WelcomeScreen extends HookWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    show() {
      getIt.get<LocalNotificationService>().requestPermission();
    }

    useEffect(() {
      Future.microtask(() {
        show();
      });
    }, []);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: deviceWidth * 0.75,
              height: 75,
              child: ElevatedButton(
                onPressed: () {
                  context.pushNamed("todoSplash");
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(AppColors.primary),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                ),
                child: Text(
                  "A To-Do List",
                  style: GoogleFonts.poppins().copyWith(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: deviceWidth * 0.75,
              height: 75,
              child: ElevatedButton(
                onPressed: () {
                  context.pushNamed("sensorTrackingPage");
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(AppColors.secondary),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                ),
                child: Text(
                  "Sensor Tracking",
                  style: GoogleFonts.poppins().copyWith(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
