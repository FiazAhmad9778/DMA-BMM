function PositionSubNav(nav, subnav) {
    if (nav.length == 1 && subnav.length == 1) {
        //var spacing = subnav.parent().width() - (nav.position().left + 0.5 * (nav.width() + subnav.width())); // centered
        var spacing = subnav.parent().width() - nav.position().left - subnav.width(); // left aligned
        subnav.css('marginRight', (spacing < 0 ? 0 : spacing) + 'px');
    }
}

$(document).ready(function () {

    PositionSubNav($('.Navigation > li.Selected'), $('.SubNavigation.Active'));

    $('.Navigation > li').mouseenter(function () {
        var selected = $('.Navigation > li.Selected').removeClass('Selected');
        var prev = $('.Navigation > li.Active').removeClass('Active');
        var next = $(this);
        var prevClass = prev.prop('class');
        var nextClass = next.prop('class');
        if (prevClass != nextClass) {
            $('.SubNavigation.Active').removeClass('Active');
            PositionSubNav(next, $('.SubNavigation.' + nextClass).addClass('Active'));
            $('.SubNavigation li.Active').removeClass('Active');
            $('.SubNavigation li.Selected').addClass('Active');
        }
        next.addClass('Active');
        selected.addClass('Selected');
    });

    $('.SubNavigation > li').not('.Disabled').hover(function () {
        $(this).removeClass('Active').addClass('Active').siblings('.Active').removeClass('Active');
    }, function () {
        if (!$(this).hasClass("Selected")) {
            $(this).removeClass("Active").siblings(".Selected").addClass("Active");
        }
    });

    $('#HeaderWrapper').mouseleave(function () {
        $('.Navigation > li.Active').removeClass('Active');
        $('.SubNavigation.Active').removeClass('Active');
        var selected = $('.Navigation > li.Selected').removeClass('Selected');
        var selectedClass = selected.prop('class');
        selected.addClass('Selected').addClass('Active');
        var subnav = $('.SubNavigation.' + selectedClass).addClass('Active');
        $('li.Active', subnav).removeClass('Active');
        $('li.Selected', subnav).addClass('Active');
        PositionSubNav(selected, subnav);
    });

});