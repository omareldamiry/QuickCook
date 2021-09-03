import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';

class StorageService {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  StorageService();

  Future<void> listExample() async {
    firebase_storage.ListResult result = await storage.ref().listAll();

    result.items.forEach((firebase_storage.Reference ref) {
      print('Found file: $ref');
    });

    result.prefixes.forEach((firebase_storage.Reference ref) {
      print('Found directory: $ref');
    });
  }

  Future<String?> downloadURL(String? fileLocation) async {
    if (fileLocation != null) {
      String? downloadURL = fileLocation.isNotEmpty
          ? await storage.ref(fileLocation).getDownloadURL()
          : null;

      return downloadURL;
    }

    return null;

    // Within your widgets:
    // Image.network(downloadURL);
  }

  Future<void> uploadExample() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = '${appDocDir.path}/file-to-upload.png';

    print(filePath);
    // ...
    // e.g. await uploadFile(filePath);
  }

  Future<void> uploadFile(String filePath, String fileName, String dest) async {
    File file = File(filePath);

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref(dest + fileName)
          .putFile(file);

      print("Image uploaded successfully!");
    } on firebase_storage.FirebaseException catch (e) {
      print(e.message);
      // e.g, e.code == 'canceled'
    }
  }
}
