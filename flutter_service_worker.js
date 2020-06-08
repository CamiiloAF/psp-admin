'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "main.dart.js": "e1af7d2887fe6221f974517ad8fc4afd",
"assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"assets/FontManifest.json": "f7161631e25fbd47f3180eae84053a51",
"assets/LICENSE": "4fea29ab44d33f891f8a35048fdafdb9",
"assets/packages/progress_dialog/assets/double_ring_loading_io.gif": "e5b006904226dc824fdb6b8027f7d930",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"assets/assets/svg/psp.svg": "300a1f7b731071b75c74aa2a8a12c985",
"assets/AssetManifest.json": "b1b642d95a9dcc37bb92635de2231ad2",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"manifest.json": "da11fb44df03bbcd099c256a0577dfcb",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"index.html": "9eb2e859d46c9938db47b2b145643a33",
"/": "9eb2e859d46c9938db47b2b145643a33"
};

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (cacheName) {
      return caches.delete(cacheName);
    }).then(function (_) {
      return caches.open(CACHE_NAME);
    }).then(function (cache) {
      return cache.addAll(Object.keys(RESOURCES));
    })
  );
});

self.addEventListener('fetch', function (event) {
  event.respondWith(
    caches.match(event.request)
      .then(function (response) {
        if (response) {
          return response;
        }
        return fetch(event.request);
      })
  );
});
