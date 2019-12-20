import 'package:webgl/src/gltf/accessor/accessor.dart';
import 'package:webgl/src/introspection/introspection.dart';

/// The samplers describe the sources of animation data
/// [input] accessor defines the timing
/// [output] accessor defines the values corresponding to the timings
/// [interpolation] type of easer to use. // Todo (jpu) : Should this be replaced by an enum ?
//@reflector
class GLTFAnimationSampler {
  static int nextId = 0;
  final int samplerId = nextId++;

  String interpolation;

  GLTFAccessor _accessorInput;
  GLTFAccessor get input => _accessorInput;
  set input(GLTFAccessor value) {
    _accessorInput = value;
  }

  GLTFAccessor _accessorOutput;
  GLTFAccessor get output => _accessorOutput;
  set output(GLTFAccessor value) {
    _accessorOutput = value;
  }

  GLTFAnimationSampler(this.interpolation);

  @override
  String toString() {
    return 'GLTFAnimationSampler{interpolation: $interpolation, _accessorInputId: ${_accessorInput.accessorId}, _accessorOutputId: ${_accessorOutput.accessorId}}';
  }
}