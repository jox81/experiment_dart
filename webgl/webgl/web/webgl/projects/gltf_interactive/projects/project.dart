import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/assets_manager/loaders/gltf_project_loader.dart';
import 'package:webgl/src/gltf/controller/node_conrtoller_type/drive_2d_node_controller.dart';
import 'package:webgl/src/gltf/interaction/node_interactionnable.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/project/gltf_load_project.dart';
import 'package:gltf/gltf.dart' as glTF;

class ArchiInteractive extends GLTFLoadProject{
  static final String gltfFilePath = './projects/archi/model_01/model_01.gltf';

  NodeInteractionnable nodeInteractionnable = new NodeInteractionnable();

  ArchiInteractive._();
  static Future<ArchiInteractive> build() async {
    GLTFProjectLoader gLTFProjectLoader = new GLTFProjectLoader()
    ..filePath = gltfFilePath;

    final Uri baseUri = Uri.parse(gltfFilePath);
    final String filePart = baseUri.pathSegments.last;
    final String gtlfDirectory = gltfFilePath.replaceFirst(filePart, '');

    final glTF.Gltf gltfSource = await gLTFProjectLoader.loadGLTFResource(gltfFilePath);

    ArchiInteractive project = new ArchiInteractive._()
    ..baseDirectory = gtlfDirectory;

    await project.initFromSource(gltfSource);
    await gLTFProjectLoader.fillBuffersData(project);
    await project.loadImages();

    return await project.._setup();
  }

  Future _setup() async{
    nodeInteractionnable.controller = new Drive2dNodeController();
    addInteractable(nodeInteractionnable);

    //get node by name
    GLTFNode roofNode = scene.nodes.firstWhere((n)=>n.name == 'roof')
    ..translate(new Vector3(0,0,0));
  }
}