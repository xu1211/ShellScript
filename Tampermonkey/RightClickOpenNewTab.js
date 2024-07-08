// ==UserScript==
// @name         RightClickOpenNewTab
// @namespace    http://tampermonkey.net/
// @version      2024-07-08
// @description  RightClick span OpenNewTab
// @author       Your Name
// @match        https://*.lotusflare.com/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=tampermonkey.net
// @grant        GM_registerMenuCommand
// @grant        GM_getValue
// @grant        GM_setValue
// ==/UserScript==

(function () {
  'use strict';

  const LOG_ENABLED = GM_getValue('logEnabled', true); // Get log enabled state from user settings

  function log(message, ...args) {
    if (LOG_ENABLED) {
      console.log(`[OE] ${message}`, ...args);
    }
  }

  function isPlansUrl() {
    const currentUrl = new URL(window.location.href);
    const pattern = /^https:\/\/[^/]+\.lotusflare\.com\/#\/[^/]+\/orchestration-engine\/plans$/;
    return pattern.test(currentUrl.toString());
  }

  function isEditUrl() {
    const currentUrl = new URL(window.location.href);
    log('isEditUrl currentUrl: ',currentUrl.toString())
    const pattern = /^https:\/\/[^/]+\.lotusflare\.com\/#\/\d+\/orchestration-engine\/plan\/[^/]+$/;
    return pattern.test(currentUrl.toString());
  }

  function openInNewTab(event) {
    try {
      log('openInNewTab function called');
      const currentUrl = new URL(window.location.href);
      log('Current URL:', currentUrl.toString());

      const newUrl = currentUrl.toString().replace('plans', 'editor');
      log('Updated URL:', newUrl);

      const linkUrl = newUrl + '/' + event;
      log('Final link URL:', linkUrl);

      window.open(linkUrl, '_blank');
    } catch (error) {
      console.error('[OE] Error in openInNewTab:', error);
    }
  }



  // Register the right-click menu command
  GM_registerMenuCommand('Open in New Tab', openInNewTab);
  log('Right-click menu command registered');

  // Add event listener to document for right-click
  document.addEventListener('contextmenu', function (event) {
    if (isPlansUrl()) {
      const targetElement = event.target;
      log('contextmenu event triggered:', targetElement.textContent.trim());

      if (targetElement.tagName.toLowerCase() === 'span') {
        log('Target element is a span');
        openInNewTab(targetElement.textContent.trim());
      }
    }
  });
  log('Right-click event listener added');


  // Add configuration options
  GM_registerMenuCommand('Toggle Logging', () => {
    const newLogState = !GM_getValue('logEnabled', true);
    GM_setValue('logEnabled', newLogState);
    log(`Logging ${newLogState ? 'enabled' : 'disabled'}`);
  });

})();
