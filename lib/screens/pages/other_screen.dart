import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plywood_admin/screens/custom/custom_name.dart';
import 'package:plywood_admin/screens/custom/header.dart';
import '../custom/popup.dart';

class OtherScreen extends StatefulWidget {
  const OtherScreen({super.key});

  @override
  State<OtherScreen> createState() => _OtherScreenState();
}

class _OtherScreenState extends State<OtherScreen> {
  void _showAddItemPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.brown,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.9,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  "Add Item",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: PopupCustom(
                      onSubmitSuccess: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Header(title: "Others"),
                HardwareSection(
                  title: "Veneers",
                  documentRef: FirebaseFirestore.instance.collection('other').doc('veneers'),
                  dataKey: 'veneers',
                ), const SizedBox(height: 16),
                HardwareSection(
                  title: "Laminates",
                  documentRef: FirebaseFirestore.instance.collection('other').doc('laminates'),
                  dataKey: 'laminates',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
