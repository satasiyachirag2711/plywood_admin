import 'package:flutter/material.dart';
import '../custom/header.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Header(title: "Dashboard",),
          ],
        ),
      ),
    );
  }
}
