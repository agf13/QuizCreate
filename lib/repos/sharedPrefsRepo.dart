/*
	Manage memory through shared preferences.
*/
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/quizQuestion.dart';

class PrefsRepo {
	SharedPreferences? prefs;

	PrefsRepo() {
		initMemory();
	}

	PrefsRepo.fromPref(SharedPreferences? prefs) : this.prefs = prefs {
	}

	/*
		def: initializez the shared preferences instance. Initializes the number of questions if it was not initialized already (needed only once per first open of app after instalation, but just in case it is checked every time)
	*/
	void initMemory() async {
		prefs = await SharedPreferences.getInstance();
		var totalQuestions = this.totalQuestions;
		if(totalQuestions == 0 || totalQuestions == null) this.totalQuestions = 0;
	}

	/*
		def: add a subject
		in: String - subjectName | the name to be added on the subject's list
	*/
	void addSubject(String subjectName) {
		int currentTotalSubjects = this.totalSubjects; // get current number of subjects

		this.setSubject(currentTotalSubjects, subjectName); // assign the subject name as the next subject
		currentTotalSubjects++; // increment number of subjects

		this.totalSubjects = currentTotalSubjects; // update number of subject
	}

	/*
		def: For a given index, set the subject name
		in: int - subjectIndex | the index of the subject
			string - subjectName | the name of the subject
	*/
	void setSubject(int subjectIndex, String subjectName) {
		prefs?.setString("subject${subjectIndex}", subjectName);
	}

	/*
		def: get the name of the subject from the given index
		in: int - subjectIndex | the index of the subject
		out: string - the name of the subject
			 null - no subject at the given index or no prefs
	*/
	String? getSubjectName(int subjectIndex) {
		String? subjectName = prefs?.getString("subject${subjectIndex}");
		return subjectName;
	}

	/*
		def: finds the index or -1 of a given subject name
		in: string - subjectName | the name of the subject
		out: int | the index at which the subject name is found
	*/
	int getSubjectIndex(String subjectName) {
		List<String> subjects = this.getSubjectNames();
		int index = -1;
		for(int i=0; i<subjects.length; i++) {
			if(subjects[i] == subjectName) return i;
		}

		return -1;
	}

	/*
		def:	adds the question in the shared preferences
		in:		QuizQuestion - question
		out:	the json string representation of the question
	*/
	String addQuestion(QuizQuestion q) {
		var stringQ = json.encode(q.toJson()); // convert to json string
		var questionIndex = "question${this.totalQuestions}";
		print("\tAdding $questionIndex");

		prefs?.setString(questionIndex, stringQ); // store the string
		this.totalQuestions = this.totalQuestions + 1; // increment the number of questions (basically indexed from 0. Total number is one more then the number showned here

		return stringQ;
	}

	/*
		def:	updates the question in the shared preferences at the given index
		in:		QuizQuestion - question
				int - index // the index of the question that we update
		out:	the json string representation of the question
	*/
	String updateQuestion(QuizQuestion q, int index) {
		var stringQ = json.encode(q.toJson());	
		var questionIndex = "question${index}";
		print("\tUpdate ${questionIndex}");

		prefs?.setString(questionIndex, stringQ);
		print("\t----- $questionIndex");

		return stringQ;
	}

	/*
		def: deletes a question. Does this by rewriting the current value of the shared memory variable with the empty string. When it is encountered, the question is skipped
		in: index - int // the question index to be deleted
		out: QuizQuestion? // the question that was just deleted
		potential error: would return null in both the cases when the question does not exist and also in the cases when the prefs is not initiaized / does not exist
	*/	
	QuizQuestion? removeQuestion(int index) {
		var questionIndex = "question${index}";
		print("\tDelete ${questionIndex}");

		var valueFromRemove = prefs?.getString(questionIndex);
		if(valueFromRemove == null || valueFromRemove == "") return null; // if no question at the given index, return null.

		prefs?.setString(questionIndex, "");
		var removedQuestion = QuizQuestion.fromJson(json.decode(valueFromRemove));
		return removedQuestion;
	}

	/*
		def: 	Retrieve the question given the number that it was saved to
		in:	int - number of question
		out: 	QuizQuestion? (if the question is found) | null (if the question was not found)
	*/
	QuizQuestion? getQuestionByNo(int number) {
		if(number > this.totalQuestions) return null;
		var questionIndex = "question${number}";
		print("\tGet question from ${questionIndex}");

		var jsonString = prefs?.getString("question${number}");

		if(jsonString != null && jsonString != "") {
			return QuizQuestion.fromJson(json.decode(jsonString));
		}
		return null;
	}

	/*
		def: return a list of all existing questions so far
	*/
	void listAllQuestions() {
		var listQuestions = <QuizQuestion>[];
		var totalNumber = this.totalQuestions;

		int i=0;
		String? jsonQuestion = null;
		while((jsonQuestion = prefs?.getString("question${i}")) != null) {
			print("====== $i");
			print(jsonQuestion);
			i++;
			if(jsonQuestion != null) {
				QuizQuestion question = QuizQuestion.fromJson(json.decode(jsonQuestion!));
				listQuestions.add(question);
			}
		}

		/* for(var i=0; i<= totalNumber; i++) {
			var jsonQuestion = prefs?.getString("${prefix}question${i}");
			print("====== $i");
			print(jsonQuestion);
		} */
	}

	/*
		def: set all questions to empty string then reset the counter of totalQuestions
	*/
	void delAllQuestions() {
		var totalNumber = this.totalQuestions;
		for(var i=0; i<= totalNumber; i++) {
			var jsonQuestion = prefs?.setString("question${i}","");
			print(jsonQuestion);
		}
		this.totalQuestions = 0;
	}

	/*
		def: get all questions for a given subject
		in: string - subject | the name of the subject we are searching for
		out: 
	*/
	//List<>

	/*
		def: get all subject names
		out: List<String> | A list with all subject names. Can be empty as well
	*/
	List<String> getSubjectNames() {
		int maxSubjectIndex = this.totalSubjects;
		if(maxSubjectIndex < 0) return [];

		List<String> subjectNames = [];
		for(int i=0; i<maxSubjectIndex; i++) {
			String? subject = this.getSubjectName(i);
			if(subject != null && subject != "") subjectNames.add(subject);
		}

		return subjectNames;
	}

	int get totalQuestions => prefs?.getInt("totalQuestions") ?? 0;
	void set totalQuestions(int val) => prefs?.setInt("totalQuestions", val);

	int get totalSubjects => prefs?.getInt("totalSubjects") ?? 0;
	void set totalSubjects(int val) => prefs?.setInt("totalSubjects", val);
}
