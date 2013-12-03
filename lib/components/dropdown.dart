library widget.dropdown;

import 'dart:async';
import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:widget/effects.dart';
import 'package:widget/widget.dart';

// TODO: esc and click outside to collapse
// https://github.com/kevmoo/widget.dart/issues/14

/**
 * [DropdownWidget] aligns closely with the model provided by the
 * [dropdown functionality](http://twitter.github.com/bootstrap/javascript.html#dropdowns)
 * in Bootstrap.
 *
 * [DropdownWidget] content is inferred from all child elements that have
 * class `dropdown-menu`. Bootstrap defines a CSS selector for `.dropdown-menu`
 * with an initial display of `none`.
 *
 * [DropdownWidget] listens for `click` events and toggles visibility of content if the
 * click target has attribute `data-toggle="dropdown"`.
 *
 * Bootstrap also defines a CSS selector which sets `display: block;` for elements
 * matching `.open > .dropdown-menu`. When [DropdownWidget] opens, the class `open` is
 * added to the inner element wrapping all content. Causing child elements with
 * class `dropdown-menu` to become visible.
 */
@CustomTag('dropdown-widget')
class DropdownWidget extends PolymerElement implements ShowHideComponent {
  static final ShowHideEffect _effect = new FadeEffect();
  static const int _duration = 100;

  bool _isShown = false;

  DropdownWidget.created() : super.created() {
    this.querySelectorAll('[data-toggle=dropdown]').onClick.listen(_onClick);
    this.onKeyDown.listen(_onKeyDown);
  }

  bool get isShown => _isShown;

  void set isShown(bool value) {
    assert(value != null);
    if(value != _isShown) {

      if(value) {
        // before we set the local shown value, ensure
        // all of the other dropdowns are closed
        closeDropdowns();
      }

      _isShown = value;

      final action = _isShown ? ShowHideAction.SHOW : ShowHideAction.HIDE;

      if(_isShown) {
        this.classes.add('open');
      } else {
        this.classes.remove('open');
      }

      final contentDiv = this.querySelector('[is=x-dropdown] > .dropdown-menu');
      if(contentDiv != null) {
        ShowHide.begin(action, contentDiv, effect: _effect);
      }
      ShowHideComponent.dispatchToggleEvent(this);
    }
  }

  Stream<Event> get onToggle => ShowHideComponent.toggleEvent.forTarget(this);

  void hide() {
    isShown = false;
  }

  void show() {
    isShown = true;
  }

  void toggle() {
    isShown = !isShown;
  }

  static void closeDropdowns() {
    document.querySelectorAll('[is=x-dropdown]')
      .where((e) => e.xtag is DropdownWidget)
      .map((e) => e.xtag as DropdownWidget)
      .forEach((dd) => dd.hide());
  }

  void _onKeyDown(KeyboardEvent e) {
    if(!e.defaultPrevented && e.keyCode == KeyCode.ESC) {
      this.hide();
      e.preventDefault();
    }
  }

  void _onClick(MouseEvent event) {
    if(!event.defaultPrevented && event.target is Element) {
      final Element target = event.target;
      if(target != null && target.dataset['toggle'] == 'dropdown') {
        toggle();
        event.preventDefault();
        target.focus();
      }
    }
  }
}
