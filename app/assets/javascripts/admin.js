// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//

$(document).ready(function(){
	// alert("skjdjks" + window.PushManager);
  
	setup(logSubscription);
  $("#package_button").click(function(){
    sendNotification();
  });
});

function setup(onSubscribed) {
  console.log('Setting up push subscription');

  if (!window.PushManager) {
    console.log('Push messaging is not supported in your browser');
  }

  if (!ServiceWorkerRegistration.prototype.showNotification) {
    console.log('Notifications are not supported in your browser');
    return;
  }

  if (Notification.permission !== 'granted') {
    Notification.requestPermission(function (permission) {
      // If the user accepts, let's create a notification
      if (permission === "granted") {
        console.log('Permission to receive notifications granted!');
        subscribe(onSubscribed);
      }
    });
    return;
  } else {
    console.log('Permission to receive notifications granted!');
    subscribe(onSubscribed);
  }
}

function subscribe(onSubscribed) {
  navigator.serviceWorker.ready.then((serviceWorkerRegistration) => {
    const pushManager = serviceWorkerRegistration.pushManager
    pushManager.getSubscription()
    .then((subscription) => {
      if (subscription) {
        refreshSubscription(pushManager, subscription, onSubscribed);
      } else {
        pushManagerSubscribe(pushManager, onSubscribed);
      }
    })
  });
}

function refreshSubscription(pushManager, subscription, onSubscribed) {
  console.log('Refreshing subscription');
  return subscription.unsubscribe().then((bool) => {
    pushManagerSubscribe(pushManager);
  });
}

function pushManagerSubscribe(pushManager, onSubscribed) {
  console.log('Subscribing started...');
  pushManager.subscribe({
    userVisibleOnly: true,
    applicationServerKey: window.publicKey
  })
  .then(onSubscribed)
  .then(() => { console.log('Subcribing finished: success!')})
  .catch((e) => {
    if (Notification.permission === 'denied') {
      console.log('Permission to send notifications denied');
    } else {
      console.error('Unable to subscribe to push', e);
    }
  });
}

function logSubscription(subscription) {
  console.log("Current subscription", subscription.toJSON());
}

function getSubscription() {
  return navigator.serviceWorker.ready
  .then((serviceWorkerRegistration) => {
    return serviceWorkerRegistration.pushManager.getSubscription()
    .catch((error) => {
      console.log('Error during getSubscription()', error);
    });
  });
}

function sendNotification() {
  getSubscription().then((subscription) => {
    return fetch("/push", {
      headers: formHeaders(),
      method: 'POST',
      credentials: 'include',
      body: JSON.stringify({ subscription: subscription.toJSON() })
    }).then((response) => {
      console.log("Push response", response);
      if (response.status >= 500) {
        console.error(response.statusText);
        alert("Sorry, there was a problem sending the notification. Try resubscribing to push messages and resending.");
      }
    })
    .catch((e) => {
      console.error("Error sending notification", e);
    });
  })
}

function formHeaders() {
  return new Headers({
    'Content-Type': 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
    'X-CSRF-Token': authenticityToken(),
  });
}

function authenticityToken() {
  return document.querySelector('meta[name=csrf-token]').content;
}