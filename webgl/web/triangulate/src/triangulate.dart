//Get first vertex

import 'geometric.dart';
import 'package:vector_math/vector_math.dart';

List<int> indices;
List<int> triangulateShape(arrayVec3){

  /*
  firstPoint = indice 0
  currentPoint = firstPoint
  Get next two edges
      concav ?
      V-> triangle temp
          pointInside ?
          F -> Close triangle
          V -> currentPoint + 1
      F-> slide index
  */

  //Create point array
  List points = [];
  List possibleIndices = [];
  var possible3 = (arrayVec3.length ~/ 3) * 3; //~~(100 / 3) > 33
  var pointCount = 0;
  for (var i = 0; i < possible3; i += 3)
  {
    var point = new Vector3(arrayVec3[i + 0], arrayVec3[i + 1], arrayVec3[i + 2]);
    points.add(point);
    possibleIndices.add(pointCount);
    pointCount++;
  }

  var startIndex = 0;
  var triangleCount = 0;
  var passCount = 0;
  var bEnd = false;
  var currentIndice = possibleIndices[possibleIndices.indexOf(startIndex)];
  var nextIndice = possibleIndices[possibleIndices.indexOf(startIndex) + 1] ;
  var nextNextIndice = possibleIndices[possibleIndices.indexOf(startIndex) + 2] ;
  var doneIndice = [];

  while(!bEnd){

    print("//////////////////////////begin pass : $passCount");

    var vec3P1 = points[currentIndice];
    var vec3P2 = points[nextIndice];
    var vec3P3 = points[nextNextIndice];

    var angle = Geometric.toDegree(Geometric.getAngleBetween3Points(vec3P1, vec3P2, vec3P3));

    if(angle > 0 && angle < 180){
      //angle concave
      print("angle concave : $angle");
      var bInside = false;
      for(var i = 0; i < points.length; i++){
        bInside = bInside || Geometric.isPointInsideTriangle(points[i], vec3P1, vec3P2, vec3P3);
        if(bInside) break;
      }

      if(!bInside){
        //create triangle
        print("create triangle");
        indices.add(currentIndice);
        indices.add(nextIndice);
        indices.add(nextNextIndice);
        triangleCount++;

        //remove done corner
        var index = possibleIndices.indexOf(nextIndice);
        if (index > -1) {
          possibleIndices.removeAt(index);
        }

        currentIndice = currentIndice;
        nextIndice = possibleIndices[possibleIndices.indexOf(currentIndice) + 1];
        nextNextIndice = possibleIndices[possibleIndices.indexOf(currentIndice) + 2];
      }else{
        //Point inside
        print("point inside triangle");
        //Slide next
        print("slide next");
        currentIndice = possibleIndices[possibleIndices.indexOf(nextIndice)];
        nextIndice = possibleIndices[possibleIndices.indexOf(currentIndice) + 1];
        nextNextIndice = possibleIndices[possibleIndices.indexOf(currentIndice) + 2];
      }
    } else if(angle == 0){
      //remove done corner
      var index = possibleIndices.indexOf(nextIndice);
      if (index > -1) {
        possibleIndices.removeAt(index);
      }
      currentIndice = currentIndice;
      if(possibleIndices.indexOf(currentIndice) + 2 < possibleIndices.length) {
        nextIndice = possibleIndices[possibleIndices.indexOf(currentIndice) + 1];
        nextNextIndice = possibleIndices[possibleIndices.indexOf(currentIndice) + 2];
      }


    } else{
      //angle convex
      print("angle convex : $angle");
      //Slide next
      print("slide next");
      currentIndice = possibleIndices[possibleIndices.indexOf(nextIndice)];
      nextIndice = possibleIndices[possibleIndices.indexOf(currentIndice) + 1];
      if(possibleIndices.indexOf(currentIndice) + 2 < possibleIndices.length) {
        nextNextIndice =
        possibleIndices[possibleIndices.indexOf(currentIndice) + 2];
      }
    }

    passCount++;
    print("passCount : $passCount");

    if(currentIndice != null && nextIndice != null && nextNextIndice == null) {
      nextNextIndice = possibleIndices[0];
    }
    if(currentIndice != null && nextIndice == null && nextNextIndice == null)
    {
      nextIndice = possibleIndices[0];
      nextNextIndice = possibleIndices[1];
    }
    if(currentIndice == null && nextIndice == null && nextNextIndice == null)
    {
      currentIndice = possibleIndices[0];
      nextIndice = possibleIndices[1];
      nextNextIndice = possibleIndices[2];
    }

    if(possibleIndices.length <= 3) bEnd = true;
    if(passCount == 35) bEnd = true;
  }

  return indices;
}