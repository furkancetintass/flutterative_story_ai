import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterative_story_ai/api/api_response.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

class GenerativeAIViewModel extends ChangeNotifier {
  static const _apiKey = String.fromEnvironment('api_key');

  final GenerativeModel _generativeModel = GenerativeModel(
      model: "gemini-pro-vision",
      apiKey: _apiKey,
      generationConfig: GenerationConfig(temperature: 0),
      safetySettings: [
        SafetySetting(
          HarmCategory.sexuallyExplicit,
          HarmBlockThreshold.none,
        ),
      ]);

  ApiResponse<GenerateContentResponse> _generateContentApiResponse =
      ApiResponse.idle();

  set generateContentApiResponse(ApiResponse<GenerateContentResponse> value) {
    _generateContentApiResponse = value;
    notifyListeners();
  }

  ApiResponse<GenerateContentResponse> get generateContentApiResponse =>
      _generateContentApiResponse;

  File? _selectedImage;

  File? get selectedImage => _selectedImage;

  Future<void> generateContent() async {
    const prompt =
        '''please create a child story and story title from the given image.
The story should also include its own title.
The story should be in line with the picture theme,
for example: scientific or romantic or fantasy etc.''';

    try {
      final ImagePicker picker = ImagePicker();

      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) {
        return;
      }

      generateContentApiResponse = ApiResponse.loading();

      _selectedImage = File(image.path);

      final imageBytes = await _selectedImage!.readAsBytes();

      final content = [
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', imageBytes.buffer.asUint8List()),
        ])
      ];

      generateContentApiResponse = ApiResponse.completed(
        await _generativeModel.generateContent(content),
      );
    } on Exception catch (e) {
      generateContentApiResponse = ApiResponse.error(e);
    }
  }
}
