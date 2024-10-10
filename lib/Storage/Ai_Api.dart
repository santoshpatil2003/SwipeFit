// import 'dart:io';
// import 'dart:typed_data';

// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';

// class TryOnApiClient {
//   final String baseUrl;
//   final FirebaseStorage storage;

//   TryOnApiClient(this.baseUrl) : storage = FirebaseStorage.instance;

//   Future<void> uploadImages(File humanImage, String garmentImagePath) async {
//     // Download garment image from Firebase Cloud Storage
//     final ref = storage.ref(garmentImagePath);
//     final Directory tempDir = await getTemporaryDirectory();
//     final File tempGarmentImage =
//         File('${tempDir.path}/temp_garment_image.jpg');

//     try {
//       await ref.writeToFile(tempGarmentImage);
//     } catch (e) {
//       throw Exception('Failed to download garment image: $e');
//     }

//     // Prepare the multipart request
//     var request =
//         http.MultipartRequest('POST', Uri.parse('$baseUrl/upload_images/'));

//     // Add human image
//     request.files
//         .add(await http.MultipartFile.fromPath('human_image', humanImage.path));

//     // Add garment image
//     request.files.add(await http.MultipartFile.fromPath(
//         'garment_image', tempGarmentImage.path));

//     // Send the request
//     var response = await request.send();

//     // Delete the temporary file
//     await tempGarmentImage.delete();

//     if (response.statusCode != 200) {
//       throw Exception('Failed to upload images');
//     }
//   }

//   Future<void> runTryOn({
//     required String garmentDes,
//     required bool isChecked,
//     required bool isCheckedCrop,
//     required int denoiseSteps,
//     required int seed,
//   }) async {
//     var response = await http.post(
//       Uri.parse('$baseUrl/run_tryon/'),
//       body: {
//         'garment_des': garmentDes,
//         'is_checked': isChecked.toString(),
//         'is_checked_crop': isCheckedCrop.toString(),
//         'denoise_steps': denoiseSteps.toString(),
//         'seed': seed.toString(),
//       },
//     );
//     if (response.statusCode != 200) {
//       throw Exception('Failed to run try-on');
//     }
//   }

//   Future<Uint8List> getOutputImage() async {
//     var response = await http.get(Uri.parse('$baseUrl/get_output_image/'));
//     if (response.statusCode == 200) {
//       return response.bodyBytes;
//     } else {
//       throw Exception('Failed to get output image');
//     }
//   }

//   Future<Uint8List> getMaskedImage() async {
//     var response = await http.get(Uri.parse('$baseUrl/get_masked_image/'));
//     if (response.statusCode == 200) {
//       return response.bodyBytes;
//     } else {
//       throw Exception('Failed to get masked image');
//     }
//   }
// }

import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class TryOnApiClient {
  final String baseUrl;

  TryOnApiClient(this.baseUrl);

  // Future<void> uploadImages(File humanImage, String garmentImageUrl) async {
  //   // Download garment image from URL
  //   final http.Response garmentResponse =
  //       await http.get(Uri.parse(garmentImageUrl));
  //   final Directory tempDir = await getTemporaryDirectory();
  //   final File tempGarmentImage =
  //       File('${tempDir.path}/temp_garment_image.jpg');
  //   await tempGarmentImage.writeAsBytes(garmentResponse.bodyBytes);

  //   var request =
  //       http.MultipartRequest('POST', Uri.parse('$baseUrl/upload_images/'));
  //   request.files
  //       .add(await http.MultipartFile.fromPath('human_image', humanImage.path));
  //   request.files.add(await http.MultipartFile.fromPath(
  //       'garment_image', tempGarmentImage.path));

  //   var response = await request.send();
  //   await tempGarmentImage.delete();

  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to upload images');
  //   }
  // }

  Future<void> uploadImages(File humanImage, String garmentImageUrl) async {
    try {
      print('Downloading garment image from: $garmentImageUrl');
      final http.Response garmentResponse =
          await http.get(Uri.parse(garmentImageUrl));

      if (garmentResponse.statusCode != 200) {
        throw Exception(
            'Failed to download garment image. Status: ${garmentResponse.statusCode}');
      }

      print('Garment image downloaded successfully');

      final Directory tempDir = await getTemporaryDirectory();
      final File tempGarmentImage =
          File('${tempDir.path}/temp_garment_image.jpg');
      await tempGarmentImage.writeAsBytes(garmentResponse.bodyBytes);

      print('Temporary garment image created at: ${tempGarmentImage.path}');

      var request =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/upload_images/'));
      print('baseurl:    ${baseUrl}');

      print('Adding human image from: ${humanImage.path}');
      request.files.add(
          await http.MultipartFile.fromPath('human_image', humanImage.path));

      print('Adding garment image from: ${tempGarmentImage.path}');
      request.files.add(await http.MultipartFile.fromPath(
          'garment_image', tempGarmentImage.path));

      print('Sending request to: ${request.url}');
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('Response received. Status: ${response.statusCode}');
      print('Response body: ${response.body}');

      await tempGarmentImage.delete();

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to upload images. Status: ${response.statusCode}, Body: ${response.body}');
      }

      print('Images uploaded successfully');
    } catch (e) {
      print('Error in uploadImages: $e');
      throw Exception('Failed to upload images: $e');
    }
  }

  Future<void> runTryOn({
    required String garmentDes,
    required bool isChecked,
    required bool isCheckedCrop,
    required int denoiseSteps,
    required int seed,
  }) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/run_tryon/'),
        body: {
          'garment_des': garmentDes,
          'is_checked': isChecked.toString(),
          'is_checked_crop': isCheckedCrop.toString(),
          'denoise_steps': denoiseSteps.toString(),
          'seed': seed.toString(),
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to run try-on. Status: ${response.statusCode}, Body: ${response.body}');
      }

      print('Try-on completed successfully');
    } catch (e) {
      print('Error in runTryOn: $e');
      throw Exception('Failed to run try-on: $e');
    }
  }

  Future<File> getOutputImage() async {
    var response = await http.get(Uri.parse('$baseUrl/get_output_image/'));
    if (response.statusCode == 200) {
      final Directory tempDir = await getTemporaryDirectory();
      final File file = File('${tempDir.path}/output_image.png');
      await file.writeAsBytes(response.bodyBytes);
      return file;
    } else {
      throw Exception('Failed to get output image');
    }
  }

  Future<File> getMaskedImage() async {
    var response = await http.get(Uri.parse('$baseUrl/get_masked_image/'));
    if (response.statusCode == 200) {
      final Directory tempDir = await getTemporaryDirectory();
      final File file = File('${tempDir.path}/masked_image.png');
      await file.writeAsBytes(response.bodyBytes);
      return file;
    } else {
      throw Exception('Failed to get masked image');
    }
  }

  // Future<Uint8List> getOutputImage() async {
  //   var response = await http.get(Uri.parse('$baseUrl/get_output_image/'));
  //   if (response.statusCode == 200) {
  //     return response.bodyBytes;
  //   } else {
  //     throw Exception('Failed to get output image');
  //   }
  // }

  // Future<Uint8List> getMaskedImage() async {
  //   var response = await http.get(Uri.parse('$baseUrl/get_masked_image/'));
  //   if (response.statusCode == 200) {
  //     return response.bodyBytes;
  //   } else {
  //     throw Exception('Failed to get masked image');
  //   }
  // }
}
