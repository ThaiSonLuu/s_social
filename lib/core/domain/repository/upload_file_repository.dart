import 'dart:io';

abstract class UploadFileRepository {
  Future<String?> postFile(File file);
}
