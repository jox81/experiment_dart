import 'dart:async';
import 'dart:html';

/// https://www.html5rocks.com/en/tutorials/getusermedia/intro/#toc-gettingstarted

Future main() async {
  if (MediaStream.supported) {
    // Good to go!
    MediaStream mediaStream;

    //Default
//    mediaStream = await window.navigator.getUserMedia(audio: true, video: true);
    // HD
//    mediaStream = await window.navigator.getUserMedia(audio: true, video: {"width": {"min": 1280}, "height": {"min": 720}});
    // VGA
    mediaStream = await window.navigator.getUserMedia(audio: true, video: {"width": {"exact": 640}, "height": {"exact": 480}});

    //other constraints : https://w3c.github.io/mediacapture-main/getusermedia.html#constrainable-interface


//    //or
//    mediaStream = await window.navigator.getUserMedia(audio: true, video: {
//      'mandatory': {'minAspectRatio': 1.333, 'maxAspectRatio': 1.334},
//      'optional': [
//        {'minFrameRate': 60},
//        {'maxWidth': 640}
//      ]
//    });

    ///idem as : <video autoplay></video>
    var video = new VideoElement()
      ..autoplay = true
      ..srcObject = mediaStream;
    document.body.append(video);
  } else {
    window.alert('getUserMedia() is not supported by your browser');
  }
}
