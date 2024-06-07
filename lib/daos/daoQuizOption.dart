import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../models/quizOption.dart';

class DaoQuizOption {
	static String toJson(QuizOption o, File? file) => "\{\"id\": ${o.id}, \"text\": \"${o.text}\", \"image\": \"${file?.readAsBytesSync()}\", \"cardNumber\": ${o.cardNumber}\}";

	static String trimJson(String json) {
		if(json[0] == '{') {
			json = json.substring(0, json.indexOf('{'));
		}
		if(json[json.length-1] == '}') {
			json = json.substring(0, json.lastIndexOf('}'));
		}
		return json;
	}

	static QuizOption fromJson(String json) {
		json = trimJson(json);
		print(json);

		QuizOption result = QuizOption();
		
		var paramList = json.split(', \"');
		return result;
	}


}
