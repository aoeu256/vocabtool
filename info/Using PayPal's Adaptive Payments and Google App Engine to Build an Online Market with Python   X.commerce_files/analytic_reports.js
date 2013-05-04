(function ($) {
var fileDownloadCheckTimer;

Drupal.behaviors.analyticReports = {
  'attach': function(context, settings){
    var $iframe = $('#analytic-reports-download',context);

    $('a.report-download-link').click(function(){
      /* Set the token that the cookie will be set to when the file is sent to the browser */
      var token = new Date().getTime();
      
      /* Grab the hfer from the a tag and set the iframe to that url with the token */
      $iframe.attr('src',$(this).attr('href')+'?reportToken='+token);
      
      /* Change the a tag to show we are processing the request */
      var originalText = $(this).text();
      $(this).text('Processing');
      $(this).addClass('ctools-ajaxing');
      var anchor = this;
      
      /* Start polling the cookie to see if the file has been sent to the browser */
      fileDownloadCheckTimer = window.setInterval(function () {
        if ($.cookie('analyticReportsDownload') == token)
          Drupal.finishDownload(anchor, originalText);
      }, 1000);
      return false;
    });
  }
}

Drupal.finishDownload = function(anchor, originalText){
  window.clearInterval(fileDownloadCheckTimer);
  $(anchor).text(originalText);
  $(anchor).removeClass('ctools-ajaxing');
  $.cookie('analyticReportsDownload',null);  
}

}(jQuery));