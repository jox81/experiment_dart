import 'package:webgl/src/application.dart';

typedef void UpdateToolBarItem(bool isActive);

enum ToolBarItemsType{
  single,
  multi
}

class ToolBars{

  static ToolBars _instance;
  static ToolBars get instance {
    if(_instance == null){
      _instance = new ToolBars._init();
    }
    return _instance;
  }

  ToolBars._init(){
    _initToolbars();
  }

  Map<String, ToolBar> toolBars;

  void _initToolbars() {
    toolBars = {};

    ToolBar toolBarAxis = new ToolBar(ToolBarItemsType.multi)
      ..toolBarItems = {
        "x": (bool isActive) => Application.instance.setActiveAxis(AxisType.x, isActive),
        "y": (bool isActive) => Application.instance.setActiveAxis(AxisType.y, isActive),
        "z": (bool isActive) => Application.instance.setActiveAxis(AxisType.z, isActive),
      };
    toolBars['axis'] = toolBarAxis;

    ToolBar toolBarTransformTools = new ToolBar(ToolBarItemsType.single)
      ..toolBarItems = {
        "s": (bool isActive) => Application.instance.setActiveTool(ActiveToolType.select),
        "M": (bool isActive) => Application.instance.setActiveTool(ActiveToolType.move),
        "R": (bool isActive) => Application.instance.setActiveTool(ActiveToolType.rotate),
        "S": (bool isActive) => Application.instance.setActiveTool(ActiveToolType.scale),
      };
    toolBars['transformTool'] = toolBarTransformTools;
  }
}

class ToolBar {
  final ToolBarItemsType toolBarItemsType;
  Map<String, UpdateToolBarItem> toolBarItems;

  ToolBar(this.toolBarItemsType);
}
