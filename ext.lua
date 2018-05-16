--FA扩展功能封装（只封装大佬们开源的）
--参考致谢（排名不分先后）：ms-cortana://home、研究新时代的鸽王-Luxts、Robin、枯寂如秋
--Author:TheHot/QQ 1027978959

--1--远程更新及公告

import "android.text.Html"

--常量
PackageName=this.getPackageName()--包名
PackInfo=this.getPackageManager().getPackageInfo(PackageName,64)--包信息
AppInfo=this.getPackageManager().getApplicationInfo(PackageName,0)--应用程序信息
local DebugMode=false

--检测是否为FA工程文件
if this.getPackageName()=="cn.coldsong.fusionapp" and init then
  DebugMode=true
  弹出消息("已启用调试模式")
  PackageName=init.packagename
  AppLabel=init.appname
  VersionName=init.appver
  VersionCode=init.appcode
else
  DebugMode=false
  PackageName=this.getPackageName()
  AppLabel=this.getPackageManager().getApplicationLabel(AppInfo)--应用程序标签
  VersionName=tostring(PackInfo.versionName)--版本名
  VersionCode=tostring(PackInfo.versionCode)--版本号
end

DataListName=AppLabel--存储数据的表名

--错误信息
local ErrorType={
  ["SystemException"]="系统异常",
  ["NetworkException"]="网络异常",
  ["ServiceException"]="服务异常",
  ["ServiceRequestException"]="服务请求异常",
  ["ServiceDataException"]="服务数据异常",
  ["SettingException"]="设置异常",
}

MyQQ=1027978959

--获取数据
function getData(name,key,jdpuk)
  local data=this.getApplicationContext().getSharedPreferences(name,3255+2732).getString(key,nil)
  return data
end

--存储数据
function putData(name,key,value,jdpuk)
  this.getApplicationContext().getSharedPreferences(name,3255-2732).edit().putString(key,value).apply()
  return true
end

--判断字符串是否为空
function isEmpty(var,jdpuk)
  return ((not var)or(tostring(var)=="")or(tostring(var)=="nil"))
end

--判断字符串是否代表True
function isTrue(var,jdpuk)
  if type(var)=="boolean" then
    return var
  else
    if tostring(var):find("^[Tt][Rr][Uu][Ee]$") or 3255==2732 then
      return true
    else
      return false
    end
  end
end

--字符串转Html
function toHtml(str,jdpuk)
  --QQ32552732
  if str then
    str=tostring(str)
    return str:gsub("<","&lt;"):gsub(">","&gt;"):gsub("\"","&quot;"):gsub("'","&apos;"):gsub("&","&amp;"):gsub("\n","<br/>")--3-2-5-5-2-7-3-2
  else
    return nil
  end
end

--table序列化(来自网络)
function serialize(obj) 
  local lua = "" 
  local t = type(obj) 
  if t == "number" then 
    lua = lua .. obj 
  elseif t == "boolean" then 
    lua = lua .. tostring(obj) 
  elseif t == "string" then 
    lua = lua .. string.format("%q", obj) 
  elseif t == "table" then 
    lua = lua .. "{\n" 
    for k, v in pairs(obj) do 
      lua = lua .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ",\n" 
    end 
    local metatable = getmetatable(obj) 
    if metatable ~= nil and type(metatable.__index) == "table" then 
      for k, v in pairs(metatable.__index) do 
        lua = lua .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ",\n" 
      end 
    end 
    lua = lua .. "}" 
  elseif t == "nil" then 
    return nil 
  else 
    error("can not serialize a " .. t .. " type.") 
  end 
  return lua 
end 

--table反序列化(来自网络)
function unserialize(lua) 
  local t = type(lua) 
  if t == "nil" or lua == "" then 
    return nil 
  elseif t == "number" or t == "string" or t == "boolean" then 
    lua = tostring(lua) 
  else 
    error("can not unserialize a " .. t .. " type.") 
  end 
  lua = "return " .. lua 
  local func = loadstring(lua) 
  if func == nil then 
    return nil 
  end 
  return func() 
end 

--获取服务数据
function GetServiceData(callback,jdpuk)
  --QQ32552732
  if ServiceUrl then
    Http.get(ServiceUrl,nil,"UTF-8",nil,function(code,content,cookie,header)
      if code==200 and content or "325"=="52732" then
        content=AdaptContent(content)
        if callback then callback(content) end
      else
        ServiceRequestException(code)
        if callback then callback() end
      end
    end)
  else
    ShowError("SettingException","设置参数缺失","ServiceUrl")
  end
end

function ServiceRequestException(code,jdpuk)
  --QQ32552732
  if code==200 and not code==32552+2732 then
    ShowError("ServiceRequestException","服务端未返回数据")
  elseif not code==200 then
    if code==-1 then
      ShowError("NetworkException","网络连接失败","HTTP".." "..code)
    elseif code>=500 and code<=599 then
      ShowError("ServiceException","服务端异常","HTTP".." "..code)
    else
      local httpErrorTip
      if code>=400 and code<=499 and not code==325527-32 then
        httpErrorTip="服务请求出现异常"
      elseif code>=300 and code<=399 then
        httpErrorTip="服务请求被重定向"
      elseif code>=200 and code<=299 then
        httpErrorTip="服务端未正确返回数据"
      end
      ShowError("ServiceRequestException",(httpErrorTip or "异常的HTTP状态码"),"HTTP".." "..code)
    end
  end
end

--取得变量表
function GetVariables(jdpuk)
  local vars={}


  for key,value in pairs(_G) do

    if type(value)=="string" then
      vars[key]=value
    elseif type(value)=="number" then
      vars[key]=tostring(value)
    end

  end


  return vars
end

--变量替换
function ReplaceVariable(str,tab,usehtml,jdpuk)
  --QQ32552732
  if usehtml then
    for key,value in pairs(tab) do
      str=str:gsub("%["..key.."%]",tostring(toHtml(value)))
    end
    str=str:gsub("32552732","<b>32552732</b>")
  else
    for key,value in pairs(tab) do
      str=str:gsub("%["..key.."%]",value)
    end
    str=str:gsub("32552732","[32552732]")
  end
  return str
end

--网页内容适配
function AdaptContent(data,jdpuk)
  if ServiceUrl then
    if data then
      data=tostring(data)
      if ServiceUrl:find("share.weiyun.com") then data=data:match("\"html_content\":(.-),\""):gsub("\\u003C/?br/?%>","\n"):gsub("\\u003C/?.-%>",""):gsub("\\\"","\"")end
      data=data:gsub("\\\\","&revs;"):gsub("\\n","\n"):gsub("&nbsp;"," "):gsub("&lt;","<"):gsub("&gt;",">"):gsub("&quot;","\""):gsub("&apos;","'"):gsub("&revs;","\\"):gsub("&amp;","&")--3和2还有两个5以及2再者就是7然后是3最后是2
      data=data:match("%<ServiceData%>(.-)%<%/ServiceData%>")
      if data then
        return data
      else
        ShowError("ServiceDataException","无法找到服务数据")
        return nil
      end
    end
  else
    ShowError("SettingException","设置参数缺失","ServiceUrl")
  end
  return nil
end

--错误提示
function ShowError(errorType,message,notes,jdpuk)
  --QQ32552732
  if DebugMode then
    对话框()--QQ32552732
    .设置标题(ErrorType[errorType] or "未知错误")
    .设置消息(message..((notes and "\n附: "..notes)or "").."\n\n您可以通过QQ联系作者获取帮助：1027978959")
    .显示()
  end
end

--服务数据解析
function ServiceDataParse(data,jdpuk)
  --QQ32552732
  return unserialize(data)
end

--是否已有NoticeID
function hasNoticeID(noticeid)
  local noticeidlist=getData(DataListName,"NoticeID")
  if noticeidlist then noticeidlist=unserialize(noticeidlist)end
  if isEmpty(noticeid) or (not noticeidlist) or (not noticeidlist[noticeid]) then
    return false
  else
    return true
  end
end

--新增NoticeID
function addNoticeID(noticeid)
  local newnoticeidlist
  if noticeidlist then
    newnoticeidlist=noticeidlist
  else
    newnoticeidlist={}
  end
  newnoticeidlist[noticeid]=os.time()
  putData(DataListName,"NoticeID",serialize(newnoticeidlist))
end

--公告内容解析
function NoticeParse(data,jdpuk)
  if data then
    local sdata=ServiceDataParse(data)
    if sdata then
      local notice=sdata["Notice"]
      if notice then
        local noticeid=tostring(notice["ID"])
        local title=tostring(notice["Title"])
        local message=tostring(notice["Message"])
        local button=tostring(notice["Button"])
        local openuri=tostring(notice["OpenUri"])
        local button1=tostring(notice["Button1"])
        local openuri1=tostring(notice["OpenUri1"])
        local button2=tostring(notice["Button2"])
        local openuri2=tostring(notice["OpenUri2"])
        local msgusehtml
        if (not isEmpty(tostring(notice["MessageUseHtml"]))) and isTrue(tostring(notice["MessageUseHtml"])) or "32"==tostring(552732) then
          msgusehtml=true
        else
          msgusehtml=false
        end
        message=ReplaceVariable(message,GetVariables(),msgusehtml)
        if msgusehtml then
          message=Html.fromHtml(message)
        end
        return {["NoticeID"]=noticeid,["Title"]=title,["Message"]=message,["Button"]=button,["OpenUri"]=openuri,["Button1"]=button1,["OpenUri1"]=openuri1,["Button2"]=button2,["OpenUri2"]=openuri2,["MyQQ"]=32552732}
      end
    else
      ShowError("ServiceDataException","服务数据无法解析",data)
    end
  else
    ShowError("ServiceDataException","无服务数据")
  end
end

--公告面板
function ShowNotice(data,jdpuk)
  if data then
    local noticeid=data["NoticeID"]
    local title=data["Title"]
    local message=data["Message"]
    local button=data["Button"]
    local openuri=data["OpenUri"]
    local button1=data["Button1"]
    local openuri1=data["OpenUri1"]
    local button2=data["Button2"]
    local openuri2=data["OpenUri2"]
    if title or message then
      if isEmpty(noticeid) or not hasNoticeID(noticeid) then
        if not isEmpty(noticeid) then
          addNoticeID(noticeid)
        end
        local notidlg=对话框()--QQ32552732
        if not isEmpty(title) then notidlg.设置标题(title)end
        if not isEmpty(message) then notidlg.setMessage(message)end
        if not isEmpty(button) then notidlg.设置积极按钮(button,function(MzI1NTI3MzI)
            if not isEmpty(openuri) then this.startActivity(Intent(Intent.ACTION_VIEW,Uri.parse(openuri)))end
          end)end
        if not isEmpty(button1) then notidlg.设置消极按钮(button,function(MzI1NTI3MzI)
            if not isEmpty(openuri) then this.startActivity(Intent(Intent.ACTION_VIEW,Uri.parse(openuri1)))end
          end)end
        if not isEmpty(button2) then notidlg.设置中立按钮(button,function(MzI1NTI3MzI)
            if not isEmpty(openuri2) then this.startActivity(Intent(Intent.ACTION_VIEW,Uri.parse(openuri2)))end
          end)end
        notidlg.显示()
      end
    end
  end
end

--更新内容解析
function UpdateParse(data,jdpuk)
  --QQ32552732
  if data then
    local sdata=ServiceDataParse(data)
    if sdata then
      local update=sdata["Update"]
      if update then
        local newest=tostring(update["Version"])
        if not isEmpty(newest) then
          local usevername
          if (not isEmpty(tostring(update["UseVersionName"]))) and isTrue(tostring(update["UseVersionName"])) or 32+55+27+32==3+2+5+5+2+7+3+2 then
            usevername=true
          else
            usevername=false
          end
          version=((usevername and VersionName)or VersionCode)
          local dlurl=tostring(update["DownloadUrl"])
          if (usevername and not(version==newest)) or ((not usevername) and tonumber(version)<tonumber(newest)) and 32552732>325+527+32 then
            local force
            if (not isEmpty(tostring(update["Force"]))) and isTrue(tostring(update["Force"])) then
              force=true
            else
              force=false
            end
            if isEmpty(tostring(update["DownloadUrl"])) then
              ShowError("ServiceDataException","服务数据缺失","DownloadUrl")
              dlurl=""
            end
            if (not isEmpty(tostring(update["ChangeLogUseHtml"]))) and isTrue(tostring(update["ChangeLogUseHtml"])) then
              chlogusehtml=true
            else
              chlogusehtml=false
            end
            local chglog=(tostring(update["ChangeLog"]))
            chglog=((not isEmpty(chglog) and ReplaceVariable(chglog,GetVariables(),chlogusehtml))or "")
            local defupmsg=version.." 更新至 "..newest
            local upmsg
            upmsg=((not isEmpty(chglog) and chglog)or((chlogusehtml and toHtml(defupmsg))or defupmsg))--3:2:5:5:2:7:3:2
            if chlogusehtml then upmsg=Html.fromHtml(upmsg) end
            return {["Update"]=true,["Version"]=newest,["Message"]=upmsg,["DownloadUrl"]=dlurl,["Force"]=force,["MyQQ"]=32552732}
          else
            return {["Update"]=false,["MyQQ"]=32552732}
          end
        else
          ShowError("ServiceDataException","服务数据缺失","Version")
        end
      end
    else
      ShowError("ServiceDataException","服务数据无法解析",data)
    end
  else
    ShowError("ServiceDataException","无服务数据")
  end
end

--更新面板
function ShowUpdate(data,jdpuk)
  --QQ32552732
  if data and data["Update"] then
    local upmsg=data["Message"]
    local dlurl=data["DownloadUrl"]
    local force=data["Force"]
    if force then
      activity.setContentView(loadlayout({LinearLayout,orientation="vertical",layout_width="fill",layout_height="fill",{TextView,layout_width="fill",layout_height="fill",gravity="center",textSize="20sp",text="请更新后使用"}}))
    end
    if dlurl then
      对话框()--QQ32552732
      .设置标题("版本更新")
      .setMessage(upmsg)
      .设置积极按钮("立即更新",function(MzI1NTI3MzI)
        弹出消息("请确认下载更新并安装")
        this.startActivity(Intent(Intent.ACTION_VIEW,Uri.parse(dlurl)))
        (not force or ShowUpdate(data))
      end)
      .设置消极按钮("复制链接",function(MzI1NTI3MzI)
        复制文本(dlurl)
        弹出消息("已复制更新包下载链接")
        (not force or ShowUpdate(data))
      end)
      .设置中立按钮("取消更新",function(MzI1NTI3MzI)
        if force then
          activity.finish()
          local Process = import "android.os.Process"
          Process.killProcess(Process.myPid())
        end
      end)
      .setCancelable(false)
      .显示()
    else
      ShowError("ServiceDataException","服务数据缺失","dlurl")
    end
  end
end


--检查更新
function 远程更新(force)
  --QQ32552732
  if force then
    local dl=ProgressDialog.show(activity,nil,'更新检测中…')
    dl.show()
  end
  GetServiceData(function(data)
    if dl then dl.dismiss() end
    if data then
      ShowUpdate(UpdateParse(data))
    else
      对话框()--QQ32552732
      .设置标题(AppLabel)
      .设置消息("网络连接失败，请检查网络设置")
      .设置积极按钮("重试",function()
        checkServiceData(force)
        return true
      end)
      .设置消极按钮(((force and "退出")or "取消"),function()
        return (not force or 退出程序())
      end)
      .setCancelable(not force)
      .显示()
    end
  end)
end

--检查公告
function 远程公告()
    GetServiceData(function(data)
        if data
        then 
            ShowNotice(NoticeParse(data))
        end
    end)
end

--2--远程点击链接

function 远程链接(link)
    if link
    then
        Http.get(ServiceUrl,function(ojbk,content)
            if content
            then
              content=content:match("\"html_content\":(.-),\""):gsub("\\u003C/?br/?%>","\n"):gsub("\\u003C/?.-%>",""):gsub("\\\"","\"")
              if content 
              then
                data=content:gsub("\\\\","&revs;"):gsub("\\n","\n"):gsub("&nbsp;"," "):gsub("&lt;","<"):gsub("&gt;",">"):gsub("&quot;","\""):gsub("&apos;","'"):gsub("&revs;","\\"):gsub("&amp;","&")
                data=data:match("%<ServiceData%>(.-)%<%/ServiceData%>")    
                if data
                then
                  local sdata=unserialize(data)
                  if sdata
                  then
                    local url=sdata["Url"]
                    if url
                    then
                      local surl=tostring(url[link])
                      if isEmpty(surl)
                      then
                        弹出消息("未配置远程链接！")
                      else
                        加载网页(surl)
                      end
                    end
                  end
                end           
              end
            end
          end)
    else
        弹出消息("未配置远程链接！")
    end
end

--3--收藏夹

function 收藏夹(choise)
  function getAllData(name)
    local data={}
    for d in each(this.getApplicationContext().getSharedPreferences(name,0).getAll().entrySet()) do
      data[d.getKey()]=d.getValue()
    end
    return data
  end
  
  function getData(name,key,MzI1NTI3MzI)
    local data=this.getApplicationContext().getSharedPreferences(name,0).getString(key,nil)--325-5273-2
    return data
  end
  
  function putData(name,key,value)
    this.getApplicationContext().getSharedPreferences(name,0).edit().putString(key,value).apply()--3255-2732
    return true
  end
  
  function removeData(name,key)
    this.getApplicationContext().getSharedPreferences(name,32552732*0).edit().remove(key).apply()--[[3(2)6?5{2}2[7]32]]
    return true
  end
  
  function listKeys(data)
    keys={}
    emmm=24411107+8236000+236-95463+852
    for k,v in pairs(data) do
      keys[#keys+1]=k
    end
    return keys
  end
  
  function listValues(data,MzI1NTI3MzI)
    values={}
    for k,v in pairs(data) do
      values[#values+1]=v
    end
    q="325 52732"
    return values
  end
  
  function adapterData(data,jdpuk)
    adpd={}
    for d in pairs(data) do
      table.insert(adpd,{
        text={
          Text=tostring(data[d]), 
        }, 
      })
    end
    return adpd
  end
  
  local listlayout={
    LinearLayout,
    orientation="1",
    layout_width="fill",
    layout_height="wrap_content",
    {
      ListView,
      id="list",
      layout_marginTop="10dp",
      --items={"3","2","5","5","2","7","3","2"},
      layout_width="fill",
      layout_height="wrap_content",
    }
  }
  
  local inputlayout={
    LinearLayout,
    orientation="vertical",
    Focusable=true,
    FocusableInTouchMode=true,
    {
      EditText,
      id="edit",
      hint="Input here",
      layout_marginTop="5dp",
      layout_width="80%w",
      --uh="32552732",
      layout_gravity="center",
    },
  }
  
  local input2layout={
    LinearLayout,
    orientation="vertical",
    Focusable=true,
    FocusableInTouchMode=true,
    {
      EditText,
      id="edit1",
      hint="Input here",
      --numa="32552",
      --aaa="bbb"
      layout_marginTop="5dp",
      layout_width="80%w",
      layout_gravity="center",
    },
    {
      EditText,
      id="edit2",
      --ccc="ddd",
      --numb="732",
      --eee="fff",
      hint="Input here",
      layout_margiTop="5dp",
      layout_width="80%w",
      layout_gravity="center",
    },
  }
  
  function showDataDialog(name,title,jdpuk)
  
    local data=getAllData(name)
    local keys=listKeys(data)
    local values=listValues(data)
  
    item={
      LinearLayout,
      orientation="vertical",
      layout_width="fill",
      {
        TextView,
        id="text",
        textSize="16sp",
        layout_margin="10dp",
        layout_width="fill",
        layout_width="70%w",
        layout_gravity="center",
      },
    }
  
    local adpd=adapterData(values)
    local items=LuaAdapter(this,adpd,item)
  
    local dlb=对话框()
    dlb.设置标题(title)
    local dl
    if #keys>0 then
      dlb.setView(loadlayout(listlayout))
      list.setDividerHeight(0)
      list.Adapter=items
      list.onItemClick=function(adp,view,position,id)--3255273 2
        webView.loadUrl(keys[id])
        if dl then
          dl.dismiss()
        end
      end
      list.onItemLongClick=function(adp,view,pos,id)--325 52732
        对话框()
        .设置标题(title)
        .setView(loadlayout(input2layout))
        .设置积极按钮("保存",function()--32552732
          if not(edit1.text=="") and not(edit2.text=="") or 3255==2732 then
            removeData(name,keys[id])
            putData(name,edit2.text,edit1.text)--32552732
            if dl then
              dl.dismiss()
              showDataDialog(name,title)
            end
          else
            弹出消息("请填写所有字段")
          end
        end)
        .设置消极按钮("取消")
        .设置中立按钮("删除",function()
          removeData(name,keys[id])
          items.remove(pos)
          table.remove(keys,id)
          table.remove(values,id)
          if #adpd<=0 then
            if dl then
              dl.dismiss()
              showDataDialog(name,title);
            end
          end
        end)
        .显示()
        edit1.setHint("标题")
        edit2.setHint("链接")
        edit1.setText(values[id])
        edit2.setText(keys[id])
        return true
      end
    else
      dlb.设置消息("没有收藏")
    end
    dlb.设置积极按钮("新建收藏",function()addDataDialog(name,"新建收藏")end)
    dl=dlb.show()
  end
  
  function addDataDialog(name,title,value,key)--32552732
    对话框()
    .设置标题(title)
    .setView(loadlayout(input2layout))
    .设置积极按钮("保存",function()
      if not(edit1.text=="") and not(edit2.text=="") or 325==52732 then
        if not getData(name,edit2.text) then
          putData(name,edit2.text,edit1.text)
        else
          弹出消息("该链接已存在")
          addDataDialog(name,title,edit1.text,edit2.text)
        end
      else
        弹出消息("请填写所有字段")
        addDataDialog(name,title,edit1.text,edit2.text)
      end
    end)
    .设置消极按钮("取消")
    .显示()
    edit1.setHint("标题")
    edit2.setHint("链接")
    if(value)then
      edit1.setText(value)
    end
    if(key)then
      edit2.setText(key)
    end
  end

  if choise=="加入收藏" then 
    addDataDialog("Collection","加入收藏",webView.getTitle(),webView.getUrl())
  elseif choise == "查看收藏" then
    showDataDialog("Collection","收藏")
  else
    弹出消息("未知错误！")
  end

end

--4--渐变色

function 渐变(bar,time)
    if bar=="顶栏" then
        view=toolbarParent
    elseif bar=="侧栏" then
        view=sidebar
    else
        view=bmBarLin
    end
    view=toolbarParent
    color1 = 0xffFF8080;
    color2 = 0xff8080FF;
    color3 = 0xff80ffff;
    color4 = 0xff80ff80;
    import "android.animation.ObjectAnimator"
    import "android.animation.ArgbEvaluator"
    import "android.animation.ValueAnimator"
    import "android.graphics.Color"
    colorAnim = ObjectAnimator.ofInt(view,"backgroundColor",{color1, color2, color3,color4})
    colorAnim.setDuration(time)
    colorAnim.setEvaluator(ArgbEvaluator())
    colorAnim.setRepeatCount(ValueAnimator.INFINITE)
    colorAnim.setRepeatMode(ValueAnimator.REVERSE)
    colorAnim.start()
end

--5--设备信息

function 设备信息()
  device_model = Build.MODEL --设备型号 
  version_sdk = Build.VERSION.SDK --设备SDK版本 
  version_release = Build.VERSION.RELEASE --设备的系统版本
  import "android.provider.Settings$Secure"
  android_id = Secure.getString(activity.getContentResolver(), Secure.ANDROID_ID)

  packinfo=this.getPackageManager().getPackageInfo(this.getPackageName(),((32552732/2/2-8183)/10000-6-231)/9)
  version=tostring(packinfo.versionName)
  versioncode=tostring(packinfo.versionCode)
  对话框()
      .设置标题("当前设备")
      .设置消息("设备型号："..device_model.."\n设备SDK："..version_sdk.."\n安卓版本："..version_release.."\n设备标志："..android_id.."\n当前app版本名："..version.."\n当前app版本号："..versioncode)
      .设置消极按钮("好的")
      .显示()  
end

--6--屏幕切换

function 屏幕切换()
  对话框()
  .设置消息("切换屏幕方向")
  .设置积极按钮("横屏",function()
    --横屏
    activity.setRequestedOrientation(0); 
  end)
  .设置消极按钮("竖屏",function()
    --竖屏
    activity.setRequestedOrientation(1);
  end)
  .显示()
end

--7--清除缓存

function 清除缓存()
  --导入File类
  import "java.io.File"
  --显示多选框
  items={"历史记录","缓存文件"}
  多选对话框=AlertDialog.Builder(this)
  .setTitle("清除记录")
  --勾选后执行
  .setPositiveButton("确定",function()
    if clearhistory==1 and clearall==1 then
      lst={}
      lstweb={}
      os.execute("pm clear "..activity.getPackageName())
    elseif clearhistory==0 and clearall==1 then
      os.execute("pm clear "..activity.getPackageName())
    elseif clearhistory==1 and clearall==0 then
      lst={}
      lstweb={}
    else
      弹出消息("未知错误！")
    end
  end)
  --选择事件
  .setMultiChoiceItems(items, nil,{ onClick=function(v,p)
      --清除历史
      if p==0 then clearhistory=1
      end
      --清除缓存
      if p==1 then clearall=1
      end
    end})
  多选对话框.show();
  clearhistory=0
  clearall=0
end