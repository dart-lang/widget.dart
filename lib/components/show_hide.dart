library widget.tabs;

import 'dart:async';
import 'dart:html';
import 'package:polymer/polymer.dart';

@CustomTag('show-hide-widget')
class ShowHideWidget extends PolymerElement {
  static const String _TOGGLE_EVENT_NAME = 'toggle';

  static const EventStreamProvider<Event> toggleEvent =
      const EventStreamProvider<Event>(_TOGGLE_EVENT_NAME);

  ShowHideWidget.created() : super.created();

  bool _isShown = false;

  bool get isShown => _isShown;

  void set isShown(bool value) {
    assert(value != null);
    if(value != _isShown) {
      _isShown = value;
      isShownChanged();
    }
  }

  Stream<Event> get onToggle => toggleEvent.forTarget(this);

  void hide() {
    isShown = false;
  }

  void show() {
    isShown = true;
  }

  void toggle() {
    isShown = !isShown;
  }

  /**
   * Should be overridden by subclasses to react to changes in [isShown].
   */
  void isShownChanged() {
    dispatchEvent(new Event(_TOGGLE_EVENT_NAME));
  }
}
