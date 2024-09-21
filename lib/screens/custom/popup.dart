import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PopupCustom extends StatefulWidget {
  final VoidCallback onSubmitSuccess;
  const PopupCustom({super.key, required this.onSubmitSuccess});

  @override
  State<PopupCustom> createState() => _PopupCustomState();
}

class _PopupCustomState extends State<PopupCustom> {
  final formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  // Variables to hold selected values
  String? selectedMainCategory;
  String? selectedSubCategory;

  // Lists to hold categories and subcategories fetched from Firestore
  List<String> mainCategories = ['wooden', 'hardware', 'other'];
  List<String> subCategories = [];

  File? selectedImage;
  XFile? webImage;

  @override
  void initState() {
    super.initState();
  }

  // Function to fetch subcategories based on the selected main category
  Future<void> fetchSubCategoriesFromFirestore(String collectionName) async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection(collectionName).get();
      List<String> fetchedSubCategories =
          snapshot.docs.map((doc) => doc.id).toList();
      setState(() {
        subCategories = fetchedSubCategories;
        selectedSubCategory = null;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching subcategories: $e');
      }
    }
  }

  // Function to upload image to Firebase Storage and return its download URL
  Future<String> uploadImageToFirebase({required String path}) async {
    try {
      String downloadUrl = '';

      if (kIsWeb && webImage != null) {
        Reference storageReference = FirebaseStorage.instance.ref().child(path);
        UploadTask uploadTask =
            storageReference.putData(await webImage!.readAsBytes());
        TaskSnapshot snapshot = await uploadTask;
        downloadUrl = await snapshot.ref.getDownloadURL();
      } else if (!kIsWeb && selectedImage != null) {
        Reference storageReference = FirebaseStorage.instance.ref().child(path);
        UploadTask uploadTask = storageReference.putFile(selectedImage!);
        TaskSnapshot snapshot = await uploadTask;
        downloadUrl = await snapshot.ref.getDownloadURL();
      }
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  // Function to pick an image from the gallery
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();

    if (kIsWeb) {
      final XFile? pickedWebImage =
          await picker.pickImage(source: ImageSource.gallery);
      if (pickedWebImage != null) {
        setState(() {
          webImage = pickedWebImage;
        });
        if (selectedMainCategory != null && selectedSubCategory != null) {
          String path =
              '${selectedMainCategory!}/${selectedSubCategory!}/${DateTime.now().millisecondsSinceEpoch}';
          String imageUrl = await uploadImageToFirebase(path: path);
          imageUrlController.text = imageUrl;
        }
      }
    } else {
      final XFile? pickedImage =
          await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          selectedImage = File(pickedImage.path);
        });
        if (selectedMainCategory != null && selectedSubCategory != null) {
          String path =
              '${selectedMainCategory!}/${selectedSubCategory!}/${DateTime.now().millisecondsSinceEpoch}';
          String imageUrl = await uploadImageToFirebase(path: path);
          imageUrlController.text = imageUrl;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Category Dropdown
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Main Category',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.brown[300]!),
              ),
              filled: true,
              fillColor: Colors.brown[50],
              labelStyle: TextStyle(color: Colors.brown[700]),
            ),
            value: selectedMainCategory,
            items: mainCategories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedMainCategory = value;
                subCategories.clear();
                if (value != null) {
                  fetchSubCategoriesFromFirestore(value);
                }
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a main category';
              }
              return null;
            },
            dropdownColor: Colors.brown[50],
            style: TextStyle(color: Colors.brown[700]),
          ),
          const SizedBox(height: 16),

          // Subcategory Dropdown
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Subcategory',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.brown[300]!),
              ),
              filled: true,
              fillColor: Colors.brown[50],
              labelStyle: TextStyle(color: Colors.brown[700]),
            ),
            value: selectedSubCategory,
            items: subCategories.map((String subCategory) {
              return DropdownMenuItem<String>(
                value: subCategory,
                child: Text(subCategory),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedSubCategory = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a subcategory';
              }
              return null;
            },
            dropdownColor: Colors.brown[50],
            style: TextStyle(color: Colors.brown[700]),
          ),
          const SizedBox(height: 16),

          if (selectedSubCategory != null) ...[
            // Name field
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.brown[300]!),
                ),
                filled: true,
                fillColor: Colors.brown[50],
                labelStyle: TextStyle(color: Colors.brown[700]),
              ),
              style: TextStyle(color: Colors.brown[700]),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Price field
            TextFormField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.brown[300]!),
                ),
                filled: true,
                fillColor: Colors.brown[50],
                labelStyle: TextStyle(color: Colors.brown[700]),
              ),
              style: TextStyle(color: Colors.brown[700]),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a price';
                } else if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description field
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.brown[300]!),
                ),
                filled: true,
                fillColor: Colors.brown[50],
                labelStyle: TextStyle(color: Colors.brown[700]),
              ),
              style: TextStyle(color: Colors.brown[700]),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Image picker button
            ElevatedButton(
              onPressed: pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 16),

            // Image URL TextField
            TextFormField(
              controller: imageUrlController,
              decoration: InputDecoration(
                labelText: 'Image URL',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.brown[300]!),
                ),
                filled: true,
                fillColor: Colors.brown[50],
                labelStyle: TextStyle(color: Colors.brown[700]),
              ),
              style: TextStyle(color: Colors.brown[700]),
              readOnly: true,
            ),
          ],

          // Submit button
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    if (selectedSubCategory == null || selectedSubCategory!.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a subcategory.')),
                      );
                      return;
                    }

                    final docRef = FirebaseFirestore.instance
                        .collection(selectedMainCategory!)
                        .doc(selectedSubCategory!);

                    final newItem = {
                      'name': nameController.text,
                      'price': double.parse(priceController.text),
                      'description': descriptionController.text,
                      'url': imageUrlController.text,
                    };

                    await docRef.update({
                      '$selectedSubCategory': FieldValue.arrayUnion([newItem])
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Data added to Firestore successfully!')),
                    );

                    formKey.currentState!.reset();
                    setState(() {
                      selectedMainCategory = null;
                      selectedSubCategory = null;
                      subCategories.clear();
                      imageUrlController.clear();
                      selectedImage = null;
                      webImage = null;
                    });
                    widget.onSubmitSuccess();
                  } catch (e) {
                    print('Error adding data to Firestore: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add data: $e')),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Submit', style: TextStyle(fontSize: 16)),
            ),
          )
        ],
      ),
    );
  }
}