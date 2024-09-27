import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plywood_admin/screens/custom/custom_gridview.dart';
class HardwareSection extends StatelessWidget {
  final String title;
  final DocumentReference documentRef;
  final String dataKey;

  const HardwareSection({
    Key? key,
    required this.title,
    required this.documentRef,
    required this.dataKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomDataGrid(
          documentRef: documentRef,
          dataKey: dataKey,
        ),
      ],
    );
  }
}
