import 'dart:html';
import 'package:angular2/core.dart';

// Component to add dynamic html components
@Component(
    selector: 'htmlComponentLoader',
    templateUrl: 'dynamic_load_html_component.html',
    styleUrls: const [
      'dynamic_load_html_component.css'
    ],
)
class DynamicLoaderHtmlComponent implements AfterViewInit{
  final ComponentResolver componentResolver;

  @ViewChild('target', read:ViewContainerRef)
  ViewContainerRef target;

  @Input()
  Element element;

  DynamicLoaderHtmlComponent(this.componentResolver);

  createDynamicHtmlComponent(){
    if(element != null) {
      (target.element.nativeElement as Element).children.add(element);
      if(element is ImageElement){
        element
            ..style.height = "60px";
      }
    }
  }

  @override
  ngAfterViewInit() {
    createDynamicHtmlComponent();
  }
}