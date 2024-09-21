import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plywood_admin/screens/custom/popup.dart';

import '../custom/custom_name.dart';
import '../custom/header.dart';
class HardwareScreen extends StatefulWidget {
  const HardwareScreen({super.key});

  @override
  State<HardwareScreen> createState() => _HardwareScreenState();
}

class _HardwareScreenState extends State<HardwareScreen> {

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
                Header(title: "Hardwares"),
                HardwareSection(
                  title: "Fancyhandle",
                  documentRef: FirebaseFirestore.instance.collection('hardware').doc('fancyhandle'),
                  dataKey: 'fancyhandle',
                ), const SizedBox(height: 16),
                HardwareSection(
                  title: "Knobs",
                  documentRef: FirebaseFirestore.instance.collection('hardware').doc('knobs'),
                  dataKey: 'knobs',

                ), const SizedBox(height: 16),
                HardwareSection(
                  title: "brasshings",
                  documentRef: FirebaseFirestore.instance.collection('hardware').doc('brasshings'),
                  dataKey: 'brasshings',

                ),
                const SizedBox(height: 16),
                HardwareSection(
                  title: "Brasshings",
                  documentRef: FirebaseFirestore.instance.collection('hardware').doc('brasshings'),
                  dataKey: 'brasshings',

                ), const SizedBox(height: 16),
                HardwareSection(
                  title: "Doorcloser",
                  documentRef: FirebaseFirestore.instance.collection('hardware').doc('doorcloser'),
                  dataKey: 'doorcloser',

                ), const SizedBox(height: 16),
                HardwareSection(
                  title: "Drawerlock",
                  documentRef: FirebaseFirestore.instance.collection('hardware').doc('drawerlock'),
                  dataKey: 'drawerlock',

                ), const SizedBox(height: 16),

                HardwareSection(
                  title: "Nicklescrew",
                  documentRef: FirebaseFirestore.instance.collection('hardware').doc('nicklescrew'),
                  dataKey: 'nicklescrew',

                ), const SizedBox(height: 16),
                HardwareSection(
                  title: "Popblack",
                  documentRef: FirebaseFirestore.instance.collection('hardware').doc('popblack'),
                  dataKey: 'popblack',

                ), const SizedBox(height: 16),
                HardwareSection(
                  title: "Pullhandle",
                  documentRef: FirebaseFirestore.instance.collection('hardware').doc('pullhandle'),
                  dataKey: 'pullhandle',

                ), const SizedBox(height: 16),
                HardwareSection(
                  title: "Rosehandlelock",
                  documentRef: FirebaseFirestore.instance.collection('hardware').doc('rosehandlelock'),
                  dataKey: 'rosehandlelock',

                ), const SizedBox(height: 16),
                HardwareSection(
                  title: "Selftappings",
                  documentRef: FirebaseFirestore.instance.collection('hardware').doc('selftapping'),
                  dataKey: 'selftapping',

                ), const SizedBox(height: 16),
                HardwareSection(
                  title: "Softcloseautohings",
                  documentRef: FirebaseFirestore.instance.collection('hardware').doc('softcloseautohings'),
                  dataKey: 'softcloseautohings',

                ), const SizedBox(height: 16),
                HardwareSection(
                  title: "Sshings",
                  documentRef: FirebaseFirestore.instance.collection('hardware').doc('sshings'),
                  dataKey: 'sshings',

                ), const SizedBox(height: 16),
                HardwareSection(
                  title: "Ssscrews",
                  documentRef: FirebaseFirestore.instance.collection('hardware').doc('ssscrews'),
                  dataKey: 'ssscrews',

                ), const SizedBox(height: 16),
                HardwareSection(
                  title: "Ssstopper",
                  documentRef: FirebaseFirestore.instance.collection('hardware').doc('ssstopper'),
                  dataKey: 'ssstopper',

                ), const SizedBox(height: 16),
                HardwareSection(
                  title: "Telescopicchannle",
                  documentRef: FirebaseFirestore.instance.collection('hardware').doc('telescopicchannle'),
                  dataKey: 'telescopicchannle',

                ), const SizedBox(height: 16),
                HardwareSection(
                  title: "Telescopicsoftclose",
                  documentRef: FirebaseFirestore.instance.collection('hardware').doc('telescopicsoftclose'),
                  dataKey: 'telescopicsoftclose',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
