$('#change_tags').each(function(){
    var $this = $(this);
    var t = $this.text();
    $this.html(t.replace('\"',''));
    $this.html(t.replace('&lt','<').replace('&gt', '>'));

});$

$('#attached_files').each(function(){
    var $this = $(this);
    var t = $this.text();
    $this.html(t.replace('\"',''));
    $this.html(t.replace('&lt','<').replace('&gt', '>'));

});$
$('.DELETE_ROW').each(function(){
    var $this = $(this);
    $this.parent().remove();
});$