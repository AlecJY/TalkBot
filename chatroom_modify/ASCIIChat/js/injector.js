// Overwrite CSS in Twtich chat room
function injectCss(node) {
    var th = document.getElementsByTagName(node)[0];
    var c = document.createElement('style');
    c.innerHTML = '.ember-chat .chat-messages .chat-line{padding:2px 20px}'
    th.appendChild(c);
}

injectCss('head');


