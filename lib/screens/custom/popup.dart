import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class PopupCustom extends StatefulWidget {
  final VoidCallback onSubmitSuccess;
  const PopupCustom({Key? key, required this.onSubmitSuccess})
      : super(key: key);

  @override
  State<PopupCustom> createState() => _PopupCustomState();
}

class _PopupCustomState extends State<PopupCustom> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  String? selectedMainCategory;
  String? selectedSubCategory;
  List<String> mainCategories = ['wooden'];
  List<String> subCategories = [];

  List<File> selectedImages = [];
  List<XFile> webImages = [];
  bool isLoading = false;

  List<TextEditingController> mmControllers = [];
  List<TextEditingController> priceControllers = [];

  @override
  void initState() {
    super.initState();
    addTextFields(); // Add initial text fields
  }

  void addTextFields() {
    setState(() {
      mmControllers.add(TextEditingController());
      priceControllers.add(TextEditingController());
    });
  }

  Future<void> fetchSubCategoriesFromFirestore(String collectionName) async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection(collectionName).get();
      List<String> fetchedSubCategories =
          snapshot.docs.map((doc) => doc.id).toList();
      if (mounted) {
        setState(() {
          subCategories = fetchedSubCategories;
          selectedSubCategory = null;
        });
      }
    } catch (e) {
      print('Error fetching subcategories: $e');
    }
  }

  Future<List<String>> uploadImagesToFirebase({required String path}) async {
    List<String> downloadUrls = [];
    try {
      setState(() => isLoading = true);
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
      setState(() => isLoading = false);
    }
    return downloadUrls;
  }

  Future<void> pickImages() async {
    final ImagePicker picker = ImagePicker();
    if (kIsWeb) {
      final List<XFile> pickedWebImages = await picker.pickMultiImage();
      if (pickedWebImages.isNotEmpty) {
        setState(() => webImages.addAll(pickedWebImages));
      }
    } else {
      final List<XFile> pickedImages = await picker.pickMultiImage();
      if (pickedImages.isNotEmpty) {
        setState(() => selectedImages
            .addAll(pickedImages.map((image) => File(image.path))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDropdown(
                label: 'Main Category',
                value: selectedMainCategory,
                items: mainCategories,
                onChanged: (value) {
                  setState(() {
                    selectedMainCategory = value;
                    subCategories.clear();
                    if (value != null) {
                      fetchSubCategoriesFromFirestore(value);
                    }
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Subcategory',
                value: selectedSubCategory,
                items: subCategories,
                onChanged: (value) {
                  setState(() => selectedSubCategory = value);
                },
              ),
              if (selectedSubCategory != null) ...[
                const SizedBox(height: 16),
                _buildTextField(controller: nameController, label: 'Name'),
                const SizedBox(height: 16),
                _buildTextField(
                    controller: priceController,
                    label: 'Price',
                    keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                _buildTextField(
                    controller: descriptionController,
                    label: 'Description',
                    maxLines: 3),
                const SizedBox(height: 16),
                _buildImagePreview(),
                const SizedBox(height: 16),
                _buildMMPriceFields(),
                const SizedBox(height: 16),
                _buildAddButton(),
                const SizedBox(height: 16),
                _buildImagePickerButton(),
                const SizedBox(height: 24),
                _buildSubmitButton(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?)? onChanged,
  }) {
    return DropdownButtonFormField<String>(
      style: const TextStyle(color: Colors.grey),
      iconEnabledColor: Colors.black,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      value: value,
      items: items
          .map((String item) =>
              DropdownMenuItem<String>(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      validator: (value) =>
          value == null || value.isEmpty ? 'Please select a $label' : null,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      style: const TextStyle(color: Colors.grey),
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter $label' : null,
    );
  }

  Widget _buildImagePreview() {
    return Container(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ...webImages
              .map((image) => _buildImageThumbnail(image.path, isWeb: true)),
          ...selectedImages.map((image) => _buildImageThumbnail(image.path)),
        ],
      ),
    );
  }

  Widget _buildImageThumbnail(String path, {bool isWeb = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: isWeb
            ? Image.network(path, width: 100, height: 100, fit: BoxFit.fill)
            : Image.file(File(path), width: 100, height: 100, fit: BoxFit.fill),
      ),
    );
  }

  Widget _buildMMPriceFields() {
    return Column(
      children: List.generate(
        mmControllers.length,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              Expanded(
                  child: _buildTextField(
                      controller: mmControllers[index], label: 'MM')),
              const SizedBox(width: 8),
              Expanded(
                  child: _buildTextField(
                      controller: priceControllers[index],
                      label: 'Price',
                      keyboardType: TextInputType.number)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: addTextFields,
        icon: const Icon(Icons.add),
        label: const Text('Add MM and Price'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildImagePickerButton() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: pickImages,
        icon: const Icon(Icons.image),
        label: const Text('Pick Images'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        onPressed: isLoading ? null : _submitForm,
        child: isLoading
            ? const CircularProgressIndicator()
            : const Text('Submit'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (formKey.currentState!.validate()) {
      if (selectedSubCategory == null || selectedSubCategory!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a subcategory.')),
        );
        return;
      }

      try {
        final docRef = FirebaseFirestore.instance
            .collection(selectedMainCategory!)
            .doc(selectedSubCategory!);

        List<String> imageUrls = await uploadImagesToFirebase(
          path: '${selectedMainCategory!}/${selectedSubCategory!}',
        );

        final newItem = {
          'name': nameController.text,
          'description': descriptionController.text,
          'url': imageUrls,
          'mm': mmControllers.map((c) => c.text).toList(),
          'price': priceControllers.map((c) => c.text).toList(),
        };

        await docRef.set(newItem);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Data added to Firestore successfully!')),
        );

        formKey.currentState!.reset();
        setState(() {
          selectedMainCategory = null;
          selectedSubCategory = null;
          subCategories.clear();
          selectedImages.clear();
          webImages.clear();
          mmControllers.clear();
          priceControllers.clear();
        });
        widget.onSubmitSuccess();
      } catch (e) {
        print('Error adding data to Firestore: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add data: $e')),
        );
      }
    }
  }
}
