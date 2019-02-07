# Dart2

## Loading dans le dossier test
Pour lancer les tests avec un chargement de fichier qui se trouve dans le dossier test, il faut utiliser : 
````
useWebPath : false
String testFolderRelativePath = "../..";//ou autre selon la hierarchie des dossiers
````

````
GLTFProject project = await loadGLTF('${testFolderRelativePath}/gltf/tests/base/data/camera/empty.gltf', useWebPath : false);
````

Configurer le lancement de test
````
-p chrome
````

## Loading dans le dossier lib !!! ne pas faire ça, ça bug .dart_tool/build

il faut lancer le fichier webdev_serve_for_test.bat à la racine du project.
Le port 8080 est forcé, ce qui permet d'utiliser:
````
assetManager.useWebPath = true;
````

Ceci forcera le chemin vers loacalhost:8080