import 'dart:async';
import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/controllers/camera_controllers.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/light.dart';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

class SceneViewCubeMap extends Scene{

  SceneViewCubeMap();

  @override
  Future setupScene() async {

    backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

    //Cameras
    Camera camera = new Camera(radians(37.0), 0.1, 100.0)
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(5.0, 5.0, 5.0)
      ..cameraController = new CameraController();
    Context.mainCamera = camera;

  }

  Future<WebGLTexture> loadCubeMap() async {
    List<ImageElement> imageElements = new List(6);
    imageElements[0] = await TextureUtils.getImageFromFile("./images/cubemap/kitchen/c00.bmp");
    imageElements[1] = await TextureUtils.getImageFromFile("./images/cubemap/kitchen/c01.bmp");
    imageElements[2] = await TextureUtils.getImageFromFile("./images/cubemap/kitchen/c02.bmp");
    imageElements[3] = await TextureUtils.getImageFromFile("./images/cubemap/kitchen/c03.bmp");
    imageElements[4] = await TextureUtils.getImageFromFile("./images/cubemap/kitchen/c04.bmp");
    imageElements[5] = await TextureUtils.getImageFromFile("./images/cubemap/kitchen/c05.bmp");

    return createCubeMapFromElements(imageElements);
  }

  WebGLTexture createCubeMapFromElements(List<ImageElement> cubeMapImages) {
    assert(cubeMapImages.length == 6);

    WebGLTexture texture = new WebGLTexture();

    gl.activeTexture.bind(TextureTarget.TEXTURE_CUBE_MAP, texture);

    for (int i = 0; i < 6; i++) {
      gl.activeTexture.texImage2D(
          TextureAttachmentTarget.TEXTURE_CUBE_MAPS[i], 0, TextureInternalFormat.RGBA, TextureInternalFormat.RGBA, TexelDataType.UNSIGNED_BYTE, cubeMapImages[i]);
    }
    gl.activeTexture.setParameterInt(TextureTarget.TEXTURE_CUBE_MAP, TextureParameter.TEXTURE_MAG_FILTER, TextureMagnificationFilterType.LINEAR);
    gl.activeTexture.setParameterInt(TextureTarget.TEXTURE_CUBE_MAP, TextureParameter.TEXTURE_MIN_FILTER, TextureMinificationFilterType.LINEAR);

    gl.activeTexture.unBind(TextureTarget.TEXTURE_CUBE_MAP);
    return texture;
  }
}
