// ==UserScript==
// @name         体验活动
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       You
// @match        https://
// @run-at      document-end
// @icon         https://www.google.com/s2/favicons?sz=64&domain=tampermonkey.net
// @grant        none
// ==/UserScript==

// 定时执行判断
function isrun() {
  let runtime1 = '14:10'
  let runtime2 = '19:00'

  let nowtime = new Date().getHours() + ':' + new Date().getMinutes()
  console.log("校验" + nowtime);
  if (nowtime == runtime1 || nowtime == runtime2) {
    return true
  }
  return false
}

// pushplus 推送api
function send(msg) {
  const PUSH_URL = 'https://www.pushplus.plus/send?token=xxx&title=体验活动&content='
  var url = PUSH_URL + msg;
  console.log("发送请求地址：" + url);
  var httpRequest = new XMLHttpRequest();//第一步：建立所需的对象
  httpRequest.open('GET', url, true);//第二步：打开连接  将请求参数写在url中  ps:"./Ptest.php?name=test&nameone=testone"
  httpRequest.send();//第三步：发送请求  将请求参数写在URL中
  /**
   * 获取数据后的处理程序
   */
  httpRequest.onreadystatechange = function () {
    if (httpRequest.readyState == 4 && httpRequest.status == 200) {
      var json = httpRequest.responseText;//获取到json字符串，还需解析
      console.log("响应：" + json);
    }
  };
}

(function () {
  'use strict';
  function run() {
    console.log("开始");
    if (isrun()) {
      console.log(">>> start")

      // 1. 登录
      var login = $(".btn_login")//登录按钮
      if (login.length > 0) {
        console.log("登录")
        send("登录");
        let e = $.Event("click");//模拟一个鼠标点击
        login.trigger(e)
        setTimeout(function () { location.reload(); }, 31 * 1000);
      }

      // 2. 检查活动
      var date = new Date().getDate();
      var active = $(".media-body")//活动元素
      if (active.length > 0) {
        active.each(function () {
          //console.log("包含元素："+$(this).prop('outerHTML'));
          var c = this.childNodes

          var str = c[1].innerText;
          var start = str.indexOf('月')
          var end = str.indexOf('日')
          var time = str.substring(start + 1, end)
          //console.log("当前时间："+date)
          if (time >= date) {
            console.log("    活动时间：" + time)
            console.log("    有活动:" + c[0].innerText)
            send(c[0].innerText + "," + str);
            console.log("    ------")
          }
        });
      }
      console.log(">>> end")
    }
    setTimeout(run, 58 * 1000);
  }
  run();
})();
