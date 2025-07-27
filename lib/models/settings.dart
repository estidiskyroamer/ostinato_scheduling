class Settings {
  final WageSettings wageSettings;
  final ScheduleSettings scheduleSettings;

  Settings({required this.wageSettings, required this.scheduleSettings});

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      wageSettings: WageSettings.fromJson(json['wageSettings']),
      scheduleSettings: ScheduleSettings.fromJson(json['scheduleSettings']),
    );
  }
}

class WageSettings {
  final int fixedRate;
  final int percentage;
  final bool isPercentage;

  WageSettings({required this.fixedRate, required this.percentage, required this.isPercentage});

  factory WageSettings.fromJson(Map<String, dynamic> json) {
    return WageSettings(
      fixedRate: json['fixedRate'],
      percentage: json['percentage'],
      isPercentage: json['isPercentage'],
    );
  }
}

class ScheduleSettings {
  final String repeat;
  final String lessonLength;
  final String scheduleEndTime;
  final String scheduleStartTime;

  ScheduleSettings({
    required this.repeat,
    required this.lessonLength,
    required this.scheduleEndTime,
    required this.scheduleStartTime,
  });

  factory ScheduleSettings.fromJson(Map<String, dynamic> json) {
    return ScheduleSettings(
      repeat: json['repeat'],
      lessonLength: json['lessonLength'],
      scheduleEndTime: json['scheduleEndTime'],
      scheduleStartTime: json['scheduleStartTime'],
    );
  }
}
