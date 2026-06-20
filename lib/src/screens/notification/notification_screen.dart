import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_stream/src/constants/app_images.dart';
import 'package:social_stream/src/constants/colors.dart';

// =============================================================
// NOTIFICATION TYPE
// =============================================================

enum NotificationType {
  followRequest,
  likedPost,
  commentedPost,
  mentionedInPost,
  startedFollowing,
}

// =============================================================
// NOTIFICATION MODEL
// =============================================================

class NotificationItemModel {
  final int id;
  final String userName;
  final String message;
  final String time;
  final String section;
  final String userImage;
  final NotificationType type;
  final String? postImage;

  bool isRead;
  bool isRequestAccepted;

  NotificationItemModel({
    required this.id,
    required this.userName,
    required this.message,
    required this.time,
    required this.section,
    required this.userImage,
    required this.type,
    this.postImage,
    this.isRead = false,
    this.isRequestAccepted = false,
  });
}

// =============================================================
// NOTIFICATION SCREEN
// =============================================================

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({
    super.key,
  });

  @override
  State<NotificationScreen> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState
    extends State<NotificationScreen> {
  // 0 = All
  // 1 = Requests
  int _selectedFilter = 0;

  // ===========================================================
  // DEMO NOTIFICATIONS
  // Replace this list with API data later.
  // ===========================================================

  final List<NotificationItemModel> _notifications =
  <NotificationItemModel>[
    NotificationItemModel(
      id: 1,
      userName: 'Carla Cohen',
      message: 'sent you a follow request.',
      time: '2 min ago',
      section: 'TODAY',
      userImage: AppImages.userImage1,
      type: NotificationType.followRequest,
    ),
    NotificationItemModel(
      id: 2,
      userName: 'Sophia Williams',
      message: 'liked your latest post.',
      time: '12 min ago',
      section: 'TODAY',
      userImage: AppImages.userImage1,
      postImage: AppImages.postImage1,
      type: NotificationType.likedPost,
    ),
    NotificationItemModel(
      id: 3,
      userName: 'Emma Watson',
      message: 'commented: “This looks amazing!”',
      time: '25 min ago',
      section: 'TODAY',
      userImage: AppImages.userImage1,
      postImage: AppImages.postImage1,
      type: NotificationType.commentedPost,
    ),
    NotificationItemModel(
      id: 4,
      userName: 'Daniel Smith',
      message: 'started following you.',
      time: '1 hr ago',
      section: 'TODAY',
      userImage: AppImages.userImage1,
      type: NotificationType.startedFollowing,
      isRead: true,
    ),
    NotificationItemModel(
      id: 5,
      userName: 'Olivia Brown',
      message: 'mentioned you in a post.',
      time: 'Yesterday',
      section: 'YESTERDAY',
      userImage: AppImages.userImage1,
      postImage: AppImages.postImage1,
      type: NotificationType.mentionedInPost,
      isRead: true,
    ),
    NotificationItemModel(
      id: 6,
      userName: 'James Anderson',
      message: 'sent you a follow request.',
      time: 'Yesterday',
      section: 'YESTERDAY',
      userImage: AppImages.userImage1,
      type: NotificationType.followRequest,
      isRead: true,
    ),
  ];

  // ===========================================================
  // FILTERED NOTIFICATIONS
  // ===========================================================

  List<NotificationItemModel> get _filteredNotifications {
    if (_selectedFilter == 1) {
      return _notifications
          .where(
            (NotificationItemModel item) =>
        item.type ==
            NotificationType.followRequest,
      )
          .toList();
    }

    return _notifications;
  }

  int get _pendingRequestCount {
    return _notifications
        .where(
          (NotificationItemModel item) =>
      item.type ==
          NotificationType.followRequest &&
          !item.isRequestAccepted,
    )
        .length;
  }

  int get _unreadCount {
    return _notifications
        .where(
          (NotificationItemModel item) =>
      !item.isRead,
    )
        .length;
  }

  // ===========================================================
  // ACTIONS
  // ===========================================================

  void _markAllAsRead() {
    setState(() {
      for (final NotificationItemModel item
      in _notifications) {
        item.isRead = true;
      }
    });

    _showMessage(
      'All notifications marked as read.',
    );
  }

  void _markNotificationAsRead(
      NotificationItemModel item,
      ) {
    if (item.isRead) {
      return;
    }

    setState(() {
      item.isRead = true;
    });
  }

  void _acceptRequest(
      NotificationItemModel item,
      ) {
    setState(() {
      item.isRequestAccepted = true;
      item.isRead = true;
    });

    _showMessage(
      '${item.userName} request accepted.',
    );
  }

  void _deleteNotification(
      NotificationItemModel item,
      ) {
    setState(() {
      _notifications.removeWhere(
            (NotificationItemModel notification) =>
        notification.id == item.id,
      );
    });

    _showMessage(
      'Notification removed.',
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
  }

  // ===========================================================
  // BUILD
  // ===========================================================

  @override
  Widget build(BuildContext context) {
    final List<NotificationItemModel>
    visibleNotifications =
        _filteredNotifications;

    final List<NotificationItemModel>
    todayNotifications =
    visibleNotifications
        .where(
          (NotificationItemModel item) =>
      item.section == 'TODAY',
    )
        .toList();

    final List<NotificationItemModel>
    yesterdayNotifications =
    visibleNotifications
        .where(
          (NotificationItemModel item) =>
      item.section == 'YESTERDAY',
    )
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      appBar: _buildAppBar(),

      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          await Future<void>.delayed(
            const Duration(milliseconds: 700),
          );
        },
        child: CustomScrollView(
          physics:
          const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: _buildHeaderCard(),
            ),

            SliverToBoxAdapter(
              child: _buildFilters(),
            ),

            if (visibleNotifications.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _buildEmptyState(),
              )
            else ...<Widget>[
              if (todayNotifications.isNotEmpty)
                SliverToBoxAdapter(
                  child: _buildNotificationSection(
                    title: 'TODAY',
                    notifications:
                    todayNotifications,
                  ),
                ),

              if (yesterdayNotifications.isNotEmpty)
                SliverToBoxAdapter(
                  child: _buildNotificationSection(
                    title: 'YESTERDAY',
                    notifications:
                    yesterdayNotifications,
                  ),
                ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 24),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // APP BAR
  // ===========================================================

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      centerTitle: false,

      leadingWidth: 64,

      leading: Padding(
        padding: const EdgeInsets.only(
          left: 14,
          top: 8,
          bottom: 8,
        ),
        child: Material(
          color: const Color(0xFFF5F6F8),
          shape: const CircleBorder(),
          child: InkWell(
            onTap: () {
              Navigator.maybePop(context);
            },
            customBorder: const CircleBorder(),
            child: const Icon(
              CupertinoIcons.arrow_left,
              size: 19,
              color: Colors.black87,
            ),
          ),
        ),
      ),

      title: const Text(
        'Notifications',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),

      actions: <Widget>[
        TextButton(
          onPressed: () {
            setState(() {
              _selectedFilter = 1;
            });
          },
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
            ),
          ),
          child: Text(
            '$_pendingRequestCount Requests',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: const Color(0xFFEEEEEE),
        ),
      ),
    );
  }

  // ===========================================================
  // HEADER CARD
  // ===========================================================

  Widget _buildHeaderCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        16,
        18,
        16,
        10,
      ),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            AppColors.primary,
            AppColors.primary.withOpacity(0.78),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primary.withOpacity(0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
              color: Colors.white,
              size: 27,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _unreadCount > 0
                      ? 'You have $_unreadCount unread notifications'
                      : 'You are all caught up',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  _unreadCount > 0
                      ? 'Check the latest activity on your account.'
                      : 'There are no unread notifications.',
                  style: TextStyle(
                    color:
                    Colors.white.withOpacity(0.82),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor:
                Colors.white.withOpacity(0.16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Read all',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ===========================================================
  // FILTERS
  // ===========================================================

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        12,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _buildFilterButton(
              title: 'All Notifications',
              count: _notifications.length,
              index: 0,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: _buildFilterButton(
              title: 'Requests',
              count: _pendingRequestCount,
              index: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton({
    required String title,
    required int count,
    required int index,
  }) {
    final bool isSelected =
        _selectedFilter == index;

    return Material(
      color: isSelected
          ? AppColors.primary
          : Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedFilter = index;
          });
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 46,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : const Color(0xFFE8E9ED),
            ),
          ),
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(width: 7),

              Container(
                constraints: const BoxConstraints(
                  minWidth: 24,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.20)
                      : AppColors.primary
                      .withOpacity(0.10),
                  borderRadius:
                  BorderRadius.circular(20),
                ),
                child: Text(
                  count.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // NOTIFICATION SECTION
  // ===========================================================

  Widget _buildNotificationSection({
    required String title,
    required List<NotificationItemModel>
    notifications,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        10,
        16,
        4,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              left: 2,
              bottom: 10,
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF8A8F99),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.9,
              ),
            ),
          ),

          ...notifications.map(
                (NotificationItemModel item) {
              return _buildNotificationItem(item);
            },
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // NOTIFICATION ITEM
  // ===========================================================

  Widget _buildNotificationItem(
      NotificationItemModel item,
      ) {
    final bool isFollowRequest =
        item.type ==
            NotificationType.followRequest;

    return Dismissible(
      key: ValueKey<int>(item.id),

      direction: DismissDirection.endToStart,

      onDismissed: (_) {
        _deleteNotification(item);
      },

      background: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.only(right: 24),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.red.shade500,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
          size: 25,
        ),
      ),

      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _markNotificationAsRead(item);
          },
          borderRadius: BorderRadius.circular(18),
          child: Container(
            margin: const EdgeInsets.only(
              bottom: 10,
            ),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: item.isRead
                  ? Colors.white
                  : AppColors.primary
                  .withOpacity(0.055),
              borderRadius:
              BorderRadius.circular(18),
              border: Border.all(
                color: item.isRead
                    ? const Color(0xFFEBECF0)
                    : AppColors.primary
                    .withOpacity(0.16),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withOpacity(0.025),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildUserAvatar(item),

                    const SizedBox(width: 12),

                    Expanded(
                      child:
                      _buildNotificationContent(item),
                    ),

                    const SizedBox(width: 8),

                    if (item.postImage != null)
                      _buildPostPreview(item.postImage!)
                    else
                      PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.more_horiz_rounded,
                          color: Color(0xFF777B85),
                          size: 22,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(14),
                        ),
                        onSelected: (String value) {
                          if (value == 'read') {
                            _markNotificationAsRead(
                              item,
                            );
                          }

                          if (value == 'delete') {
                            _deleteNotification(item);
                          }
                        },
                        itemBuilder:
                            (BuildContext context) {
                          return <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'read',
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons
                                        .done_all_rounded,
                                    size: 19,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Mark as read',
                                  ),
                                ],
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons
                                        .delete_outline_rounded,
                                    size: 19,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Delete',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ];
                        },
                      ),
                  ],
                ),

                if (isFollowRequest)
                  _buildRequestActions(item),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // AVATAR
  // ===========================================================

  Widget _buildUserAvatar(
      NotificationItemModel item,
      ) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Container(
          width: 52,
          height: 52,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary
                  .withOpacity(0.35),
              width: 1.5,
            ),
          ),
          child: CircleAvatar(
            backgroundColor:
            const Color(0xFFF0F1F4),
            backgroundImage:
            AssetImage(item.userImage),
          ),
        ),

        Positioned(
          right: -1,
          bottom: -1,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color:
              _notificationIconColor(item.type),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            child: Icon(
              _notificationIcon(item.type),
              size: 11,
              color: Colors.white,
            ),
          ),
        ),

        if (!item.isRead)
          Positioned(
            top: 0,
            left: -2,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ===========================================================
  // CONTENT
  // ===========================================================

  Widget _buildNotificationContent(
      NotificationItemModel item,
      ) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: <Widget>[
        Text.rich(
          TextSpan(
            children: <InlineSpan>[
              TextSpan(
                text: '${item.userName} ',
                style: const TextStyle(
                  color: Color(0xFF202126),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                ),
              ),
              TextSpan(
                text: item.message,
                style: const TextStyle(
                  color: Color(0xFF5F636D),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
            ],
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 5),

        Row(
          children: <Widget>[
            Icon(
              CupertinoIcons.clock,
              size: 12,
              color: Colors.grey.shade500,
            ),

            const SizedBox(width: 4),

            Text(
              item.time,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ===========================================================
  // POST PREVIEW
  // ===========================================================

  Widget _buildPostPreview(String image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        image,
        width: 52,
        height: 52,
        fit: BoxFit.cover,
        errorBuilder: (
            BuildContext context,
            Object error,
            StackTrace? stackTrace,
            ) {
          return Container(
            width: 52,
            height: 52,
            color: const Color(0xFFF0F1F4),
            alignment: Alignment.center,
            child: const Icon(
              Icons.image_outlined,
              color: Colors.grey,
            ),
          );
        },
      ),
    );
  }

  // ===========================================================
  // REQUEST ACTIONS
  // ===========================================================

  Widget _buildRequestActions(
      NotificationItemModel item,
      ) {
    if (item.isRequestAccepted) {
      return Padding(
        padding: const EdgeInsets.only(
          left: 64,
          top: 12,
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.10),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.check_circle_rounded,
                  size: 16,
                  color: Colors.green,
                ),
                SizedBox(width: 6),
                Text(
                  'Request Accepted',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(
        left: 64,
        top: 13,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: SizedBox(
              height: 38,
              child: ElevatedButton(
                onPressed: () {
                  _acceptRequest(item);
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Accept',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: SizedBox(
              height: 38,
              child: OutlinedButton(
                onPressed: () {
                  _deleteNotification(item);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor:
                  const Color(0xFF555A64),
                  side: const BorderSide(
                    color: Color(0xFFDADCE2),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // EMPTY STATE
  // ===========================================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color:
                AppColors.primary.withOpacity(0.09),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _selectedFilter == 1
                    ? Icons.person_add_alt_1_rounded
                    : Icons
                    .notifications_none_rounded,
                color: AppColors.primary,
                size: 42,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              _selectedFilter == 1
                  ? 'No pending requests'
                  : 'No notifications yet',
              style: const TextStyle(
                color: Color(0xFF202126),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              _selectedFilter == 1
                  ? 'New follow requests will appear here.'
                  : 'Your latest account activity will appear here.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF777B85),
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // TYPE ICON
  // ===========================================================

  IconData _notificationIcon(
      NotificationType type,
      ) {
    switch (type) {
      case NotificationType.followRequest:
        return Icons.person_add_alt_1_rounded;

      case NotificationType.likedPost:
        return Icons.favorite_rounded;

      case NotificationType.commentedPost:
        return Icons.chat_bubble_rounded;

      case NotificationType.mentionedInPost:
        return Icons.alternate_email_rounded;

      case NotificationType.startedFollowing:
        return Icons.person_rounded;
    }
  }

  Color _notificationIconColor(
      NotificationType type,
      ) {
    switch (type) {
      case NotificationType.followRequest:
        return AppColors.primary;

      case NotificationType.likedPost:
        return Colors.red;

      case NotificationType.commentedPost:
        return Colors.orange;

      case NotificationType.mentionedInPost:
        return Colors.purple;

      case NotificationType.startedFollowing:
        return Colors.green;
    }
  }
}