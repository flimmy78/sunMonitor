<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
	<style type="text/css">
	 body{
	 font-family:Microsoft YaHei,Verdana,Arial,SimSun;color:#666;font-size:14px;background:#f6f6f6; overflow:hidden;
	 }
	</style>
    <script src="js/boot.js" type="text/javascript"></script>
  </head>
  
  <body>
  <fieldset style="width:95%;height:95%;border:solid 1px #aaa;position:relative;">
	<legend>用户信息管理</legend>
	<div style="width:100%;">
        <div class="mini-toolbar" style="border-bottom:0;padding:0px;">
            <table style="width:100%;">
                <tr>
                    <td style="width:100%;">
                        <!-- <a class="mini-button" iconCls="icon-add" onclick="add()" plain="true">增加</a>
                        <a class="mini-button" iconCls="icon-edit" onclick="edit()" plain="true">编辑</a> -->
                        <a class="mini-button" iconCls="icon-remove" onclick="remove()" plain="true">删除</a>
                        <a class="mini-button" iconCls="icon-tip" onclick="ResetPWD()" plain="true">初始化密码</a>       
                    </td>
                    <td style="white-space:nowrap;" onkeydown="_key()">
                    	<span style="padding-left:5px;font-size: 12px">姓名：</span>
                        <input id="key" class="mini-textbox" emptyText="请输入姓名" style="width:150px;" onenter="onKeyEnter"/>   
                        <a class="mini-button" iconCls="icon-search" plain="true" onclick="search()">查询</a>
                    </td>
                </tr>
            </table>           
        </div>
    </div>
     <div id="datagrid1" class="mini-datagrid" style="width:99.8%;height:87%;"  
                    url="user/querySunUser.action"  idField="id"
                    multiSelect="false" allowResize="true" onrowdblclick="onRowDblClick"  pageSize="10">
                <div property="columns" >
                    <div type="indexcolumn" width="5"></div>   
                    <div type="checkcolumn" width="10"></div>                              
                    <div field="username" width="20" headerAlign="center" align="center" allowSort="true">账号</div>
                    <div field="name" width="20" headerAlign="center" align="center" allowSort="true">姓名</div>
                    <div field="userDTU" width="20" headerAlign="center" align="center" allowSort="true">关联DTU</div>                
                    <div field="grid" width="20" headerAlign="center" align="center" allowSort="true" renderer="isGrid">是否并网</div>
                </div>    
   	 </div>

    

    <script type="text/javascript">
        mini.parse();
		function isGrid(e) {
       
            if (e.value == 0) {
                return "×";
            }
         else 
           return "√";
    }
    //////////////////////////////////////
        var grid = mini.get("datagrid1");
        grid.load();

        
        function add() {
            
            mini.open({
                url: bootPATH + "../jsp/EmployeeWindow.html",
                title: "添加用户", width: 280, height: 350,
                onload: function () {
                    var iframe = this.getIFrameEl();
                    var data = { action: "add"};
                    iframe.contentWindow.SetData(data);
                },
                ondestroy: function (action) {

                    grid.reload();
                }
            });
        }
        function edit() {
            var row = grid.getSelecteds();
             if (row[1]) {
                alert("不能同时对多个用户信息进行修改");
            }
            else if (row[0]) {
                mini.open({
                    url: bootPATH + "../jsp/EmployeeWindow.html",
                    title: "修改用户信息", width: 280, height: 350,
                    onload: function () {
                        var iframe = this.getIFrameEl();
                        var data = { action: "edit", id: row[0].id };
                        iframe.contentWindow.SetData(data);
                        
                    },
                    ondestroy: function (action) {
                        grid.reload();
                        
                    }
                });
                
            }
            else {
                alert("请选中一条记录");
            }
            
        }
        function remove() {
            
            var rows = grid.getSelecteds();
            if (rows.length > 0) {
                if (confirm("确定删除选中记录？")) {
                    var ids = [];
                    for (var i = 0, l = rows.length; i < l; i++) {
                        var r = rows[i];
                        ids.push(r.id);
                    }
                    var id = ids.join(',');
                    grid.loading("操作中，请稍后......");
                    $.ajax({
                      url: "./user/removeUser.action?ids=" +id,
                        success: function (text) {
                            grid.reload();
                        },
                        error: function () {
                        }
                    });
                }
            } else {
                alert("请选中一条记录");
            }
        }
        function search() {
            var key = mini.get("key").getValue();
            grid.load({ key: key });
        }
        function _key() {
        	if (event.keyCode == 13){
            	search();
            }
        }
        /////////////////////////////////////////////////
        //////////////////////////////////////////////////////
    function ResetPWD() {
         var rows = grid.getSelecteds();
            if (rows.length > 0) {
                if (confirm("确定初始化选中记录？")) {
                    var ids = [];
                    for (var i = 0, l = rows.length; i < l; i++) {
                        var r = rows[i];
                        ids.push(r.id);
                    }
                    var id = ids.join(',');
                    grid.loading("操作中，请稍后......");
                    $.ajax({
                        url: "./user/updatePasswd.action?ids=" +id,
                        success: function (text) {
                            grid.reload();
                        },
                        error: function () {
                        }
                    });
                }
            } else {
                alert("请选中一条记录");
            }
        }



    </script>
  </fieldset>
  </body>
</html>
