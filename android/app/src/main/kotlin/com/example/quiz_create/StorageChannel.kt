package com.example.quiz_create

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.example.quiz_create.StorageChannel

class StorageChannel: FlutterActivity() {
	private val CHANNEL = "androidStorage"

	override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
		//super.configureFlutterEngine(flutterEngine)
		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
			call, result ->
			if (call.method == "getQuizListJson") {
				var quizList = getQuizListJson()
				result.success(quizList)
			} else {
				result.error("NoSuchMethod","not implemented. Check name.", null);
			}
		}
	}

	private fun getQuizListJson(): String {
		var response: String = "to be implemented"

		return response
	}
}

