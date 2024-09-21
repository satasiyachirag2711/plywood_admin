
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plywood_admin/screens/pages/hardware_screen.dart';
import 'package:plywood_admin/screens/pages/other_screen.dart';
import 'package:plywood_admin/screens/pages/wooden_screen.dart';
import 'package:provider/provider.dart';

import '../../controllers/MenuAppController.dart';
import '../../responsive.dart';
import '../pages/dashboard_screen.dart';
import 'side_menu.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 4,
              child:Obx(() => data.value==1?Woodenscreen():data.value==2?HardwareScreen():data.value==3?OtherScreen(): DashboardScreen(),),
            ),
          ],
        ),
      ),
    );
  }
}
