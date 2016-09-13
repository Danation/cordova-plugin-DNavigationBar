(function (cordova) {
    cordova.define("DNavigationBar",
        function (require, exports, module) {
            var exec = require("cordova/exec");

            var DNavigationBar = function () {

                /**
                 * Create a navigation bar.
                 * IMPORTANT: create() must be called before any other functions are called
                 * tintColorRgba is a string with the format "int,int,int,int" (all values are 0-255)
                 */
                this.create = function (tintColorRgba) {
                    exec(null, null, "DNavigationBar", "create", [tintColorRgba]);
                };

                /**
                 * Show/Hide Back button
                 */
                this.setBackButtonVisible = function (shouldShow) {
                    exec(null, null, "DNavigationBar", "setBackButtonVisible", [shouldShow]);
                };

                /**
                 * Show/Hide Home button
                 */
                this.setHomeButtonVisible = function (shouldShow) {
                    exec(null, null, "DNavigationBar", "setHomeButtonVisible", [shouldShow]);
                };

                /*
                 * Sets the title of the navigation bar
                 */
                this.setTitle = function (title) {
                    exec(null, null, "DNavigationBar", "setTitle", [title]);
                };

                /**
                 * Show/hide the navigation bar
                 */
                this.setVisible = function (shouldShow) {
                    exec(null, null, "DNavigationBar", "setVisible", [shouldShow]);
                };
            };

            var dNavigationBar = new DNavigationBar();
            module.exports = dNavigationBar;
            exports = dNavigationBar;
        }
    );
}(window.cordova));