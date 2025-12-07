import Toybox.Lang;
import Toybox.WatchUi;

class MainMenuBuilder {
    static function buildMenu() as WatchUi.Menu2 {
        var menu = new WatchUi.Menu2({ :title => "Menu" });
        var helper = new BreastfeedTrackerHelper();

        if (helper.getFeedings().size() > 0) {
            menu.addItem(
                new MenuItem(
                    WatchUi.loadResource(Rez.Strings.menu_label_undo) as String,
                    null,
                    :undo,
                    {}
                )
            );
        }

        menu.addItem(
            new MenuItem(
                WatchUi.loadResource(Rez.Strings.menu_label_left) as String,
                null,
                :left,
                {}
            )
        );
        menu.addItem(
            new MenuItem(
                WatchUi.loadResource(Rez.Strings.menu_label_right) as String,
                null,
                :right,
                {}
            )
        );
        menu.addItem(
            new MenuItem(
                WatchUi.loadResource(Rez.Strings.menu_label_bottle) as String,
                null,
                :bottle,
                {}
            )
        );

        if (helper.getFeedings().size() > 0) {
            menu.addItem(
                new MenuItem(
                    WatchUi.loadResource(Rez.Strings.menu_label_history) as String,
                    null,
                    :listFeedings,
                    {}
                )
            );
        }

        menu.addItem(
            new MenuItem(
                WatchUi.loadResource(Rez.Strings.menu_label_about) as String,
                null,
                :about,
                {}
            )
        );

        return menu;
    }
}
