class ASR{
  String _from;
  String _to;
  String _collection;
  
  ASR(this._from,this._to,this._collection);

  String get to => _to;

  String get from => _from;

  String get collection => _collection;

  set to(String value) {
    _to = value;
  }

  set collection(String value) {
    _collection = value;
  }

  set from(String value) {
    _from = value;
  }
  // Convert a Note object Stringo a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    map['from'] = _from;
    map['to'] = _to;
    map['collection'] = _collection;
    return map;
  }

  // Extract a Note object from a Map object
  ASR.fromMapObject(Map<String, dynamic> map) {
    this._from = map['from'];
    this._to = map['to'];
    this._collection = map['collection'];
  }

}