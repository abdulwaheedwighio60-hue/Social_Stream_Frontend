class ImageHelper {

  ImageHelper._();

  static  String getImageMimeType(String filePath) {
    final String extension =
    filePath.split('.').last.toLowerCase();

    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';

      case 'png':
        return 'image/png';

      case 'webp':
        return 'image/webp';

      case 'gif':
        return 'image/gif';

      case 'heic':
        return 'image/heic';

      case 'heif':
        return 'image/heif';

      default:
        return 'image/jpeg';
    }
  }
}