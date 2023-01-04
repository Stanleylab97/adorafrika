import 'dart:io';

import 'package:adorafrika/services/permission_management.dart';
import 'package:adorafrika/services/storage_management.dart';
import 'package:adorafrika/services/toast_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecordAudioProvider extends ChangeNotifier {
  final Record _record = Record();
  bool _isRecording = false;
  String _afterRecordingFilePath = '';
  String _pickedVideoFilename = "";
  bool get isRecording => _isRecording;
  String get pickedVideoFilename => _pickedVideoFilename;
  String get recordedFilePath => _afterRecordingFilePath;

  clearOldData() async {
    final prefs = await SharedPreferences.getInstance();
    _afterRecordingFilePath = '';
    _pickedVideoFilename = "";
    await prefs.setString("panegyrique_path", "");

    notifyListeners();
  }

  recordWithCamera() {}

  recordVoice() async {
    final _isPermitted = (await PermissionManagement.recordingPermission()) &&
        (await PermissionManagement.storagePermission());

    if (!_isPermitted) return;

    if (!(await _record.hasPermission())) return;

    final _voiceDirPath = await StorageManagement.getAudioDir;
    final _voiceFilePath = StorageManagement.createRecordAudioPath(
        dirPath: _voiceDirPath, fileName: 'audio_message');

    await _record.start(path: _voiceFilePath);
    _isRecording = true;
    notifyListeners();

    showToast('Recording Started');
  }

  pickAudioFile() async {
    final prefs = await SharedPreferences.getInstance();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['mp3', 'aac', 'wav, m4a'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      _afterRecordingFilePath = file.path;
      _isRecording = false;
      showToast('File selected');
      notifyListeners();
    } else {
      // User canceled the picker
      return;
    }
    // if no file is picked
    if (result == null) return;
    // first picked file (if multiple are selected)
    await prefs.setString('panegyrique_path', _afterRecordingFilePath);
    notifyListeners();
  }

  pickVideoFile() async {
    final prefs = await SharedPreferences.getInstance();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['mp4'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      _afterRecordingFilePath = file.path;
      _isRecording = false;
      _pickedVideoFilename = result.files.first.name;
      showToast('Video file selected');
      notifyListeners();
    } else {
      // User canceled the picker
      return;
    }
    // if no file is picked
    if (result == null) return;
    // first picked file (if multiple are selected)
    await prefs.setString('panegyrique_path', _afterRecordingFilePath);
    notifyListeners();
  }

  stopRecording() async {
    String? _audioFilePath;
    final prefs = await SharedPreferences.getInstance();
    if (await _record.isRecording()) {
      _audioFilePath = await _record.stop();

      showToast('Recording Stopped');
    }

    print('Audio file path: $_audioFilePath');

    _isRecording = false;
    _afterRecordingFilePath = _audioFilePath ?? '';
    await prefs.setString('panegyrique_path', _afterRecordingFilePath);
    notifyListeners();
  }
}
