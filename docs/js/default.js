$(document).ready(function () {
    // Add the "active" class to the a element of the navigation's current page
    var pageName = this.location.href.split('/').pop();

    if($('#title').text() === "Home") {
        $('#nav-home').addClass('active');
        return;
    }

    $('#navbar a').each(function () {
        if ($(this).attr('href').match(pageName + "$")) {
            $(this).addClass('active');
        }
    });
});
