import 'dart:async';
import 'package:get/get.dart';
import '../../../../../core/domain/entities/media.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../domain/usecases/get_watch_later_use_case.dart';
import '../../domain/usecases/add_to_watch_later_use_case.dart';
import '../../domain/usecases/remove_from_watch_later_use_case.dart';

class WatchLaterController extends GetxController with StateMixin<List<Media>> {
  final GetWatchLaterUseCase _getWatchLaterUseCase;
  final AddToWatchLaterUseCase _addToWatchLaterUseCase;
  final RemoveFromWatchLaterUseCase _removeFromWatchLaterUseCase;
  
  final AuthController _authController = Get.find<AuthController>();
  StreamSubscription? _watchLaterSubscription;

  WatchLaterController(
    this._getWatchLaterUseCase,
    this._addToWatchLaterUseCase,
    this._removeFromWatchLaterUseCase,
  );

  // Single observable for checking status of a specific media (ID)
  final RxList<int> watchLaterIds = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Reactively listen to user auth changes
    ever(_authController.user, (_) => _listenToWatchLater());
    _listenToWatchLater(); // Initial check
  }

  void _listenToWatchLater() {
    // Cancel existing subscription if any
    _watchLaterSubscription?.cancel();

    final user = _authController.user.value;
    if (user == null) {
      watchLaterIds.clear();
      change([], status: RxStatus.empty());
      return;
    }

    // Don't show loading on every minor change, only on first load
    if (state == null || state!.isEmpty) {
      change(null, status: RxStatus.loading());
    }

    _watchLaterSubscription = _getWatchLaterUseCase.execute(user.uid).listen(
      (list) {
        watchLaterIds.assignAll(list.map((m) => m.id));
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

  Future<void> toggleWatchLater(Media media) async {
    final user = _authController.user.value;
    if (user == null) {
      SnackbarUtils.warning(
        title: 'Sign In Required',
        message: 'Please sign in to save movies to your watch later list.',
      );
      return;
    }

    try {
      final isCurrentlyAdded = watchLaterIds.contains(media.id);
      if (isCurrentlyAdded) {
        await _removeFromWatchLaterUseCase.execute(user.uid, media.id);
        SnackbarUtils.info(
          title: 'Removed',
          message: '"${media.title}" was removed from your watch later list.',
        );
      } else {
        await _addToWatchLaterUseCase.execute(user.uid, media);
        SnackbarUtils.success(
          title: 'Saved!',
          message: '"${media.title}" was added to your watch later list.',
        );
      }
    } catch (e) {
      SnackbarUtils.error(
        title: 'Something went wrong',
        message: 'Could not update watch later list. Please try again.',
      );
    }
  }

  bool isInWatchLater(int mediaId) {
    return watchLaterIds.contains(mediaId);
  }

  @override
  void onClose() {
    _watchLaterSubscription?.cancel();
    super.onClose();
  }
}
