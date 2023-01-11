class HelpCenterMessageBody {
  String name;
  String message;

  HelpCenterMessageBody({this.name = "", this.message = ""});

  void copyWith({String? name, String? message}) {
    this.name = name ?? this.name;
    this.message = message ?? this.message;
  }

  void resetValues() {
    name = "";
    message = "";
  }

  Map<String, dynamic> toJson() {
    return {"title": name, "message": message};
  }
}
