import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

enum EditFeature { addObject, removeObject, removeBackground }

final promptEditProvider = StateNotifierProvider<PromptEditNotifier, PromptEditState>((ref) {
  return PromptEditNotifier();
});

class PromptEditState {
  final EditFeature activeFeature;
  final XFile? uploadedImageFile;
  final bool showUndoRedo;

  PromptEditState({
    this.activeFeature = EditFeature.addObject,
    this.uploadedImageFile,
    this.showUndoRedo = false,
  });

  PromptEditState copyWith({
    EditFeature? activeFeature,
    XFile? uploadedImageFile,
    bool? showUndoRedo,
  }) {
    return PromptEditState(
      activeFeature: activeFeature ?? this.activeFeature,
      uploadedImageFile: uploadedImageFile ?? this.uploadedImageFile,
      showUndoRedo: showUndoRedo ?? this.showUndoRedo,
    );
  }
}

class PromptEditNotifier extends StateNotifier<PromptEditState> {
  PromptEditNotifier() : super(PromptEditState());
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        state = state.copyWith(uploadedImageFile: image);
      }
    } catch (e) {
      debugPrint('Image picker error: $e');
    }
  }

  void setActiveFeature(EditFeature feature) {
    state = state.copyWith(
      activeFeature: feature,
      showUndoRedo: feature == EditFeature.removeBackground,
    );
  }

  void removeImage() {
    print('Removing image...'); // Debug
    state = PromptEditState(
      uploadedImageFile: null,
      activeFeature: state.activeFeature,
      showUndoRedo: state.showUndoRedo,
    );
    print('Image should be removed now'); // Debug
  }

  void undo() {
    // Implement undo functionality
  }

  void redo() {
    // Implement redo functionality
  }
}