if (navigator.serviceWorker) {
  navigator.serviceWorker.register('/serviceworker.js', { scope: './' })
    .then(function(reg) {
    	console.log('content of serviceworker is '+ navigator.serviceWorker);
      console.log('[Companion]', 'Service worker registered!');
    });
}


