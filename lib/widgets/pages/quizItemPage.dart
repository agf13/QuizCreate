import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import '../../repos/sharedPrefsRepo.dart';
import '../../models/quizQuestion.dart';
import '../quizItem.dart';

class QuizItemPage extends StatefulWidget {
	//QuizQuestion question = QuizQuestion();
	SharedPreferences? prefs = null;

	QuizItemPage({super.key, required this.prefs});

	@override
	State<QuizItemPage> createState() => _QuizItemPageState();
}

class _QuizItemPageState extends State<QuizItemPage> {
	PrefsRepo? pr = null;
	QuizQuestion currentQuestion = QuizQuestion();
	int index = 0;
	bool navUp = true;
	late QuizItem quizReference;

	@override
	void initState() {
		super.initState();
		pr = PrefsRepo.fromPref(widget.prefs);
		var question = pr?.getQuestionByNo(this.index);
		if(question == null) this.currentQuestion.text = "No questions at this point";
		else{
			setState(() {
				this.currentQuestion = question;
			});
		}
	}

	Widget quizNavigation() {
		return Row(
			mainAxisAlignment: MainAxisAlignment.center,
			children: [
				// prev button
				ElevatedButton(
					onLongPress: () {
						setState(() => this.navUp = !this.navUp);
					},
					onPressed: () {
						var newIndex = this.index - 1;
						var newQuestion = pr?.getQuestionByNo(newIndex) ?? QuizQuestion(text: "No more questions in front");
						setState(() {
							this.index = newIndex;
							this.currentQuestion = newQuestion;
						});
						this.quizReference.resetWidgetAnswerState();
					},
					child: Text("Prev"),
				),
				// some space
				Padding(padding: EdgeInsets.only(left: 10)),
				// The number of the current question
				Text("${this.index}"),
				// some space
				Padding(padding: EdgeInsets.only(left: 10)),
				// next button
				ElevatedButton(
					onLongPress: () {
						setState(() => this.navUp = !this.navUp);
					},
					onPressed: () {
						var newIndex = this.index + 1;
						var newQuestion = pr?.getQuestionByNo(newIndex) ?? QuizQuestion(text: "No other question from here on");
						setState(() {
							this.index = newIndex;
							this.currentQuestion = newQuestion;
						});
						this.quizReference.resetWidgetAnswerState();
					},
					child: Text("Next"),
				),
			],
		);
	}

	@override
	Widget build(BuildContext context) {
		var qJson = this.currentQuestion.toJson();
		this.quizReference = QuizItem(question: this.currentQuestion); // keep a reference to update the label status

		print(qJson);
		return Scaffold(
			appBar: AppBar(
				title: const Text("Quiz"),
			),
			body: SingleChildScrollView(
				child: Center(
					child: Column (
						mainAxisAlignment: MainAxisAlignment.center,
						children: [
							// Navigation for question
							(this.navUp) ? quizNavigation() : Padding(padding: EdgeInsets.only(top:0)),
							// Show tre question and its options
							// QuizItem(question: this.currentQuestion),
							this.quizReference,
							// Navigation for question
							(!this.navUp) ? quizNavigation() : Padding(padding: EdgeInsets.only(top:0)),
						]
					),
				),
			),
		);
	}

	
}
