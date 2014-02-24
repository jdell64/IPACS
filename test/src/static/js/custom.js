$('#change_tags').each(function(){
    var $this = $(this);
    var t = $this.text();
    $this.html(t.replace('\"',''));
    $this.html(t.replace('&lt','<').replace('&gt', '>'));
    $this.html(t.replace('&lt;li&gt;','<li>').replace('</li>', '</li>'));
});$