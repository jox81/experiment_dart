import 'dart:math';
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf/animation/animation_channel_target_path_type.dart';
import 'package:webgl/src/gltf/animation/animation_sampler.dart';
import 'package:webgl/src/utils/utils_math.dart';
import 'package:webgl/src/gltf/accessor/accessor.dart';

class GLTFUtilsAnimation{
  static ByteBuffer getNextInterpolatedValues(
      GLTFAnimationSampler sampler, AnimationChannelTargetPathType targetType, num currentTime) {
    ByteBuffer result;

    Float32List keyTimes = _getKeyTimes(sampler.input);
    Float32List keyValues = _getKeyValues(sampler.output);

    num playTime =
        (currentTime / 1000) % keyTimes.last; // Todo (jpu) : find less cost ?

    //> playtime range
    int previousIndex = 0;
    double previousTime = 0.0;

    previousTime = keyTimes.lastWhere((e) => e < playTime, orElse: () => null);
    previousIndex = keyTimes.indexOf(previousTime);

//    while (keyTimes[previousIndex] < playTime) {
//      previousTime = keyTimes[previousIndex];
//      previousIndex++;
//    }
//    previousIndex--;

    int nextIndex = (previousIndex + 1) % keyTimes.length;
    double nextTime = keyTimes[nextIndex];

    //> values
    int nextStartIndex =
        nextIndex * sampler.output.components; //sampler.output.byteOffset +
    Float32List nextValues = keyValues.sublist(
        nextStartIndex, nextStartIndex + sampler.output.components);

    Float32List previousValues;
    if (previousIndex == -1) {
      previousValues = nextValues;
    } else {
      int previousStartIndex = previousIndex *
          sampler.output.components; //sampler.output.byteOffset +
      previousValues = keyValues.sublist(previousStartIndex,
          previousStartIndex + sampler.output.components) as Float32List;
    }

    double interpolationValue = nextTime - previousTime != 0.0
        ? (playTime - previousTime) / (nextTime - previousTime)
        : 0.0;

    // Todo (jpu) : add easer ratio interpolation
    result = getInterpolationValue(
        previousValues,
        nextValues,
        interpolationValue,
        previousIndex,
        previousTime,
        playTime,
        nextIndex,
        nextTime,
        targetType);

    return result;
  }

  static ByteBuffer getInterpolationValue(
      Float32List previousValues,
      Float32List nextValues,
      double interpolationValue,
      int previousIndex,
      double previousTime,
      num playTime,
      int nextIndex,
      double nextTime,
      AnimationChannelTargetPathType targetType) {
    ByteBuffer result;

    switch (targetType) {
      case AnimationChannelTargetPathType.translation:
      case AnimationChannelTargetPathType.scale:
        Vector3 previous = new Vector3.fromFloat32List(previousValues);
        Vector3 next = new Vector3.fromFloat32List(nextValues);

        Vector3 resultVector3 = UtilsMath.vector3Lerp(previous, next, interpolationValue);
        result = resultVector3.storage.buffer;
        break;
      case AnimationChannelTargetPathType.rotation:
        Quaternion previous = new Quaternion.fromFloat32List(previousValues);
        Quaternion next = new Quaternion.fromFloat32List(nextValues);

        //
        double angle = next.radians - previous.radians;
        if (angle.abs() > pi) {
          next[3] *= -1;
        }

        Quaternion resultQuaternion = UtilsMath.slerp(previous, next, interpolationValue);
        result = resultQuaternion.storage.buffer;
        break;
      case AnimationChannelTargetPathType.weights:
//        throw 'Renderer:getInterpolationValue() : switch not implemented yet : ${targetType}';
      // Todo (jpu) :
        break;
    }

    //debug.logCurrentFunction('interpolationValue : $interpolationValue');
    //debug.logCurrentFunction(
//        'previous : $previousIndex > ${previousTime.toStringAsFixed(3)} \t: ${degrees(previous.radians).toStringAsFixed(3)} ${previousTime.toStringAsFixed(3)} \t| $previous');
    //debug.logCurrentFunction(
//        'result   : - > ${playTime.toStringAsFixed(3)} \t: ${degrees(result.radians).toStringAsFixed(3)} ${playTime.toStringAsFixed(3)} \t| $result');
    //debug.logCurrentFunction(
//        'next     : $nextIndex > ${nextTime.toStringAsFixed(3)} \t: ${degrees(next.radians).toStringAsFixed(3)} ${nextTime.toStringAsFixed(3)} \t| $next');
    //debug.logCurrentFunction('');

    return result;
  }

  static Float32List _getKeyTimes(GLTFAccessor accessor) {
    Float32List keyTimes = accessor.bufferView.buffer.data.buffer.asFloat32List(
        accessor.bufferView.byteOffset + accessor.byteOffset,
        accessor.count * accessor.components);
    return keyTimes;
  }

  // Todo (jpu) : try to return only buffer
  static Float32List _getKeyValues(GLTFAccessor accessor) {
    Float32List keyValues = accessor.bufferView.buffer.data.buffer
        .asFloat32List(accessor.bufferView.byteOffset + accessor.byteOffset,
        accessor.count * accessor.components);
    return keyValues;
  }
}