<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>
<html xmlns='http://www.w3.org/1999/xhtml' lang='en' xml:lang='en'>
<head>


<title>HTML List Problem</title>

<style type="text/css">
    #container { width: 420px; }

    #container ul {
        list-style-type: none;
        margin: 0;
        padding: 0 20px;
        background: green;
    }

    .item {
     padding: 5px 0 4px 20px;
         list-style-type: square;
         color: yellow;
}

    .item-current {
        list-style-type: square;

    }

    .item-even { background: yellow; }
    .item-odd { background: orange; }

    .text1 {
        width: 200px;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
        float: left;
    }
    .text2, .text3 {
        float: right;
        width: 30px;
    }


</style>

</head>


<body>

<div id="container">
    <ul>
        <li class="item item-current item-even">
            <div class="text1 item-current">
                Some Text
            </div>
            <div class="text2">
                text2
            </div>
            <div class="text3">
                text3
            </div>
        </li>
        <li class="item  item-odd">
            <div class="text1">
                Some Text
            </div>
            <div class="text2">
                text2
            </div>
            <div class="text3">
                text3
            </div>
        </li>
        <li class="item item-even">
            <div class="text1">
                Some Text
            </div>
            <div class="text2">
                text2
            </div>
            <div class="text3">
                text3
            </div>
        </li>
        <li class="item  item-odd">
            <div class="text1">
                Some Text
            </div>
            <div class="text2">
                text2
            </div>
            <div class="text3">
                text3
            </div>
        </li>
    </ul>
</div>

</body>
</html>