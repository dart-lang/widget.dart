library widget.alert;

import 'dart:async';
import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:widget/effects.dart';
import 'package:widget/widget.dart';

/**
 * [AlertWidget] follows the same convention as
 * [its inspiration](http://getbootstrap.com/javascript/#alerts) in Bootstrap.
 *
 * Clicking on a nested element with the attribute `data-dismiss='alert'` will
 * cause [AlertWidget] to close.
 *
 * Adding an `alert-*` class to [AlertWidget] will apply the associated
 * Boostrap style. These include `alert-success`, `alert-info`, `alert-warning`,
 * and `alert-danger`.
 */
@CustomTag('alert-widget')
class AlertWidget extends PolymerElement implements ShowHideComponent {

  AlertWidget.created(): super.created()  {
    this.onClick.listen(_onClick);
  }

  bool get applyAuthorStyles => true;

  bool _isShown = true;

  bool get isShown => _isShown;

  void set isShown(bool value) {
    assert(value != null);
    if(value != _isShown) {
      _isShown = value;
      final action = _isShown ? ShowHideAction.SHOW : ShowHideAction.HIDE;
      ShowHide.begin(action, this, effect: new ScaleEffect());

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

  @override
  void enteredView() {
    super.enteredView();
    _updateAlertClasses();
  }

  void _updateAlertClasses() {
    var alertClasses = this.classes
        .where((c) => c.startsWith('alert-'));

    var alertDiv = shadowRoot.querySelector('.alert');

    alertDiv.classes.retainWhere((s) => s == 'alert');
    alertDiv.classes.addAll(alertClasses);
  }

  void _onClick(MouseEvent event) {
    if(!event.defaultPrevented) {
      final Element target = event.target as Element;
      if(target != null && target.dataset['dismiss'] == 'alert') {
        hide();
      }
    }
  }
}
