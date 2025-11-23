import 'package:centranews/providers/local_user_provider.dart';
import 'package:centranews/providers/localization_provider.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:centranews/utils/bookmark_manager.dart';
import 'package:centranews/utils/pop_up_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:centranews/utils/full_screen_overlay_progress_bar.dart';

final supabase = Supabase.instance.client;

class BookmarkButton extends ConsumerStatefulWidget {
  const BookmarkButton({super.key, required this.articleID});

  final String articleID;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends ConsumerState<BookmarkButton>
    with FullScreenOverlayProgressBar {
  bool isBookmarked = false;
  bool hasLoadInitialAdditionArticleData = false;

  @override
  Widget build(BuildContext context) {
    if (!hasLoadInitialAdditionArticleData) {
      loadBookmarkStateStartUp();
    }
    var currentTheme = ref.watch(themeProvider);
    var localUser = ref.watch(userProvider);
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        children: [
          //TODO: currently not displaying bookmark count
          // Text(
          //   bookmarkCount == null
          //       ? widget.parentBookmarkCount.toString()
          //       : bookmarkCount.toString(),
          //   style: currentTheme.textTheme.bodyMedium,
          // ),
          IconButton(
            onPressed: () {
              toggleBookmark();
            },
            icon: (isBookmarked && (localUser != null))
                ? Icon(
                    Icons.bookmark,
                    color: currentTheme.currentColorScheme.bgInverse,
                  )
                : Icon(
                    Icons.bookmarks_outlined,
                    color: currentTheme.currentColorScheme.bgInverse,
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> loadBookmarkStateStartUp() async {
    var articleIsBookmarked = await BookmarkManager.isArticleBookmarked(
      widget.articleID,
    );

    if (mounted) {
      setState(() {
        isBookmarked = articleIsBookmarked;
        hasLoadInitialAdditionArticleData = true;
      });
    }
  }

  void toggleBookmark() async {
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    var localUser = ref.watch(userProvider);
    if (localUser == null) {
      showSignInPrompt(context, currentTheme, localization);
      return;
    }
    try {
      if (mounted) {
        showProgressBar(context, currentTheme);
      }
      if (isBookmarked) {
        await BookmarkManager.removeArticleIdFromBookmark(
          localUser.uid,
          widget.articleID,
        );
      } else {
        await BookmarkManager.addArticleIdToBookmark(
          localUser.uid,
          widget.articleID,
        );
      }
      await loadBookmarkState();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (mounted) {
        closeProgressBar(context);
      }
    }
  }

  Future<void> loadBookmarkState() async {
    try {
      if (supabase.auth.currentUser == null) return;
      var articleIsBookmarked = await BookmarkManager.isArticleBookmarked(
        widget.articleID,
      );

      if (mounted) {
        setState(() {
          isBookmarked = articleIsBookmarked;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
