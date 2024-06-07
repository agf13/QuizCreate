import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import '../../repos/sharedPrefsRepo.dart';
import '../../models/quizQuestion.dart';
import '../quizItemEdit.dart';

class QuizItemEditPage extends StatefulWidget {
	SharedPreferences? prefs = null;
	//QuizQuestion question = QuizQuestion();

	//QuizItemEditPage({super.key, question, required this.prefs}): this.question = question;
	QuizItemEditPage({super.key, required this.prefs});


	@override
	State<QuizItemEditPage> createState() => _QuizItemEditPageState();
}

class _QuizItemEditPageState extends State<QuizItemEditPage> {
	bool navigationUp = false;
	
	PrefsRepo? pr = null;
	QuizQuestion currentQuestion = QuizQuestion();
	int index = 0;

	@override
	void initState() {
		super.initState();
		pr = PrefsRepo.fromPref(widget.prefs);
		var question = pr?.getQuestionByNo(this.index, null);
		if(question != null) {

			setState(() {
				this.currentQuestion = question;
			});
		}
		else this.currentQuestion.text = "New question";
	}

	void toggleNavigation() {
		setState(() => this.navigationUp = !this.navigationUp);
	}

	Widget editNavigation() {
		return Row(
			mainAxisAlignment: MainAxisAlignment.center,
			children: [
				// Prev button
				ElevatedButton(
					onLongPress: () {
						toggleNavigation();
					},
					onPressed: () {
						var newIndex = this.index - 1;
						var newQuestion = pr?.getQuestionByNo(newIndex, null) ?? QuizQuestion();
							setState(() {
							this.currentQuestion = newQuestion;
							this.index = newIndex;
						});
					},
					child: const Text("Prev"),
				),
				// Index text
				Padding(padding: EdgeInsets.only(left: 10)),
				Text("${this.index}"),
				Padding(padding: EdgeInsets.only(left: 10)),
				// Next button
				ElevatedButton(
					onLongPress: () {
						toggleNavigation();
					},
					onPressed: () {
						var newIndex = this.index + 1;
						var newQuestion = pr?.getQuestionByNo(newIndex, null) ?? QuizQuestion();
						setState(() {
							this.currentQuestion = newQuestion;
							this.index = newIndex;
						});
					},
					child: const Text("Next"),
				),
			],
		);
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text("Edit question"),
			),
			body: SingleChildScrollView(
				child: Center(
					child: Column( 
						mainAxisAlignment: MainAxisAlignment.center,
						children: [	
							// Add the naviation buttons for questions (prev and next) and the index of the question
							(this.navigationUp ? editNavigation() : Padding(padding: EdgeInsets.only(top: 0))),
							// Some space between
							Padding(padding: EdgeInsets.only(top: 10)),
							// The edit widget
							QuizItemEdit(question: this.currentQuestion, prefs: widget.prefs, index: this.index),
							// Adding space
							Padding(padding: EdgeInsets.only(top: 0)),
							// Next and prev buttons, as well as a number indicating the question index
							(this.navigationUp ? Padding(padding: EdgeInsets.only(top: 0)) : editNavigation()),
						],
					),
				),
			),
		);
	}
}
