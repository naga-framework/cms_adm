-define(_CSS,?CSS(?MODULE,?FUNCTION_NAME)).
-define(_JS,?JS(?MODULE,?FUNCTION_NAME)).

%%TODO: DEV,PROD MINIFY
-define(CSS(X,Y), 
  case {X,Y} of 
    {adm_dashboard,index} -> [{gentelella, [bootstrap3,fontawesome,
                                            nprogress,icheck,progressbar,
                                            jqvmap,moment,daterangepicker,
                                            pnotify,gentelella]}];
    {adm_articles,article}-> [{gentelella, [bootstrap3,fontawesome,
                                            nprogress,icheck,datatables,
                                            pnotify,gentelella]},
                              {simplemde}];
    {adm_articles,index}-> [{gentelella, [bootstrap3,fontawesome,
                                          nprogress,icheck,datatables,
                                          pnotify,gentelella]}];
    {adm_users,index}   -> [{gentelella,[bootstrap3,fontawesome,
                                         nprogress,icheck,datatables,
                                         pnotify,gentelella]}];
    {adm_users,profile} -> [{gentelella,[bootstrap3,fontawesome,
                                         nprogress,icheck,prettify,select2,switchery,starrr,
                                         pnotify,gentelella]}]
  end).

-define(JS(X,Y), 
  case {X,Y} of
    {adm_dashboard,index} -> [{gentelella,[jquery,bootstrap3,fastclick,
                                           nprogress,chartjs,gauge,
                                           progressbar,icheck,skycons,flot,
                                           flot_orderbars,flot_spline,flot_curvedlines,
                                           datejs,jqvmap,moment,
                                           daterangepicker,pnotify,gentelella]}];
    {adm_articles,article}-> [{gentelella, [jquery,bootstrap3,fastclick,nprogress,icheck,
                                            datatables,jszip,pdfmake,pnotify,starrr,gentelella]},
                              {simplemde}];
    {adm_articles,index}-> [{gentelella, [jquery,bootstrap3,fastclick,nprogress,icheck,
                                          datatables,jszip,pdfmake,pnotify,starrr,
                                          gentelella]}];    
    {adm_users,index}   -> [{gentelella,[jquery,bootstrap3,fastclick,
                                         nprogress,icheck,datatables,
                                         jszip,pdfmake,pnotify,starrr,gentelella]}];
    {adm_users,profile} -> [{gentelella,[jquery,bootstrap3,fastclick,progressbar,
                                         nprogress,raphael,morris,icheck,moment,
                                         daterangepicker,wysiwyg,hotkeys,prettify,
                                         tagsinput,switchery,select2,parsley,autosize,
                                         autocomplete,pnotify,starrr,gentelella]}]
  end).