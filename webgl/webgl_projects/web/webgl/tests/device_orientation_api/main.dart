import 'dart:async';
import 'dart:html';

///https://developer.mozilla.org/fr/docs/WebAPI/Detecting_device_orientation
Future main() async {

  window.onDeviceOrientation.listen(process);


//  if(Device.isEventTypeSupported('deviceorientation')) {
//    window.addEventListener("deviceorientation", process, true);
//  } else {
//    document.getElementById('log').innerHtml += '<p class="warning">Votre navigateur ne semble pas supporter <code>deviceorientation</code></p>';
//  }
}

void process(DeviceOrientationEvent event) {
  var alpha = event.alpha;
  var beta = event.beta;
  var gamma = event.gamma;
  document.getElementById('log').innerHtml = "<ul><li>Alpha : $alpha</li><li>Beta : $beta</li><li>Gamma : $gamma</li></ul>";
}

