import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_stream/src/constants/colors.dart';
import 'package:social_stream/src/provider/user_detail_provider.dart';
import 'package:social_stream/src/services/post_provider.dart';

class EditPostScreen extends StatefulWidget {
  final int postId;

  final String initialCaption;
  final String initialLocation;

  final List<String> existingImages;

  const EditPostScreen({
    super.key,
    required this.postId,
    this.initialCaption = '',
    this.initialLocation = '',
    this.existingImages = const <String>[],
  });

  @override
  State<EditPostScreen> createState() =>
      _EditPostScreenState();
}

class _EditPostScreenState
    extends State<EditPostScreen> {
  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  final ImagePicker _imagePicker =
  ImagePicker();

  late final TextEditingController
  _captionController;

  late final TextEditingController
  _locationController;

  final List<XFile> _selectedImages =
  <XFile>[];

  bool _replaceExistingImages = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _captionController =
        TextEditingController(
          text: widget.initialCaption,
        );

    _locationController =
        TextEditingController(
          text: widget.initialLocation,
        );
  }

  @override
  void dispose() {
    _captionController.dispose();
    _locationController.dispose();

    super.dispose();
  }

  // =========================================================
  // PICK IMAGES
  // =========================================================

  Future<void> _pickImages() async {
    if (_isSaving) return;

    try {
      final List<XFile> selectedFiles =
      await _imagePicker.pickMultiImage(
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (selectedFiles.isEmpty || !mounted) {
        return;
      }

      setState(() {
        _selectedImages.addAll(
          selectedFiles.where(
                (XFile newImage) =>
            !_selectedImages.any(
                  (XFile oldImage) =>
              oldImage.path ==
                  newImage.path,
            ),
          ),
        );
      });
    } catch (error) {
      if (!mounted) return;

      _showMessage(
        'Images select nahi ho saken.',
        isError: true,
      );
    }
  }

  // =========================================================
  // REMOVE SELECTED IMAGE
  // =========================================================

  void _removeSelectedImage(int index) {
    if (_isSaving) return;

    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  // =========================================================
  // UPDATE POST
  // =========================================================

  // Future<void> _updatePost() async {
  //   if (_isSaving) return;
  //
  //   FocusScope.of(context).unfocus();
  //
  //   if (!(_formKey.currentState?.validate() ??
  //       false)) {
  //     return;
  //   }
  //
  //   /*
  //    * ReplaceImages true aur new images empty hon,
  //    * to backend existing images delete kar dega.
  //    */
  //
  //   if (_replaceExistingImages &&
  //       _selectedImages.isEmpty &&
  //       widget.existingImages.isNotEmpty) {
  //     final bool confirmed =
  //     await _confirmRemoveAllImages();
  //
  //     if (!confirmed || !mounted) {
  //       return;
  //     }
  //   }
  //
  //   final UserDetailProvider userProvider =
  //   context.read<UserDetailProvider>();
  //
  //   final String token =
  //       userProvider.user?.token?.trim() ??
  //           '';
  //
  //   if (token.isEmpty) {
  //     _showMessage(
  //       'Session expire ho gayi hai. Dobara login karein.',
  //       isError: true,
  //     );
  //
  //     return;
  //   }
  //
  //   setState(() {
  //     _isSaving = true;
  //   });
  //
  //   final PostProvider postProvider =
  //   context.read<PostProvider>();
  //
  //   final bool updated =
  //   await postProvider.updatePost(
  //     postId: widget.postId,
  //     token: token,
  //     caption:
  //     _captionController.text.trim(),
  //     addLocation:
  //     _locationController.text.trim(),
  //     images: _selectedImages
  //         .map(
  //           (XFile image) =>
  //           File(image.path),
  //     )
  //         .toList(),
  //     replaceImages:
  //     _replaceExistingImages,
  //     updateTagPeople: false,
  //     tagPeople: const <int>[],
  //   );
  //
  //   if (!mounted) return;
  //
  //   setState(() {
  //     _isSaving = false;
  //   });
  //
  //   if (!updated) {
  //     _showMessage(
  //       postProvider.errorMessage ??
  //           'Post update nahi ho saki.',
  //       isError: true,
  //     );
  //
  //     return;
  //   }
  //
  //   _showMessage(
  //     'Post successfully update ho gayi.',
  //   );
  //
  //   Navigator.of(context).pop(true);
  // }

  Future<bool> _confirmRemoveAllImages() async {
    final bool? result =
    await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(22),
          ),
          title: const Text(
            'Remove all images?',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          content: const Text(
            'Aapne replace images enable kiya hai '
                'lekin koi new image select nahi ki. '
                'Save karne par current images remove ho jayengi.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext)
                    .pop(false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext)
                    .pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                Colors.red.shade600,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Remove Images',
              ),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  void _showMessage(
      String message, {
        bool isError = false,
      }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError
              ? Colors.red.shade600
              : Colors.green.shade600,
          behavior:
          SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(14),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isSaving,
      child: Scaffold(
        backgroundColor:
        const Color(0xFFF6F7F9),
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          title: const Text(
            'Edit Post',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),
          leading: IconButton(
            onPressed: _isSaving
                ? null
                : () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black87,
              size: 20,
            ),
          ),
          actions: <Widget>[
            Padding(
              padding:
              const EdgeInsets.only(
                right: 12,
              ),
              child: TextButton(
                onPressed: (){},
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color:
                    AppColors.primary,
                    fontSize: 15,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics:
            const BouncingScrollPhysics(),
            padding:
            const EdgeInsets.fromLTRB(
              16,
              18,
              16,
              35,
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: <Widget>[
                _buildTextSection(),

                const SizedBox(height: 16),

                _buildImageSection(),

                const SizedBox(height: 24),

                _buildUpdateButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // TEXT SECTION
  // =========================================================

  Widget _buildTextSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: <Widget>[
          const Row(
            children: <Widget>[
              Icon(
                Icons.edit_note_rounded,
                color: AppColors.primary,
                size: 24,
              ),
              SizedBox(width: 9),
              Text(
                'Post Details',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          TextFormField(
            controller: _captionController,
            enabled: !_isSaving,
            maxLines: 6,
            minLines: 3,
            maxLength: 2000,
            textCapitalization:
            TextCapitalization.sentences,
            decoration: _inputDecoration(
              label: 'Caption',
              hint:
              'Apne post ke bare mein likhein...',
              icon: Icons.notes_rounded,
            ),
            validator: (String? value) {
              final String caption =
                  value?.trim() ?? '';

              if (caption.isEmpty &&
                  widget.existingImages.isEmpty &&
                  _selectedImages.isEmpty) {
                return 'Caption ya image required hai.';
              }

              return null;
            },
          ),

          const SizedBox(height: 14),

          TextFormField(
            controller: _locationController,
            enabled: !_isSaving,
            maxLength: 500,
            textCapitalization:
            TextCapitalization.words,
            decoration: _inputDecoration(
              label: 'Location',
              hint: 'Location add karein',
              icon:
              Icons.location_on_outlined,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // IMAGE SECTION
  // =========================================================

  Widget _buildImageSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Post Images',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Existing images rakhein ya new images add karein',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                onPressed:
                _isSaving
                    ? null
                    : _pickImages,
                tooltip: 'Add images',
                style: IconButton.styleFrom(
                  backgroundColor:
                  AppColors.primary
                      .withOpacity(0.10),
                ),
                icon: const Icon(
                  Icons.add_photo_alternate_outlined,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          if (widget
              .existingImages.isNotEmpty) ...[
            const SizedBox(height: 18),

            const Text(
              'Current images',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              height: 105,
              child: ListView.separated(
                scrollDirection:
                Axis.horizontal,
                itemCount: widget
                    .existingImages.length,
                separatorBuilder:
                    (_, __) =>
                const SizedBox(
                  width: 10,
                ),
                itemBuilder: (
                    BuildContext context,
                    int index,
                    ) {
                  return _buildNetworkImage(
                    widget.existingImages[index],
                  );
                },
              ),
            ),
          ],

          if (_selectedImages.isNotEmpty) ...[
            const SizedBox(height: 18),

            Row(
              children: <Widget>[
                const Expanded(
                  child: Text(
                    'New selected images',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 13,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  '${_selectedImages.length}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            SizedBox(
              height: 105,
              child: ListView.separated(
                scrollDirection:
                Axis.horizontal,
                itemCount:
                _selectedImages.length,
                separatorBuilder:
                    (_, __) =>
                const SizedBox(
                  width: 10,
                ),
                itemBuilder: (
                    BuildContext context,
                    int index,
                    ) {
                  return _buildLocalImage(
                    index,
                  );
                },
              ),
            ),
          ],

          const SizedBox(height: 18),

          Container(
            decoration: BoxDecoration(
              color:
              const Color(0xFFF7F8FA),
              borderRadius:
              BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey.shade200,
              ),
            ),
            child: SwitchListTile.adaptive(
              value:
              _replaceExistingImages,
              onChanged: _isSaving
                  ? null
                  : (bool value) {
                setState(() {
                  _replaceExistingImages =
                      value;
                });
              },
              activeColor:
              AppColors.primary,
              title: const Text(
                'Replace existing images',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
              subtitle: Text(
                _replaceExistingImages
                    ? 'Current images remove hokar selected images save hongi.'
                    : 'Selected images current images ke saath add hongi.',
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 11,
                ),
              ),
              secondary: Icon(
                _replaceExistingImages
                    ? Icons
                    .published_with_changes_rounded
                    : Icons
                    .add_photo_alternate_outlined,
                color: AppColors.primary,
              ),
            ),
          ),

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed:
              _isSaving
                  ? null
                  : _pickImages,
              style: OutlinedButton.styleFrom(
                foregroundColor:
                AppColors.primary,
                side: const BorderSide(
                  color: AppColors.primary,
                ),
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(15),
                ),
              ),
              icon: const Icon(
                Icons.photo_library_outlined,
              ),
              label: const Text(
                'Select Images',
                style: TextStyle(
                  fontWeight:
                  FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkImage(
      String imageUrl,
      ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 105,
        height: 105,
        color: Colors.grey.shade200,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (
              BuildContext context,
              Object error,
              StackTrace? stackTrace,
              ) {
            return const Icon(
              Icons.broken_image_outlined,
              color: Colors.black38,
              size: 32,
            );
          },
        ),
      ),
    );
  }

  Widget _buildLocalImage(int index) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        ClipRRect(
          borderRadius:
          BorderRadius.circular(15),
          child: Image.file(
            File(
              _selectedImages[index].path,
            ),
            width: 105,
            height: 105,
            fit: BoxFit.cover,
          ),
        ),

        Positioned(
          top: -6,
          right: -6,
          child: InkWell(
            onTap: () {
              _removeSelectedImage(index);
            },
            borderRadius:
            BorderRadius.circular(20),
            child: Container(
              width: 27,
              height: 27,
              decoration: BoxDecoration(
                color: Colors.red.shade600,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // UPDATE BUTTON
  // =========================================================

  Widget _buildUpdateButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: (){},
        // _isSaving ? null : _updatePost,
        style: ElevatedButton.styleFrom(
          backgroundColor:
          AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor:
          AppColors.primary
              .withOpacity(0.45),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(17),
          ),
        ),
        icon: _isSaving
            ? const SizedBox(
          width: 21,
          height: 21,
          child:
          CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : const Icon(
          Icons.check_circle_outline_rounded,
        ),
        label: Text(
          _isSaving
              ? 'Updating Post...'
              : 'Update Post',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(
        icon,
        color: AppColors.primary,
      ),
      filled: true,
      fillColor: const Color(0xFFF8F9FA),
      contentPadding:
      const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(15),
        borderSide: BorderSide(
          color: Colors.grey.shade200,
        ),
      ),
      focusedBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(
        color: Colors.black.withOpacity(0.05),
      ),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }
}