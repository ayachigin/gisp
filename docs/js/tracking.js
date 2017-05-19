window.addEventListener('load', function () {
    var a = document.querySelectorAll('a');

    function f() {
        if (this.dataset.tracking) {
            var s = this.dataset.tracking.split(','),
                category = s[0] || '',
                action   = s[1] || '',
                label    = s[2] || '';
            ga('send', 'event', category, action, label);
        }
    }

    for (var i = 0, l = a.length; i < l; i++) {
        a[i].addEventListener('click', f);
    }
});
