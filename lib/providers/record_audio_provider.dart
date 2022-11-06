import 'package:adorafrika/services/permission_management.dart';
import 'package:adorafrika/services/storage_management.dart';
import 'package:adorafrika/services/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecordAudioProvider extends ChangeNotifier{
  final Record _record = Record();
  bool _isRecording = false;
  String _afterRecordingFilePath = '';

  bool get isRecording => _isRecording;
  String get recordedFilePath => _afterRecordingFilePath;

  clearOldData(){
    _afterRecordingFilePath = '';
    notifyListeners();
  }

  recordVoice()async{
    final _isPermitted = (await PermissionManagement.recordingPermission()) && (await PermissionManagement.storagePermission());

    if(!_isPermitted) return;

    if(!(await _record.hasPermission())) return;

    final _voiceDirPath = await StorageManagement.getAudioDir;
    final _voiceFilePath = StorageManagement.createRecordAudioPath(dirPath: _voiceDirPath, fileName: 'audio_message');

    await _record.start(path: _voiceFilePath);
    _isRecording = true;
    notifyListeners();

    showToast('Recording Started');
  }

  stopRecording()async{
    String? _audioFilePath;
    final prefs = await SharedPreferences.getInstance();
    if(await _record.isRecording()){
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