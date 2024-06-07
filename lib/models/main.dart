import 'baseQuizItem.dart';
import 'quizOption.dart';
import 'quizQuestion.dart';

void main() {
	var b = BaseQuizItem(text: "la lal a");
	var o = QuizOption(text: "some text");
	var q = QuizQuestion(text: "alte alte raspunruri", answers: [o], correctAnswer: 1);

	print("The quiz as the answer ${q.correctAnswer}");

	b.printConsole();
	o.printConsole();
	q.printConsole();
}
