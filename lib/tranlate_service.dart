import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'lang.dart';

class TranslateService {
  // Create an instance of Dio for HTTP requests
  final dio = Dio();
  // Main translation function
  Future<Map<String, dynamic>?> translate(String text, String from, String to) async {
    try {
      // Open the Hive box where translations are stored (local cache)
      final box = Hive.box('translationsbox'); 
      // Create a unique key for caching this translation
      // Example: "hello-en-ar"
      final cacheKey = '$text-$from-$to'; 
      // Check if translation exists in cache
      if (box.containsKey(cacheKey)) {
        final saved = box.get(cacheKey);
        print('Loaded from Hive cache');
        return {
          'main': saved['translated'],              // The main translated text
          'matches': List<String>.from(saved['matches']), // A list of alternative translations
        };
      }
      // If not cached → Fetch from API
      final apiUrl = 'https://api.mymemory.translated.net/get?q=$text&langpair=$from|$to';
      final resp = await dio.get(apiUrl); // Send GET request
      // Handle API response
      if (resp.statusCode == 200) {
        // Parse response JSON into Lang model
        final data = Lang.fromJson(resp.data);
        // Extract all possible matches (alternative translations)
        final matches = (resp.data['matches'] as List)
            .map((e) => e['translation'].toString())
            .toList();
        // Save translation in Hive cache
        await box.put(cacheKey, {
          'translated': data.responseData?.translatedText ?? '',
          'matches': matches,
        });
        // Return the translation result
        return {
          'main': data.responseData?.translatedText, // Main translated text
          'matches': matches,                        // List of matches
        };
      } else {
        // Handle non-success status codes (e.g., 404, 500)
        print('Error: ${resp.statusCode}');
        return null;
      }
    } catch (e) {
      // Catch any exception: network, parsing, Hive, etc.
      print('Error: $e');
      return null;
    }
  }
  // Function to find similar words from cache (auto-suggestions)
  List<String> getSimilarWords(String word) {
    // Open the same Hive box
    final box = Hive.box('translationsbox');
    // Prepare the search query in lowercase and trimmed
    final query = word.toLowerCase().trim();
    // Use a Set to avoid duplicate words
    final similar = <String>{};
    // Loop through all cache keys
    for (var key in box.keys) {
      // Ensure the key is a String and starts with the query
      if (key is String && key.toLowerCase().contains(query)) {
        // Keys are stored like "hello-en-ar" → we extract "hello"
        final parts = key.split('-');
        if (parts.isNotEmpty) similar.add(parts.first);
      }
    }
    // Convert Set → List and sort alphabetically
    final list = similar.toList();
    list.sort();
    // Return the final list of similar words
    return list;
  }
}
