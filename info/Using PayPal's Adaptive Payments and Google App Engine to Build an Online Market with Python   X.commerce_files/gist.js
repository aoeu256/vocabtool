(function ($) {
  $(document).ready(function() {    
    //assign click handlers to all code tabs
    $(".tabs li").click(function(e){
      e.preventDefault();
      setActive(this);
    });
      
    //set first tabs & code blocks to be active
    $(".codeSample .tabs li:nth-child(1), .codeSample .code li:nth-child(1)").addClass("active");
      
    //set appropriate code block height for each active code sample
    $(".codeSample .code li:nth-child(1)").each(function(index) {
      $(this).parent("ul").height($(this).height());
    });

    function setActive(tabClicked){
      var tab = $(tabClicked);
      var rootBlock = tab.parent("ul").parent("div");
      var index = tab.index() + 1;
      
      //set active tab index
      rootBlock.find(".tabs li").removeClass("active");
      tab.addClass("active");
      
      //set active code index
      rootBlock.find(".code li").removeClass("active");
      var codeEl = rootBlock.find(".code li:nth-child(" + index + ")");
      codeEl.addClass("active");
      
      //set code block height to hide underlying samples
      rootBlock.find(".code").height(codeEl.height());
    }
  });
})(jQuery);