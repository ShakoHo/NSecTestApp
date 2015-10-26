/**
 * Created by shako on 10/23/15.
 */
window.addEventListener("load", function() {
    //console.log("Hello World!");
    console.log("Test String");
    document.getElementById('reload1').onclick = reload1;
});

function reload1() {

    var iframe1 = document.getElementById('iframe1');
    iframe1.src = iframe1.src;
    console.log("reload1");
}

