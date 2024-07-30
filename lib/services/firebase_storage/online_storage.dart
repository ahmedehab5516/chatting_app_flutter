import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class OnlineStorage {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String?> uploadFileForUser(
    String root,
    String? folderName,
    String userID,
    File file,
  ) async {
    try {
      final storageRef = _firebaseStorage.ref();

      final fileName = file.path.split("/").last;
      final timeStamp = DateTime.now().microsecondsSinceEpoch;

      final uploadRef2 =
          storageRef.child("$root/$userID/$folderName/$timeStamp-$fileName");
      await uploadRef2.putFile(file);

      return uploadRef2.getDownloadURL();
    } catch (e) {
      throw ("error uploading the file to online storage $e");
    }
  }

  Future<List<Reference>?> getUserUploadedFiles(
    String root,
    String? folderName,
    String userID,
  ) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();

      final userUploads = storageRef.child("$root/$userID/$folderName");

      final ListResult images = await userUploads.listAll();

      final List<Reference> allFiles = images.items;

      return allFiles;
    } catch (e) {
      throw ("Error downloading a file from online storage: $e");
    }
  }
}
