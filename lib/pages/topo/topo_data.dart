class TopoItemData {
  final String title;
  final bool isShow;
  final bool isNative;
  const TopoItemData(this.title, this.isShow, this.isNative);
}

const List<TopoItemData> topoData = [
  TopoItemData('家住回龙观', true, true),
  TopoItemData('宜居四五宜居四444444fkjfhahrknlkgamklsnd环', false, false),
  TopoItemData('喧嚣三里屯', false, false),
  TopoItemData('比邻十号线', false, false),
  TopoItemData('比邻十号线', false, false),
  TopoItemData('比邻十号线1231 ', false, false),
];

class MESHItemData {
  final String title;
  final bool isShow;
  final bool isNative;
  const MESHItemData(this.title, this.isShow, this.isNative);
}

const List<MESHItemData> meshData = [
  MESHItemData('宜居四4444,ma4五环', true, true),
  MESHItemData('比邻十号线', true, false),
  MESHItemData('比邻十号线', true, false),
  MESHItemData('比邻十号线', false, false),
  MESHItemData('比邻1111222十号线', false, false),
];
