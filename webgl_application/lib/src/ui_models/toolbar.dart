import 'package:webgl_application/src/application.dart';

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

  Application get application => Application.instance;

  ToolBars._init(){
    _initToolbars();
  }

  Map<String, ToolBar> toolBars;

  void _initToolbars() {
    toolBars = {};

    ToolBar toolBarAxis = new ToolBar(ToolBarItemsType.multi)
      ..toolBarItems = {
        "x": (bool isActive) => application.setActiveAxis(AxisType.x, isActive),
        "y": (bool isActive) => application.setActiveAxis(AxisType.y, isActive),
        "z": (bool isActive) => application.setActiveAxis(AxisType.z, isActive),
      };
    toolBars['axis'] = toolBarAxis;

    ToolBar toolBarTransformTools = new ToolBar(ToolBarItemsType.single)
      ..toolBarItems = {
        "s": (bool isActive) => application.setActiveTool(ActiveToolType.select),
        "M": (bool isActive) => application.setActiveTool(ActiveToolType.move),
        "R": (bool isActive) => application.setActiveTool(ActiveToolType.rotate),
        "S": (bool isActive) => application.setActiveTool(ActiveToolType.scale),
      };
    toolBars['transformTool'] = toolBarTransformTools;
  }
}

class ToolBar {
  final ToolBarItemsType toolBarItemsType;
  Map<String, UpdateToolBarItem> toolBarItems = {};

  ToolBar(this.toolBarItemsType);
}

abstract class ToolBarAxis{
  void setActiveAxis(AxisType axisType, bool isActive);
}

abstract class ToolBarTool{
  void setActiveTool(ActiveToolType value);
}
