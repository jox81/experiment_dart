import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:webgl_application/app_component.template.dart' as ng;//This must point to app_component.dart folder
import 'package:webgl_application/src/services/in_memory_data_service.dart';
import 'package:http/http.dart';
import 'index.template.dart' as self;

@GenerateInjector([
  routerProvidersHash, // You can use routerProviders in production
  const ClassProvider(Client, useClass: InMemoryDataService),
  // Using a real back end?
  // Import 'package:http/browser_client.dart' and change the above to:
  //   const ClassProvider(Client, useClass: BrowserClient),
])
final InjectorFactory injector = self.injector$Injector;

void main() {
  runApp(ng.AppComponentNgFactory, createInjector: injector);
}