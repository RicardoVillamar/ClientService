import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CloudinaryService {
  static final _instance = CloudinaryService._internal();
  final Cloudinary cloudinary;
  final String cloudApi =
      dotenv.env['CLOUDINARY_API_URL'] ?? 'https://api.cloudinary.com/v1_1/';
  final String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';

  factory CloudinaryService() {
    return _instance;
  }

  CloudinaryService._internal()
      : cloudinary = Cloudinary.fromStringUrl(
          dotenv.env['CLOUDINARY_URL'] ?? '',
        );

  /// Uploads an image to Cloudinary and returns the URL.
  Future<String> uploadImage(File image) async {
    final response = await http.post(
      Uri.parse("$cloudApi$cloudName/image/upload"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'file':
            'data:image/jpeg;base64,${base64Encode(image.readAsBytesSync())}',
        'upload_preset': dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? '',
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['secure_url'] as String;
    } else {
      throw Exception('Failed to upload image: ${response.body}');
    }
  }
}
