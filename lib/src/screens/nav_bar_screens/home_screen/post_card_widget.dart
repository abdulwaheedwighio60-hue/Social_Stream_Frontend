import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:social_stream/src/constants/colors.dart';
import 'package:social_stream/src/models/like_model.dart';
import 'package:social_stream/src/provider/user_detail_provider.dart';
import 'package:social_stream/src/services/like_provider.dart';
import 'package:social_stream/src/widgets/app_snack_bar.dart';

class PostCardWidget extends StatefulWidget {
  final int postId;

  final String userName;
  final String userUsername;
  final String userImage;

  final String caption;
  final String location;

  final List<String> postImages;

  final int likes;
  final String comments;
  final String shares;

  final bool isVerified;
  final bool isLiked;
  final bool isBookmarked;

  // Post current logged-in user ki hai ya nahi.
  final bool isPostOwner;

  // Non-owner post ke extra options ke liye.
  final VoidCallback? onMoreTap;

  // Owner options.
  final Future<void> Function()? onEditPost;
  final Future<void> Function()? onDeletePost;

  final void Function(
      bool isLiked,
      int likeCount,
      )? onLikeChanged;

  final VoidCallback? onCommentTap;
  final VoidCallback? onShareTap;
  final VoidCallback? onBookmarkTap;

  const PostCardWidget({
    super.key,
    required this.postId,
    required this.userName,
    required this.userUsername,
    required this.userImage,
    required this.postImages,
    this.caption = '',
    this.location = '',
    this.likes = 0,
    this.comments = '0',
    this.shares = '0',
    this.isVerified = true,
    this.isLiked = false,
    this.isBookmarked = false,
    this.isPostOwner = false,
    this.onMoreTap,
    this.onEditPost,
    this.onDeletePost,
    this.onLikeChanged,
    this.onCommentTap,
    this.onShareTap,
    this.onBookmarkTap,
  });

  @override
  State<PostCardWidget> createState() =>
      _PostCardWidgetState();
}

class _PostCardWidgetState extends State<PostCardWidget> {
  late final PageController _pageController;

  late bool _isLiked;
  late bool _isBookmarked;
  late int _likeCount;

  bool _isDeleting = false;
  bool _isEditing = false;

  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    _isLiked = widget.isLiked;
    _isBookmarked = widget.isBookmarked;
    _likeCount = widget.likes;
  }

  @override
  void didUpdateWidget(
      covariant PostCardWidget oldWidget,
      ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isLiked != widget.isLiked) {
      _isLiked = widget.isLiked;
    }

    if (oldWidget.likes != widget.likes) {
      _likeCount = widget.likes;
    }

    if (oldWidget.isBookmarked !=
        widget.isBookmarked) {
      _isBookmarked = widget.isBookmarked;
    }

    if (widget.postImages.isEmpty) {
      _currentImageIndex = 0;
    } else if (_currentImageIndex >=
        widget.postImages.length) {
      _currentImageIndex = 0;

      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // =========================================================
  // MORE OPTIONS
  // =========================================================

  void _handleMoreTap() {
    if (_isDeleting || _isEditing) {
      return;
    }

    final bool hasOwnerOptions =
        widget.onEditPost != null ||
            widget.onDeletePost != null;

    if (widget.isPostOwner && hasOwnerOptions) {
      _showPostOptionsBottomSheet();
      return;
    }

    widget.onMoreTap?.call();
  }

  Future<void> _showPostOptionsBottomSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) {
        return Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.fromLTRB(
            16,
            10,
            16,
            18,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 25,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 42,
                  height: 5,
                  margin: const EdgeInsets.only(
                    bottom: 18,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                Row(
                  children: <Widget>[
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.tune_rounded,
                        color: AppColors.primary,
                        size: 23,
                      ),
                    ),

                    const SizedBox(width: 12),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Post options',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Manage your post',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        Navigator.of(sheetContext).pop();
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                if (widget.onEditPost != null)
                  _buildPostOptionTile(
                    icon: Icons.edit_outlined,
                    iconBackgroundColor:
                    AppColors.primary.withOpacity(0.10),
                    iconColor: AppColors.primary,
                    title: 'Edit post',
                    subtitle:
                    'Update caption, location or images',
                    onTap: () {
                      Navigator.of(sheetContext).pop();

                      Future<void>.delayed(
                        const Duration(milliseconds: 180),
                        _handleEditPost,
                      );
                    },
                  ),

                if (widget.onEditPost != null &&
                    widget.onDeletePost != null)
                  const SizedBox(height: 10),

                if (widget.onDeletePost != null)
                  _buildPostOptionTile(
                    icon: Icons.delete_outline_rounded,
                    iconBackgroundColor:
                    Colors.red.withOpacity(0.09),
                    iconColor: Colors.red.shade600,
                    title: 'Delete post',
                    subtitle:
                    'Permanently remove this post',
                    titleColor: Colors.red.shade700,
                    onTap: () {
                      Navigator.of(sheetContext).pop();

                      Future<void>.delayed(
                        const Duration(milliseconds: 180),
                        _handleDeletePost,
                      );
                    },
                  ),

                const SizedBox(height: 14),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(sheetContext).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      side: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPostOptionTile({
    required IconData icon,
    required Color iconBackgroundColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color titleColor = Colors.black87,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade200,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 23,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey.shade400,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // EDIT POST
  // =========================================================

  Future<void> _handleEditPost() async {
    if (widget.onEditPost == null || _isEditing) {
      return;
    }

    setState(() {
      _isEditing = true;
    });

    try {
      await widget.onEditPost!.call();
    } catch (error) {
      if (!mounted) return;

      AppSnackBar.showError(
        context,
        message: 'Failed to open post editing.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isEditing = false;
        });
      }
    }
  }

  // =========================================================
  // DELETE POST
  // =========================================================

  Future<void> _handleDeletePost() async {
    if (widget.onDeletePost == null || _isDeleting) {
      return;
    }

    final bool? shouldDelete =
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 28,
          ),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.09),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red.shade600,
                    size: 31,
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  'Delete this post?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 9),

                Text(
                  'This action cannot be undone. '
                      'The post and its related content '
                      'will be permanently removed.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),

                const SizedBox(height: 22),

                Row(
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        height: 47,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(dialogContext)
                                .pop(false);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor:
                            Colors.black87,
                            side: BorderSide(
                              color:
                              Colors.grey.shade300,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontWeight:
                              FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 11),

                    Expanded(
                      child: SizedBox(
                        height: 47,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(dialogContext)
                                .pop(true);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            Colors.red.shade600,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(14),
                            ),
                          ),
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            size: 19,
                          ),
                          label: const Text(
                            'Delete',
                            style: TextStyle(
                              fontWeight:
                              FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (shouldDelete != true || !mounted) {
      return;
    }

    setState(() {
      _isDeleting = true;
    });

    try {
      await widget.onDeletePost!.call();
    } catch (error) {
      if (!mounted) return;

      AppSnackBar.showError(
        context,
        message: 'Failed to delete post.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  // =========================================================
  // LIKE / UNLIKE
  // =========================================================

  Future<void> _handleLikeTap() async {
    final LikeProvider likeProvider =
    context.read<LikeProvider>();

    if (likeProvider.isPostLikeLoading(
      widget.postId,
    )) {
      return;
    }

    final UserDetailProvider userProvider =
    context.read<UserDetailProvider>();

    final String token =
        userProvider.user?.token?.trim() ?? '';

    if (token.isEmpty) {
      AppSnackBar.showError(
        context,
        message:
        'Your session has expired. Please log in again.',
      );

      return;
    }

    final bool previousIsLiked = _isLiked;
    final int previousLikeCount = _likeCount;

    final bool nextIsLiked = !_isLiked;

    setState(() {
      _isLiked = nextIsLiked;

      if (nextIsLiked) {
        _likeCount++;
      } else {
        _likeCount =
        _likeCount > 0 ? _likeCount - 1 : 0;
      }
    });

    final LikeModel? result =
    await likeProvider.likePost(
      postId: widget.postId,
      token: token,
    );

    if (!mounted) return;

    if (result == null) {
      setState(() {
        _isLiked = previousIsLiked;
        _likeCount = previousLikeCount;
      });

      AppSnackBar.showError(
        context,
        message:
        likeProvider.errorMessage ??
            'Failed to update post like.',
      );

      return;
    }

    setState(() {
      _isLiked = result.isLiked;
      _likeCount = result.likeCount;
    });

    widget.onLikeChanged?.call(
      result.isLiked,
      result.likeCount,
    );
  }

  // =========================================================
  // BOOKMARK
  // =========================================================

  void _handleBookmarkTap() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });

    widget.onBookmarkTap?.call();
  }

  // =========================================================
  // COUNT FORMAT
  // =========================================================

  String _formatCount(int count) {
    if (count >= 1000000) {
      final double value = count / 1000000;

      return value == value.truncateToDouble()
          ? '${value.toStringAsFixed(0)}M'
          : '${value.toStringAsFixed(1)}M';
    }

    if (count >= 1000) {
      final double value = count / 1000;

      return value == value.truncateToDouble()
          ? '${value.toStringAsFixed(0)}K'
          : '${value.toStringAsFixed(1)}K';
    }

    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme =
        Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      color: AppColors.white,
      elevation: 1.5,
      shadowColor: Colors.black.withOpacity(0.10),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(
          color: Colors.black.withOpacity(0.05),
        ),
      ),
      child: Stack(
        children: <Widget>[
          AbsorbPointer(
            absorbing: _isDeleting,
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: <Widget>[
                _buildPostHeader(textTheme),

                if (widget.caption.trim().isNotEmpty)
                  _buildCaption(textTheme),

                if (widget.postImages.isNotEmpty)
                  _buildPostImages(),

                _buildActionSection(),
              ],
            ),
          ),

          if (_isDeleting)
            Positioned.fill(
              child: Container(
                color: Colors.white.withOpacity(0.75),
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(16),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color:
                        Colors.black.withOpacity(0.10),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                        height: 20,
                        child:
                        CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(width: 11),
                      Text(
                        'Deleting post...',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // =========================================================
  // HEADER
  // =========================================================

  Widget _buildPostHeader(TextTheme textTheme) {
    final bool showMoreButton =
        widget.isPostOwner ||
            widget.onMoreTap != null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        14,
        14,
        8,
        12,
      ),
      child: Row(
        children: <Widget>[
          _buildProfileImage(),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        widget.userName,
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style:
                        textTheme.titleMedium?.copyWith(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),
                    ),

                    if (widget.isVerified) ...<Widget>[
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.verified_rounded,
                        color: AppColors.primary,
                        size: 17,
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 2),

                Text(
                  widget.userUsername,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                if (widget.location
                    .trim()
                    .isNotEmpty) ...<Widget>[
                  const SizedBox(height: 3),

                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: Colors.grey.shade600,
                      ),

                      const SizedBox(width: 3),

                      Expanded(
                        child: Text(
                          widget.location,
                          maxLines: 1,
                          overflow:
                          TextOverflow.ellipsis,
                          style:
                          textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          if (showMoreButton)
            IconButton(
              onPressed:
              _isDeleting || _isEditing
                  ? null
                  : _handleMoreTap,
              splashRadius: 22,
              tooltip: 'Post options',
              icon: _isEditing
                  ? const SizedBox(
                width: 21,
                height: 21,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              )
                  : const Icon(
                Icons.more_horiz_rounded,
                size: 25,
                color: Colors.black87,
              ),
            ),
        ],
      ),
    );
  }

  // =========================================================
  // PROFILE IMAGE
  // =========================================================

  Widget _buildProfileImage() {
    return Container(
      width: 50,
      height: 50,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary,
          width: 1.8,
        ),
      ),
      child: ClipOval(
        child: widget.userImage.trim().isEmpty
            ? _buildDefaultUserImage()
            : Image.network(
          widget.userImage,
          width: 46,
          height: 46,
          fit: BoxFit.cover,
          loadingBuilder: (
              BuildContext context,
              Widget child,
              ImageChunkEvent? progress,
              ) {
            if (progress == null) {
              return child;
            }

            return const Center(
              child: SizedBox(
                width: 17,
                height: 17,
                child:
                CircularProgressIndicator(
                  strokeWidth: 1.8,
                  color: AppColors.primary,
                ),
              ),
            );
          },
          errorBuilder: (
              BuildContext context,
              Object error,
              StackTrace? stackTrace,
              ) {
            return _buildDefaultUserImage();
          },
        ),
      ),
    );
  }

  Widget _buildDefaultUserImage() {
    return Image.asset(
      'assets/images/user.png',
      width: 46,
      height: 46,
      fit: BoxFit.cover,
      errorBuilder: (
          BuildContext context,
          Object error,
          StackTrace? stackTrace,
          ) {
        return Container(
          color: Colors.grey.shade200,
          alignment: Alignment.center,
          child: Icon(
            Icons.person_rounded,
            size: 27,
            color: Colors.grey.shade500,
          ),
        );
      },
    );
  }

  // =========================================================
  // CAPTION
  // =========================================================

  Widget _buildCaption(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        14,
        0,
        14,
        13,
      ),
      child: Text.rich(
        TextSpan(
          children: <InlineSpan>[
            TextSpan(
              text: '${widget.userUsername} ',
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w700,
                height: 1.45,
              ),
            ),
            TextSpan(
              text: widget.caption.trim(),
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.black87,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // POST IMAGES
  // =========================================================

  Widget _buildPostImages() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.05,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.postImages.length,
            physics:
            const BouncingScrollPhysics(),
            onPageChanged: (int index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (
                BuildContext context,
                int index,
                ) {
              return Image.network(
                widget.postImages[index],
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (
                    BuildContext context,
                    Widget child,
                    ImageChunkEvent? progress,
                    ) {
                  if (progress == null) {
                    return child;
                  }

                  return const Center(
                    child:
                    CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  );
                },
                errorBuilder: (
                    BuildContext context,
                    Object error,
                    StackTrace? stackTrace,
                    ) {
                  return Container(
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.broken_image_outlined,
                      size: 42,
                    ),
                  );
                },
              );
            },
          ),
        ),

        if (widget.postImages.length > 1)
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius:
                BorderRadius.circular(30),
              ),
              child: Text(
                '${_currentImageIndex + 1}/'
                    '${widget.postImages.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

        if (widget.postImages.length > 1)
          Positioned(
            bottom: 12,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List<Widget>.generate(
                widget.postImages.length,
                    (int index) {
                  final bool selected =
                      index == _currentImageIndex;

                  return AnimatedContainer(
                    duration: const Duration(
                      milliseconds: 250,
                    ),
                    margin:
                    const EdgeInsets.symmetric(
                      horizontal: 3,
                    ),
                    width: selected ? 16 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: selected
                          ? Colors.white
                          : Colors.white54,
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  // =========================================================
  // ACTIONS
  // =========================================================

  Widget _buildActionSection() {
    final LikeProvider likeProvider =
    context.watch<LikeProvider>();

    final bool isLikeLoading =
    likeProvider.isPostLikeLoading(
      widget.postId,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        8,
        9,
        8,
        10,
      ),
      child: Row(
        children: <Widget>[
          _buildActionButton(
            icon: _isLiked
                ? Icons.favorite_rounded
                : Iconsax.heart,
            label: _formatCount(_likeCount),
            color: _isLiked
                ? Colors.red
                : Colors.black87,
            onTap: isLikeLoading
                ? null
                : _handleLikeTap,
            isLoading: isLikeLoading,
          ),

          _buildActionButton(
            icon: Iconsax.message,
            label: widget.comments,
            color: Colors.black87,
            onTap: widget.onCommentTap,
          ),

          _buildActionButton(
            icon: Iconsax.send_2,
            label: widget.shares,
            color: Colors.black87,
            onTap: widget.onShareTap,
          ),

          const Spacer(),

          IconButton(
            onPressed: _handleBookmarkTap,
            icon: Icon(
              _isBookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              color: _isBookmarked
                  ? AppColors.primary
                  : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onTap,
    bool isLoading = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 9,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (isLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child:
                  CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                )
              else
                Icon(
                  icon,
                  size: 22,
                  color: color,
                ),

              const SizedBox(width: 6),

              Text(
                label,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}