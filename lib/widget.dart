library widget;

import 'dart:async';
import 'dart:html';
import 'package:widget/effects.dart';

abstract class SwapComponent {

  int get activeItemIndex;
  Element get activeItem;
  List<Element> get items;

  Future<bool> showItemAtIndex(int index, {ShowHideEffect effect, int duration,
    EffectTiming effectTiming, ShowHideEffect hideEffect});

  Future<bool> showItem(Element item, {ShowHideEffect effect, int duration,
    EffectTiming effectTiming, ShowHideEffect hideEffect});
  // TODO: showItem with id?
}
