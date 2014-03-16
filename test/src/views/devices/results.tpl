%include('main/header.tpl')
%count = results['count']
%import lib.format_functions
Your search "{{results['search']}}" found {{results['count']}} results.
<br><br>
%if count > 0:
    %for result in results['results']:
        {{!lib.format_functions.search_format(result)}}<br>
    %end
%end

%include('main/footer.tpl')

