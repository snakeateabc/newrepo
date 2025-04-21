// This script determines the optimal renderer for Flutter web
(function() {
  // Detect if device is mobile
  var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
  
  // Detect if browser supports WebGL
  function hasWebGL() {
    try {
      var canvas = document.createElement('canvas');
      return !!window.WebGLRenderingContext && 
        (canvas.getContext('webgl') || canvas.getContext('experimental-webgl'));
    } catch(e) {
      return false;
    }
  }
  
  // Set renderer based on device capabilities
  if (isMobile || !hasWebGL()) {
    // Use HTML renderer for mobile or devices without WebGL
    window.flutterWebRenderer = "html";
  } else {
    // Use CanvasKit renderer for desktop with WebGL
    window.flutterWebRenderer = "canvaskit";
  }
})(); 