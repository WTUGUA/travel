class History{
  int _id;
  String _hisSource;
  String _hisTar;
  int _collection;

  History(this._hisSource,this._hisTar,this._collection);
  History.withId(this._hisSource,this._hisTar,this._collection);

  int get id => _id;

  String get hisTar => _hisTar;

  String get hisSource => _hisSource;

  int get collection => _collection;

  set hisTar(String value) {
    _hisTar = value;
  }

  set collection(int value) {
    _collection = value;
  }

  set hisSource(String value) {
    _hisSource = value;
  }
  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['hisSource'] = _hisSource;
    map['hisTar'] = _hisTar;
    map['collection'] = _collection;
    return map;
  }

  // Extract a Note object from a Map object
  History.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._hisSource = map['hisSource'];
    this._hisTar = map['hisTar'];
    this._collection = map['collection'];
  }


}
