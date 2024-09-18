import 'dart:html';
import 'dart:async';

Future<String?> pickImageWeb() async {
  FileUploadInputElement uploadInput = FileUploadInputElement();
  uploadInput.accept = 'image/*';
  uploadInput.click();

  final completer = Completer<String?>();

  uploadInput.onChange.listen((e) {
    final files = uploadInput.files;
    if (files!.isNotEmpty) {
      final reader = FileReader();
      reader.readAsDataUrl(files[0]);

      reader.onLoadEnd.listen((e) {
        completer.complete(reader.result as String?);
      });
    }
  });

  return completer.future;
}
