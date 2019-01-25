import 'dart:async';
import 'dart:html';

Future main() async {

  if (MediaStream.supported) {
    // Good to go!
    print("MediaStream supported");
  } else {
    window.alert('getUserMedia() is not supported by your browser');
  }

  /// https://api.dartlang.org/stable/2.0.0/dart-html/Navigator/getUserMedia.html

//
//  MediaStream mediaStream;
////  mediaStream = await window.navigator.getUserMedia(audio: true, video: true);
//  mediaStream = await window.navigator.getUserMedia(
//      audio: true,
//      video: {'mandatory':
//      { 'minAspectRatio': 1.333, 'maxAspectRatio': 1.334 },
//        'optional':
//        [{ 'minFrameRate': 60 },
//        { 'maxWidth': 640 }]
//      });
//
//  var video = new VideoElement()
//    ..autoplay = true
//    ..src = Url.createObjectUrlFromStream(mediaStream);
//  document.body.append(video);
}
