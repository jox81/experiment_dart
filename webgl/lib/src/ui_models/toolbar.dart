
typedef void UpdateToolBarItem(bool isActive);

enum ToolBarItemsType{
  single,
  multi
}

class ToolBar {
  final ToolBarItemsType toolBarItemsType;
  Map<String, UpdateToolBarItem> toolBarItems;

  ToolBar(this.toolBarItemsType);
}
