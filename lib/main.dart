import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_cloud_translation/google_cloud_translation.dart';

void main() => runApp(WordListApp());

Future<List<String>> loadWordList() async {
  String jsonString = await rootBundle.loadString('assets/words.json');
  List<dynamic> jsonList = json.decode(jsonString);
  List<String> wordList = List<String>.from(jsonList);
  return wordList;
}

class WordListApp extends StatefulWidget {
  @override
  _WordListAppState createState() => _WordListAppState();
}

class _WordListAppState extends State<WordListApp> {
  TranslationModel _translated = TranslationModel(translatedText: '', detectedSourceLanguage: '');
  late Translation _translation;
  List<String> words = [];
  String randomWord = '';
  String _text = 'hello';

  @override
  void initState() {
    super.initState();
    loadWordList().then((loadedWords) {
      setState(() {
        words = loadedWords;
      });
    });

    _translation = Translation(
        apiKey: 'AIzaSyDhYeWoKAxbJ4xUsooQ3MHbiwM0XCE1RCM'
    );
  }

  void shuffleWordList() {
    setState(() {
      words.shuffle();
      randomWord = words.isNotEmpty ? words.first : '';
    });
  }


  @override
  MaterialApp build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Vocabulary Trainer'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 16.0),
              Text(
                _translated.translatedText,
                style: TextStyle(fontSize: 24.0),
              ),
              SizedBox(height: 16.0),
              Text(
                randomWord,
                style: TextStyle(fontSize: 24.0),
              ),
              ElevatedButton(
                onPressed: () async {
                  shuffleWordList();
                  _text = randomWord;
                  _translated = await _translation.translate(text: _text, to: 'ja');
                  setState(() {});
                },
                child: Text('roll'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}