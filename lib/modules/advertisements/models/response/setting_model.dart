class SettingModel {
  final String vodafoneCashNumber;
  final int cost;

  SettingModel({required this.vodafoneCashNumber, required this.cost});

  factory SettingModel.fromJson(Map<String, dynamic> json) => SettingModel(
        vodafoneCashNumber: json["vodafone_cash"] ?? "",
        cost: json["special_cost"] ?? 0,
      );
}
