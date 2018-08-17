pour lancer les tests avec chargement de fichier, il faut utiliser : 
useWebPath : false
String testFolderRelativePath = "../..";

-p chrome

=>
GLTFProject project = await loadGLTF('${testFolderRelativePath}/gltf/tests/base/data/camera/empty.gltf', useWebPath : false);