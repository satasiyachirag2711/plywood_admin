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
                  documentRef: FirebaseFirestore.instance
                      .collection('wooden')
                      .doc('plywood'),
                  dataKey: 'plywood',
                ),
                const SizedBox(height: 20),
                HardwareSection(
                  title: "Plywood 21 Year Guarantee",
                  documentRef: FirebaseFirestore.instance
                      .collection('wooden')
                      .doc('plywood_21'),
                  dataKey: 'plywood_21',
                ),
                const SizedBox(height: 20),
                HardwareSection(
                  title: "Plywood Life-Time Guarantee",
                  documentRef: FirebaseFirestore.instance
                      .collection('wooden')
                      .doc('plywood_lifetime'),
                  dataKey: 'plywood_lifetime',
                ),
                const SizedBox(height: 20),
                HardwareSection(
                  title: "Dooe",
                  documentRef: FirebaseFirestore.instance
                      .collection('wooden')
                      .doc('door'),
                  dataKey: 'door',
                ),
                const SizedBox(height: 20),
                HardwareSection(
                  title: "Blackboard",
                  documentRef: FirebaseFirestore.instance
                      .collection('wooden')
                      .doc('blackboard'),
                  dataKey: 'blackboard',
                ),
                const SizedBox(height: 20),
                HardwareSection(
                  title: "MDF",
                  documentRef: FirebaseFirestore.instance
                      .collection('wooden')
                      .doc('mdf'),
                  dataKey: 'mdf',
                ),
                const SizedBox(height: 20),
                HardwareSection(
                  title: "Blackboard",
                  documentRef: FirebaseFirestore.instance
                      .collection('wooden')
                      .doc('blackboard'),
                  dataKey: 'blackboard',
                ),
                const SizedBox(height: 20),
                HardwareSection(
                  title: "SDf",
                  documentRef: FirebaseFirestore.instance
                      .collection('wooden')
                      .doc('sdf'),
                  dataKey: 'sdf',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
