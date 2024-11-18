import 'dart:io';

abstract class UploadFileRepository {
  Future<String?> postFile(File file);
  Future<List<String?>?> postMultipleFiles(List<File> imageFiles);
}
