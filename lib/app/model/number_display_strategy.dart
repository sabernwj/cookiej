class NumberDisplayStrategy {
	int applyScenarioFlag;
	int displayTextMinNumber;
	String displayText;

	NumberDisplayStrategy({this.applyScenarioFlag, this.displayTextMinNumber, this.displayText});

	NumberDisplayStrategy.fromJson(Map<String, dynamic> json) {
		applyScenarioFlag = json['apply_scenario_flag'];
		displayTextMinNumber = json['display_text_min_number'];
		displayText = json['display_text'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['apply_scenario_flag'] = this.applyScenarioFlag;
		data['display_text_min_number'] = this.displayTextMinNumber;
		data['display_text'] = this.displayText;
		return data;
	}
}