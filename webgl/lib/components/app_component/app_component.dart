import 'package:angular2/core.dart';
import 'package:webgl/components/canvas_component/canvas_component.dart';
import 'package:webgl/components/layout_component/layout_component.dart';
import 'package:webgl/components/properties_component/properties_component.dart';
import 'package:webgl/components/toolbar_component/toolbar_component.dart';
import 'package:webgl/scene_views/scene_view_base.dart';
import 'package:webgl/scene_views/scene_view_experiment/scene_view_experiment.dart';
import 'package:webgl/scene_views/scene_view_framebuffer.dart';
import 'package:webgl/scene_views/scene_view_particle.dart';
import 'package:webgl/scene_views/scene_view_particle_simple.dart';
import 'package:webgl/scene_views/scene_view_pbr.dart';
import 'package:webgl/scene_views/scene_view_performance_test.dart';
import 'package:webgl/scene_views/scene_view_primitives.dart';
import 'package:webgl/src/application.dart';
import 'package:webgl/src/scene.dart';


@Component(
    selector: 'my-app',
    templateUrl: 'app_component.html',
    styleUrls: const ['app_component.css'],
    directives: const [ToolbarComponent, CanvasComponent, LayoutComponent, PropertiesComponent]
)
class AppComponent implements AfterViewInit{

  Application application;
  Scene currentScene;

  @ViewChild(CanvasComponent)
  CanvasComponent canvasComponent;

  List<Scene> scenes;
  int sceneId = 0;

  switchScene () async {
    sceneId++;
    sceneId %= scenes.length;

    currentScene = scenes[sceneId];
    await currentScene.setup();
    application.render(currentScene);
  }

  @override
  ngAfterViewInit() {
    application = new Application(canvasComponent.canvas);

    scenes = [
      new SceneViewBase(application),
//      new SceneViewPrimitives(application),
//      new SceneViewPBR(application),
//    new SceneViewFrameBuffer(application),
//    new SceneViewExperiment(application),
//    new SceneViewParticleSimple(application),
//    new SceneViewParticle(application),
//    new SceneViewPerformanceTest(application),
//    new SceneViewShaderLearning01(application),
    ];

    switchScene ();
  }

}