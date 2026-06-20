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

  final VoidCallback? onMoreTap;

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
    this.onMoreTap,
    this.onLikeChanged,
    this.onCommentTap,
    this.onShareTap,
    this.onBookmarkTap,
  });

  @override
  State<PostCardWidget> createState() =>
      _PostCardWidgetState();
}

class _PostCardWidgetState
    extends State<PostCardWidget> {
  late final PageController _pageController;

  late bool _isLiked;
  late bool _isBookmarked;
  late int _likeCount;

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

    if (_currentImageIndex >=
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

    // Optimistic UI update
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

    // Backend actual state
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPostHeader(textTheme),

          if (widget.caption.trim().isNotEmpty)
            _buildCaption(textTheme),

          if (widget.postImages.isNotEmpty)
            _buildPostImages(),

          _buildActionSection(),
        ],
      ),
    );
  }

  // =========================================================
  // HEADER
  // =========================================================

  Widget _buildPostHeader(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        14,
        14,
        8,
        12,
      ),
      child: Row(
        children: [
          _buildProfileImage(),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.userName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleMedium?.copyWith(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    if (widget.isVerified) ...[
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

                if (widget.location.trim().isNotEmpty) ...[
                  const SizedBox(height: 3),

                  Row(
                    children: [
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
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall?.copyWith(
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

          IconButton(
            onPressed: widget.onMoreTap,
            splashRadius: 22,
            icon: const Icon(
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
                child: CircularProgressIndicator(
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
          children: [
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
      children: [
        AspectRatio(
          aspectRatio: 1.05,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.postImages.length,
            physics: const BouncingScrollPhysics(),
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
                    child: CircularProgressIndicator(
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
                borderRadius: BorderRadius.circular(30),
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
              children: List.generate(
                widget.postImages.length,
                    (int index) {
                  final bool selected =
                      index == _currentImageIndex;

                  return AnimatedContainer(
                    duration: const Duration(
                      milliseconds: 250,
                    ),
                    margin: const EdgeInsets.symmetric(
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
        children: [
          _buildActionButton(
            icon: _isLiked
                ? Icons.favorite_rounded
                : Iconsax.heart,
            label: _formatCount(_likeCount),
            color:
            _isLiked ? Colors.red : Colors.black87,
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
            children: [
              if (isLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
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