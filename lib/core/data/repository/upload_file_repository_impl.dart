import 'dart:io';

import 'package:s_social/core/data/data_source/upload_file_service.dart';
import 'package:s_social/core/domain/repository/upload_file_repository.dart';

class UploadFileRepositoryImpl implements UploadFileRepository {
  UploadFileRepositoryImpl({required UpLoadFileDataSource dataSource})
      : _dataSource = dataSource;

  final UpLoadFileDataSource _dataSource;

  @override
  Future<String?> postFile(File file) async {
    try {
      return await _dataSource.postFile(file);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<String?>?> postMultipleFiles(List<File> imageFiles) async {
    try {
      return await _dataSource.postMultipleFiles(imageFiles);
    } catch (_) {
      return null;
    }
  }
}
