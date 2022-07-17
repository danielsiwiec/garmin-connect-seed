//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;

typedef PickerType as Number or Float or Duration;

//! Handles a Number Picker selection
class PickerDelegate extends WatchUi.NumberPickerDelegate {

    private var _view as NumberPickerView;

    //! Constructor
    //! @param view The current view
    public function initialize(view as NumberPickerView) {
        NumberPickerDelegate.initialize();
        _view = view;
    }

    //! Handle a number being entered
    //! @param value The number that was entered
    //! @return true if handled, false otherwise
    public function onNumberPicked(value as PickerType) as Boolean {
        _view.setCurrentValue(value);
        return true;
    }
}

//! Handle looping through the Number Pickers
class BaseInputDelegate extends WatchUi.BehaviorDelegate {

    private var _count as Number = 0;
    private var _view as NumberPickerView;

    //! Constructor
    //! @param view The current view
    public function initialize(view as NumberPickerView) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    //! On select behavior, push new Number Picker
    //! @return true if handled, false otherwise
    public function onSelect() as Boolean {
        return onMenu();
    }

    //! On menu behavior, push new Number Picker
    //! @return true if handled, false otherwise
    public function onMenu() as Boolean {
        if (WatchUi has :NumberPicker) {
            if (_count == 0) {
                _view.setModeLabel("Distance");
                var value = 1000f;
                var np = new WatchUi.NumberPicker(WatchUi.NUMBER_PICKER_DISTANCE, value);
                WatchUi.pushView(np, new $.PickerDelegate(_view), WatchUi.SLIDE_IMMEDIATE);
                _count++;
            } else if (_count == 1) {
                _view.setModeLabel("Duration HH:MM:SS");
                // intentionally larger than max
                var value = Time.Gregorian.duration({:hours=>9, :minutes=>8, :seconds=>10});
                var np = new WatchUi.NumberPicker(WatchUi.NUMBER_PICKER_TIME, value);
                WatchUi.pushView(np, new $.PickerDelegate(_view), WatchUi.SLIDE_IMMEDIATE);
                _count++;
            } else if (_count == 2) {
                _view.setModeLabel("Duration MM:SS");
                var value = Time.Gregorian.duration({:hours=>1, :minutes=>8, :seconds=>10});
                var np = new WatchUi.NumberPicker(WatchUi.NUMBER_PICKER_TIME_MIN_SEC, value);
                WatchUi.pushView(np, new $.PickerDelegate(_view), WatchUi.SLIDE_IMMEDIATE);
                _count++;
            } else if (_count == 3) {
                _view.setModeLabel("Time Of Day");
                var value = Time.Gregorian.duration({:hours=>23, :minutes=>8, :seconds=>10});
                var np = new WatchUi.NumberPicker(WatchUi.NUMBER_PICKER_TIME_OF_DAY, value);
                WatchUi.pushView(np, new $.PickerDelegate(_view), WatchUi.SLIDE_IMMEDIATE);
                _count++;
            } else if (_count == 4) {
                _view.setModeLabel("Weight");
                var value = 454;
                var np = new WatchUi.NumberPicker(WatchUi.NUMBER_PICKER_WEIGHT, value);
                WatchUi.pushView(np, new $.PickerDelegate(_view), WatchUi.SLIDE_IMMEDIATE);
                _count++;
            } else if (_count == 5) {
                _view.setModeLabel("Height");
                var value = 2;
                var np = new WatchUi.NumberPicker(WatchUi.NUMBER_PICKER_HEIGHT, value);
                WatchUi.pushView(np, new $.PickerDelegate(_view), WatchUi.SLIDE_IMMEDIATE);
                _count++;
            } else if (_count == 6) {
                _view.setModeLabel("Calories");
                var value = 200;
                var np = new WatchUi.NumberPicker(WatchUi.NUMBER_PICKER_CALORIES, value);
                WatchUi.pushView(np, new $.PickerDelegate(_view), WatchUi.SLIDE_IMMEDIATE);
                _count++;
            } else if (_count == 7) {
                _view.setModeLabel("Birth Year");
                var value = 1980;
                var np = new WatchUi.NumberPicker(WatchUi.NUMBER_PICKER_BIRTH_YEAR, value);
                WatchUi.pushView(np, new $.PickerDelegate(_view), WatchUi.SLIDE_IMMEDIATE);
                _count = 0;
            }
            return true;
        }

        return false;
    }

}

//! Shows the current picked value
class NumberPickerView extends WatchUi.View {

    private var _curValue as PickerType?;
    private var _modeLabel as String = "";

    //! Constructor
    public function initialize() {
        View.initialize();
    }

    //! Load the resources
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
    }

    //! Restore the state of the app and prepare the view to be shown
    public function onShow() as Void {
    }

    //! Update the view to show the value picked
    //! @param dc Device context
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var modeLabelFontHeight = dc.getFontHeight(Graphics.FONT_SMALL);
        var centerX = dc.getWidth() / 2;
        var centerY = dc.getHeight() / 2;
        var labelLocY = centerY - 10;
        var valueLocY = labelLocY + modeLabelFontHeight + 5;

        if (WatchUi has :NumberPicker) {
            dc.drawText(centerX, (centerY - 50), Graphics.FONT_SMALL, "Press Menu Or Select", Graphics.TEXT_JUSTIFY_CENTER);
            var curValue = _curValue;
            if (curValue != null) {
                dc.drawText(centerX, labelLocY, Graphics.FONT_SMALL, _modeLabel, Graphics.TEXT_JUSTIFY_CENTER);
                if (curValue instanceof Time.Duration) {
                    dc.drawText(centerX, valueLocY, Graphics.FONT_SMALL, curValue.value().toString(), Graphics.TEXT_JUSTIFY_CENTER);
                } else {
                    dc.drawText(centerX, valueLocY, Graphics.FONT_SMALL, curValue.toString(), Graphics.TEXT_JUSTIFY_CENTER);
                }
            }
        } else {
            dc.drawText(centerX, (centerY - 50), Graphics.FONT_SMALL, "NumberPicker not supported.", Graphics.TEXT_JUSTIFY_CENTER);
        }
    }

    //! Set the current value
    //! @param value The value
    public function setCurrentValue(value as PickerType) as Void {
        _curValue = value;
    }

    //! Set the label for the value picked
    //! @param label The label
    public function setModeLabel(label as String) as Void {
        _modeLabel = label;
    }
}
