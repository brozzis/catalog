
<script language="JavaScript">
<!--

function WM_preloadImages() {

/*
WM_preloadImages()
Loads images into the browser's cache for later use.

Source: Webmonkey Code Library
(http://www.hotwired.com/webmonkey/javascript/code_library/)

Author: Nadav Savio
Author Email: nadav@wired.com

Usage: WM_preloadImages('image 1 URL', 'image 2 URL', 'image 3 URL', ...);
*/

  // Don't bother if there's no document.images
  if (document.images) {
    if (typeof(document.WM) == 'undefined'){
      document.WM = new Object();
    }
    document.WM.loadedImages = new Array();
    // Loop through all the arguments.
    var argLength = WM_preloadImages.arguments.length;
    for(arg=0;arg<argLength;arg++) {
      // For each arg, create a new image.
      document.WM.loadedImages[arg] = new Image();
      // Then set the source of that image to the current argument.
      document.WM.loadedImages[arg].src = WM_preloadImages.arguments[arg];
    }
  }
}


</script>
