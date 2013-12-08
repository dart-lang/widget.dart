library widget.tabs;

import 'package:polymer/polymer.dart';

@CustomTag('show-hide-widget')
class ShowHideWidget extends PolymerElement {

  ShowHideWidget.created() : super.created();

  ShowHideWidget.createdWithValue(bool isShown) :
    this._isShown = isShown,
    super.created();

  bool _isShown = false;

  bool get isShown => _isShown;

  void set isShown(bool value) {
    assert(value != null);
    if(value != _isShown) {
      _isShown = value;
      notifyPropertyChange(#isShown, !isShown, isShown);
    }
  }

  void hide() {
    isShown = false;
  }

  void show() {
    isShown = true;
  }

  void toggle() {
    isShown = !isShown;
  }
}
