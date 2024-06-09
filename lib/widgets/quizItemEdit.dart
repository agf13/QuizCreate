/*
	Widget for editing questions and answers
*/

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/quizOption.dart';
import '../models/quizQuestion.dart';
import '../models/baseQuizItem.dart';
import '../repos/sharedPrefsRepo.dart';


import 'quizItemOption.dart';
import 'quizItemQuestion.dart';

class QuizItemEdit extends StatefulWidget {
	var question = QuizQuestion();
	SharedPreferences? prefs = null;
	int index;

	QuizItemEdit({super.key, question, required this.prefs, required this.index}) : 
		this.question = question;

	@override
	State<QuizItemEdit> createState() => _QuitItemEditState();
}

class _QuitItemEditState extends State<QuizItemEdit> {
	String trashIconPath = "";
	String currentSubject = "Select a subject";
	int currentSubjectIndex = -1;

	bool isNew = false;

	String answerState = "Waiting for option";
	bool edit1 = false;
	bool edit2 = false;
	bool edit3 = false;
	bool edit4 = false;
	bool editQ = false;

	@override
	void initState() {
		super.initState();
		this.trashIconPath = widget.prefs?.getString("trash_icon") ?? "assets/images/icon_trash_2.png";
	}

	void changeImage(BaseQuizItem baseItem) async {
		String? oldImagePath = baseItem.image; // store the path to the image if the item already has one. Otherwise store null. The image property of the baseItem is a string representing the path to the image, and not the actual file

		final imagePicker = ImagePicker(); // Initialize image picker
		final XFile? img = await imagePicker.pickImage(
			source: ImageSource.gallery,
		);
		if (img == null) return; // if image is null, return
		setState(() {
			baseItem.image = img.path; // set the image to the item
		});

		// Store the image in local memory. If the item already had an image before, replace the old image with the new one
		baseItem.changeImage(File(img.path));
	}

	Widget questionEdit(QuizQuestion question, bool edit) {
		return SingleChildScrollView(
			scrollDirection: Axis.horizontal,
			child: Row(
				mainAxisAlignment: MainAxisAlignment.center,
				children: [
					// Spacing in front for style
					Padding(padding: EdgeInsets.only(left: 50)),
					// Label to identify if the field is a question or an answer
					const Text("Q:", style: TextStyle(fontSize: 15)),
					Padding(padding: EdgeInsets.only(left: 10)),
					// Button for question (allow to change text and image)
					ElevatedButton(
						onLongPress: () {
							// Change the image associated with the question
							changeImage(question);
						},
						onPressed: () {
							// Change the state of the button (if its showing the text or if it is in edit mode
							setState(() => editQ = !editQ);
						},
						child: edit == true ? 
							// Define the space in which the text field will be located
							SizedBox(
								width: 150,
								height: 60,
								child: TextField(
									onChanged: (text) {
										// Update the text associated with the question at each new modification (it just works, could have better updated on save or something)
										setState(() {question.text = text;});
									},
									decoration: InputDecoration(
										// Show the associated text as hint, since its the best way as I don't exactly have the time to look how to make the text itself editable
										hintText: "${question.text}",
									),
								),
							) :
							SizedBox(
								width: 100,
								child: Text("${question.text}"),
							),
					),
					// Some space
					Padding(padding: EdgeInsets.fromLTRB(10,0,0,0),),
					// Placeholder for the image if chosen
					Container(
						width: 100,
						height: 100,
						child: question.image == null ? Padding(padding: EdgeInsets.all(0)) : Image.file(File(question.image!)),
						decoration: BoxDecoration(
							border: Border.all(color: Colors.blueAccent),
						),
					),
					// Some spacing between the trash icon and the image
					Padding(padding: EdgeInsets.only(left: 20)),
					// Button to delete the image for the quiz
					ElevatedButton(
						onLongPress: () {
							var basePath = "assets/image/";
						},
						onPressed: () {
							if(question.image != null) {
								File? imageFile = File(question.image!);
								imageFile?.delete();
								setState(() => question.image = null);
							}
						},
						child: Image.asset(this.trashIconPath, width: 30, height: 30),
					),
					// Some padding at the end for style
					Padding(padding: EdgeInsets.only(left: 20)),
				],
			),
		);
	}

	Widget optionEdit(QuizOption option, bool edit) {
		return SingleChildScrollView(
			scrollDirection: Axis.horizontal,
			child: Row(
				mainAxisAlignment: MainAxisAlignment.center,
				children: [
					// Label to identify if the field is a question or an answer
					Container(
						padding: EdgeInsets.all(10),
						child: Row(
							children: [
								// Button to mark this as correct answer
								SizedBox(
									width: 30,
									height: 30,
									child:	ElevatedButton(
										onPressed: () {
											// Mark as correct answer
											setState(() => widget.question.correctAnswer = option.cardNumber);
										},
										child: SizedBox(width:10, height: 10),
									),
								),
								Padding(padding: EdgeInsets.only(left: 10)),
								// Show the number of the answer (not really very relevent to user, but still kinda usefull
								Text("A${option.cardNumber + 1}:", style: TextStyle(fontSize: 15)),
								Padding(padding: EdgeInsets.only(left: 10)),
								// Button for option (allow to change text and image)
								ElevatedButton(
									onLongPress: () {
										// Change the image of the question option (answer)
										changeImage(option);
									},
									onPressed: () {
											// Manuallt check for which option is this widget rendered such that we can change whether is the edit display or the show display rendered
										if(option.cardNumber == 0) setState(() => edit1 = !edit1);
										if(option.cardNumber == 1) setState(() => edit2 = !edit2);
										if(option.cardNumber == 2) setState(() => edit3 = !edit3);
										if(option.cardNumber == 3) setState(() => edit4 = !edit4);
									},
									child: edit == true ?
										// Create the space where the TextField will be put 
										SizedBox(
											width: 150,
											height: 60,
											child: TextField(
												onChanged: (text) {
													// Update text on each stroke or deletion. Could have better updated it on save or something (it is a working way. Maybe change it in the future)
													setState(() {option.text = text;});
												},
												decoration: InputDecoration(
													// Show the option associated text as hint text to know what was written before editing, as the text disappears when switching from show to edit
													hintText: "${option.text}",
												),
											),
										) :
										// Just present the text with width restriction (this way it will align itself on multiple rows)
										SizedBox(
											width: 100,
											child: Text("${option.text}"),
										),
								),
							],
						),
						decoration: BoxDecoration(
							border: widget.question.correctAnswer == option.cardNumber ? Border.all(color: Colors.black) : Border.all(color: Colors.white),
						),
					),
					// Some space between the text and image
					Padding(padding: EdgeInsets.fromLTRB(10,0,0,0),),
					// Placeholder for the image if choosen
					Container(
						width: 100,
						height: 100,
						child: option.image == null ? Padding(padding: EdgeInsets.all(0)) : Image.file(File(option.image!)),
						decoration: BoxDecoration(
							border: Border.all(color: Colors.blueAccent),
						),
					),
					// Some space
					Padding(padding: EdgeInsets.only(left: 20)),
					// Button for deleting an image
					ElevatedButton(
						onLongPress: () {
							// Base path for easier writing of logic in this code
							var basePath = "assets/images/";

							// Set the icon trash
							if(this.trashIconPath == "${basePath}icon_trash.png") {
								setState(() => this.trashIconPath = "${basePath}icon_trash_0.png");
							}
							else if(this.trashIconPath == "${basePath}icon_trash_0.png")  {
								setState(() => this.trashIconPath = "${basePath}icon_trash.png");
							}
							//else{
							//	setState(() => this.trashIconPath = "${basePath}icon_trash.png");
							//}

							// set the icon in memory to use it in every place
							widget.prefs?.setString('trash_icon', this.trashIconPath);
						},
						onPressed: () {
							// Code to erase image
							if(option.image != null) {
								File? imageFile = File(option.image!);
								imageFile?.delete();
								setState(() => option.image = null);
							}
							
							// Maybe for the future. To not copy it again
							if(option.cardNumber == 0) {	
							}
							if(option.cardNumber == 1) {
							}
							if(option.cardNumber == 2) {
							}
							if(option.cardNumber == 3) {
							}
						},
						child: Image.asset(this.trashIconPath, width: 31, height: 31),
					),
				],
			),
		);
	}

	Widget subjectDropDown(BuildContext context) {
		String newSubject = ""; // init newSubject var to be used for creating new subjects
		var pr = PrefsRepo.fromPref(widget.prefs); // init prefs repo

		return SingleChildScrollView(
			scrollDirection: Axis.horizontal, 
			child: Row(
				mainAxisAlignment: MainAxisAlignment.center,
				children: [
					// Label for the subject choosing drop-down
					Text("Subject: "),
					Padding(padding: EdgeInsets.only(left: 10),),
					// Button that will display the subject, allow selecting a new one or creating one
					ElevatedButton(
						onLongPress: () => showDialog<String> (
							context: context,
							builder: (BuildContext context) => AlertDialog(
								title: const Text("Create a subject"),
								content: SizedBox(
									width: 100,
									height: 50,
									child: TextField(
										onChanged: (text) {
											newSubject = text;
										}
										// some boxDecoration
									),
								),
								actions: <Widget>[	
									TextButton(
										// adding a subject
										onPressed: () {
											// saving the subject as a new one
											if(newSubject != "") {
												//var pr = PrefsRepo.fromPref(widget.prefs);
												pr.addSubject(newSubject);
											}

											Navigator.pop(context, 'Add');
										},
										child: const Text('Add'),
									),
									// cancel subject creation
									TextButton(
										onPressed: () {
											Navigator.pop(context, 'Cancel');
										},
										child: const Text('Cancel'),
									),
								]
							),
						),
						// show all existing subjects
						onPressed: () => showDialog<String> (
							context: context,
							builder: (BuildContext context) => AlertDialog(
								title: const Text("Select a subject"),
								content: SizedBox(
									width: 100,
									height: 50,
									child: DropdownMenu<String>(
										requestFocusOnTap: true,
										label: const Text("Subject"),
										onSelected: (String? text) {
											int index = pr.getSubjectIndex(text ?? ""); // find the index of the subject
											setState(() => this.currentSubjectIndex = index);
										},
										dropdownMenuEntries: pr.getSubjectNames()
											.map<DropdownMenuEntry<String>>((String subject) {
												return DropdownMenuEntry<String>(
													value: subject,
													label: subject,
													enabled: true, // whether we can click the option
													style: MenuItemButton.styleFrom(
														foregroundColor: Colors.black,
													),
												);
											}).toList(),
									),
								),
								actions: <Widget>[	
									// cancel subject creation
									TextButton(
										onPressed: () {
											Navigator.pop(context, 'Ok');
										},
										child: const Text('Ok'),
									),
								]
							),
						),
						child: Text("${pr.getSubjectName(this.currentSubjectIndex)}"),
					),
				],
			),
		);
	}

	@override
	Widget build(BuildContext context) {
		return Center(
			child: Container(
				margin: EdgeInsets.all(10),
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
						//QuizItemQuestion(baseQuizItem: widget.question), // Just display the question if seems like useful to see
						// Title
						//const Text("Edit the question and answers",
						//	style: TextStyle(
						//		fontSize: 38,
						//	),
						//),
						//Padding(padding: EdgeInsets.only(top: 30)),
						// Question edit
						subjectDropDown(context),
						Padding(padding: EdgeInsets.fromLTRB(0,30,0,0)),
						questionEdit(widget.question, editQ),
						Padding(padding: EdgeInsets.fromLTRB(0,30,0,0)),
						// Option 1 edit
						optionEdit(widget.question.answers[0], edit1),
						Padding(padding: EdgeInsets.fromLTRB(0,10,0,0),),
						// Option 2 edit
						optionEdit(widget.question.answers[1], edit2),
						Padding(padding: EdgeInsets.fromLTRB(0,10,0,0),),
						// Option 3 edit
						optionEdit(widget.question.answers[2], edit3),
						Padding(padding: EdgeInsets.fromLTRB(0,10,0,0),),
						// Option 4 edit
						optionEdit(widget.question.answers[3], edit4),
						// Button to save the cahnges
						Padding(padding: EdgeInsets.only(top: 0)),
						ElevatedButton(
							onPressed: () {
								// Basically save this to the total of questions
								var pr = PrefsRepo.fromPref(widget.prefs);
								print(widget.question.toJson());

								if(pr.getQuestionByNo(widget.index, null) == null) {
									var res = pr.addQuestion(widget.question, null);
								}
								else {
									var res = pr.updateQuestion(widget.question, widget.index, null);
								}
								
							},
							child: Text("Save changes"),
						),
					],
				),
			),
		);
	}
}
