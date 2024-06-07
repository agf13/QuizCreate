import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../models/quizQuestion.dart';
import '../models/baseQuizItem.dart';

import 'quizItemOption.dart';
import 'quizItemQuestion.dart';

class QuizItem extends StatefulWidget {
	var question = QuizQuestion();
	_QuitItemState? subWidget = null;

	QuizItem({super.key, question}) : 
		this.question = question;

	@override
	State<QuizItem> createState() {
		this.subWidget = _QuitItemState();
		print("create state...");
		print(this.subWidget?.answerState);
		print("|||||");
		return this.subWidget!;
	}

	void resetWidgetAnswerState() {
		print("reseting state");
		print("${this.subWidget?.answerState}");
		this.subWidget?.resetAnswerState();
	}
}

class _QuitItemState extends State<QuizItem> {
	String answerState = "Waiting for option";

	void resetAnswerState() {
		print("actually reseting state");
		setState(() => this.answerState = "Waiting for option");
	}

	void changeImage(BaseQuizItem option) async {
		final imagePicker = ImagePicker();
		final XFile? img = await imagePicker.pickImage(
			source: ImageSource.gallery,
		);
		if (img == null) return;
		setState(() {
			option.image = img.path;
		});
		
	}

	void checkAnswer(int cardNo) {
		if(widget.question.answered == false) setState(() => widget.question.answered = true);
		if(widget.question.correctAnswer == cardNo) {
			setState(() {
				answerState = "Correct";
			});
		}
		else {
			setState(() {
				answerState = "Wrong";
			});
		}
	}

	@override
	Widget build(BuildContext context) {
		return Center(
			child: Container(
				margin: EdgeInsets.all(10),
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
						// Show the questiosn
						QuizItemQuestion(baseQuizItem: widget.question),
						Padding(
							padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
						),
						// Show the first 2 answers
						Row(
							mainAxisAlignment: MainAxisAlignment.center,
							children: [
								// Build first item button
								ElevatedButton(
									onPressed: () {
										// Checking if this is the correct answer
										checkAnswer(0);
									},
									child: QuizItemOption(
										baseQuizItem: widget.question.answers[0]
									),
								),
								Padding(
										padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
								),
								// Build second item button
								ElevatedButton(
									onPressed: () {
										// Checking for the correct answer;
										checkAnswer(1);
									},
									child: QuizItemOption(
										baseQuizItem: widget.question.answers[1]
									),
								),
							]
						),
						Padding(
							padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
						),
						// Show the other 2 answers
						Row(
							mainAxisAlignment: MainAxisAlignment.center,
							children: [
								// Build third item button
								ElevatedButton(
									onPressed: () {
										// Checking for the correct answer
										checkAnswer(2);
									},
									child: QuizItemOption(
										baseQuizItem: widget.question.answers[2]
									),
								),
								Padding(
									padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
								),
								// Build forth item button
								ElevatedButton(
									onPressed: () {
										// Checking if this is the correct answer
										checkAnswer(3);
									},
									child: QuizItemOption(
										baseQuizItem: widget.question.answers[3]
									),
								),
							],
						),
						Padding(
							padding: EdgeInsets.only(top: 30),
						),
						// Show whether the questions was answered correctly
						(widget.question.answered == false) ? Text("Waiting for answer") : Text("$answerState"),
					]
				),
			),
		);
	}
}
