import 'package:image/image.dart';
import 'dart:io';
import 'dart:convert';

import 'baseQuizItem.dart';
import 'quizOption.dart';

/*
	This is the item model for creating questions
*/

class QuizQuestion extends BaseQuizItem {
	List<QuizOption> answers;
	int correctAnswer;
	bool answered = false;

	QuizQuestion({answers, correctAnswer = -1, String? text, String? image}) : 
		this.answers = answers ?? [],
		this.correctAnswer = correctAnswer,
		super(text: text, image: image) {
		// manually creating empty answers as fallback if needed
		if(this.answers.length == 0) {
			this.answers.add(QuizOption(cardNumber: 0));
			this.answers.add(QuizOption(cardNumber: 1));
			this.answers.add(QuizOption(cardNumber: 2));
			this.answers.add(QuizOption(cardNumber: 3));
		}
	}

	QuizQuestion.fromJson(Map<String, dynamic> json) :
		this.answers = [],
		this.correctAnswer = json['correctAnswer'] as int,
		super(text: json['text'] as String?, image: json['image'] as String?) {
		this.id = json['id'] as int;
		// initializing the list of options
		json['answers'].forEach((elem) {
			QuizOption o = QuizOption.fromJson(elem);
			this.answers.add(o);
		});
	}


	@override
	void printConsole() {
		super.printConsole();
		print("\tcorrect answer: ${this.correctAnswer}");
	}

	Map<String, dynamic> toJson() => {
		'id': this.id,
		'text': this.text,
		'image': this.image,
		'correctAnswer': this.correctAnswer,
		'answers': this.answers
	};
}
