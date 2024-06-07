/*
	This is the option widget for a question. This is the little button with a text and image
*/

import 'package:flutter/material.dart';
import 'dart:io';

import '../models/baseQuizItem.dart';

class QuizItemOption extends StatefulWidget {
	BaseQuizItem baseQuizItem;

	QuizItemOption({super.key, baseQuizItem}) :
		this.baseQuizItem = baseQuizItem;

	@override
	State<QuizItemOption> createState() => _QuizItemOptionState();
}

class _QuizItemOptionState extends State<QuizItemOption> {
	@override
	Widget build(BuildContext context) {
		return Container(
			constraints: BoxConstraints(
				maxWidth: 100,
			),
			child: Center(
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
							child: (widget.baseQuizItem.text == null) ? Padding(padding: EdgeInsets.all(0)) : Text("${widget.baseQuizItem.text}"),
						),
						Padding(
							padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
						),
					],
				),
			),
		);
	}
}
