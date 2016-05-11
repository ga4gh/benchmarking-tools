/**
 *
 * Created by pkrusche on 27/04/2016.
 */

/** add multiple functions to page onload event */
function onLoad(func) {
    var oldonload = window.onload;
    if (typeof window.onload != 'function') {
        window.onload = func;
    } else {
        window.onload = function() {
            if (oldonload) {
                oldonload();
            }
            func();
        }
    }
}
