import 'dart:async';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/light.dart';
import 'package:webgl/src/geometry/mesh.dart';
import 'package:webgl/src/material/materials.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';
@MirrorsUsed(
    targets: const [
      SceneViewFrameBuffer,
    ],
    override: '*')
import 'dart:mirrors';

class SceneViewFrameBuffer extends SceneJox{

  SceneViewFrameBuffer();

  @override
  Future setupScene() async {

    backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

    //Cameras
    CameraPerspective camera = new CameraPerspective(radians(37.0), 0.1, 100.0)
      ..targetPosition = new Vector3.zero()
      ..translation = new Vector3(5.0, 5.0, 5.0);
    Context.mainCamera = camera;

    //
    DirectionalLight directionalLight = new DirectionalLight();
    light = directionalLight;

    //
    List<WebGLTexture> renderedTextures = TextureUtils.buildRenderedTextures();

    //Mesh
    MaterialBaseTexture materialBaseTextureNormal =
    new MaterialBaseTexture()
      ..texture = renderedTextures[0];
    materials.add(materialBaseTextureNormal);

    QuadMesh quadColor = new QuadMesh()
      ..name = 'quadColor'
      ..translation = new Vector3(0.0, 1.0, 0.0)
      ..material = materialBaseTextureNormal
      ..matrix.rotateZ(radians(90.0));
    meshes.add(quadColor);

    //
    MaterialDepthTexture materialDepthTextureNormal =
    new MaterialDepthTexture()
      ..texture = renderedTextures[1];
    materials.add(materialDepthTextureNormal);

    QuadMesh quadDepth = new QuadMesh()
      ..name = 'quadDepth'
      ..translation = new Vector3(0.0, -1.0, 0.0)
      ..material = materialDepthTextureNormal
      ..matrix.rotateZ(radians(90.0));
    meshes.add(quadDepth);



  }
}
