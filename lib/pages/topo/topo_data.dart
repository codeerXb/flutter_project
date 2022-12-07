class TopoItemData {
  final String title;
  final bool isShow;
  final bool isNative;
  const TopoItemData(this.title, this.isShow, this.isNative);
}

const List<TopoItemData> topoData = [
  TopoItemData('家住回龙观', true, true),
  TopoItemData('宜居四五环', false, false),
  TopoItemData('喧嚣三里屯', false, false),
  TopoItemData('比邻十号线', false, false),
];
