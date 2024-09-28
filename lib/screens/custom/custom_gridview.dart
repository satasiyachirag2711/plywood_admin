import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomDataGrid extends StatelessWidget {
  final DocumentReference documentRef;

  const CustomDataGrid({
    super.key,
    required this.documentRef,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: documentRef.get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data?.data() == null) {
          return const Center(child: Text("No data found"));
        }

        var data = snapshot.data!.data() as Map<String, dynamic>;
        var urls = List<String>.from(data['url']);

        return LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = 2; // Default for small screens
            if (constraints.maxWidth > 1200) {
              crossAxisCount = 5; // For large screens
            } else if (constraints.maxWidth > 800) {
              crossAxisCount = 4; // For medium screens
            } else if (constraints.maxWidth > 600) {
              crossAxisCount = 3; // For small tablets
            }

            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: urls.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1, // Square aspect ratio for images
              ),
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    urls[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
