import 'package:flutter/material.dart';
import 'dart:io';

import '../models/baseQuizItem.dart';

class QuizItemQuestion extends StatefulWidget {
	BaseQuizItem baseQuizItem;

	QuizItemQuestion({super.key, baseQuizItem}): 
		this.baseQuizItem = baseQuizItem;

	@override
	State<QuizItemQuestion> createState() => _QuizItemQuestionState();
}

class _QuizItemQuestionState extends State<QuizItemQuestion> {

	@override
	Widget build(BuildContext context) {
		return Container(
			decoration: BoxDecoration(
				border: Border.all(
					color: Colors.black,
				),
			),
			margin: EdgeInsets.all(10),
			padding: EdgeInsets.all(20),
			child: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				children: [
					Padding(
						padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
					),
					Container(
						child: (widget.baseQuizItem.image == null) ? Padding(padding: EdgeInsets.all(0)) : Image.file(File(widget.baseQuizItem.image!), width: 100, height: 100),
					),
					Container(
						child: (widget.baseQuizItem.text == null) ? Padding(padding: EdgeInsets.all(0)) : Text("${widget.baseQuizItem.text}", style: TextStyle(fontSize: 23)),
					),
					Padding(
						padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
					),
				],
			),
		);
	}
}
