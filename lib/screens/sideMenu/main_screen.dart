import 'package:flutter/material.dart';
import 'package:plywood_admin/screens/pages/wooden_screen.dart';
import 'package:provider/provider.dart';

import '../../controllers/MenuAppController.dart';
import '../../responsive.dart';
import 'side_menu.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              const Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            const Expanded(
              // It takes 5/6 part of the screen
              flex: 4,
              child: Woodenscreen(),
            ),
          ],
        ),
      ),
    );
  }
}
