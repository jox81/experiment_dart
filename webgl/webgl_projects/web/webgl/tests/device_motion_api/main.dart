import 'dart:async';
import 'dart:html';


Future main() async {
    window.onDeviceMotion.listen(process);
//  if(Device.isEventTypeSupported('devicemotion')) {
//    window.onDeviceMotion.listen(process);
////    window.addEventListener("devicemotion", process, true);
//  } else {
//    document.getElementById('log').innerHtml += '<p class="warning">Votre navigateur ne semble pas supporter <code>deviceorientation</code></p>';
//  }
}

void process(DeviceMotionEvent event) {
  var x = event.accelerationIncludingGravity.x;
  var y = event.accelerationIncludingGravity.y;
  var z = event.accelerationIncludingGravity.z;
  document.getElementById('log').innerHtml = "<ul><li>X : $x</li><li>Y : $y</li><li>Z : $z</li></ul>";
}