package com.example.quiz_create

import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

import com.example.quiz_create.StorageChannel

class MainActivity: FlutterActivity() {
	val storageChannel = StorageChannel()

	override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)
		storageChannel.configureFlutterEngine(flutterEngine)
	}
}
