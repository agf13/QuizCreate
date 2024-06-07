import "dart:io";
import "package:image_picker/image_picker.dart";

import "baseQuizItem.dart";

/*
	This is the base item for creating option answers for a question
*/

class QuizOption extends BaseQuizItem {
	int cardNumber;

	QuizOption({this.cardNumber = -1, String? text, String? image}) : super(text: text, image: image);

	QuizOption.fromJson(Map<String, dynamic> json) :
		this.cardNumber = json['cardNumber'] as int,
		super(text: json['text'] as String?, image: json['image'] as String?) {
		this.id = json['id'] as int;
	}

	Map<String, dynamic> toJson() => {
		'id': this.id,
		'text': this.text,
		'cardNumber': this.cardNumber,
		'image': this.image
	};

	@override
	void printConsole() {
		super.printConsole();
		print("\tcardNumber: ${this.cardNumber}");
	}
}
