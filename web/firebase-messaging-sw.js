importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyCJtcoAg-Na9craJY8PspDFXqRcsgAC1Uc",
  authDomain: "trybagc.firebaseapp.com",
  projectId: "trybagc",
  storageBucket: "trybagc.appspot.com",
  messagingSenderId: "477826821886",
  appId: "1:477826821886:web:8e3644aac45443a16b7faf",
  measurementId: "G-6RK740WP7J"
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage(function(payload) {
    console.log('Received background message ', payload);

    const notificationTitle = payload.notification.title;
    const notificationOptions = {
      body: payload.notification.body,
    };

    self.registration.showNotification(notificationTitle, notificationOptions);
  });
