import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'lang.dart';

class TranslateService {
  final dio = Dio();

  Future<Map<String, dynamic>?> translate(String text, String from, String to) async {
    try {
      final box = Hive.box('translationsbox'); 
      final cacheKey = '$text-$from-$to'; 
      // Check cache first
      if (box.containsKey(cacheKey)) {
        final saved = box.get(cacheKey);
        print('Loaded from Hive cache');
        return {
          'main': saved['translated'],
          'matches': List<String>.from(saved['matches']),
        };
      }

      //Fetch from API
      final apiUrl = 'https://api.mymemory.translated.net/get?q=$text&langpair=$from|$to';
      final resp = await dio.get(apiUrl);

      if (resp.statusCode == 200) {
        final data = Lang.fromJson(resp.data);

        //Extract matches
        final matches = (resp.data['matches'] as List)
            .map((e) => e['translation'].toString())
            .toList();

        //Save in cache
        await box.put(cacheKey, {
          'translated': data.responseData?.translatedText ?? '',
          'matches': matches,
        });

        return {
          'main': data.responseData?.translatedText,
          'matches': matches,
        };
      } else {
        print('Error: ${resp.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
    List<String> getSimilarWords(String word) {
    final box = Hive.box('translationsbox');
    final query = word.toLowerCase().trim();
    final similar = <String>{};
    for (var key in box.keys) {
      if (key is String && key.toLowerCase().startsWith(query)) {
        final parts = key.split('-');
        if (parts.isNotEmpty) similar.add(parts.first);
      }
    }
    final list = similar.toList();
    list.sort();
    return list;
  }
}
