(function ($) {
  $(document).ready(function() {    

  //Vertically aligns the hero image and bleed images.
  var hero = $('.hero');
  if (hero.length > 0) {
    var hero_top = hero.position().top
    $('.hero-left, .hero-right').offset({top: hero_top});  
  }
  
  // Store the #hash for later use.
  var hash = window.location.hash.substring(1);

  $('#review-filter-button').click(function() {
    box = $('.view-application-list-reviwer .top-box .view-filters').slideToggle();
    return false;
  });
  $('.view-application-list-reviwer .top-box .view-filters').hide();

  $(".merge-copier").click(function() {
    var from = $('#' + $(this).attr('copies'));
    var to = $('#' + $(this).attr('to'));
    if (to.hasClass('form-checkboxes')) {
      var max = 0;
      var toList = Array();
      var fromList = Array();
      to.find(':input').each(function() {
        toList[max] = $(this).attr('id');
        max++;
      });
      max = 0;
      from.find(':input').each(function() {
        fromList[max] = $(this).attr('id');
        max++;
      });
      for (i = 0; i < max; i++) {
        var old = $('#' + fromList[i]);
        if (old.is(":checked")) {
          $('#' + toList[i]).attr("checked", "checked");
        } else {
          $('#' + toList[i]).removeAttr("checked");
        }
      }
    } else {
      var val = from.val();
      to.val(val);
    }

    return false;
  });


  $(".agree-text-box").hide();
  $(".read-agree-link").click(function() {
    $(".agree-text-box").toggle();
    return false;
  });
  
  $(".privacy-text-box").hide();
  $(".read-privacy-link").click(function() {
    $(".privacy-text-box").toggle();
    return false;
  });


  $(".site-search-options").mouseleave(function() {
    $(this).hide();
  });

  $(".avatar-box").hide();
  $("#users-avatar-upload").hide();
  $(".avatar-box-controller").click(function() {
    $(".avatar-box").slideToggle();
    $("#users-avatar-upload").slideToggle();
    return false;
  });

  $(".search_sorter select").change(function() {
    $(".search_sorter #sort-by").attr('action', $(this).val());
    window.location = $(".search_sorter #sort-by").attr('action'); 
  });

  $(".partner-catalog").jCarouselLite({
    btnNext: ".partner-next",
    btnPrev: ".partner-prev",
    visible: 5
  });
  
  $('#user-edit-picture fieldset').hide();
  $('#edit-open-picture-upload').click(function() {
    $('#user-edit-picture fieldset').slideToggle();
    return false;
  })

  // Hide our use cases if js enabled.
  $found = false;
  $('.blog-month .blog-container').each(function() {
    if (!$(this).hasClass('default')) {
      $(this).hide(); 
    } else {
      $found = true;
    }
  });
 

  $('.blog-month .open-date-link').removeClass('opened');
  $('.blog-month .open-date-link').addClass('closed');
  $('.blog-month .open-date-link').click(function() {
    if ($(this).hasClass('opened')) {
      $(this).addClass('closed');
      $(this).removeClass('opened');
    } else {
      $(this).addClass('opened');
      $(this).removeClass('closed');
    }
    $('.blog-month-' + $(this).attr('opens')).slideToggle();
    return false;
  });

  if ($found != true) {
    $('.blog-month .open-date-link:first').trigger('click');
  }

	// Hide our use cases if js enabled.
	$('.use-cases-holder').hide();
    $('.use-cases-control').click(function() {
      var rel = $(this).attr('rel');
      var cat = $('#' + rel + ' .use-cases-category');
      if (cat.hasClass('open')) {
        cat.addClass('closed');
        cat.removeClass('open');
      } else {
        cat.addClass('open');
        cat.removeClass('closed');
      }
      $('#' + rel + ' .use-cases-holder').slideToggle('slow');
      return false;
    });
    $('.use-cases-control').each(function() {
      var rel = $(this).attr('rel');
      var cat = $('#' + rel + ' .use-cases-category');
      if(rel == hash) {
        cat.addClass('open');
        cat.removeClass('closed');
        $('#' + rel + ' .use-cases-holder').slideToggle('slow');
        return true;
      }
    });

    // Hide our products
    $('.products-content').hide();
    $('.products-title a').click(function() {
      $(this).parents('.products-holder').toggleClass('products-active').find('.products-content').slideToggle('fast');
      return false;
    });
    
    $('.product-selector').change(function() {
      var val = $(this).val();
      if (val == 0) {
        // unhide everything.
        $('.product-list-row').each( function() {$(this).show();} );
      } else {
        $('.product-list-row').hide();
        $('.product-list-row.views-row-' + val).show();
      }
    });
    
    /* PayPal SDK page. Create a weird filter dropdown for some reason. */
    $('#block-views-sdk-block-6 caption').each(function(index, value) {
      $('.sdk-product-selector').append(
        $('<option></option>').val(index + 1).html($(value).html())
      ); 
    });
    
    /* Hide and show stuff when the above selector is used. */
    $('.sdk-product-selector').change(function() {
      var val = $(this).val();
      if (val == 0) {
        // unhide everything.
        $('#block-views-sdk-block-6 table').each(function() {
          $(this).show();
        });
        // Remove hash
        history.pushState("", document.title, window.location.pathname);
      }
      else {
        $('#block-views-sdk-block-6 table').each(function() {
          $(this).hide();
        });
        $('#block-views-sdk-block-6 table:nth-child(' + val + ')').show();
        // Add hash for linking.
        window.location.hash = val;
      }
    });
    if($('#block-views-sdk-block-6').length == 1) {
      var hash = window.location.hash.slice(1);
      if(hash != "") {
        $('.sdk-product-selector').val(hash);
        $('#block-views-sdk-block-6 table').each(function() {
          $(this).hide();
        });
        $('#block-views-sdk-block-6 table:nth-child(' + hash + ')').show();
      }
    }
    
    
    $('.profile-edit-link').click(function() {
      var disabled = $('.profile_edit input:first').attr('disabled');

      if (typeof disabled !== 'undefined' && disabled !== false) {
        $('.profile_edit input').removeAttr('disabled');
      } else {
        $('.profile_edit input').attr('disabled', 'disabled');

      }

      return false;
    })

    $('.site-search-options-link').click(function() {
      var box = $('.site-search-options');
      box.toggle();
      return false;
    });
    
    $('.site-search-box').blur(function() {
      var box = $('.site-search-options');
      box.toggle(false);
      return false;
    });

    $('.options-link a').click(function() {
      var box = $('.forum-search-box fieldset');
      box.toggle();
      return false;
    });
    
    $('.code-filter-link').click(function() {
      if ($(this).attr('opens') == 'all') {
        $('.code-samples .view-row').slideDown()
      } else {
        var theClass = 'code-sample-language-' + $(this).attr('opens');
        $('.code-samples .view-row').each(function() {
          if ($(this).hasClass(theClass)) {
            $(this).slideDown();
          } else {
            $(this).slideUp();
          }
        });        
      }
      return false;
    });
    
    $('.code-action-view').click(function() {
      $('#code-view-' + $(this).attr('opens')).slideToggle();
      return false;
    });

    $('.news-body').hide();
    $('.news-controller').click(function() {
      var cat = $(this).parent().parent().parent();

      if (cat.hasClass('open')) {
        cat.addClass('closed');
        cat.removeClass('open');
      } else {
        cat.addClass('open');
        cat.removeClass('closed');
      }

      var body = $('#news-body-' + $(this).attr('nid'));
      body.toggle();
      return false;
    });


    $('#product-selection').change(function() {
      if ($(this).attr('value') == 0) {
        // Show them all.
        $('.product-category-item').show();
      } else {
        // Hide all, show only value.
        $('.product-category-item').hide(0);
        $('#product-category-' + $(this).attr('value')).toggle(1);
      }
    })

    $('.print-icon a').click(function() {
      window.print();
      return false;
    })
	
//Sidebar navtree - create collapsible lists
  $('#navtree .branch').next().hide();
  $('#navtree .branch').click(function() { 
    $(this).next().slideToggle(); 
	$(this).toggleClass('open'); 
   });
  //Make current link orange in navtree upon load
  $('#navtree a').each(function() {   
    if (this.href == window.location.href) {
      $(this).addClass('current');
    }
  });
  //Make anchor links orange in navtree upon click 
  $('#navtree a').click(function () {
    $('#navtree a').removeClass('current');
    $(this).addClass('current');
  });
 //Active menu stays expanded
  $('#navtree a').each(function() {   
    if (this.href == window.location.href) {
      $(this).parentsUntil('.treelistfirst').show();
    }
  });
  
///Accordion variation of sidebar nav
  $('#accordion > li > .category').click(function(){
    if(false == $(this).next().is(':visible')) {
       $('#accordion ul').slideUp(300);
    }
    $(this).next().slideToggle(300);
});
  //Active menu stays expanded
  $('#accmenu a').each(function() {   
    if (this.href == window.location.href) {
      $(this).parentsUntil('#active ul').show();
      $(this).addClass('current');
      $(this).parent().parent().parent().addClass('open');
    }
  });
  //Toggle classes for arrows
  $('#accmenu .branch').click(function() {
    $(this).addClass('open').siblings().removeClass('open');
});

//Enable the search button only if the search field is not blank or default value.
  $('#edit-search-submit').click(function() {
    var textbox = $("#edit-keywords");
		if (textbox.val() == " " || textbox.val() == textbox.attr("placeholder")) {
			return false;
		}
		else {
			return true;
		}
	});
  //Set focus on search box when you click the submit button
  $('#edit-search-submit').click(function() {
    $('#search-custom-searchsite #edit-keywords').focus();
  });
	
	//Set Search text toggle on off
	var placeholder = 'Search';
  $(".site-search-box").focus(function() {
    if($(this).val() == placeholder) {
      $(this).val("");
    }
  })
	.blur(function() {
    if($(this).val() == '') {
      $(this).val(placeholder);
    }
  });

});
	
})(jQuery);
