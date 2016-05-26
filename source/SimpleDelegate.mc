using Toybox.WatchUi as Ui;

class SimpleDelegate extends Ui.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        Ui.pushView(new Rez.Menus.MainMenu(), new SimpleMenuDelegate(), Ui.SLIDE_UP);
        return true;
    }

}