class NotLoadedAssetException implements Exception{
  String message = 'not loaded asset !';

  @override
  String toString() {
    return 'NotLoadedAssetException : $message}';
  }
}