import 'dart:html';

class LoadProgressEvent{
  final ProgressEvent progressEvent;
  final String filePath;

  LoadProgressEvent(this.progressEvent, this.filePath);

  @override
  String toString() {
    return '''
    ##############################
    filePath : ${filePath}
    lengthComputable : ${progressEvent?.lengthComputable}
    loaded : ${progressEvent?.loaded} octets
    total : ${progressEvent?.total} octets
    % : ${progressEvent!= null ? progressEvent.loaded / progressEvent.total * 100 : ''}
    ##############################
    ''';
  }
}