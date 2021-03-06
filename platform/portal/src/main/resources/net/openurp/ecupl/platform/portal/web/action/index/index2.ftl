[#ftl]
[@b.head]
<script src="${base}/static/scripts/menu.js" type="text/javascript"></script>
<link href="${base}/static/css/home.css?v2" rel="stylesheet" type="text/css" />
<style>
#_menu_folder {
  height:100%;
  width:100%;
  background-color:rgba(0, 0, 0, 0.2);
  cursor:pointer;
  position:relative;
}
#_menu_folder:hover {
  height:100%;
  width:100%;
  background-color:rgba(222, 222, 222, 1);
}
.arrow-right {
        width: 0;
        height: 0;
        border-top: 6px solid transparent;
        border-bottom: 6px solid transparent;
        border-left: 6px solid rgba(0, 0, 0, 0.6);
    top:50%;
    position:absolute;
}
.arrow-left {
        width: 0;
        height: 0;
        border-top: 6px solid transparent;
        border-bottom: 6px solid transparent;
        border-right:6px solid rgba(0, 0, 0, 0.6);
    top:50%;
    position:absolute;
}
</style>
[/@]
[#macro displayMenu m]
   [#if m.entry??]
     {"entry":"${m.app.url?replace('{openurp.webapp}',webappBase)}${m.entry.name}","title":"${m.title}","indexno":"${m.indexno}","id":${m.id}} [#t/]
   [#else]
   {"title":"${m.title}","indexno":"${m.indexno}","id":${m.id},"children":[[#list m.children as mc][@displayMenu mc/][#if mc_has_next],[/#if][/#list]]} [#t/]
   [/#if]
[/#macro]
<nav style="margin-bottom: 0px;" role="navigation" class="navbar navbar-default">
   <div class="navbar-header">
       <img src="#" style="width:50px;height:50px;float: left !important;"/>
       <a onclick="return bg.Go(this,null)" style="height: 20px;" class="navbar-brand" href="${base}/index">{school.shortName}</a>
   </div>
   <div>
     <ul class="nav navbar-nav" style="height: 50px;" id="app_nav_bar"></ul>
     <ul class="nav navbar-nav navbar-right" style="height: 35px; padding-top: 15px;">
       <li>
        <span class="glyphicon glyphicon-user" aria-hidden="true">[@b.a href="/security/my" target="_blank" title="查看登录记录"]${user.name}&nbsp;[/@]</span>
         </li>
     <li>
     <span class="glyphicon glyphicon-log-out" aria-hidden="true">[@b.a href="!logout" target="_top"]退出&nbsp;&nbsp;[/@]</span>
        </li>
      </ul>
    </div>
</nav>

<table id="mainTable" style="width:100%;">
  <tr>
     <td style="height:100%;width:10%;padding-right: 0px;" id="leftTD" valign="top">
       <div id="menu_panel" ><ul class="menu collapsible" id="menu_ul"></ul></div>
     </td>
     <td style="height:100%;width:5px">
      <div id="_menu_folder"><div id="_menu_folder_tri"></div></div>
     </td>
     <td id="rightTD" valign="top" style="padding-left: 0px;">
     [#-- <div id="main" class="ajax_container">选择一个菜单</div> --]
     <iframe width="100%" height="100%" frameborder="0" id="main" name="main" src="#" scrolling="auto">
     </iframe>
     </td>
  </tr>
</table>
<script type="text/javascript">
  var menus = [ [#t/]
   [#list menus?keys as k]
     {"title":"${k.title}","indexno":"${k.indexno}","id":"app${k.id}","children":[[#list menus.get(k) as m][@displayMenu m/][#if m_has_next],[/#if][/#list]]} [#t/]
     [#if k_has_next],[/#if] [#t/]
   [/#list]
   ][#t/]

  var foldTemplate='<li style="margin:0px;" class="{active_class}"><a href="javascript:void(0)" class="first_menu">{menu.title}</a><ul class="acitem" style="display: none;"><div class="scroll_box" id="menu{menu.id}"></div></ul></li>'
  var menuTempalte='<li><a class="p_1" onclick="return bg.Go(this,\'main\')" href="{menu.entry}">{menu.title}</a></li>';

  function addMenus(menus,jqueryElem){
    var appendHtml='';
    for(var i=0;i<menus.length;i++){
      var menu = menus[i];
      if(menu.children){
        appendHtml = foldTemplate.replace('{menu.id}',menu.id);
        appendHtml = appendHtml.replace('{menu.title}',menu.title);
        appendHtml = appendHtml.replace('{active_class}',(i==0)?"expand":"");
        jqueryElem.append(appendHtml);
        addMenus(menu.children,jQuery('#menu'+menu.id));
      }else{
        appendHtml = menuTempalte.replace('{menu.id}',menu.id);
        appendHtml = appendHtml.replace('{menu.title}',menu.title);
        appendHtml = appendHtml.replace('{menu.entry}',menu.entry+".action");
        jqueryElem.append(appendHtml);
      }
    }
  }
  addMenus(menus,jQuery('#menu_ul'));

  jQuery("ul.menu li a.p_1").click(function() {
    jQuery("ul.menu li.current").removeClass('current');
    jQuery(this).parent('li').addClass('current');
  });
  jQuery(function() {
    jQuery('#_menu_folder_tri').addClass('arrow-left');
    jQuery('#_menu_folder').click(function() {
      jQuery('#leftTD').toggle(200);
      var jq_tri = jQuery('#_menu_folder_tri');
      if(jq_tri.hasClass('arrow-left')) {
        jq_tri.removeClass('arrow-left');
        jq_tri.addClass('arrow-right');
      } else {
        jq_tri.removeClass('arrow-right');
        jq_tri.addClass('arrow-left');
      }
    });
  });
</script>
[@b.foot/]
