
class Select{
  String _sourceSelect;
  String _targetSelect;

  String get sourceSelect => _sourceSelect;

  String get targetSelect => _targetSelect;

  set sourceSelect(String value) {
    _sourceSelect = value;
  }

  Select(this._sourceSelect, this._targetSelect);

  Select.withId(this._sourceSelect, this._targetSelect);

  set targetSelect(String value) {
    _targetSelect = value;
  }
  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    map['sourceSelect'] = _sourceSelect;
    map['targetSelect'] = _targetSelect;
    return map;
  }

  // Extract a Note object from a Map object
  Select.fromMapObject(Map<String, dynamic> map) {
    this._sourceSelect = map['sourceSelect'];
    this._targetSelect = map['targetSelect'];
  }

  // 命名构造函数
  Select.fromJson(Map<String, dynamic> json): _sourceSelect = json['src'], _targetSelect = json['dst'];

  Map<String,dynamic> toJson() =>{'src':_sourceSelect, 'dst':_targetSelect};

}