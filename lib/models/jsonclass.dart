class ConfigData {
  int zid;
  String name;
  List<ObjJson> lamps;
  List<ObjJson> curtains;
  List<ObjJson> others;

  ConfigData(this.zid, this.name, [this.lamps, this.curtains, this.others]);

  factory ConfigData.fromJson(dynamic json) {
    var lampsObjsJson = json['lamps'] as List;
    List<ObjJson> _lamps = lampsObjsJson
        .map((lampsObjsJson) => ObjJson.fromJson(lampsObjsJson))
        .toList();

    var curtainsObjsJson = json['curtains'] as List;
    List<ObjJson> _curtains = curtainsObjsJson
        .map((curtainsObjsJson) => ObjJson.fromJson(curtainsObjsJson))
        .toList();

    var othersObjsJson = json['others'] as List;
    List<ObjJson> _others = othersObjsJson
        .map((othersObjsJson) => ObjJson.fromJson(othersObjsJson))
        .toList();

    return ConfigData(
        json['zid'] as int, json['name'] as String, _lamps, _curtains, _others);
  }

  @override
  String toString() {
    return '{ ${this.zid}, ${this.name}, ${this.lamps}, ${this.curtains}, ${this.others} }';
  }
}

class ObjJson {
  int lid;
  String type;
  int maxlevel;
  int minlevel;

  ObjJson(this.lid, this.type, this.maxlevel, this.minlevel);

  factory ObjJson.fromJson(dynamic json) {
    return ObjJson(json['id'] as int, json['type'] as String,
        json['maxlevel'] as int, json['minlevel'] as int);
  }

  @override
  String toString() {
    return '{ ${this.lid}, ${this.type},${this.maxlevel},${this.minlevel} }';
  }
}
