class FileHelpers {
  static String getFileName(String path) {
    return path.split('/').last;
  }

  static String getFileExtension(String path) {
    return path.split('.').last;
  }
}
