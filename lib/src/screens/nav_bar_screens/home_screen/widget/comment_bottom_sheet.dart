import 'package:flutter/material.dart';
import 'package:social_stream/src/constants/app_images.dart';
import 'package:social_stream/src/constants/colors.dart';
import 'package:social_stream/src/models/comment_model.dart';

class CommentBottomSheet {
  static Future<void> show(
      BuildContext context, {
        required int postId,
      }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (BuildContext context) {
        return _CommentsBottomSheet(
          postId: postId,
        );
      },
    );
  }
}

class _CommentsBottomSheet extends StatefulWidget {
  final int postId;

  const _CommentsBottomSheet({
    required this.postId,
  });

  @override
  State<_CommentsBottomSheet> createState() =>
      _CommentsBottomSheetState();
}

class _CommentsBottomSheetState
    extends State<_CommentsBottomSheet> {
  final TextEditingController _commentController =
  TextEditingController();

  final FocusNode _commentFocusNode = FocusNode();

  final ScrollController _scrollController =
  ScrollController();

  final List<CommentModel> _comments = <CommentModel>[
    CommentModel(
      id: 1,
      userName: 'jenny_m',
      comment: 'Amazing, Good Luck!',
      time: '2w',
      userImage: AppImages.userImage1,
      likeCount: 33200,
      replyCount: 32,
      isVerified: true,
    ),
    CommentModel(
      id: 2,
      userName: 'joshua_k',
      comment: 'You inspire me every day.',
      time: '1w',
      userImage: AppImages.userImage1,
      likeCount: 125000,
      replyCount: 2,
      isVerified: true,
      isLiked: true,
    ),
    CommentModel(
      id: 3,
      userName: 'leslie_a',
      comment: 'Your smile is contagious.',
      time: '2w',
      userImage: AppImages.userImage1,
      likeCount: 10200,
      replyCount: 47,
      isVerified: true,
      isLiked: true,
    ),
    CommentModel(
      id: 4,
      userName: 'anya_s',
      comment: 'You are my sunshine.',
      time: '2w',
      userImage: AppImages.userImage1,
      likeCount: 185,
      replyCount: 23,
    ),
    CommentModel(
      id: 5,
      userName: 'gill_s',
      comment: 'You have such a great sense of style.',
      time: '2w',
      userImage: AppImages.userImage1,
      likeCount: 12,
      replyCount: 0,
    ),
    CommentModel(
      id: 6,
      userName: 'joshua_k',
      comment: 'You are so kind and compassionate.',
      time: '1w',
      userImage: AppImages.userImage1,
      likeCount: 125000,
      replyCount: 2,
      isVerified: true,
      isLiked: true,
    ),
  ];

  bool _isSending = false;

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  // =========================================================
  // SEND COMMENT
  // =========================================================

  Future<void> _sendComment() async {
    final String comment =
    _commentController.text.trim();

    if (comment.isEmpty || _isSending) {
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      // Yahan future mein comment API call hogi.
      await Future<void>.delayed(
        const Duration(milliseconds: 400),
      );

      final CommentModel newComment = CommentModel(
        id: DateTime.now().millisecondsSinceEpoch,
        userName: 'you',
        comment: comment,
        time: 'now',
        userImage: AppImages.userImage1,
        likeCount: 0,
        replyCount: 0,
      );

      if (!mounted) return;

      setState(() {
        _comments.insert(0, newComment);
      });

      _commentController.clear();

      if (_scrollController.hasClients) {
        await _scrollController.animateTo(
          0,
          duration: const Duration(
            milliseconds: 300,
          ),
          curve: Curves.easeOut,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  // =========================================================
  // LIKE COMMENT
  // =========================================================

  void _toggleCommentLike(
      CommentModel comment,
      ) {
    setState(() {
      comment.isLiked = !comment.isLiked;

      if (comment.isLiked) {
        comment.likeCount++;
      } else {
        comment.likeCount =
        comment.likeCount > 0
            ? comment.likeCount - 1
            : 0;
      }
    });
  }

  // =========================================================
  // FORMAT COUNT
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
    final MediaQueryData mediaQuery =
    MediaQuery.of(context);

    return AnimatedPadding(
      duration: const Duration(
        milliseconds: 200,
      ),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
        bottom: mediaQuery.viewInsets.bottom,
      ),
      child: Container(
        height: mediaQuery.size.height * 0.82,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(28),
          ),
        ),
        child: Column(
          children: <Widget>[
            _buildHeader(),

            const Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFFEEEEEE),
            ),

            Expanded(
              child: _comments.isEmpty
                  ? _buildEmptyState()
                  : _buildCommentsList(),
            ),

            _buildCommentInput(),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // HEADER
  // =========================================================

  Widget _buildHeader() {
    return Column(
      children: <Widget>[
        const SizedBox(height: 10),

        Container(
          width: 44,
          height: 5,
          decoration: BoxDecoration(
            color: const Color(0xFFD8D8D8),
            borderRadius: BorderRadius.circular(20),
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(
            18,
            12,
            10,
            12,
          ),
          child: Row(
            children: <Widget>[
              const SizedBox(width: 40),

              Expanded(
                child: Column(
                  children: <Widget>[
                    const Text(
                      'Comments',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF1D1F24),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      '${_comments.length} comments',
                      style: const TextStyle(
                        color: Color(0xFF8B8F98),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: IconButton.styleFrom(
                  backgroundColor:
                  const Color(0xFFF4F5F7),
                ),
                icon: const Icon(
                  Icons.close_rounded,
                  color: Color(0xFF44474F),
                  size: 21,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =========================================================
  // COMMENTS LIST
  // =========================================================

  Widget _buildCommentsList() {
    return Scrollbar(
      controller: _scrollController,
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(
          16,
          14,
          16,
          20,
        ),
        physics: const BouncingScrollPhysics(),
        itemCount: _comments.length,
        separatorBuilder: (
            BuildContext context,
            int index,
            ) {
          return const SizedBox(height: 18);
        },
        itemBuilder: (
            BuildContext context,
            int index,
            ) {
          return _buildCommentItem(
            _comments[index],
          );
        },
      ),
    );
  }

  // =========================================================
  // COMMENT ITEM
  // =========================================================

  Widget _buildCommentItem(
      CommentModel comment,
      ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildUserAvatar(comment.userImage),

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
                      comment.userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF26282E),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  if (comment.isVerified) ...<Widget>[
                    const SizedBox(width: 4),

                    const Icon(
                      Icons.verified_rounded,
                      color: Color(0xFFFF6B35),
                      size: 16,
                    ),
                  ],

                  const Spacer(),

                  Text(
                    comment.time,
                    style: const TextStyle(
                      color: Color(0xFF8E929B),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              Text(
                comment.comment,
                style: const TextStyle(
                  color: Color(0xFF555961),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  height: 1.35,
                ),
              ),

              const SizedBox(height: 8),

              Row(
                children: <Widget>[
                  _buildSmallAction(
                    icon: comment.isLiked
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    text: _formatCount(
                      comment.likeCount,
                    ),
                    color: comment.isLiked
                        ? Colors.red
                        : const Color(0xFF6D717A),
                    onTap: () {
                      _toggleCommentLike(comment);
                    },
                  ),

                  const SizedBox(width: 18),

                  _buildSmallAction(
                    icon:
                    Icons.chat_bubble_outline_rounded,
                    text: comment.replyCount.toString(),
                    color: const Color(0xFF6D717A),
                    onTap: () {
                      _commentController.text =
                      '@${comment.userName} ';

                      _commentController.selection =
                          TextSelection.fromPosition(
                            TextPosition(
                              offset: _commentController
                                  .text.length,
                            ),
                          );

                      _commentFocusNode.requestFocus();
                    },
                  ),

                  const SizedBox(width: 18),

                  GestureDetector(
                    onTap: () {
                      _commentController.text =
                      '@${comment.userName} ';

                      _commentFocusNode.requestFocus();
                    },
                    child: const Text(
                      'Reply',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserAvatar(String image) {
    return Container(
      width: 40,
      height: 40,
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary.withOpacity(0.25),
          width: 1.3,
        ),
      ),
      child: CircleAvatar(
        backgroundColor: const Color(0xFFF1F2F4),
        backgroundImage: AssetImage(image),
        onBackgroundImageError: (
            Object error,
            StackTrace? stackTrace,
            ) {},
        child: image.trim().isEmpty
            ? const Icon(
          Icons.person_rounded,
          color: Colors.grey,
        )
            : null,
      ),
    );
  }

  Widget _buildSmallAction({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 3,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              size: 16,
              color: color,
            ),

            const SizedBox(width: 5),

            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // COMMENT INPUT
  // =========================================================

  Widget _buildCommentInput() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          14,
          10,
          14,
          10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(
            top: BorderSide(
              color: Color(0xFFEEEEEE),
            ),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 14,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            const CircleAvatar(
              radius: 19,
              backgroundColor: Color(0xFFF1F2F4),
              backgroundImage: AssetImage(
                AppImages.userImage1,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: 44,
                  maxHeight: 110,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F8),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFFE9EAED),
                  ),
                ),
                child: TextField(
                  controller: _commentController,
                  focusNode: _commentFocusNode,
                  minLines: 1,
                  maxLines: 4,
                  textCapitalization:
                  TextCapitalization.sentences,
                  textInputAction:
                  TextInputAction.newline,
                  style: const TextStyle(
                    color: Color(0xFF25272C),
                    fontSize: 13,
                    height: 1.4,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Add a comment...',
                    hintStyle: TextStyle(
                      color: Color(0xFF9A9EA6),
                      fontSize: 13,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding:
                    EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 13,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 9),

            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _commentController,
              builder: (
                  BuildContext context,
                  TextEditingValue value,
                  Widget? child,
                  ) {
                final bool canSend =
                    value.text.trim().isNotEmpty &&
                        !_isSending;

                return AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 180,
                  ),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: canSend
                        ? AppColors.primary
                        : const Color(0xFFD8DADD),
                    shape: BoxShape.circle,
                    boxShadow: canSend
                        ? <BoxShadow>[
                      BoxShadow(
                        color: AppColors.primary
                            .withOpacity(0.28),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                        : null,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: canSend
                          ? _sendComment
                          : null,
                      customBorder:
                      const CircleBorder(),
                      child: Center(
                        child: _isSending
                            ? const SizedBox(
                          width: 19,
                          height: 19,
                          child:
                          CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // EMPTY STATE
  // =========================================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color:
                AppColors.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                color: AppColors.primary,
                size: 38,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'No comments yet',
              style: TextStyle(
                color: Color(0xFF25272C),
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'Be the first person to leave a comment.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF858992),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================
// COMMENT MODEL
// =============================================================
