import 'package:get/get.dart';
import '../../../../../core/domain/entities/media.dart';
import '../../domain/usecases/get_media_by_actor_usecase.dart';

class ActorDiscoveryController extends GetxController with StateMixin<List<Media>> {
  final GetMediaByActorUseCase _getMediaByActorUseCase;

  ActorDiscoveryController(this._getMediaByActorUseCase);

  final RxString actorName = ''.obs;
  final RxString profileUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final int? actorId = Get.arguments['id'];
    actorName.value = Get.arguments['name'] ?? 'Actor';
    profileUrl.value = Get.arguments['profileUrl'] ?? '';

    if (actorId != null) {
      fetchMediaByActor(actorId);
    } else {
      change([], status: RxStatus.error('Actor ID not found'));
    }
  }

  Future<void> fetchMediaByActor(int actorId) async {
    try {
      change([], status: RxStatus.loading());
      final results = await _getMediaByActorUseCase.execute(actorId);
      if (results.isEmpty) {
        change([], status: RxStatus.empty());
      } else {
        change(results, status: RxStatus.success());
      }
    } catch (e) {
      change([], status: RxStatus.error(e.toString()));
    }
  }
}
