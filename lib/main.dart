import 'package:flutter/material.dart';
import 'package:flutterative_story_ai/view/screen/generate_story_screen.dart';
import 'package:flutterative_story_ai/view_model/generative_ai_view_model.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GenerativeAIViewModel(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.dark,
            seedColor: const Color(0xFFA0BCF6),
          ),
          useMaterial3: true,
        ),
        home: const GenerateStoryScreen(),
      ),
    );
  }
}
