
class Word{
  int _id;
  String _sourceWord;
  String _targetWord;

  int get id => _id;

  String get sourceWord => _sourceWord;

  String get targetWord => _targetWord;

  set sourceWord(String value) {
    _sourceWord = value;
  }

  Word(this._sourceWord, this._targetWord);

  Word.withId(this._id,this._sourceWord, this._targetWord);

  set targetWord(String value) {
    _targetWord = value;
  }
  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['sourceWord'] = _sourceWord;
    map['targetWord'] = _targetWord;
    return map;
  }

  // Extract a Note object from a Map object
  Word.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._sourceWord = map['sourceWord'];
    this._targetWord = map['targetWord'];
  }



  // 命名构造函数
  Word.fromJson(Map<String, dynamic> json): _sourceWord = json['src'], _targetWord = json['dst'];

  Map<String,dynamic> toJson() =>{'src':_sourceWord, 'dst':_targetWord};

}