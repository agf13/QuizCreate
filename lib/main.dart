import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

import 'models/quizQuestion.dart';
import 'models/quizOption.dart';
import 'widgets/quizItem.dart';
import 'widgets/quizItemEdit.dart';
import 'widgets/pages/quizItemEditPage.dart';
import 'widgets/pages/quizItemPage.dart';
import 'repos/storageChannel.dart';
import 'repos/sharedPrefsRepo.dart';

void main() {
	runApp(const MyApp());
}

class MyApp extends StatelessWidget {
	const MyApp({super.key});

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Quiz Create',
			theme: ThemeData(
				colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
				useMaterial3: true,
			),
			home: const MyHomePage(title: 'Quiz Create'),
		);
	}
}

class MyHomePage extends StatefulWidget {
	const MyHomePage({super.key, required this.title});

	final String title;

	@override
	State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
	var question = QuizQuestion();
	var tmp = "not yet ";
	SharedPreferences? prefs = null;

	@override
	void initState() {
		super.initState();
		initQuestion();
		initMem();
	}

	File? _imgFile;

	void initMem() async {
		this.prefs = await SharedPreferences.getInstance();
		setState(() => this.prefs = this.prefs);
	}
    
	void takeSnapshot() async {
		final ImagePicker picker = ImagePicker();
		final XFile? img = await picker.pickImage(
			source: ImageSource.gallery, // alternatively, use ImageSource.gallery
			maxWidth: 400,
		);

		if (img == null) return;

		setState(() {
			_imgFile = File(img.path); // convert it to a Dart:io file
		});	
	}

	void initQuestion() {
		print("Init question started @@@@@@@@@@@@@@@2");
		String questionJson = prefs?.getString("q_test") ?? "";
		print(questionJson);
		if(questionJson != "") {
			var questionJsonDecoded = jsonDecode(questionJson);
			this.question = QuizQuestion.fromJson(questionJsonDecoded);
			setState(() {this.question = this.question;});
			this.question.printConsole();
			print("\t Question initialized");
		}
		else print("\t No question to init");
		

		/*
		question.text = "Question number 1 it is";
		question.correctAnswer = 1;
		
		QuizOption option1 = QuizOption(text: "Option 1", cardNumber: 0);
		QuizOption option2 = QuizOption(text: "Option 2", cardNumber: 1);
		QuizOption option3 = QuizOption(text: "Option 3", cardNumber: 2);
		QuizOption option4 = QuizOption(text: "Option 4", cardNumber: 3);

		question.answers = [option1, option2, option3, option4];
		*/
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				backgroundColor: Theme.of(context).colorScheme.inversePrimary,
				title: Text(widget.title),
			),
			body: SingleChildScrollView (
				child: Center(
					child: Column(
						mainAxisAlignment: MainAxisAlignment.center,
						children: <Widget>[
							// Some spacing to not be really glued to the top of the screen
							Padding(padding: EdgeInsets.only(top: 50)),
							// Button to the quiz
							ElevatedButton(
								onPressed: () {
									Navigator.push(context, MaterialPageRoute(builder: (context) => QuizItemPage(prefs: this.prefs)));
								},
								child: SizedBox(
									width: 100,
									height: 70,
									child: Center(child:Text("Quiz")),
								),
							),
							// Some space
							Padding(padding: EdgeInsets.only(top: 50)),
							// Button to Edit page
							ElevatedButton(
								onPressed: () {
									Navigator.push(context, MaterialPageRoute(builder: (context) => QuizItemEditPage(prefs: this.prefs)));
								},
								child: SizedBox(
									width: 100,
									height: 70,
									child: Center(child:Text("Edit Questions")),
								),
							),
						],
					),
				),
			),
		);
	}
}
