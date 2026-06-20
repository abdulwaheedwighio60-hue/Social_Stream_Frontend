import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_stream/root_screen.dart';
import 'package:social_stream/src/services/post_provider.dart';
import 'package:social_stream/src/widgets/app_snack_bar.dart';

import '../../../constants/colors.dart';
import '../../../provider/user_detail_provider.dart';
import '../../../widgets/custom_text_form_field_widget.dart';

class PostUploadScreen extends StatefulWidget {
  const PostUploadScreen({super.key});

  @override
  State<PostUploadScreen> createState() =>
      _PostUploadScreenState();
}

class _PostUploadScreenState
    extends State<PostUploadScreen> {
  // =====================================
  // CONTROLLERS
  // =====================================

  final TextEditingController
  captionController =
  TextEditingController();

  final TextEditingController
  locationController =
  TextEditingController();

  // =====================================
  // IMAGE PICKER
  // =====================================

  final ImagePicker _picker =
  ImagePicker();

  // =====================================
  // MEDIA FILES
  // =====================================

  List<XFile> mediaFiles = [];

  // =====================================
  // TAGGED USERS
  // =====================================

  List<int> taggedPeople = [];

  // =====================================
  // PICK MEDIA
  // =====================================

  Future<void> pickMedia() async {
    final List<XFile> pickedFiles =
    await _picker.pickMultipleMedia();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        mediaFiles.addAll(pickedFiles);
      });
    }
  }

  // =====================================
  // REMOVE MEDIA
  // =====================================

  void removeMedia(int index) {
    setState(() {
      mediaFiles.removeAt(index);
    });
  }

  // =====================================
  // UPLOAD POST
  // =====================================

  Future<void> uploadPost() async {
    // Close keyboard before validation/upload.
    FocusManager.instance.primaryFocus?.unfocus();

    final postProvider = Provider.of<PostProvider>(
      context,
      listen: false,
    );

    final userProvider = Provider.of<UserDetailProvider>(
      context,
      listen: false,
    );

    final String caption = captionController.text.trim();
    final String location = locationController.text.trim();
    final String token = userProvider.user?.token?.trim() ?? '';

    // =========================================================
    // VALIDATE POST CONTENT
    // =========================================================

    if (caption.isEmpty && mediaFiles.isEmpty) {
      AppSnackBar.showWarning(
        context,
        message: 'Please add a caption or select media before posting.',
      );
      return;
    }

    // =========================================================
    // VALIDATE USER SESSION
    // =========================================================

    if (token.isEmpty) {
      AppSnackBar.showError(
        context,
        message: 'Your session has expired. Please log in again.',
      );
      return;
    }

    // =========================================================
    // CONVERT XFILE TO FILE
    // =========================================================

    final List<File> files = mediaFiles
        .where((media) => media.path.trim().isNotEmpty)
        .map((media) => File(media.path))
        .toList();

    try {
      // =======================================================
      // UPLOAD POST
      // =======================================================

      final bool success = await postProvider.uploadPost(
        token: token,
        caption: caption,
        addLocation: location,
        images: files,
        tagPeople: taggedPeople,
      );

      // BuildContext must not be used after await
      // without checking whether the widget is still mounted.
      if (!mounted) return;

      // =======================================================
      // HANDLE ERROR
      // =======================================================

      if (!success) {
        AppSnackBar.showError(
          context,
          message: postProvider.errorMessage?.trim().isNotEmpty == true
              ? postProvider.errorMessage!.trim()
              : 'Failed to upload post. Please try again.',
        );
        return;
      }

      // =======================================================
      // HANDLE SUCCESS
      // =======================================================

      AppSnackBar.showSuccess(
        context,
        message: 'Your post has been uploaded successfully.',
      );

      // Optional: clear form after successful upload.
      captionController.clear();
      locationController.clear();

      setState(() {
        mediaFiles.clear();
        taggedPeople.clear();
      });

      // Remove post creation screen from navigation stack.
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const RootScreen(),
        ),
            (route) => false,
      );
    } catch (error, stackTrace) {
      debugPrint('Upload post error: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      AppSnackBar.showError(
        context,
        message: 'Something went wrong while uploading your post.',
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final userDetailProvider =
    Provider.of<UserDetailProvider>(
      context,
    );

    final postProvider =
    Provider.of<PostProvider>(
      context,
    );

    return Scaffold(
      backgroundColor:
      const Color(0xffF7F7F7),

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
          const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 10,
          ),

          child: Column(
            children: [
              // =====================================
              // TOP BAR
              // =====================================

              Row(
                mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,

                children: [
                  // BACK BUTTON

                  // Container(
                  //   height: 40,
                  //   width: 40,
                  //
                  //   decoration:
                  //   BoxDecoration(
                  //     color: Colors.white,
                  //     shape:
                  //     BoxShape.circle,
                  //
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors
                  //             .black
                  //             .withOpacity(
                  //           0.04,
                  //         ),
                  //
                  //         blurRadius: 10,
                  //       ),
                  //     ],
                  //   ),
                  //
                  //   child: IconButton(
                  //     onPressed: () {
                  //       Navigator.pop(
                  //         context,
                  //       );
                  //     },
                  //
                  //     icon: const Icon(
                  //       Icons
                  //           .arrow_back_ios_new,
                  //
                  //       size: 18,
                  //
                  //       color:
                  //       AppColors
                  //           .darkGrey,
                  //     ),
                  //   ),
                  // ),

                  const Text(
                    "Create Post",

                    style: TextStyle(
                      fontSize: 18,

                      fontWeight:
                      FontWeight
                          .w700,
                    ),
                  ),

                  // =====================================
                  // POST BUTTON
                  // =====================================

                  GestureDetector(
                    onTap:
                    postProvider
                        .isLoading
                        ? null
                        : uploadPost,

                    child: postProvider
                        .isLoading
                        ? const SizedBox(
                      height: 22,
                      width: 22,

                      child:
                      CircularProgressIndicator(
                        strokeWidth:
                        2,
                      ),
                    )
                        : const Text(
                      "Post",

                      style:
                      TextStyle(
                        fontSize:
                        15,

                        fontWeight:
                        FontWeight
                            .w700,

                        color:
                        AppColors
                            .primary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 24,
              ),

              // =====================================
              // USER INFO
              // =====================================

              Row(
                children: [
                  CircleAvatar(
                    radius: 22,

                    backgroundImage:
                    NetworkImage(
                      "${userDetailProvider.user?.profileImage}",
                    ),
                  ),

                  const SizedBox(
                    width: 12,
                  ),

                  Text(
                    "${userDetailProvider.user?.userName}",

                    style: const TextStyle(
                      fontSize: 15,

                      fontWeight:
                      FontWeight
                          .w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),

              // =====================================
              // CAPTION FIELD
              // =====================================

              CustomTextFormFieldWidget(
                controller:
                captionController,

                hintText:
                "Write a caption...",

                maxLines: 6,

                minLines: 6,

                fillColor:
                Colors.white,

                borderRadius: 18,

                contentPadding:
                const EdgeInsets.all(
                  18,
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // =====================================
              // LOCATION FIELD
              // =====================================

              CustomTextFormFieldWidget(
                controller:
                locationController,

                hintText:
                "Add Location",

                fillColor:
                Colors.white,

                borderRadius: 18,

                contentPadding:
                const EdgeInsets.all(
                  18,
                ),

                prefixIcon:
                const Icon(
                  Iconsax.location,
                  color:
                  AppColors.primary,
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // =====================================
              // ADD MEDIA BUTTON
              // =====================================

              GestureDetector(
                onTap: pickMedia,

                child: Container(
                  height: 58,

                  padding:
                  const EdgeInsets
                      .symmetric(
                    horizontal: 16,
                  ),

                  decoration:
                  BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                    BorderRadius
                        .circular(
                      16,
                    ),
                  ),

                  child: const Row(
                    children: [
                      Icon(
                        Iconsax
                            .gallery_add,

                        color:
                        AppColors
                            .primary,
                      ),

                      SizedBox(
                        width: 12,
                      ),

                      Text(
                        "Add Photos & Videos",

                        style:
                        TextStyle(
                          fontSize:
                          15,

                          fontWeight:
                          FontWeight
                              .w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 18,
              ),

              // =====================================
              // MEDIA PREVIEW
              // =====================================

              if (mediaFiles.isNotEmpty)
                SizedBox(
                  height: 110,

                  child:
                  ListView.builder(
                    scrollDirection:
                    Axis.horizontal,

                    itemCount:
                    mediaFiles.length,

                    itemBuilder:
                        (
                        context,
                        index,
                        ) {
                      final file =
                      mediaFiles[
                      index];

                      final isVideo =
                      file.path
                          .toLowerCase()
                          .endsWith(
                        ".mp4",
                      );

                      return Stack(
                        children: [
                          Container(
                            width: 100,

                            margin:
                            const EdgeInsets
                                .only(
                              right: 12,
                            ),

                            decoration:
                            BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(
                                16,
                              ),
                            ),

                            child:
                            ClipRRect(
                              borderRadius:
                              BorderRadius.circular(
                                16,
                              ),

                              child:
                              isVideo
                                  ? Container(
                                color:
                                Colors.black,

                                child:
                                const Center(
                                  child:
                                  Icon(
                                    Icons.play_circle_fill,

                                    color:
                                    Colors.white,

                                    size:
                                    40,
                                  ),
                                ),
                              )
                                  : Image.file(
                                File(
                                  file.path,
                                ),

                                fit:
                                BoxFit.cover,
                              ),
                            ),
                          ),

                          Positioned(
                            top: 5,
                            right: 16,

                            child:
                            GestureDetector(
                              onTap: () {
                                removeMedia(
                                  index,
                                );
                              },

                              child:
                              Container(
                                padding:
                                const EdgeInsets.all(
                                  4,
                                ),

                                decoration:
                                const BoxDecoration(
                                  color:
                                  Colors.black,

                                  shape:
                                  BoxShape.circle,
                                ),

                                child:
                                const Icon(
                                  Icons.close,

                                  color:
                                  Colors.white,

                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

              const SizedBox(
                height: 22,
              ),

              // =====================================
              // TAG PEOPLE
              // =====================================

              _buildOptionTile(
                icon: Iconsax.user,

                title: "Tag People",

                subtitle:
                taggedPeople
                    .isEmpty
                    ? "No people tagged"
                    : "${taggedPeople.length} people tagged",

                onTap: () {
                  // OPEN TAG SCREEN
                },
              ),

              const SizedBox(
                height: 14,
              ),

              // =====================================
              // LOCATION TILE
              // =====================================

              _buildOptionTile(
                icon:
                Iconsax.location,

                title: "Location",

                subtitle:
                locationController
                    .text
                    .isEmpty
                    ? "No location added"
                    : locationController
                    .text,

                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================
  // OPTION TILE
  // =====================================

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding:
        const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
          BorderRadius.circular(
            16,
          ),
        ),

        child: Row(
          children: [
            Container(
              height: 34,
              width: 34,

              decoration: BoxDecoration(
                color: AppColors
                    .primary
                    .withOpacity(
                  0.12,
                ),

                shape:
                BoxShape.circle,
              ),

              child: Icon(
                icon,
                size: 18,

                color:
                AppColors.primary,
              ),
            ),

            const SizedBox(
              width: 14,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,

                children: [
                  Text(
                    title,

                    style:
                    TextStyle(
                      fontSize: 15,

                      fontWeight:
                      FontWeight
                          .w600,

                      color: AppColors
                          .primaryDark
                          .withOpacity(
                        0.9,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 4,
                  ),

                  Text(
                    subtitle,

                    style:
                    TextStyle(
                      fontSize: 13,

                      color: Colors
                          .grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios,

              size: 16,

              color: AppColors
                  .primary
                  .withOpacity(
                0.7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}