import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plywood_admin/screens/custom/custom_name.dart';
import 'package:plywood_admin/screens/custom/header.dart';

class Woodenscreen extends StatefulWidget {
  const Woodenscreen({super.key});

  @override
  State<Woodenscreen> createState() => _WoodenscreenState();
}

class _WoodenscreenState extends State<Woodenscreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Header(title: "Woodens"),
                HardwareSection(
                  title: "Plywood",
                  documentRef: FirebaseFirestore.instance.collection('wooden').doc('plywood'),
                  dataKey: 'plywood',
                ), const SizedBox(height: 16),
                HardwareSection(
                  title: "MDF",
                  documentRef: FirebaseFirestore.instance.collection('wooden').doc('mdf'),
                  dataKey: 'mdf',
                ),  const SizedBox(height: 16),

                HardwareSection(
                  title: "Rk-Screw",
                  documentRef: FirebaseFirestore.instance.collection('wooden').doc('rk-screw'),
                  dataKey: 'rk-screw',

                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
