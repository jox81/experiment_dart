class NotLoadedAssetException implements Exception{
  String _message = 'not loaded asset !';
  String get message => _message;

  NotLoadedAssetException([String message]){
    if(message != null){
      _message = message;
    }
  }

  @override
  String toString() {
    return 'NotLoadedAssetException : $message}';
  }
}