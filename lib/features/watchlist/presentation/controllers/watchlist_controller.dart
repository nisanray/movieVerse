import 'dart:async';
import 'package:get/get.dart';
import '../../domain/repositories/watchlist_repository.dart';
import '../../../media_discovery/domain/entities/media.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../../core/utils/snackbar_utils.dart';

class WatchlistController extends GetxController with StateMixin<List<Media>> {
  final WatchlistRepository _repository;
  final AuthController _authController = Get.find<AuthController>();
  StreamSubscription? _watchlistSubscription;

  WatchlistController(this._repository);

  // Single observable for checking status of a specific media (ID)
  final RxList<int> watchlistIds = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Reactively listen to user auth changes
    // This handles the case where the user logs in after the controller is created
    ever(_authController.user, (_) => _listenToWatchlist());
    _listenToWatchlist(); // Initial check
  }

  void _listenToWatchlist() {
    // Cancel existing subscription if any
    _watchlistSubscription?.cancel();

    final user = _authController.user.value;
    if (user == null) {
      watchlistIds.clear();
      change([], status: RxStatus.empty());
      return;
    }

    // Don't show loading on every minor change, only on first load
    if (state == null || state!.isEmpty) {
      change(null, status: RxStatus.loading());
    }

    _watchlistSubscription = _repository.getWatchlist(user.uid).listen(
      (list) {
        watchlistIds.assignAll(list.map((m) => m.id));
        if (list.isEmpty) {
          change([], status: RxStatus.empty());
        } else {
          change(list, status: RxStatus.success());
        }
      },
      onError: (err) {
        change(null, status: RxStatus.error(err.toString()));
      },
    );
  }

  Future<void> toggleWatchlist(Media media) async {
    final user = _authController.user.value;
    if (user == null) {
      SnackbarUtils.warning(
        title: 'Sign In Required',
        message: 'Please sign in to save movies to your watchlist.',
      );
      return;
    }

    try {
      final isCurrentlyAdded = watchlistIds.contains(media.id);
      if (isCurrentlyAdded) {
        await _repository.removeFromWatchlist(user.uid, media.id);
        SnackbarUtils.info(
          title: 'Removed',
          message: '"${media.title}" was removed from your watchlist.',
        );
      } else {
        await _repository.addToWatchlist(user.uid, media);
        SnackbarUtils.success(
          title: 'Saved!',
          message: '"${media.title}" was added to your watchlist.',
        );
      }
    } catch (e) {
      SnackbarUtils.error(
        title: 'Something went wrong',
        message: 'Could not update watchlist. Please try again.',
      );
    }
  }

  bool isInWatchlist(int mediaId) {
    return watchlistIds.contains(mediaId);
  }

  @override
  void onClose() {
    _watchlistSubscription?.cancel();
    super.onClose();
  }
}
