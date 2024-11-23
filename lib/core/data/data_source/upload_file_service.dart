import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class UpLoadFileDataSource {
  Reference get _storageRef => FirebaseStorage.instance.ref();

  Future<String> postFile(File file) async {
    try {
      final fileExt = file.path.split(".").last;
      final path = await _generateFilePath(fileExt: fileExt);
      final reference = _storageRef.child(path);
      await reference.putFile(file);
      final downloadUrl = await reference.getDownloadURL();
      return downloadUrl;
    } catch (_) {
      rethrow;
    }
  }

  Future<String> _generateFilePath({required String fileExt}) async {
    const uuid = Uuid();

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw Exception("user not exist");
    }

    int time = 10;

    while (--time > 0) {
      final path = "$uid/${uuid.v4()}-${uuid.v4()}-${uuid.v4()}.$fileExt";

      Uint8List? foundFile;
      try {
        foundFile = await _storageRef.child(path).getData();
      } catch (_) {}

      if (foundFile == null) {
        return path;
      }
    }

    throw Exception("An error occur");
  }

  Future<List<String>> postMultipleFiles(List<File> imageFiles) {
    return Future.wait(imageFiles.map((file) => postFile(file)));
  }
}
