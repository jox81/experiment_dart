import 'dart:html';

class LoadProgressEvent{
  final ProgressEvent progressEvent;
  final String name;
  final int id;

  LoadProgressEvent(this.progressEvent, this.name, this.id);

  @override
  String toString() {
    return '''
    ##############################
    id : ${id}
    name : ${name}
    lengthComputable : ${progressEvent?.lengthComputable}
    loaded : ${progressEvent?.loaded} octets
    total : ${progressEvent?.total} octets
    % : ${progressEvent!= null ? progressEvent.loaded / progressEvent.total * 100 : ''}
    ##############################
    ''';
  }
}