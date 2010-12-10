
<script language="JavaScript">
<!--

function WM_imageSwap(daImage, daSrc){
  var objStr,obj;
  /*
    WM_imageSwap()
    Changes the source of an image.

    Source: Webmonkey Code Library
    (http://www.hotwired.com/webmonkey/javascript/code_library/)

    Author: Shvatz
    Author Email: shvatz@wired.com

    Usage: WM_imageSwap(originalImage, 'newSourceUrl');

    Requires: WM_preloadImages() (optional, but recommended)
    Thanks to Ken Sundermeyer (ksundermeyer@macromedia.com) for his help
    with variables in ie3 for the mac. 
    */

  // Check to make sure that images are supported in the DOM.
  if(document.images){
    // Check to see whether you are using a name, number, or object
    if (typeof(daImage) == 'string') {
      // This whole objStr nonesense is here solely to gain compatability
      // with ie3 for the mac.
      objStr = 'document.' + daImage;
      obj = eval(objStr);
      obj.src = daSrc;
    } else if ((typeof(daImage) == 'object') && daImage && daImage.src) {
      daImage.src = daSrc;
    }
  }
}


// -->

</script>


