// ===== 贝尔安亲采购助手 · Service Worker（修复版副本 sw.js）=====
// 修复点：静态资源由“缓存优先、后台更新”改为“网络优先、断网回退缓存”。
// 这样改动页面/JS 后，用户无需手动升级版本号也能在下次联网时加载到新版本；
// 同时保留断网时回退到已缓存资源的离线能力。
const CACHE_NAME = 'bex-purchase-v6';

// 相对路径，部署在二级目录（如 /menu/）时也能正确缓存
const SHELL = ['./', './index.html', './manifest.json', './icon-192.png', './icon-512.png', './xlsx.full.min.js'];

self.addEventListener('install', e => {
  e.waitUntil((async () => {
    const cache = await caches.open(CACHE_NAME);
    // 逐个缓存，单个文件失败不拖垮整次安装
    await Promise.all(SHELL.map(url => cache.add(url).catch(() => {})));
    await self.skipWaiting();
  })());
});

self.addEventListener('activate', e => {
  e.waitUntil((async () => {
    const keys = await caches.keys();
    await Promise.all(keys.filter(k => k !== CACHE_NAME).map(k => caches.delete(k)));
    await self.clients.claim();
  })());
});

self.addEventListener('fetch', e => {
  const req = e.request;
  if (req.method !== 'GET') return;

  const url = new URL(req.url);
  // Supabase 接口等跨域请求一律走网络，不缓存
  if (url.origin !== self.location.origin) return;

  // 页面导航：网络优先，断网时回退到缓存的首页
  if (req.mode === 'navigate') {
    e.respondWith((async () => {
      try {
        const res = await fetch(req);
        if (res && res.ok) {
          const cache = await caches.open(CACHE_NAME);
          cache.put(req, res.clone());
        }
        return res;
      } catch (err) {
        const cache = await caches.open(CACHE_NAME);
        return (await cache.match(req)) || (await cache.match('./index.html')) || Response.error();
      }
    })());
    return;
  }

  // 静态资源：网络优先，断网回退缓存
  e.respondWith((async () => {
    const cache = await caches.open(CACHE_NAME);
    try {
      const res = await fetch(req);
      if (res && res.ok) cache.put(req, res.clone());
      return res;
    } catch (err) {
      return (await cache.match(req)) || Response.error();
    }
  })());
});
