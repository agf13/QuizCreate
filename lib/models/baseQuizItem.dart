import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

/*
	This is the item model for creating questions and options
*/

class BaseQuizItem {
	int _id = -1;
	String? text;
	String? image;

	BaseQuizItem({ this.text= null, this.image = null });

	void set id(int id) => this._id = id;
	int get id => this._id;

	void changeImage(File imageNew) {
		if(this.image != null) {
			File? oldFile = File(this.image!);
			oldFile.writeAsBytesSync(imageNew.readAsBytesSync()); // replace content of old with new
			// Don't updatee the this.image which represents the path, because we just rewrite its content
		}
		else {
			var fileName = imageNew.path.split(Platform.pathSeparator).last;
			var path = "${getApplicationDocumentsDirectory()}/${fileName}";
			File? newFile = File(path);
			newFile.writeAsBytesSync(imageNew.readAsBytesSync());
			this.image = path; // Update this.image since it did not exist before, so we are creating there instead of rewriting
		}
	}

	void printConsole() => print("id: $_id, text: $text, image: $image");
}

