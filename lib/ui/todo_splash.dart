import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_sensor/router.dart';

import '../generated/assets.dart';

class TodoSplash extends HookWidget {
  const TodoSplash({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      Future.delayed(const Duration(milliseconds: 1000), () {
        context.goNamed("todoHome");
      });
      return;
    }, []);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.iconsIcTask1,
            ),
            Text(
              "Daily To-Do App",
              style: GoogleFonts.sigmar().copyWith(
                fontSize: 21,
              ),
            )
          ],
        ),
      ),
    );
  }
}
