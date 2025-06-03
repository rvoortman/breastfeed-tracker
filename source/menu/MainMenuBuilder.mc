import Toybox.Lang;
import Toybox.WatchUi;

class MainMenuBuilder {
    static function buildMenu() as WatchUi.Menu2 {
        var menu = new WatchUi.Menu2({ :title => "Nenu" });
        var helper = new BreastfeedTrackerHelper();

        menu.addItem(
            new MenuItem(
                // WatchUi.loadResource(Rez.Strings.menu_label_about),
                "Day Graph",
                null,
                :listFeedings,
                {}
            )
        );

        if (helper.getFeedings().size() > 0) {
            menu.addItem(
                new MenuItem(
                    WatchUi.loadResource(Rez.Strings.menu_label_undo),
                    null,
                    :undo,
                    {}
                )
            );
        }

        menu.addItem(
            new MenuItem(
                WatchUi.loadResource(Rez.Strings.menu_label_left),
                null,
                :left,
                {}
            )
        );
        menu.addItem(
            new MenuItem(
                WatchUi.loadResource(Rez.Strings.menu_label_right),
                null,
                :right,
                {}
            )
        );
        menu.addItem(
            new MenuItem(
                WatchUi.loadResource(Rez.Strings.menu_label_bottle),
                null,
                :bottle,
                {}
            )
        );

        menu.addItem(
            new MenuItem(
                WatchUi.loadResource(Rez.Strings.menu_label_about),
                null,
                :about,
                {}
            )
        );

        return menu;
    }
}
