import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/materials/material_type.dart';
import 'package:webgl/src/materials/types/base_color_material.dart';
import 'package:webgl/src/materials/types/base_color_vertex_material.dart';
import 'package:webgl/src/materials/types/base_material.dart';
import 'package:webgl/src/materials/types/base_texture_material.dart';
import 'package:webgl/src/materials/types/base_texture_normal_material.dart';
import 'package:webgl/src/materials/types/depth_texture_material.dart';
import 'package:webgl/src/materials/types/point_material.dart';
import 'package:webgl/src/materials/types/pragmatic_pbr_material.dart';
import 'package:webgl/src/materials/types/reflection_material.dart';
import 'package:webgl/src/materials/types/sky_box_material.dart';
import 'package:webgl/src/gltf/mesh/mesh.dart';
import 'package:webgl/src/introspection/introspection.dart';
import 'package:webgl/lights.dart';
import 'package:webgl/src/utils/utils_textures.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

@reflector
class MaterialsFactory {
  static void assignMaterialTypeToModel(
      MaterialType materialType, GLTFMesh mesh) {
    switch (materialType) {
//      case MaterialType.MaterialCustom:
//        newMaterial = new MaterialCustom();
//        break;
      case MaterialType.MaterialPoint:
        mesh
          ..primitives[0].drawMode = DrawMode.POINTS
          ..primitives[0].material =
          new MaterialPoint(pointSize: 5.0, color: new Vector4.all(1.0));
        break;
      case MaterialType.MaterialBase:
        mesh
          ..primitives[0].drawMode = DrawMode.TRIANGLES
          ..primitives[0].material = new MaterialBase();
        break;
      case MaterialType.MaterialBaseColor:
        mesh
          ..primitives[0].drawMode = DrawMode.TRIANGLES
          ..primitives[0].material =
          new MaterialBaseColor(new Vector4.all(1.0));
        break;
      case MaterialType.MaterialBaseVertexColor:
        MaterialBaseVertexColor material = new MaterialBaseVertexColor();
        mesh
          ..primitives[0].drawMode = DrawMode.TRIANGLES
          ..primitives[0].material = material;
        break;
      case MaterialType.MaterialBaseTexture:
        WebGLTexture texture = TextureUtils.getDefaultColoredTexture();
        MaterialBaseTexture material = new MaterialBaseTexture()
          ..texture = texture;
        mesh
          ..primitives[0].drawMode = DrawMode.TRIANGLES
          ..primitives[0].material = material;
        break;
      case MaterialType.MaterialBaseTextureNormal:
        WebGLTexture texture = TextureUtils.getDefaultColoredTexture();
        MaterialBaseTextureNormal material = new MaterialBaseTextureNormal()
          ..texture = texture;
        mesh
          ..primitives[0].drawMode = DrawMode.TRIANGLES
          ..primitives[0].material = material;
        break;
      case MaterialType.MaterialPBR:
        PointLight light = new PointLight();
        MaterialPragmaticPBR material = new MaterialPragmaticPBR(light);
        mesh
          ..primitives[0].drawMode = DrawMode.TRIANGLES
          ..primitives[0].material = material;
        break;
      case MaterialType.MaterialDepthTexture:
        mesh
          ..primitives[0].drawMode = DrawMode.TRIANGLES
          ..primitives[0].material = new MaterialDepthTexture();
        break;
      case MaterialType.MaterialSkyBox:
        mesh
          ..primitives[0].drawMode = DrawMode.TRIANGLES
          ..primitives[0].material = new MaterialSkyBox();
        break;
      case MaterialType.MaterialReflection:
        mesh
          ..primitives[0].drawMode = DrawMode.TRIANGLES
          ..primitives[0].material = new MaterialReflection();
        break;
      default:
        break;
    }
  }
}