import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

const DEBUG = true;

class LyatskiyTeamWatchFaceApp extends Application.AppBase {

    var _view as LyatskiyTeamWatchFaceView?;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        _view = new LyatskiyTeamWatchFaceView();

        return [ _view ];
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() as Void {
        (_view as LyatskiyTeamWatchFaceView).handleSettingsChanged();
        WatchUi.requestUpdate();
    }

}