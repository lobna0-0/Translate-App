import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:translate/tranlate_service.dart';

class TranslatePage extends StatelessWidget {
  final textController = TextEditingController();
  final toLang = 'ar'.obs;
  final fromLang = 'en'.obs;
  final translatedText = ''.obs;
  final allMatches = <String>[].obs;
  final similarWords = <String>[].obs;
  final translateService = TranslateService();

  final languages = const [
    DropdownMenuEntry(value: 'en', label: 'English'),
    DropdownMenuEntry(value: 'ar', label: 'Arabic'),
    DropdownMenuEntry(value: 'fr', label: 'French'),
    DropdownMenuEntry(value: 'es', label: 'Spanish'),
    DropdownMenuEntry(value: 'it', label: 'Italian'),
    DropdownMenuEntry(value: 'de', label: 'German'),
  ];

  TranslatePage({super.key});

  Future<String> detectLanguage(String text) async {
    final t = text.trim();
    if (t.isEmpty) return 'en';

    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    if (arabicRegex.hasMatch(t)) return 'ar';

    final accentedLatin = RegExp(r'[àâæçéèêëîïôœùûüÿñáéíóú]');
    if (accentedLatin.hasMatch(t)) return 'fr';
    return 'en';
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.deepPurple;
    final secondaryColor = Colors.deepPurple.shade100;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Translate App',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 6,
        shadowColor: Colors.black45,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Input Field
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 3),
                        blurRadius: 6)
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: TextField(
                  controller: textController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Enter text to translate...',
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 24.0),

              // Dropdowns Row
              Row(
                children: [
                  Expanded(
                    child: Obx(() => DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'From',
                            labelStyle:
                                TextStyle(color: primaryColor, fontSize: 16),
                            filled: true,
                            fillColor: secondaryColor.withOpacity(0.3),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          value: fromLang.value,
                          items: languages
                              .map((lang) => DropdownMenuItem(
                                  value: lang.value, child: Text(lang.label)))
                              .toList(),
                          onChanged: (val) => fromLang.value = val ?? 'auto',
                        )),
                  ),
                  const SizedBox(width: 12.0),
                  const Icon(Icons.compare_arrows,
                      color: Colors.deepPurple, size: 28),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Obx(() => DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'To',
                            labelStyle:
                                TextStyle(color: primaryColor, fontSize: 16),
                            filled: true,
                            fillColor: secondaryColor.withOpacity(0.3),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          value: toLang.value,
                          items: languages
                              .map((lang) => DropdownMenuItem(
                                  value: lang.value, child: Text(lang.label)))
                              .toList(),
                          onChanged: (val) => toLang.value = val ?? 'ar',
                        )),
                  ),
                ],
              ),

              const SizedBox(height: 30.0),

              // Translate Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 4,
                ),
                onPressed: () async {
                  final text = textController.text.trim();
                  if (text.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'Please enter text to translate',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  final detectedLang = await detectLanguage(text);
                  fromLang.value = detectedLang;

                  if (detectedLang == toLang.value) {
                    Get.snackbar(
                      'Error',
                      'The word is already in ${toLang.value.toUpperCase()}',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.orangeAccent,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  final result = await translateService.translate(
                    text,
                    detectedLang,
                    toLang.value,
                  );

                  final similars = translateService.getSimilarWords(text);
                  similarWords.assignAll(similars);

                  if (result != null) {
                    translatedText.value = result['main'] ?? '';
                    allMatches.assignAll(result['matches'] ?? []);
                  } else {
                    translatedText.value = 'Translation failed';
                    allMatches.clear();
                  }
                },
                icon: const Icon(Icons.translate, color: Colors.white),
                label: const Text(
                  'Translate',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 30.0),

              // Result Card
              Obx(() => AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, 4),
                            blurRadius: 8)
                      ],
                    ),
                    child: Text(
                      translatedText.value.isEmpty
                          ? 'Translation will appear here'
                          : translatedText.value,
                      style: TextStyle(
                        fontSize: 18,
                        color: translatedText.value.isEmpty
                            ? Colors.grey
                            : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )),

              const SizedBox(height: 24.0),

              // Other Matches
              Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (allMatches.isNotEmpty)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(
                            'Other Matches:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ...allMatches.map((m) => Card(
                            color: Colors.white,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                m,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          )),
                    ],
                  )),

              const SizedBox(height: 24.0),

              Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (similarWords.isNotEmpty)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(
                            'Similar Words:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ...similarWords.map((s) => Card(
                            color: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                s,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          )),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
