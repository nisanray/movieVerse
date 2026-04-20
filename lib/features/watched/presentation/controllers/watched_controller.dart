import 'dart:async';
import 'package:get/get.dart';
import '../../../media_discovery/domain/entities/media.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../domain/usecases/get_watched_use_case.dart';
import '../../domain/usecases/add_to_watched_use_case.dart';
import '../../domain/usecases/remove_from_watched_use_case.dart';

class WatchedController extends GetxController with StateMixin<List<Media>> {
  final GetWatchedUseCase _getWatchedUseCase;
  final AddToWatchedUseCase _addToWatchedUseCase;
  final RemoveFromWatchedUseCase _removeFromWatchedUseCase;
  
  final AuthController _authController = Get.find<AuthController>();
  StreamSubscription? _watchedSubscription;

  WatchedController(
    this._getWatchedUseCase,
    this._addToWatchedUseCase,
    this._removeFromWatchedUseCase,
  );

  final RxList<int> watchedIds = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    ever(_authController.user, (_) => _listenToWatched());
    _listenToWatched();
  }

  void _listenToWatched() {
    _watchedSubscription?.cancel();

    final user = _authController.user.value;
    if (user == null) {
      watchedIds.clear();
      change([], status: RxStatus.empty());
      return;
    }

    if (state == null || state!.isEmpty) {
      change(null, status: RxStatus.loading());
    }

    _watchedSubscription = _getWatchedUseCase.execute(user.uid).listen(
      (list) {
        watchedIds.assignAll(list.map((m) => m.id));
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

  Future<void> toggleWatched(Media media) async {
    final user = _authController.user.value;
    if (user == null) {
      SnackbarUtils.warning(
        title: 'Sign In Required',
        message: 'Please sign in to track your watched movies.',
      );
      return;
    }

    try {
      final isCurrentlyWatched = watchedIds.contains(media.id);
      if (isCurrentlyWatched) {
        await _removeFromWatchedUseCase.execute(user.uid, media.id);
         SnackbarUtils.info(
          title: 'Removed from Watched',
          message: '"${media.title}" was removed from your watched list.',
        );
      } else {
        await _addToWatchedUseCase.execute(user.uid, media);
        SnackbarUtils.success(
          title: 'Marked as Watched!',
          message: '"${media.title}" is now in your watched collection.',
        );
      }
    } catch (e) {
      SnackbarUtils.error(
        title: 'Update Failed',
        message: 'Could not update status. Please try again.',
      );
    }
  }

  bool isWatched(int mediaId) {
    return watchedIds.contains(mediaId);
  }

  @override
  void onClose() {
    _watchedSubscription?.cancel();
    super.onClose();
  }
}
