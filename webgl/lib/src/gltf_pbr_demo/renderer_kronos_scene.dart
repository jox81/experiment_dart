import 'dart:web_gl' as webgl;
import 'dart:html';
import 'dart:math' as Math;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gtlf/asset.dart';
import 'package:webgl/src/gtlf/mesh.dart';
import 'package:webgl/src/gtlf/node.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/utils/utils_debug.dart';
import 'package:webgl/src/gltf_pbr_demo/renderer_kronos_mesh.dart';
import 'package:webgl/src/gltf_pbr_demo/renderer_kronos_utils.dart';

class KronosScene {
  int pendingBuffers;
  int pendingTextures;
  int samplerIndex;

  GLTFAsset assets;
  GlobalState globalState;

  List<GLTFNode> nodes;
  List<KronosMesh> meshes;

  Matrix4 projectionMatrix;
  Matrix4 viewMatrix;

  dynamic backBuffer;
  dynamic frontBuffer;

  KronosScene(webgl.RenderingContext gl, GlobalState glState, String model, GLTFProject gltf) {
    logCurrentFunction();
    globalState = glState;

    nodes = gltf.nodes;
    meshes = [];
    assets = gltf.asset;
    pendingTextures = 0;
    pendingBuffers = 0;
    samplerIndex = 3; // skip the first three because of the cubemaps
    for (GLTFMesh gltfMesh in gltf.meshes) {
      meshes.add(new KronosMesh(gl, this, globalState, model, gltf, gltfMesh.meshId));
    }
  }

  int getNextSamplerIndex() {
    logCurrentFunction();
    int result = samplerIndex++;
    if (result > 31) {
      throw new Exception('Too many texture samplers in use.');
    }
    return result;
  }

  void drawScene(webgl.RenderingContext gl) {
    logCurrentFunction();
    gl.clear(webgl.COLOR_BUFFER_BIT | webgl.DEPTH_BUFFER_BIT);

    if (this.pendingTextures > 0 || this.pendingBuffers > 0) {
      return;
    }
    document.getElementById('loadSpinner').style.display = 'none';

    void drawNodeRecursive (KronosScene scene, GLTFNode node, Matrix4 parentTransform) {
      // Transform
      Matrix4 localTransform;
      if (node.matrix != null) {
        localTransform = node.matrix.clone();
      } else {
        localTransform = new Matrix4.identity();
        Vector3 scale = node.scale != null ? node.scale : new Vector3(1.0, 1.0, 1.0);
        Quaternion rotation = node.rotation != null ? node.rotation : new Quaternion.identity();
        Vector3 translate = node.translation != null ? node.translation : new Vector3.zero();

        localTransform.setFromTranslationRotationScale(translate, rotation, scale);
      }

      localTransform = (localTransform * parentTransform) as Matrix4;

      if (node.mesh != null && node.mesh.meshId < scene.meshes.length) {
        scene.meshes[node.mesh.meshId].drawMesh(gl, localTransform, scene.viewMatrix, scene.projectionMatrix, scene.globalState);
      }

      if (node.children != null && node.children.length > 0) {
        for (int i = 0; i < node.children.length; i++) {
          drawNodeRecursive(scene, scene.nodes[node.children[i].nodeId], localTransform);
        }
      }
    };

    // set up the camera position and view matrix
    Vector3 cameraPos = new Vector3(
        -MainInfos.translate * Math.sin(MainInfos.roll) * Math.cos(-MainInfos.pitch),
        -MainInfos.translate * Math.sin(-MainInfos.pitch),
        MainInfos.translate * Math.cos(MainInfos.roll) * Math.cos(-MainInfos.pitch)
    );
    this.globalState.uniforms['u_Camera'].vals = cameraPos.storage;

    // Update view matrix
    // roll, pitch and translate are all globals.
    Matrix4 xRotation = new Matrix4.identity();
    xRotation.rotateY(MainInfos.roll);
    Matrix4 yRotation = new Matrix4.identity();
    yRotation.rotateX(MainInfos.pitch);
    viewMatrix = new Matrix4.identity();
    viewMatrix = yRotation.multiplied(xRotation);
    this.viewMatrix[14] = -MainInfos.translate;

    GLTFNode firstNode = nodes[0];

    drawNodeRecursive(this, firstNode, new Matrix4.identity());

    // draw to the front buffer
    frontBuffer.drawImage(backBuffer, 0, 0);
  }

  ImageElement loadImage(ImageInfo imageInfo, webgl.RenderingContext gl) {
    logCurrentFunction();
    var scene = this;
    ImageElement image = new ImageElement();
    this.pendingTextures++;
    image.src = imageInfo.uri;
    image.onLoad.listen((_){
      webgl.Texture texture = gl.createTexture();
      int glIndex = webgl.TEXTURE0 + imageInfo.samplerId;  // gl.TEXTUREn enums are in numeric order.
      gl.activeTexture(glIndex);
      gl.bindTexture(webgl.TEXTURE_2D, texture);

      gl.texParameteri(webgl.TEXTURE_2D, webgl.TEXTURE_WRAP_S, imageInfo.clamp != null ? webgl.CLAMP_TO_EDGE : webgl.REPEAT);
      gl.texParameteri(webgl.TEXTURE_2D, webgl.TEXTURE_WRAP_T, imageInfo.clamp != null ? webgl.CLAMP_TO_EDGE : webgl.REPEAT);
      gl.texParameteri(webgl.TEXTURE_2D, webgl.TEXTURE_MIN_FILTER, webgl.LINEAR);
      gl.texParameteri(webgl.TEXTURE_2D, webgl.TEXTURE_MAG_FILTER, webgl.LINEAR);
      gl.pixelStorei(webgl.UNPACK_FLIP_Y_WEBGL, 0);
      gl.texImage2D(webgl.TEXTURE_2D, 0, webgl.RGBA, webgl.RGBA,/*imageInfo.colorSpace, imageInfo.colorSpace,*/ webgl.UNSIGNED_BYTE, image);

      scene.pendingTextures--;
      scene.drawScene(gl);
    });

    return image;
  }

  void loadImages(Map<String, ImageInfo> imageInfos, webgl.RenderingContext gl) {
    logCurrentFunction();
    this.pendingTextures = 0;
    for (String imageinfo in imageInfos.keys.toList()) {
      this.loadImage(imageInfos[imageinfo], gl);
    }
  }
}