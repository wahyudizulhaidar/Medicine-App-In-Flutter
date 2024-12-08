class Pill {
  int id;
  String name;
  String amount;
  String type;
  int howManyWeeks;
  String medicineForm;
  int time;
  int notifyId;

  Pill(
      {required this.id,
      required this.howManyWeeks,
      required this.time,
      required this.amount,
      required this.medicineForm,
      required this.name,
      required this.type,
      required this.notifyId});

  //------------------set pill to map-------------------

  Map<String, dynamic> pillToMap() {
    Map<String, dynamic> map = Map();
    map['id'] = this.id;
    map['name'] = this.name;
    map['amount'] = this.amount;
    map['type'] = this.type;
    map['howManyWeeks'] = this.howManyWeeks;
    map['medicineForm'] = this.medicineForm;
    map['time'] = this.time;
    map['notifyId'] = this.notifyId;
    return map;
  }

  //=====================================================

  //---------------------create pill object from map---------------------
  Pill pillMapToObject(Map<String, dynamic> pillMap) {
    return Pill(
        id: pillMap['id'] ?? 0, // Default jika 'id' null
        name: pillMap['name'] ?? '', // Default jika 'name' null
        amount: pillMap['amount'] ?? '', // Default jika 'amount' null
        type: pillMap['type'] ?? '', // Default jika 'type' null
        howManyWeeks: pillMap['howManyWeeks'] ?? 0, // Default jika 'howManyWeeks' null
        medicineForm: pillMap['medicineForm'] ?? '', // Default jika 'medicineForm' null
        time: pillMap['time'] ?? 0, // Default jika 'time' null
        notifyId: pillMap['notifyId'] ?? 0 // Default jika 'notifyId' null
    );
  }
//=====================================================================

  //---------------------| Get the medicines image path |-------------------------
  String get image {
    switch (this.medicineForm) {
      case "Syrup":
        return "assets/images/syrup.png";
      case "Pill":
        return "assets/images/pills.png";
      case "Capsule":
        return "assets/images/capsule.png";
      case "Cream":
        return "assets/images/cream.png";
      case "Drops":
        return "assets/images/drops.png";
      case "Syringe":
        return "assets/images/syringe.png";
      default:
        return "assets/images/pills.png";
    }
  }
//=============================================================================
}
