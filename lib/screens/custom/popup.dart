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

  // Variables to hold selected values
  String? selectedMainCategory;
  String? selectedSubCategory;

  // Lists to hold categories and subcategories fetched from Firestore
  List<String> mainCategories = ['wooden'];
  List<String> subCategories = [];

  List<File> selectedImages = [];
  List<XFile> webImages = [];
  bool isLoading = false;

  List<TextEditingController> mmControllers = [];
  List<TextEditingController> priceControllers = [];

  List<String> mmList = [];
  List<String> priceList = [];

  @override
  void initState() {
    super.initState();
  }

  // Add a new pair of text fields for "mm" and "price"
  void addTextFields() {
    setState(() {
      mmControllers.add(TextEditingController());
      priceControllers.add(TextEditingController());
    });
  }

  // Function to fetch subcategories based on the selected sideMenu category
// Function to fetch subcategories based on the selected sideMenu category
  Future<void> fetchSubCategoriesFromFirestore(String collectionName) async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection(collectionName).get();
      List<String> fetchedSubCategories =
          snapshot.docs.map((doc) => doc.id).toList();

      // Check if the widget is still mounted before calling setState
      if (mounted) {
        setState(() {
          subCategories = fetchedSubCategories;
          selectedSubCategory =
              null; // Reset the subcategory selection when the sideMenu category changes
        });
      }
    } catch (e) {
      print('Error fetching subcategories: $e');
    }
  }

  // Function to upload image to Firebase Storage and return its download URL
  Future<List<String>> uploadImagesToFirebase({required String path}) async {
    List<String> downloadUrls = [];

    try {
      setState(() {
        isLoading = true; // Show loader while uploading
      });
      if (kIsWeb) {
        for (var webImage in webImages) {
          Reference storageReference = FirebaseStorage.instance
              .ref()
              .child('$path/${DateTime.now().millisecondsSinceEpoch}');
          UploadTask uploadTask =
              storageReference.putData(await webImage.readAsBytes());
          TaskSnapshot snapshot = await uploadTask;
          String downloadUrl = await snapshot.ref.getDownloadURL();
          downloadUrls.add(downloadUrl);
        }
      } else {
        for (var image in selectedImages) {
          Reference storageReference = FirebaseStorage.instance
              .ref()
              .child('$path/${DateTime.now().millisecondsSinceEpoch}');
          UploadTask uploadTask = storageReference.putFile(image);
          TaskSnapshot snapshot = await uploadTask;
          String downloadUrl = await snapshot.ref.getDownloadURL();
          downloadUrls.add(downloadUrl);
        }
      }
    } catch (e) {
      print('Error uploading images: $e');
    } finally {
      setState(() {
        isLoading = false; // Hide loader after upload is done
      });
    }

    return downloadUrls;
  }

  // Function to pick multiple images
  Future<void> pickImages() async {
    final ImagePicker picker = ImagePicker();

    if (kIsWeb) {
      final List<XFile> pickedWebImages = await picker.pickMultiImage();
      if (pickedWebImages.isNotEmpty) {
        setState(() {
          webImages.addAll(pickedWebImages);
        });
      }
    } else {
      final List<XFile> pickedImages = await picker.pickMultiImage();
      if (pickedImages.isNotEmpty) {
        setState(() {
          selectedImages.addAll(pickedImages.map((image) => File(image.path)));
        });
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
          // Main Category Dropdown field (wooden, hardware, other)
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Main Category',
              border: OutlineInputBorder(),
              hintText: 'Select Main Category',
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
                subCategories
                    .clear(); // Clear subcategories when main category changes
                if (value != null) {
                  // Fetch subcategories when a main category is selected
                  fetchSubCategoriesFromFirestore(value);
                }
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a sideMenu category';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Subcategory Dropdown field (documents from the selected collection)
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Subcategory',
              border: OutlineInputBorder(),
              hintText: 'Select Subcategory',
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
          ),
          const SizedBox(height: 16),

          if (selectedSubCategory != null) ...[
            // Name field
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                hintText: 'Enter Name',
              ),
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
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
                hintText: 'Enter Price',
              ),
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
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                hintText: 'Enter Description',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            if (kIsWeb)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: webImages
                    .map((image) => Image.network(image.path,
                        width: 100, height: 100, fit: BoxFit.cover))
                    .toList(),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: selectedImages
                    .map((image) => Image.file(image,
                        width: 100, height: 100, fit: BoxFit.cover))
                    .toList(),
              ),
            const SizedBox(height: 20),
            // Add "mm" and "price" fields
            ListView.builder(
              shrinkWrap: true,
              itemCount: mmControllers.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: mmControllers[index],
                        decoration: const InputDecoration(
                          labelText: 'MM',
                          border: OutlineInputBorder(),
                          hintText: 'Enter MM',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter MM';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: priceControllers[index],
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Price',
                          border: OutlineInputBorder(),
                          hintText: 'Enter Price',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Price';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            IconButton(
              onPressed: addTextFields,
              icon: const Icon(Icons.add),
            ),
            // Image picker button
            ElevatedButton(
              onPressed: pickImages,
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 16),

            // Image URL TextField (auto-filled after upload)
          ],

          // Submit button
          const SizedBox(height: 16),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          Center(
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      if (formKey.currentState!.validate()) {
                        mmList.clear();
                        priceList.clear();

                        for (int i = 0; i < mmControllers.length; i++) {
                          mmList.add(mmControllers[i].text);
                          priceList.add(priceControllers[i].text);
                        }

                        try {
                          // Ensure that selectedSubCategory is not null or empty
                          if (selectedSubCategory == null ||
                              selectedSubCategory!.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select a subcategory.'),
                              ),
                            );
                            return;
                          }

                          // Reference to the document where the array will be stored
                          final docRef = FirebaseFirestore.instance
                              .collection(selectedMainCategory!)
                              .doc(selectedSubCategory!);

                          List<String> imageUrls = await uploadImagesToFirebase(
                            path:
                                '${selectedMainCategory!}/${selectedSubCategory!}',
                          );
                          // Create the new item map with a local timestamp
                          final newItem = {
                            'name': nameController.text,
                            'description': descriptionController.text,
                            'url': imageUrls,
                            'mm': mmList, // Store MM list
                            'price': priceList,
                          };

                          // Update the document to add the new item to the array
                          await docRef.set(newItem);

                          // Show a success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Data added to Firestore successfully!'),
                            ),
                          );

                          // Optionally, clear the form after submission
                          formKey.currentState!.reset();
                          setState(() {
                            selectedMainCategory = null;
                            selectedSubCategory = null;
                            subCategories.clear();
                            selectedImages.clear();
                            webImages.clear();
                          });
                          widget.onSubmitSuccess();
                        } catch (e) {
                          print('Error adding data to Firestore: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to add data: $e'),
                            ),
                          );
                        }
                      }
                    },
              child: const Text('Submit'),
            ),
          )
        ],
      ),
    );
  }
}
