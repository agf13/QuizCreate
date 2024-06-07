import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StorageChannel {
	static const platform = MethodChannel('androidStorage');

	Future<String> getQuizListJson() async {
		String response;
		try {
			response = await platform.invokeMethod<String>('getQuizListJson') ?? "";
		} on PlatformException catch (e) {
			response = "Failed to get quiz list";
		}

		return response;
	}
}

