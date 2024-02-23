import 'package:flutter/material.dart';
import 'package:flutterative_story_ai/api/api_response.dart';
import 'package:flutterative_story_ai/constants/asset_path_constants.dart';
import 'package:flutterative_story_ai/view/widget/story_content_widget.dart';
import 'package:flutterative_story_ai/view_model/generative_ai_view_model.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class GenerateStoryScreen extends StatefulWidget {
  const GenerateStoryScreen({super.key});

  @override
  State<GenerateStoryScreen> createState() => _GenerateStoryScreenState();
}

class _GenerateStoryScreenState extends State<GenerateStoryScreen> {
  @override
  Widget build(BuildContext context) {
    final apiResponse = context
        .select<GenerativeAIViewModel, ApiResponse<GenerateContentResponse>>(
            (value) => value.generateContentApiResponse);
    return Scaffold(
      floatingActionButton: _fab(context, apiResponse),
      appBar: AppBar(
        title: const Text("Flutterative Story AI"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _getWidget(apiResponse),
      ),
    );
  }

  SizedBox _fab(
    BuildContext context,
    ApiResponse<GenerateContentResponse> apiResponse,
  ) {
    return SizedBox(
      height: 120,
      child: Column(
        children: [
          Lottie.asset(
            AssetPathConstants.arrowAnimation,
            height: 70,
          ),
          Expanded(
            child: FloatingActionButton.extended(
              onPressed: () =>
                  context.read<GenerativeAIViewModel>().generateContent(),
              label: apiResponse.status == Status.loading
                  ? const CircularProgressIndicator.adaptive()
                  : const Text("Select image"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getWidget(ApiResponse<GenerateContentResponse> apiResponse) {
    switch (apiResponse.status) {
      case Status.loading:
        return _generatingTextWidget();
      case Status.completed:
        if (apiResponse.data?.text?.isNotEmpty == true) {
          return _storyWidget(apiResponse.data!.text!);
        }
        return _errorWidget();
      case Status.error:
        return _errorWidget();
      default:
        return _emptyWidget(context);
    }
  }

  Center _generatingTextWidget() {
    return Center(
        child: Text(
      "Generating Story...",
      style: Theme.of(context).textTheme.bodyLarge,
    ));
  }

  Center _errorWidget() {
    return Center(
      child: Text(
        "Error occurred",
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  Column _emptyWidget(BuildContext context) {
    return Column(
      children: [
        ImageSkeleton(
          child: _emptyImageContainer(),
        ),
        Lottie.asset(
          AssetPathConstants.aiAnimation,
          height: MediaQuery.of(context).size.height * 0.4,
        ),
      ],
    );
  }

  Container _emptyImageContainer() {
    return Container(
      color: Colors.grey.shade800,
      height: MediaQuery.of(context).size.height * 0.3,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.image_search_rounded,
              size: 56,
            ),
            const SizedBox(height: 12),
            Text(
              "Select an image to create a story",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _storyWidget(String text) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ImageSkeleton(
            child: context.read<GenerativeAIViewModel>().selectedImage == null
                ? _emptyImageContainer()
                : _fileImageWidget(),
          ),
          const SizedBox(height: 24),
          StoryContentWidget(text: text),
          const SizedBox(height: 150),
        ],
      ),
    );
  }

  Image _fileImageWidget() {
    return Image.file(
      context.read<GenerativeAIViewModel>().selectedImage!,
      height: MediaQuery.of(context).size.height * 0.3,
      fit: BoxFit.cover,
    );
  }
}

class ImageSkeleton extends StatelessWidget {
  const ImageSkeleton({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(18),
      ),
      child: child,
    );
  }
}
