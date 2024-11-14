import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class StorageService {
  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  Future<void> uploadPropertyFile(String filePath, String fileName) async {
    File file = File(filePath);

    try {
      await storage.ref('property/${fileName}').putFile(file);
    } on firebase_core.FirebaseException catch(e) {
      print(e);
    }
  }

  Future<String> downloadPropertyURL(String imageName) async {
    String downloadURL = await storage.ref('property/${imageName}').getDownloadURL();

    return downloadURL;
  }

  Future<void> uploadOrderFile(String filePath, String fileName) async {
    File file = File(filePath);

    try {
      await storage.ref('order/${fileName}').putFile(file);
    } on firebase_core.FirebaseException catch(e) {
      print(e);
    }
  }

  Future<String> downloadOrderURL(String imageName) async {
    String downloadURL = await storage.ref('order/${imageName}').getDownloadURL();

    return downloadURL;
  }

  Future<firebase_storage.ListResult> listFile() async {
    firebase_storage.ListResult results = await storage.ref('property').listAll();

    results.items.forEach((firebase_storage.Reference ref) {print('Found File : ${ref}');});
    return results;
  }

  Future removeFileWithDownloadUrl({required url}) async {
    try {
      await storage.refFromURL(url).delete();
    } catch(e) {

    }
  }
}