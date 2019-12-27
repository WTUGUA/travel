import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

//enum RtEvent{
//  pageMain,
//  pageRec,
//  pageComparison,
//  pageTranslation,
//}

class RouterBloc extends Bloc<RouterEvent, RouterState> {
  @override
  RouterState get initialState => StateMain();

  @override
  Stream<RouterState> mapEventToState(
    RouterEvent event,
  ) async* {
    switch (event.runtimeType) {
      case RouterMain:
        yield StateMain();
        break;
      case RouterRec:
        yield StateRec();
        break;
      case RouterComparison:
        yield StateComparison();
        break;
      case RouterTranslation:
        yield StateTranslation();
        break;
      case RouterPicImage:
        yield StatePicImage();
        break;
      case RouterHistory:
        yield StateHistory();
        break;
      case RouterCamera:
        yield StateCamera();
        break;
      case RouterPreview:
        yield StatePreview();
        break;
    }
  }
}
